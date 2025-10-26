package com.petcaresystem.dao;

import com.petcaresystem.enities.*;
import com.petcaresystem.enities.enu.AppointmentStatus;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.time.LocalDateTime;
import java.util.List;

public class AppointmentDAO {

    /** Danh sách lịch hẹn của 1 khách, mới nhất trước (EAGER fetch Customer, Pet) */
    public List<Appointment> findByCustomer(Long customerId) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "select a from Appointment a " +
                    "join fetch a.customer " +
                    "join fetch a.pet " +
                    "where a.customer.accountId = :cid " +
                    "order by a.appointmentDate desc";
            return s.createQuery(hql, Appointment.class)
                    .setParameter("cid", customerId)
                    .list();
        }
    }

    /** Upcoming (>= now) cho trang khách hàng (EAGER fetch Customer, Pet) */
    public List<Appointment> findUpcomingByCustomer(Long customerId) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "select a from Appointment a " +
                    "join fetch a.customer " +
                    "join fetch a.pet " +
                    "where a.customer.accountId = :cid and a.appointmentDate >= :now " +
                    "order by a.appointmentDate asc";
            return s.createQuery(hql, Appointment.class)
                    .setParameter("cid", customerId)
                    .setParameter("now", LocalDateTime.now())
                    .list();
        }
    }

    /** Lấy chi tiết 1 lịch (EAGER fetch Customer, Pet, Services) */
    public Appointment findById(Long id) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "select a from Appointment a " +
                    "left join fetch a.customer " +
                    "left join fetch a.pet " +
                    "left join fetch a.services " +
                    "where a.appointmentId = :id";
            return s.createQuery(hql, Appointment.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    /** Tạo lịch hẹn */
    public boolean create(Long customerId,
                          Long petId,
                          List<Long> serviceIds,
                          LocalDateTime start,
                          LocalDateTime end,
                          String notes) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();

            Customer customer = s.get(Customer.class, customerId);
            Pet pet = s.get(Pet.class, petId);
            if (customer == null || pet == null)
                throw new IllegalArgumentException("Customer/Pet not found");

            Appointment a = new Appointment();
            a.setCustomer(customer);
            a.setPet(pet);
            a.setStaff(null);
            a.setAppointmentDate(start);
            a.setEndDate(end);
            a.setStatus(AppointmentStatus.SCHEDULED);
            a.setNotes(notes);

            if (serviceIds != null) {
                for (Long sid : serviceIds) {
                    Service sv = s.get(Service.class, sid);
                    if (sv != null) a.getServices().add(sv);
                }
            }

            a.calculateTotalAmount();
            s.persist(a);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    /** Hủy lịch nếu thuộc về customer */
    public boolean cancelIfOwnedBy(Long appointmentId, Long customerId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Appointment a = s.get(Appointment.class, appointmentId);
            if (a == null || a.getCustomer() == null ||
                    !a.getCustomer().getAccountId().equals(customerId)) {
                return false;
            }
            if (!a.canBeCancelled()) return false;

            a.cancel();
            s.merge(a);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    /** Lấy danh sách appointments theo ngày (EAGER fetch Customer, Pet) */
    public List<Appointment> findByDate(LocalDateTime startOfDay, LocalDateTime endOfDay) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "select a from Appointment a " +
                    "join fetch a.customer " +
                    "join fetch a.pet " +
                    "where a.appointmentDate >= :start and a.appointmentDate < :end " +
                    "order by a.appointmentDate asc";
            return s.createQuery(hql, Appointment.class)
                    .setParameter("start", startOfDay)
                    .setParameter("end", endOfDay)
                    .list();
        }
    }

    /** Lấy appointments có thể check-in */
    public List<Appointment> findCheckInEligible(LocalDateTime startOfDay, LocalDateTime endOfDay) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "select a from Appointment a " +
                    "join fetch a.customer " +
                    "join fetch a.pet " +
                    "left join fetch a.services " +
                    "where a.appointmentDate >= :start and a.appointmentDate < :end " +
                    "and (a.status = :scheduled or a.status = :inProgress) " +
                    "order by a.appointmentDate asc";
            return s.createQuery(hql, Appointment.class)
                    .setParameter("start", startOfDay)
                    .setParameter("end", endOfDay)
                    .setParameter("scheduled", AppointmentStatus.SCHEDULED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS)
                    .getResultList();
        }
    }

    /** Lấy appointments có thể check-in với filter và paging */
    public List<Appointment> findCheckInEligibleWithFilter(LocalDateTime startOfDay, LocalDateTime endOfDay, 
                                                            String customerName, String petName, 
                                                            int page, int pageSize) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            // Step 1: Get appointment IDs with filter and paging
            StringBuilder hql = new StringBuilder("select a.appointmentId from Appointment a " +
                    "join a.customer c " +
                    "join a.pet p " +
                    "where a.appointmentDate >= :start and a.appointmentDate < :end " +
                    "and (a.status = :scheduled or a.status = :inProgress) ");
            
            if (customerName != null && !customerName.trim().isEmpty()) {
                hql.append("and lower(c.fullName) like :customerName ");
            }
            if (petName != null && !petName.trim().isEmpty()) {
                hql.append("and lower(p.name) like :petName ");
            }
            
            hql.append("order by a.appointmentDate asc");
            
            var idQuery = s.createQuery(hql.toString(), Long.class)
                    .setParameter("start", startOfDay)
                    .setParameter("end", endOfDay)
                    .setParameter("scheduled", AppointmentStatus.SCHEDULED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS);
            
            if (customerName != null && !customerName.trim().isEmpty()) {
                idQuery.setParameter("customerName", "%" + customerName.toLowerCase() + "%");
            }
            if (petName != null && !petName.trim().isEmpty()) {
                idQuery.setParameter("petName", "%" + petName.toLowerCase() + "%");
            }
            
            idQuery.setFirstResult((page - 1) * pageSize);
            idQuery.setMaxResults(pageSize);
            
            List<Long> ids = idQuery.getResultList();
            
            if (ids.isEmpty()) {
                return new java.util.ArrayList<>();
            }
            
            // Step 2: Fetch full appointments with eager loading
            String fetchHql = "select a from Appointment a " +
                    "join fetch a.customer " +
                    "join fetch a.pet " +
                    "left join fetch a.services " +
                    "where a.appointmentId in :ids " +
                    "order by a.appointmentDate asc";
            
            return s.createQuery(fetchHql, Appointment.class)
                    .setParameter("ids", ids)
                    .getResultList();
        }
    }

    /** Đếm số appointments có thể check-in với filter */
    public long countCheckInEligible(LocalDateTime startOfDay, LocalDateTime endOfDay, 
                                     String customerName, String petName) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("select count(distinct a.appointmentId) from Appointment a " +
                    "join a.customer c " +
                    "join a.pet p " +
                    "where a.appointmentDate >= :start and a.appointmentDate < :end " +
                    "and (a.status = :scheduled or a.status = :inProgress) ");
            
            if (customerName != null && !customerName.trim().isEmpty()) {
                hql.append("and lower(c.fullName) like :customerName ");
            }
            if (petName != null && !petName.trim().isEmpty()) {
                hql.append("and lower(p.name) like :petName ");
            }
            
            var query = s.createQuery(hql.toString(), Long.class)
                    .setParameter("start", startOfDay)
                    .setParameter("end", endOfDay)
                    .setParameter("scheduled", AppointmentStatus.SCHEDULED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS);
            
            if (customerName != null && !customerName.trim().isEmpty()) {
                query.setParameter("customerName", "%" + customerName.toLowerCase() + "%");
            }
            if (petName != null && !petName.trim().isEmpty()) {
                query.setParameter("petName", "%" + petName.toLowerCase() + "%");
            }
            
            return query.getSingleResult();
        }
    }

    /** Lấy appointments đã check-in (có thể check-out) */
    public List<Appointment> findCheckedIn() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "select a from Appointment a " +
                    "join fetch a.customer " +
                    "join fetch a.pet " +
                    "left join fetch a.services " +
                    "where a.status = :confirmed or a.status = :inProgress " +
                    "order by a.updatedAt asc";
            return s.createQuery(hql, Appointment.class)
                    .setParameter("confirmed", AppointmentStatus.CONFIRMED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS)
                    .getResultList();
        }
    }

    /** Lấy appointments đã check-in với filter và paging */
    public List<Appointment> findCheckedInWithFilter(String customerName, String petName, 
                                                      int page, int pageSize) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            // Step 1: Get appointment IDs with filter and paging
            StringBuilder hql = new StringBuilder("select a.appointmentId from Appointment a " +
                    "join a.customer c " +
                    "join a.pet p " +
                    "where (a.status = :confirmed or a.status = :inProgress) ");
            
            if (customerName != null && !customerName.trim().isEmpty()) {
                hql.append("and lower(c.fullName) like :customerName ");
            }
            if (petName != null && !petName.trim().isEmpty()) {
                hql.append("and lower(p.name) like :petName ");
            }
            
            hql.append("order by a.updatedAt asc");
            
            var idQuery = s.createQuery(hql.toString(), Long.class)
                    .setParameter("confirmed", AppointmentStatus.CONFIRMED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS);
            
            if (customerName != null && !customerName.trim().isEmpty()) {
                idQuery.setParameter("customerName", "%" + customerName.toLowerCase() + "%");
            }
            if (petName != null && !petName.trim().isEmpty()) {
                idQuery.setParameter("petName", "%" + petName.toLowerCase() + "%");
            }
            
            idQuery.setFirstResult((page - 1) * pageSize);
            idQuery.setMaxResults(pageSize);
            
            List<Long> ids = idQuery.getResultList();
            
            if (ids.isEmpty()) {
                return new java.util.ArrayList<>();
            }
            
            // Step 2: Fetch full appointments with eager loading
            String fetchHql = "select a from Appointment a " +
                    "join fetch a.customer " +
                    "join fetch a.pet " +
                    "left join fetch a.services " +
                    "where a.appointmentId in :ids " +
                    "order by a.updatedAt asc";
            
            return s.createQuery(fetchHql, Appointment.class)
                    .setParameter("ids", ids)
                    .getResultList();
        }
    }

    /** Đếm số appointments đã check-in với filter */
    public long countCheckedIn(String customerName, String petName) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("select count(distinct a.appointmentId) from Appointment a " +
                    "join a.customer c " +
                    "join a.pet p " +
                    "where (a.status = :confirmed or a.status = :inProgress) ");
            
            if (customerName != null && !customerName.trim().isEmpty()) {
                hql.append("and lower(c.fullName) like :customerName ");
            }
            if (petName != null && !petName.trim().isEmpty()) {
                hql.append("and lower(p.name) like :petName ");
            }
            
            var query = s.createQuery(hql.toString(), Long.class)
                    .setParameter("confirmed", AppointmentStatus.CONFIRMED)
                    .setParameter("inProgress", AppointmentStatus.IN_PROGRESS);
            
            if (customerName != null && !customerName.trim().isEmpty()) {
                query.setParameter("customerName", "%" + customerName.toLowerCase() + "%");
            }
            if (petName != null && !petName.trim().isEmpty()) {
                query.setParameter("petName", "%" + petName.toLowerCase() + "%");
            }
            
            return query.getSingleResult();
        }
    }

    /** Check-in */
    public boolean checkIn(Long appointmentId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Appointment a = s.get(Appointment.class, appointmentId);
            
            if (a == null) {
                System.out.println("❌ Check-in failed: Appointment #" + appointmentId + " not found");
                return false;
            }
            
            if (!a.canCheckIn()) {
                System.out.println("❌ Check-in failed: Appointment #" + appointmentId + " has status: " + a.getStatus());
                System.out.println("   Required status: SCHEDULED or CONFIRMED");
                return false;
            }

            a.checkIn();
            s.merge(a);
            tx.commit();
            System.out.println("✅ Check-in successful: Appointment #" + appointmentId + " -> CHECKED_IN");
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.out.println("❌ Check-in exception for Appointment #" + appointmentId);
            e.printStackTrace();
            return false;
        }
    }

    /** Check-out và tạo invoice nếu chưa có */
    public boolean checkOut(Long appointmentId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            
            // Eager fetch appointment with invoice to avoid lazy loading issues
            String hql = "select a from Appointment a " +
                    "left join fetch a.customer " +
                    "left join fetch a.invoice " +
                    "where a.appointmentId = :id";
            Appointment a = s.createQuery(hql, Appointment.class)
                    .setParameter("id", appointmentId)
                    .uniqueResult();
            
            if (a == null || !a.canCheckOut()) return false;

            a.checkOut();

            if (a.getInvoice() == null) {
                Invoice invoice = new Invoice();
                invoice.setAppointment(a);
                invoice.setCustomer(a.getCustomer());
                
                // Initialize required fields
                invoice.setSubtotal(a.getTotalAmount());
                invoice.setTotalAmount(a.getTotalAmount());
                invoice.setAmountDue(a.getTotalAmount());
                invoice.setIssueDate(LocalDateTime.now());
                invoice.setDueDate(LocalDateTime.now().plusDays(30)); // 30 days payment term
                invoice.setStatus(com.petcaresystem.enities.enu.InvoiceStatus.PENDING);
                
                s.persist(invoice);
                a.setInvoice(invoice);
            }

            s.merge(a);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
}
