package com.petcaresystem.dao;

import com.petcaresystem.enities.Service;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

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

    private static final Logger LOGGER = Logger.getLogger(ServiceDAO.class.getName());

    /** Lấy tất cả service + category (tránh N+1) */
    // getAllServices
    public List<Service> getAllServices() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            List<Service> results = s.createQuery(
                    "select sv from Service sv " +
                            "left join fetch sv.category c " +
                            "order by sv.serviceId desc", Service.class
            ).list();
            if (results == null || results.isEmpty()) {
                return Collections.emptyList();
            }
            return new ArrayList<>(new LinkedHashSet<>(results));
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to load services", ex);
            return Collections.emptyList();
        }
    }

    // searchServices nhận categoryId (Integer)
    public List<Service> searchServices(String keyword, Integer categoryId, Boolean isActive,
                                        String sortBy, String sortOrder) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "select sv from Service sv " +
                            "left join fetch sv.category c where 1=1 ");

            if (keyword != null && !keyword.isBlank()) {
                hql.append(" and (lower(sv.serviceName) like :kw or lower(sv.description) like :kw) ");
            }
            if (categoryId != null) {
                hql.append(" and c.categoryId = :cid ");
            }
            if (isActive != null) {
                hql.append(" and sv.isActive = :act ");
            }

            String col = switch (sortBy == null ? "serviceId" : sortBy) {
                case "serviceName" -> "sv.serviceName";
                case "price"       -> "sv.price";
                case "duration"    -> "sv.durationMinutes";
                case "category"    -> "c.name";
                case "updated"     -> "sv.updatedAt";
                default            -> "sv.serviceId";
            };
            String dir = "DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC";
            hql.append(" order by ").append(col).append(" ").append(dir);

            Query<Service> q = s.createQuery(hql.toString(), Service.class);
            if (keyword != null && !keyword.isBlank()) q.setParameter("kw", "%"+keyword.toLowerCase()+"%");
            if (categoryId != null) q.setParameter("cid", categoryId);
            if (isActive != null) q.setParameter("act", isActive);

            List<Service> results = q.list();
            if (results == null || results.isEmpty()) {
                return Collections.emptyList();
            }
            return new ArrayList<>(new LinkedHashSet<>(results));
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to search services", ex);
            return Collections.emptyList();
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
