package com.petcaresystem.dao;

import com.petcaresystem.enities.Pet;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class PetDAO {

    // ✅ Lấy danh sách tất cả thú cưng
    public List<Pet> getPet() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<Pet> pets = session.createQuery("from Pet", Pet.class).list();
        session.close();
        return pets;
    }

    // ✅ Thêm thú cưng mới
    public void addPet(Pet pet) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(pet);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Cập nhật thông tin thú cưng
    public void updatePet(Pet pet) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(pet);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Xóa thú cưng theo ID
    public void deletePet(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Pet pet = session.get(Pet.class, id);
            if (pet != null) {
                session.remove(pet);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Lấy thú cưng theo ID
    public Pet getPetById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Pet pet = session.get(Pet.class, id);
        session.close();
        return pet;
    }

    // ✅ Kiểm tra Pet có tồn tại hay không
    public boolean existsById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Long count = session.createQuery("select count(p.idpet) from Pet p where p.idpet = :id", Long.class)
                .setParameter("id", id)
                .uniqueResult();
        session.close();
        return count != null && count > 0;
    }

    // ✅ Dành cho test trực tiếp
    public static void main(String[] args) {
        PetDAO petDAO = new PetDAO();
        List<Pet> pets = petDAO.getPet();
        pets.forEach(System.out::println);
    }
}
