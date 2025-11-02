package com.petcaresystem.dao;

import com.petcaresystem.enities.Customer;
import com.petcaresystem.enities.Pet;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class PetDAO {

    /* ================== LIST / READ ================== */

    // Giữ lại hàm cũ
    public List<Pet> getPet() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Pet", Pet.class).list();
        }
    }

    public List<Pet> getAllPets() { return getPet(); }

    public Pet getPetById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Pet.class, id);
        }
    }

    public boolean existsById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session.createQuery(
                            "select count(p.idpet) from Pet p where p.idpet = :id", Long.class)
                    .setParameter("id", id)
                    .uniqueResult();
            return count != null && count > 0;
        }
    }

    public List<Pet> findByCustomerId(Long accountId) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery(
                            "select p from Pet p join fetch p.customer c " +
                                    "where c.accountId = :cid order by p.name", Pet.class)
                    .setParameter("cid", accountId)
                    .getResultList();
        }
    }

    public long countAllPets() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session.createQuery("select count(p.idpet) from Pet p", Long.class).uniqueResult();
            return count != null ? count : 0L;
        }
    }

    /* ================== CREATE / UPDATE / DELETE (tên mới khớp controller) ================== */

    // ===== CREATE
    /** Tạo pet và gán đúng chủ dựa vào accountId (controller đang gọi tên này) */
    public void createForCustomer(Long customerAccountId, Pet pet) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();

            Customer customer = s.createQuery(
                            "from Customer c where c.accountId = :aid", Customer.class)
                    .setParameter("aid", customerAccountId)
                    .uniqueResult();

            if (customer == null) {
                throw new IllegalArgumentException("Customer (by accountId) not found");
            }

            pet.setCustomer(customer);
            s.persist(pet);

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            // KHÔNG throw e; -> bọc RuntimeException để khỏi phải khai báo throws
            throw new RuntimeException(e);
        }
    }

    // Giữ lại hàm cũ addPet (nếu nơi khác còn dùng)
    public void addPet(Pet pet) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(pet);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException(e);
        }
    }

    // ===== UPDATE
    /** Alias cho controller */
    public void update(Pet pet) { updatePet(pet); }

    public void updatePet(Pet pet) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(pet);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException(e);
        }
    }

    // ===== DELETE
    /** Alias cho controller – ở đây xoá cứng cho đơn giản (không dùng reflection) */
    public void softDelete(Long petId) { hardDelete(petId); }

    public void hardDelete(Long petId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Pet p = s.get(Pet.class, petId);
            if (p != null) s.remove(p);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException(e);
        }
    }

    // Giữ lại hàm cũ (int id) để không phá chỗ khác:
    public void deletePet(int id) { hardDelete((long) id); }

    /** Xoá chỉ khi đúng chủ (kiểm tra accountId) */
    public boolean deleteOwned(Long petId, Long ownerAccountId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Pet p = s.get(Pet.class, petId);
            if (p != null && p.getCustomer() != null &&
                    ownerAccountId.equals(p.getCustomer().getAccountId())) {
                s.remove(p);
                tx.commit();
                return true;
            }
            if (tx != null) tx.rollback();
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException(e);
        }
    }

    /* ================== ALIAS cho controller gọi ================== */

    // PetSelfController đang gọi findById()
    public Pet findById(Long id) { return getPetById(id); }
}
