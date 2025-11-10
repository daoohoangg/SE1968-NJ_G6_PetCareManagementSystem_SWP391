package com.petcaresystem.dao;

import com.petcaresystem.enities.*;
import com.petcaresystem.enities.enu.AppointmentStatus;
import com.petcaresystem.enities.enu.InvoiceStatus;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

public class AppointmentDAO {

    /* ====================== Query helpers ====================== */

    private static <T> List<T> readList(Session s, String hql, Class<T> type, Map<String, Object> params) {
        var q = s.createQuery(hql, type).setReadOnly(true);
        if (params != null) params.forEach(q::setParameter);
        return q.getResultList();
    }

    private static <T> T readOne(Session s, String hql, Class<T> type, Map<String, Object> params) {
        var q = s.createQuery(hql, type).setReadOnly(true);
        if (params != null) params.forEach(q::setParameter);
        return q.uniqueResult();
    }

    /* ====================== Public APIs ====================== */

    /** Tất cả lịch hẹn của 1 customer (lọc theo accounts.account_id) */
    public List<Appointment> findByCustomer(Long accountId) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = """
                    select distinct a
                    from Appointment a
                    join fetch a.customer c
                    join fetch a.pet p
                    left join fetch a.services sv
                    where c.accountId = :cid
                    order by a.appointmentDate desc
                    """;
            return readList(s, hql, Appointment.class, Map.of("cid", accountId));
        }
    }

    public List<Appointment> findUpcomingByCustomer(Long accountId) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = """
                    select a from Appointment a
                    join fetch a.customer c
                    join fetch a.pet p
                    where c.accountId = :cid and a.appointmentDate >= :now
                    order by a.appointmentDate asc
                    """;
            var params = new HashMap<String, Object>();
            params.put("cid", accountId);
            params.put("now", LocalDateTime.now());
            return readList(s, hql, Appointment.class, params);
        }
    }

    public Appointment findById(Long id) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = """
                    select a from Appointment a
                    left join fetch a.customer
                    left join fetch a.pet
                    left join fetch a.services
                    where a.appointmentId = :id
                    """;
            return readOne(s, hql, Appointment.class, Map.of("id", id));
        }
    }

    private Receptionist getDefaultReceptionist(Session s) {
        String hql = "from Receptionist r order by r.accountId asc";
        return s.createQuery(hql, Receptionist.class).setMaxResults(1).uniqueResult();
    }

    private Staff getDefaultStaff(Session s) {
        String hql = "from Staff st order by st.accountId asc";
        return s.createQuery(hql, Staff.class).setMaxResults(1).uniqueResult();
    }

    public boolean create(Long customerAccountId,
                          Long petId,
                          List<Long> serviceIds,
                          LocalDateTime start,
                          LocalDateTime end,
                          String notes) {
        Session s = null;
        Transaction tx = null;
        try {
            s = HibernateUtil.getSessionFactory().openSession();
            tx = s.beginTransaction();

            Customer customer = s.createQuery(
                            "from Customer c where c.accountId = :aid", Customer.class)
                    .setParameter("aid", customerAccountId)
                    .uniqueResult();

            Pet pet = s.get(Pet.class, petId);

            if (customer == null) {
                throw new IllegalArgumentException("Không tìm thấy hồ sơ khách hàng (accountId=" + customerAccountId + ").");
            }
            if (pet == null || pet.getCustomer() == null
                    || !java.util.Objects.equals(pet.getCustomer().getCustomerId(), customer.getCustomerId())) {
                throw new IllegalArgumentException("Thú cưng không tồn tại hoặc không thuộc tài khoản của bạn.");
            }
            if (start == null) {
                throw new IllegalArgumentException("Vui lòng chọn thời gian bắt đầu.");
            }
            if (end != null && !end.isAfter(start)) {
                throw new IllegalArgumentException("Thời gian kết thúc phải sau thời gian bắt đầu.");
            }
            if (serviceIds == null || serviceIds.isEmpty()) {
                throw new IllegalArgumentException("Bạn phải chọn ít nhất một dịch vụ.");
            }

            Appointment a = new Appointment();
            a.setCustomer(customer);
            a.setPet(pet);
            a.setAppointmentDate(start);
            a.setEndDate(end);
            a.setNotes(notes);

            for (Long sid : serviceIds) {
                Service sv = s.get(Service.class, sid);
                if (sv != null) a.getServices().add(sv);
            }
            a.calculateTotalAmount();



            Staff staff = getDefaultStaff(s);
            Receptionist recep = getDefaultReceptionist(s);
            if (staff == null) throw new IllegalArgumentException("No available staff found");
            a.setStaff(staff);
            if (recep != null) a.setReceptionist(recep);

            a.setStatus(AppointmentStatus.SCHEDULED);
            a.setCreatedAt(LocalDateTime.now());
            a.setUpdatedAt(LocalDateTime.now());

            s.persist(a);




            s.persist(a);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) {
                try {
                    var st = tx.getStatus();
                    if (st != null && (st.isOneOf(
                            org.hibernate.resource.transaction.spi.TransactionStatus.ACTIVE,
                            org.hibernate.resource.transaction.spi.TransactionStatus.MARKED_ROLLBACK))) {
                        tx.rollback();
                    }
                } catch (Exception ignore) {  }
            }
            throw e;
        } finally {
            if (s != null && s.isOpen()) {
                try { s.close(); } catch (Exception ignore) {}
            }
        }
    }

    public boolean cancelIfOwnedBy(Long appointmentId, Long customerAccountId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();

            Appointment a = s.get(Appointment.class, appointmentId);
            if (a == null || a.getCustomer() == null ||
                    !Objects.equals(a.getCustomer().getAccountId(), customerAccountId)) {
                return false;
            }
            if (!a.canBeCancelled()) return false;

            a.cancel();
            s.merge(a);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    /** Lịch hẹn theo khoảng ngày (view cho staff) */
    public List<Appointment> findByDate(LocalDateTime startOfDay, LocalDateTime endOfDay) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = """
                    select a from Appointment a
                    join fetch a.customer
                    join fetch a.pet
                    where a.appointmentDate >= :start and a.appointmentDate < :end
                    order by a.appointmentDate asc
                    """;
            var q = s.createQuery(hql, Appointment.class)
                    .setParameter("start", startOfDay)
                    .setParameter("end", endOfDay)
                    .setReadOnly(true);
            return q.getResultList();
        }
    }

    /** DS đủ điều kiện check-in trong ngày (SCHEDULED/IN_PROGRESS) */
    public List<Appointment> findCheckInEligible(LocalDateTime startOfDay, LocalDateTime endOfDay) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = """
                    select a from Appointment a
                    join fetch a.customer
                    join fetch a.pet
                    left join fetch a.services
                    where a.appointmentDate >= :start and a.appointmentDate < :end
                      and (a.status = :scheduled or a.status = :inProgress)
                    order by a.appointmentDate asc
                    """;
            return s.createQuery(hql, Appointment.class)
                    .setParameter("start", startOfDay)
                    .setParameter("end", endOfDay)
                    .setParameter("scheduled", AppointmentStatus.SCHEDULED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS)
                    .setReadOnly(true)
                    .getResultList();
        }
    }

    public List<Appointment> findCheckInEligibleWithFilter(LocalDateTime startOfDay, LocalDateTime endOfDay,
                                                           String customerName, String petName,
                                                           int page, int pageSize) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            // step 1: lấy id theo filter
            StringBuilder hql = new StringBuilder("""
                    select a.appointmentId from Appointment a
                    join a.customer c
                    join a.pet p
                    where a.appointmentDate >= :start and a.appointmentDate < :end
                      and (a.status = :scheduled or a.status = :inProgress)
                    """);

            if (customerName != null && !customerName.isBlank()) hql.append("and lower(c.fullName) like :cname ");
            if (petName != null && !petName.isBlank())           hql.append("and lower(p.name) like :pname ");
            hql.append("order by a.appointmentDate asc");

            var q = s.createQuery(hql.toString(), Long.class)
                    .setParameter("start", startOfDay)
                    .setParameter("end", endOfDay)
                    .setParameter("scheduled", AppointmentStatus.SCHEDULED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .setReadOnly(true);

            if (customerName != null && !customerName.isBlank()) q.setParameter("cname", "%"+customerName.toLowerCase()+"%");
            if (petName != null && !petName.isBlank())           q.setParameter("pname", "%"+petName.toLowerCase()+"%");

            List<Long> ids = q.getResultList();
            if (ids.isEmpty()) return new ArrayList<>();

            // step 2: fetch đầy đủ
            String fetch = """
                    select a from Appointment a
                    join fetch a.customer
                    join fetch a.pet
                    left join fetch a.services
                    where a.appointmentId in :ids
                    order by a.appointmentDate asc
                    """;
            return s.createQuery(fetch, Appointment.class)
                    .setParameter("ids", ids)
                    .setReadOnly(true)
                    .getResultList();
        }
    }

    public long countCheckInEligible(LocalDateTime startOfDay, LocalDateTime endOfDay,
                                     String customerName, String petName) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("""
                    select count(distinct a.appointmentId) from Appointment a
                    join a.customer c
                    join a.pet p
                    where a.appointmentDate >= :start and a.appointmentDate < :end
                      and (a.status = :scheduled or a.status = :inProgress)
                    """);
            if (customerName != null && !customerName.isBlank()) hql.append("and lower(c.fullName) like :cname ");
            if (petName != null && !petName.isBlank())           hql.append("and lower(p.name) like :pname ");

            var q = s.createQuery(hql.toString(), Long.class)
                    .setParameter("start", startOfDay)
                    .setParameter("end", endOfDay)
                    .setParameter("scheduled", AppointmentStatus.SCHEDULED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS)
                    .setReadOnly(true);

            if (customerName != null && !customerName.isBlank()) q.setParameter("cname", "%"+customerName.toLowerCase()+"%");
            if (petName != null && !petName.isBlank())           q.setParameter("pname", "%"+petName.toLowerCase()+"%");
            return q.getSingleResult();
        }
    }

    public List<Appointment> findCheckedIn() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = """
                    select a from Appointment a
                    join fetch a.customer
                    join fetch a.pet
                    left join fetch a.services
                    where a.status = :confirmed or a.status = :inProgress
                    order by a.updatedAt asc
                    """;
            return s.createQuery(hql, Appointment.class)
                    .setParameter("confirmed", AppointmentStatus.CONFIRMED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS)
                    .setReadOnly(true)
                    .getResultList();
        }
    }

    public List<Appointment> findCheckedInWithFilter(String customerName, String petName,
                                                     int page, int pageSize) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("""
                    select a.appointmentId from Appointment a
                    join a.customer c
                    join a.pet p
                    where (a.status = :confirmed or a.status = :inProgress)
                    """);
            if (customerName != null && !customerName.isBlank()) hql.append("and lower(c.fullName) like :cname ");
            if (petName != null && !petName.isBlank())           hql.append("and lower(p.name) like :pname ");
            hql.append("order by a.updatedAt asc");

            var idQ = s.createQuery(hql.toString(), Long.class)
                    .setParameter("confirmed", AppointmentStatus.CONFIRMED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .setReadOnly(true);

            if (customerName != null && !customerName.isBlank()) idQ.setParameter("cname", "%"+customerName.toLowerCase()+"%");
            if (petName != null && !petName.isBlank())           idQ.setParameter("pname", "%"+petName.toLowerCase()+"%");

            List<Long> ids = idQ.getResultList();
            if (ids.isEmpty()) return new ArrayList<>();

            String fetch = """
                    select a from Appointment a
                    join fetch a.customer
                    join fetch a.pet
                    left join fetch a.services
                    where a.appointmentId in :ids
                    order by a.updatedAt asc
                    """;
            return s.createQuery(fetch, Appointment.class)
                    .setParameter("ids", ids)
                    .setReadOnly(true)
                    .getResultList();
        }
    }

    public long countCheckedIn(String customerName, String petName) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("""
                    select count(distinct a.appointmentId) from Appointment a
                    join a.customer c
                    join a.pet p
                    where (a.status = :confirmed or a.status = :inProgress)
                    """);
            if (customerName != null && !customerName.isBlank()) hql.append("and lower(c.fullName) like :cname ");
            if (petName != null && !petName.isBlank())           hql.append("and lower(p.name) like :pname ");

            var q = s.createQuery(hql.toString(), Long.class)
                    .setParameter("confirmed", AppointmentStatus.CONFIRMED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS)
                    .setReadOnly(true);

            if (customerName != null && !customerName.isBlank()) q.setParameter("cname", "%"+customerName.toLowerCase()+"%");
            if (petName != null && !petName.isBlank())           q.setParameter("pname", "%"+petName.toLowerCase()+"%");
            return q.getSingleResult();
        }
    }


    public boolean checkIn(Long appointmentId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Appointment a = s.get(Appointment.class, appointmentId);
            if (a == null || !a.canCheckIn()) { if (tx != null) tx.rollback(); return false; }
            a.checkIn();
            s.merge(a);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    public boolean checkOut(Long appointmentId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();

            String hql = """
                    select a from Appointment a
                    left join fetch a.customer
                    left join fetch a.invoice
                    where a.appointmentId = :id
                    """;
            Appointment a = s.createQuery(hql, Appointment.class)
                    .setParameter("id", appointmentId)
                    .uniqueResult();

            if (a == null || !a.canCheckOut()) { if (tx != null) tx.rollback(); return false; }

            a.checkOut();

            if (a.getInvoice() == null) {
                Invoice invoice = new Invoice();
                invoice.setAppointment(a);
                invoice.setCustomer(a.getCustomer());
                invoice.setSubtotal(a.getTotalAmount());
                invoice.setTotalAmount(a.getTotalAmount());
                invoice.setAmountDue(a.getTotalAmount());
                invoice.setIssueDate(LocalDateTime.now());
                invoice.setDueDate(LocalDateTime.now().plusDays(30));
                invoice.setStatus(InvoiceStatus.PENDING);
                s.persist(invoice);
                a.setInvoice(invoice);
            }

            s.merge(a);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }
    public long countCompletedAppointments(LocalDate startDate, LocalDate endDate) {

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM appointments WHERE UPPER(status) = 'COMPLETED'");

            if (startDate != null) {
                sql.append(" AND COALESCE(appointment_date, created_at) >= :from");
            }
            if (endDate != null) {
                sql.append(" AND COALESCE(appointment_date, created_at) <= :to");
            }

            Query<?> query = session.createNativeQuery(sql.toString());

            if (startDate != null) {
                query.setParameter("from", Timestamp.valueOf(startDate.atStartOfDay()));
            }
            if (endDate != null) {
                query.setParameter("to", Timestamp.valueOf(endDate.atTime(LocalTime.MAX)));
            }

            Object result = query.getSingleResult();
            if (result instanceof Number) {
                return ((Number) result).longValue();
            }
            return result != null ? Long.parseLong(result.toString()) : 0L;
        }
    }
    public long countAppointments(LocalDate startDate, LocalDate endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM appointments WHERE 1 = 1");

            if (startDate != null) {
                sql.append(" AND COALESCE(appointment_date, created_at) >= :from");
            }
            if (endDate != null) {
                sql.append(" AND COALESCE(appointment_date, created_at) <= :to");
            }

            Query<?> query = session.createNativeQuery(sql.toString());

            if (startDate != null) {
                query.setParameter("from", Timestamp.valueOf(startDate.atStartOfDay()));
            }
            if (endDate != null) {
                query.setParameter("to", Timestamp.valueOf(endDate.atTime(LocalTime.MAX)));
            }

            Object result = query.getSingleResult();
            if (result instanceof Number) {
                return ((Number) result).longValue();
            }
            return result != null ? Long.parseLong(result.toString()) : 0L;
        }
    }
    public long countPendingAppointments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<AppointmentStatus> pendingStatuses = List.of(
                    AppointmentStatus.SCHEDULED,
                    AppointmentStatus.CONFIRMED,
                    AppointmentStatus.CHECKED_IN,
                    AppointmentStatus.IN_PROGRESS
            );

            Query<Long> query = session.createQuery(
                    "select count(a.appointmentId) from Appointment a where a.status in (:statuses)",
                    Long.class
            );
            query.setParameterList("statuses", pendingStatuses);

            Long result = query.uniqueResult();
            return result != null ? result : 0L;
        }
    }

    public long countPetsInCareOn(LocalDate date) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            LocalDateTime startOfDay = date.atStartOfDay();
            LocalDateTime startOfNextDay = date.plusDays(1).atStartOfDay();

            List<AppointmentStatus> activeStatuses = List.of(
                    AppointmentStatus.CHECKED_IN,
                    AppointmentStatus.IN_PROGRESS
            );

            Query<Long> query = session.createQuery(
                    "select count(distinct a.pet.idpet) from Appointment a " +
                            "where a.appointmentDate >= :startOfDay " +
                            "and a.appointmentDate < :startOfNextDay " +
                            "and a.status in (:statuses)",
                    Long.class
            );
            query.setParameter("startOfDay", startOfDay);
            query.setParameter("startOfNextDay", startOfNextDay);
            query.setParameterList("statuses", activeStatuses);

            Long result = query.uniqueResult();
            return result != null ? result : 0L;
        }
    }
    public List<Appointment> findUpcomingAppointments(int limit) {
        int effectiveLimit = limit <= 0 ? 5 : limit;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            LocalDateTime start = LocalDate.now().atStartOfDay();

            List<Long> ids = session.createQuery(
                            "select a.appointmentId from Appointment a " +
                                    "where a.appointmentDate >= :startOfDay " +
                                    "order by a.appointmentDate asc",
                            Long.class)
                    .setParameter("startOfDay", start)
                    .setMaxResults(effectiveLimit)
                    .list();

            if (ids.isEmpty()) {
                return Collections.emptyList();
            }

            List<Appointment> fetched = session.createQuery(
                            "select distinct a from Appointment a " +
                                    "join fetch a.customer " +
                                    "join fetch a.pet " +
                                    "left join fetch a.staff " +
                                    "left join fetch a.services " +
                                    "where a.appointmentId in (:ids) " +
                                    "order by a.appointmentDate asc",
                            Appointment.class)
                    .setParameterList("ids", ids)
                    .list();

            if (fetched.isEmpty()) {
                return Collections.emptyList();
            }

            Map<Long, Appointment> byId = new HashMap<>();
            for (Appointment appointment : fetched) {
                if (appointment != null && appointment.getAppointmentId() != null) {
                    byId.put(appointment.getAppointmentId(), appointment);
                }
            }

            List<Appointment> ordered = new ArrayList<>(ids.size());
            for (Long id : ids) {
                Appointment appointment = byId.get(id);
                if (appointment != null) {
                    ordered.add(appointment);
                }
            }
            return ordered;
        }
    }

    /** Update appointment */
    public boolean updateAppointment(Appointment appointment) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            appointment.setUpdatedAt(LocalDateTime.now());
            s.merge(appointment);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    /** Delete appointment */
    public boolean deleteAppointment(Long appointmentId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Appointment a = s.get(Appointment.class, appointmentId);
            if (a != null) {
                s.remove(a);
                tx.commit();
                return true;
            }
            if (tx != null) tx.rollback();
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    /** Check if service is available at given time */
    public boolean isServiceAvailableAtTime(Long serviceId, LocalDateTime startTime, LocalDateTime endTime) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            // Check if there are any staff available for this service
            String hql = """
                    select count(st.accountId) from Staff st
                    where st.isAvailable = true
                    and st.accountId not in (
                        select a.staff.accountId from Appointment a
                        where a.status in ('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS')
                        and (
                            (a.appointmentDate <= :start and a.endDate > :start)
                            or (a.appointmentDate < :end and a.endDate >= :end)
                            or (a.appointmentDate >= :start and a.endDate <= :end)
                        )
                    )
                    """;
            
            Long availableStaffCount = s.createQuery(hql, Long.class)
                    .setParameter("start", startTime)
                    .setParameter("end", endTime)
                    .uniqueResult();
            
            return availableStaffCount != null && availableStaffCount > 0;
        }
    }

    /** Assign staff to appointment based on specialization and availability */
    public boolean assignStaffToAppointment(Long appointmentId, Long staffId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            
            Appointment appointment = s.get(Appointment.class, appointmentId);
            Staff staff = s.get(Staff.class, staffId);
            
            if (appointment == null || staff == null) {
                if (tx != null) tx.rollback();
                return false;
            }
            
            // Check if staff is available at appointment time
            if (!staff.getIsAvailable()) {
                if (tx != null) tx.rollback();
                return false;
            }
            
            // Check for time conflicts
            String hql = """
                    select count(a.appointmentId) from Appointment a
                    where a.staff.accountId = :staffId
                    and a.appointmentId != :appointmentId
                    and a.status in ('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS')
                    and (
                        (a.appointmentDate <= :start and a.endDate > :start)
                        or (a.appointmentDate < :end and a.endDate >= :end)
                        or (a.appointmentDate >= :start and a.endDate <= :end)
                    )
                    """;
            
            Long conflictCount = s.createQuery(hql, Long.class)
                    .setParameter("staffId", staffId)
                    .setParameter("appointmentId", appointmentId)
                    .setParameter("start", appointment.getAppointmentDate())
                    .setParameter("end", appointment.getEndDate() != null ? 
                            appointment.getEndDate() : appointment.getAppointmentDate().plusHours(2))
                    .uniqueResult();
            
            if (conflictCount != null && conflictCount > 0) {
                if (tx != null) tx.rollback();
                return false;
            }
            
            // Assign staff to appointment
            appointment.setStaff(staff);
            appointment.setUpdatedAt(LocalDateTime.now());
            s.merge(appointment);
            
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    /** Auto-assign best available staff for appointment */
    public boolean autoAssignStaff(Long appointmentId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            
            Appointment appointment = s.get(Appointment.class, appointmentId);
            if (appointment == null) {
                if (tx != null) tx.rollback();
                return false;
            }
            
            LocalDateTime startTime = appointment.getAppointmentDate();
            LocalDateTime endTime = appointment.getEndDate() != null ? 
                    appointment.getEndDate() : startTime.plusHours(2);
            
            // Find available staff (prioritize by workload)
            String hql = """
                    select s from Staff s
                    where s.isAvailable = true
                    and s.accountId not in (
                        select a.staff.accountId from Appointment a
                        where a.status in ('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS')
                        and (
                            (a.appointmentDate <= :start and a.endDate > :start)
                            or (a.appointmentDate < :end and a.endDate >= :end)
                            or (a.appointmentDate >= :start and a.endDate <= :end)
                        )
                    )
                    order by (
                        select count(a2.appointmentId) from Appointment a2
                        where a2.staff.accountId = s.accountId
                        and a2.appointmentDate >= :dayStart
                        and a2.appointmentDate < :dayEnd
                    ) asc
                    """;
            
            LocalDateTime dayStart = startTime.toLocalDate().atStartOfDay();
            LocalDateTime dayEnd = dayStart.plusDays(1);
            
            List<Staff> availableStaff = s.createQuery(hql, Staff.class)
                    .setParameter("start", startTime)
                    .setParameter("end", endTime)
                    .setParameter("dayStart", dayStart)
                    .setParameter("dayEnd", dayEnd)
                    .setMaxResults(1)
                    .list();
            
            if (availableStaff.isEmpty()) {
                if (tx != null) tx.rollback();
                return false;
            }
            
            appointment.setStaff(availableStaff.get(0));
            appointment.setUpdatedAt(LocalDateTime.now());
            s.merge(appointment);
            
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
}
