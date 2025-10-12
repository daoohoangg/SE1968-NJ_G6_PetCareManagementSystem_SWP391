package com.petcaresystem.dao;

import com.petcaresystem.enities.PetServiceHistory;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class PetServiceHistoryDAO {

    // ✅ Lấy toàn bộ danh sách lịch sử dịch vụ
    public List<PetServiceHistory> getAllHistories() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<PetServiceHistory> histories = session.createQuery("from PetServiceHistory", PetServiceHistory.class).list();
        session.close();
        return histories;
    }

    // ✅ Lấy danh sách lịch sử dịch vụ theo ID thú cưng
    public List<PetServiceHistory> getHistoriesByPetId(int idpet) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<PetServiceHistory> histories = session.createQuery(
                        "from PetServiceHistory where pet.idpet = :idpet", PetServiceHistory.class)
                .setParameter("idpet", idpet)
                .list();
        session.close();
        return histories;
    }

    // ✅ Thêm mới một lịch sử dịch vụ
    public void addHistory(PetServiceHistory history) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        session.save(history);
        tx.commit();
        session.close();
    }

    // ✅ Cập nhật lịch sử dịch vụ
    public void updateHistory(PetServiceHistory history) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        session.update(history);
        tx.commit();
        session.close();
    }

    // ✅ Xóa lịch sử dịch vụ
    public void deleteHistory(int idhistory) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        PetServiceHistory history = session.get(PetServiceHistory.class, idhistory);
        if (history != null) {
            session.delete(history);
        }
        tx.commit();
        session.close();
    }

    // ✅ Test nhanh DAO
    public static void main(String[] args) {
        PetServiceHistoryDAO dao = new PetServiceHistoryDAO();
        List<PetServiceHistory> histories = dao.getAllHistories();
        histories.forEach(System.out::println);
    }
    public PetServiceHistory getHistoryById(int idhistory) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        PetServiceHistory history = session.get(PetServiceHistory.class, idhistory);
        session.close();
        return history;
    }

}
