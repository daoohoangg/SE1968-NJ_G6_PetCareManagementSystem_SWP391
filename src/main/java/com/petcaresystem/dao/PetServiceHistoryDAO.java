package com.petcaresystem.dao;

import com.petcaresystem.enities.PetServiceHistory;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class PetServiceHistoryDAO {

    // ✅ Lấy toàn bộ lịch sử dịch vụ
    public List<PetServiceHistory> getAllHistories() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from PetServiceHistory", PetServiceHistory.class).list();
        }
    }

    // ✅ Lấy lịch sử theo Pet ID
    public List<PetServiceHistory> getHistoriesByPetId(int petId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "from PetServiceHistory where pet.id = :petId", PetServiceHistory.class)
                    .setParameter("petId", petId)
                    .list();
        }
    }

    // ✅ Lấy chi tiết lịch sử theo ID
    public PetServiceHistory getHistoryById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(PetServiceHistory.class, id);
        }
    }

    // ✅ Thêm mới một bản ghi lịch sử
    public void addHistory(PetServiceHistory history) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(history);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Cập nhật lịch sử
    public void updateHistory(PetServiceHistory history) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(history);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Xóa lịch sử theo ID
    public void deleteHistory(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            PetServiceHistory history = session.get(PetServiceHistory.class, id);
            if (history != null) {
                session.remove(history);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Dành cho test trực tiếp
    public static void main(String[] args) {
        PetServiceHistoryDAO dao = new PetServiceHistoryDAO();
        List<PetServiceHistory> list = dao.getHistoriesByPetId(1);
        list.forEach(System.out::println);
    }
}
