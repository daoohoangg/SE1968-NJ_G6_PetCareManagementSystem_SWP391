package com.petcaresystem.dao;

import com.petcaresystem.enities.Service;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Map;

public class ServiceDAO {

    // Whitelist cột sort -> tránh lỗi cú pháp & injection
    private static final Map<String, String> SORT_MAP = Map.of(
            "serviceId",   "s.serviceId",
            "serviceName", "s.serviceName",
            "price",       "s.price",
            "duration",    "s.durationMinutes",
            "updated",     "s.updatedAt",
            "category",    "c.name" // sort theo thuộc tính scalar của category
    );

    /** Lấy tất cả service + category (tránh N+1) */
    public List<Service> getAllServices() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Service> list = session.createQuery(
                    "SELECT s FROM Service s LEFT JOIN FETCH s.category c ORDER BY s.serviceId DESC",
                    Service.class
            ).list();
            System.out.println("[DAO] services size = " + (list == null ? "null" : list.size()));
            return list != null ? list : java.util.Collections.emptyList();
        } catch (Exception e) {
            e.printStackTrace();
            return java.util.Collections.emptyList();
        }
    }

    /** Lấy 1 service kèm category */
    public Service getServiceById(int serviceId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT s FROM Service s " +
                                    "LEFT JOIN FETCH s.category " +
                                    "WHERE s.serviceId = :id",
                            Service.class
                    ).setParameter("id", serviceId)
                    .uniqueResult();
        }
    }

    /** Tạo service */
    public boolean createService(Service service) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(service);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /** Cập nhật service */
    public boolean updateService(Service service) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(service);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /** Soft delete: set isActive = false */
    public boolean deleteService(int serviceId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Service s = session.get(Service.class, serviceId);
            if (s != null) {
                s.setActive(false);
                session.merge(s);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /** Hard delete */
    public boolean hardDeleteService(int serviceId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Service s = session.get(Service.class, serviceId);
            if (s != null) {
                session.remove(s);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /** Search + filter + sort (dùng categoryId) */
    public List<Service> searchServices(String keyword, Integer categoryId, Boolean isActive,
                                        String sortBy, String sortOrder) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT s FROM Service s " +
                            "LEFT JOIN FETCH s.category c " + // fetch để JSP đọc s.category an toàn
                            "WHERE 1=1 "
            );

            if (keyword != null && !keyword.isBlank()) {
                hql.append("AND (LOWER(s.serviceName) LIKE :kw OR LOWER(s.description) LIKE :kw) ");
            }
            if (categoryId != null) {
                hql.append("AND c.categoryId = :cid ");
            }
            if (isActive != null) {
                hql.append("AND s.isActive = :ia ");
            }

            String orderField = SORT_MAP.getOrDefault(
                    sortBy == null ? "" : sortBy.trim(),
                    "s.serviceId"
            );
            hql.append("ORDER BY ").append(orderField)
                    .append(" DESC".equalsIgnoreCase(sortOrder) ? " DESC" : " ASC");

            Query<Service> q = session.createQuery(hql.toString(), Service.class);

            if (keyword != null && !keyword.isBlank()) {
                q.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            }
            if (categoryId != null) {
                q.setParameter("cid", categoryId);
            }
            if (isActive != null) {
                q.setParameter("ia", isActive);
            }

            return q.list();
        }
    }

    /** Active services */
    public List<Service> getActiveServices() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "SELECT s FROM Service s " +
                            "LEFT JOIN FETCH s.category " +
                            "WHERE s.isActive = true " +
                            "ORDER BY s.serviceName",
                    Service.class
            ).list();
        }
    }

    /** Dịch vụ theo categoryId */
    public List<Service> getServicesByCategoryId(int categoryId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT s FROM Service s " +
                                    "LEFT JOIN FETCH s.category c " +
                                    "WHERE c.categoryId = :cid " +
                                    "ORDER BY s.serviceName",
                            Service.class
                    ).setParameter("cid", categoryId)
                    .list();
        }
    }
}
