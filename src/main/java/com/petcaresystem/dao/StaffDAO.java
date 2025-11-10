package com.petcaresystem.dao;

import com.petcaresystem.enities.Staff;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.time.LocalDateTime;
import java.util.List;

public class StaffDAO {

    // ✅ Lấy danh sách tất cả staff
    public List<Staff> getAllStaff() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Staff", Staff.class).list();
        }
    }

    // ✅ Lấy staff theo ID
    public Staff getStaffById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Staff.class, id);
        }
    }

    // ✅ Thêm staff mới
    public void addStaff(Staff staff) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(staff);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Cập nhật thông tin staff
    public void updateStaff(Staff staff) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(staff);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Xóa staff theo ID
    public void deleteStaff(Long id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Staff staff = session.get(Staff.class, id);
            if (staff != null) {
                session.remove(staff);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Tìm staff theo tên
    public List<Staff> findByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "from Staff s where lower(s.fullName) like lower(:name)", 
                            Staff.class)
                    .setParameter("name", "%" + name + "%")
                    .list();
        }
    }

    // ✅ Kiểm tra staff có tồn tại không
    public boolean existsById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session.createQuery(
                            "select count(s.accountId) from Staff s where s.accountId = :id", 
                            Long.class)
                    .setParameter("id", id)
                    .uniqueResult();
            return count != null && count > 0;
        }
    }

    // ✅ Lấy danh sách staff available (không bận)
    public List<Staff> getAvailableStaff() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "from Staff s where s.isAvailable = true", 
                            Staff.class)
                    .list();
        }
    }

    // ✅ Lấy staff available theo specialization
    public List<Staff> getAvailableStaffBySpecialization(String specialization) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "from Staff s where s.isAvailable = true and lower(s.specialization) like lower(:spec)", 
                            Staff.class)
                    .setParameter("spec", "%" + specialization + "%")
                    .list();
        }
    }

    // ✅ Kiểm tra staff có available trong khoảng thời gian không
    public boolean isStaffAvailableAtTime(Long staffId, LocalDateTime startTime, LocalDateTime endTime) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Check if staff is marked as available
            Staff staff = session.get(Staff.class, staffId);
            if (staff == null || !staff.getIsAvailable()) {
                return false;
            }

            // Check if staff has conflicting appointments
            String hql = """
                    select count(a.appointmentId) from Appointment a
                    where a.staff.accountId = :staffId
                    and a.status in ('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS')
                    and (
                        (a.appointmentDate <= :start and a.endDate > :start)
                        or (a.appointmentDate < :end and a.endDate >= :end)
                        or (a.appointmentDate >= :start and a.endDate <= :end)
                    )
                    """;
            
            Long conflictCount = session.createQuery(hql, Long.class)
                    .setParameter("staffId", staffId)
                    .setParameter("start", startTime)
                    .setParameter("end", endTime)
                    .uniqueResult();
            
            return conflictCount == null || conflictCount == 0;
        }
    }

    // ✅ Lấy danh sách staff available trong khoảng thời gian
    public List<Staff> getAvailableStaffAtTime(LocalDateTime startTime, LocalDateTime endTime) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
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
                    """;
            
            return session.createQuery(hql, Staff.class)
                    .setParameter("start", startTime)
                    .setParameter("end", endTime)
                    .list();
        }
    }

    // ✅ Lấy staff available theo specialization và thời gian
    public List<Staff> getAvailableStaffBySpecializationAndTime(
            String specialization, LocalDateTime startTime, LocalDateTime endTime) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = """
                    select s from Staff s
                    where s.isAvailable = true
                    and lower(s.specialization) like lower(:spec)
                    and s.accountId not in (
                        select a.staff.accountId from Appointment a
                        where a.status in ('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS')
                        and (
                            (a.appointmentDate <= :start and a.endDate > :start)
                            or (a.appointmentDate < :end and a.endDate >= :end)
                            or (a.appointmentDate >= :start and a.endDate <= :end)
                        )
                    )
                    """;
            
            return session.createQuery(hql, Staff.class)
                    .setParameter("spec", "%" + specialization + "%")
                    .setParameter("start", startTime)
                    .setParameter("end", endTime)
                    .list();
        }
    }

    // ✅ Đếm số appointments của staff trong ngày
    public long countStaffAppointmentsOnDate(Long staffId, LocalDateTime startOfDay, LocalDateTime endOfDay) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = """
                    select count(a.appointmentId) from Appointment a
                    where a.staff.accountId = :staffId
                    and a.appointmentDate >= :start
                    and a.appointmentDate < :end
                    and a.status in ('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS')
                    """;
            
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("staffId", staffId)
                    .setParameter("start", startOfDay)
                    .setParameter("end", endOfDay)
                    .uniqueResult();
            
            return count != null ? count : 0;
        }
    }
}
