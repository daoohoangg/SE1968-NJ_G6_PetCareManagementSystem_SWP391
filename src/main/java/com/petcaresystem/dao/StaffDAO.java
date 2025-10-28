package com.petcaresystem.dao;

import com.petcaresystem.enities.Staff;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

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
}
