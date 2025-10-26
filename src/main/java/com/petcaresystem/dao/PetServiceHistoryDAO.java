package com.petcaresystem.dao;

import com.petcaresystem.enities.PetServiceHistory;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class PetServiceHistoryDAO {

    private static final int DEFAULT_PAGE_SIZE = 10;

    // ✅ UC-PD-01: View Records with Pagination
    public List<PetServiceHistory> getAllHistories(int page, int pageSize) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "select h from PetServiceHistory h " +
                    "join fetch h.pet " +
                    "left join fetch h.staff " +
                    "order by h.serviceDate desc", 
                    PetServiceHistory.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .list();
        }
    }
    
    // Overload: Get all histories without pagination (for backward compatibility)
    public List<PetServiceHistory> getAllHistories() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "select h from PetServiceHistory h " +
                    "join fetch h.pet " +
                    "left join fetch h.staff " +
                    "order by h.serviceDate desc", 
                    PetServiceHistory.class)
                    .list();
        }
    }
    
    // Count total records for pagination
    public long countAllHistories() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "select count(h) from PetServiceHistory h", 
                    Long.class)
                    .uniqueResult();
        }
    }

    // ✅ UC-PD-01: View Records by Pet ID with Pagination
    public List<PetServiceHistory> getHistoriesByPetId(int petId, int page, int pageSize) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "select h from PetServiceHistory h " +
                            "join fetch h.pet " +
                            "left join fetch h.staff " +
                            "where h.pet.idpet = :petId " +
                            "order by h.serviceDate desc", 
                            PetServiceHistory.class)
                    .setParameter("petId", petId)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .list();
        }
    }
    
    // Overload: Get histories by pet ID without pagination (for backward compatibility)
    public List<PetServiceHistory> getHistoriesByPetId(int petId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "select h from PetServiceHistory h " +
                            "join fetch h.pet " +
                            "left join fetch h.staff " +
                            "where h.pet.idpet = :petId " +
                            "order by h.serviceDate desc", 
                            PetServiceHistory.class)
                    .setParameter("petId", petId)
                    .list();
        }
    }
    
    // Count records by pet ID
    public long countHistoriesByPetId(int petId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "select count(h) from PetServiceHistory h where h.pet.idpet = :petId", 
                    Long.class)
                    .setParameter("petId", petId)
                    .uniqueResult();
        }
    }

    // ✅ UC-PD-04: View Record Detail
    public PetServiceHistory getHistoryById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "select h from PetServiceHistory h " +
                    "join fetch h.pet p " +
                    "left join fetch p.customer " +
                    "left join fetch h.staff " +
                    "where h.id = :id", 
                    PetServiceHistory.class)
                    .setParameter("id", id)
                    .uniqueResult();
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

    // ✅ Tìm kiếm theo tên pet hoặc ngày
    public List<PetServiceHistory> searchByPetNameOrDate(String searchTerm) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "select h from PetServiceHistory h " +
                    "join fetch h.pet p " +
                    "where lower(p.name) like lower(:term) " +
                    "or cast(h.serviceDate as string) like :term " +
                    "order by h.serviceDate desc";
            return session.createQuery(hql, PetServiceHistory.class)
                    .setParameter("term", "%" + searchTerm + "%")
                    .list();
        }
    }

    // ✅ Lọc theo loại dịch vụ
    public List<PetServiceHistory> filterByServiceType(String serviceType) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            if (serviceType == null || serviceType.trim().isEmpty() || serviceType.equals("All Services")) {
                return getAllHistories();
            }
            return session.createQuery(
                            "select h from PetServiceHistory h " +
                            "join fetch h.pet " +
                            "where h.serviceType = :type " +
                            "order by h.serviceDate desc", 
                            PetServiceHistory.class)
                    .setParameter("type", serviceType)
                    .list();
        }
    }

    // ✅ UC-PD-02: Search & Filter Records with Pagination
    public List<PetServiceHistory> searchAndFilter(String searchTerm, String serviceType, 
                                                     Integer petId, int page, int pageSize) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "select h from PetServiceHistory h " +
                    "join fetch h.pet p " +
                    "left join fetch h.staff " +
                    "where 1=1 ");
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                hql.append("and (lower(p.name) like lower(:term) " +
                          "or lower(h.description) like lower(:term) " +
                          "or lower(h.notes) like lower(:term)) ");
            }
            
            if (serviceType != null && !serviceType.trim().isEmpty() && !serviceType.equals("All")) {
                hql.append("and h.serviceType = :type ");
            }
            
            if (petId != null && petId > 0) {
                hql.append("and p.idpet = :petId ");
            }
            
            hql.append("order by h.serviceDate desc");
            
            var query = session.createQuery(hql.toString(), PetServiceHistory.class);
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                query.setParameter("term", "%" + searchTerm + "%");
            }
            
            if (serviceType != null && !serviceType.trim().isEmpty() && !serviceType.equals("All")) {
                query.setParameter("type", serviceType);
            }
            
            if (petId != null && petId > 0) {
                query.setParameter("petId", petId);
            }
            
            return query.setFirstResult((page - 1) * pageSize)
                       .setMaxResults(pageSize)
                       .list();
        }
    }
    
    // Overload: Search & Filter without pagination (for backward compatibility)
    public List<PetServiceHistory> searchAndFilter(String searchTerm, String serviceType) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "select h from PetServiceHistory h " +
                    "join fetch h.pet p " +
                    "left join fetch h.staff " +
                    "where 1=1 ");
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                hql.append("and (lower(p.name) like lower(:term) " +
                          "or lower(h.description) like lower(:term) " +
                          "or lower(h.notes) like lower(:term)) ");
            }
            
            if (serviceType != null && !serviceType.trim().isEmpty() && !serviceType.equals("All Services")) {
                hql.append("and h.serviceType = :type ");
            }
            
            hql.append("order by h.serviceDate desc");
            
            var query = session.createQuery(hql.toString(), PetServiceHistory.class);
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                query.setParameter("term", "%" + searchTerm + "%");
            }
            
            if (serviceType != null && !serviceType.trim().isEmpty() && !serviceType.equals("All Services")) {
                query.setParameter("type", serviceType);
            }
            
            return query.list();
        }
    }
    
    // Count search/filter results
    public long countSearchAndFilter(String searchTerm, String serviceType, Integer petId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "select count(h) from PetServiceHistory h " +
                    "join h.pet p " +
                    "where 1=1 ");
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                hql.append("and (lower(p.name) like lower(:term) " +
                          "or lower(h.description) like lower(:term) " +
                          "or lower(h.notes) like lower(:term)) ");
            }
            
            if (serviceType != null && !serviceType.trim().isEmpty() && !serviceType.equals("All")) {
                hql.append("and h.serviceType = :type ");
            }
            
            if (petId != null && petId > 0) {
                hql.append("and p.idpet = :petId ");
            }
            
            var query = session.createQuery(hql.toString(), Long.class);
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                query.setParameter("term", "%" + searchTerm + "%");
            }
            
            if (serviceType != null && !serviceType.trim().isEmpty() && !serviceType.equals("All")) {
                query.setParameter("type", serviceType);
            }
            
            if (petId != null && petId > 0) {
                query.setParameter("petId", petId);
            }
            
            return query.uniqueResult();
        }
    }

    // ✅ Lấy danh sách các loại dịch vụ duy nhất
    public List<String> getDistinctServiceTypes() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "select distinct h.serviceType from PetServiceHistory h order by h.serviceType", 
                            String.class)
                    .list();
        }
    }
}
