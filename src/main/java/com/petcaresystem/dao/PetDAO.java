package com.petcaresystem.dao;

import com.petcaresystem.enities.Pet;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class PetDAO {

    // ✅ Lấy danh sách tất cả thú cưng
    public List<Pet> getPet() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Pet", Pet.class).list();
        }
    }

    // ✅ Alias method cho getAllPets()
    public List<Pet> getAllPets() {
        return getPet();
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
            Pet pet = session.get(Pet.class, (long) id);
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
    public Pet getPetById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Pet.class, id);
        }
    }

    // ✅ Kiểm tra Pet có tồn tại hay không
    public boolean existsById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session.createQuery("select count(p.idpet) from Pet p where p.idpet = :id", Long.class)
                    .setParameter("id", id)
                    .uniqueResult();
            return count != null && count > 0;
        }
    }

    // ✅ Lấy danh sách Pet theo customerId
    public List<Pet> findByCustomerId(Long accountId) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery(
                    "FROM Pet p JOIN FETCH p.customer c WHERE p.customer.accountId = :cid ORDER BY p.name",
                    Pet.class
            ).setParameter("cid", accountId).getResultList();
        }
    }

    public long countAllPets() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session.createQuery("select count(p.idpet) from Pet p", Long.class).uniqueResult();
            return count != null ? count : 0L;
        }
    }


    // ✅ Xóa thú cưng thuộc về đúng chủ
    public boolean deleteOwned(Long petId, Long customerId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Pet pet = session.get(Pet.class, petId);
            if (pet != null && pet.getCustomer() != null &&
                    customerId.equals(pet.getCustomer().getAccountId())) {
                session.remove(pet);
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

    // ✅ Test nhanh
    public static void main(String[] args) {
        PetDAO petDAO = new PetDAO();
        List<Pet> pets = petDAO.getPet();
        pets.forEach(System.out::println);
    }
}
