package com.petcaresystem.dao;

import com.petcaresystem.enities.Service;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class ServiceDAO {
    
    // Get all services
    public List<Service> getAllServices() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Service ORDER BY serviceId DESC", Service.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // Get service by ID
    public Service getServiceById(int serviceId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Service.class, serviceId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // Create new service
    public boolean createService(Service service) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(service);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
    
    // Update service
    public boolean updateService(Service service) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(service);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete service (soft delete by setting isActive to false)
    public boolean deleteService(int serviceId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Service service = session.get(Service.class, serviceId);
            if (service != null) {
                service.setActive(false);
                session.merge(service);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
    
    // Hard delete service
    public boolean hardDeleteService(int serviceId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Service service = session.get(Service.class, serviceId);
            if (service != null) {
                session.remove(service);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
    
    // Search services with filters and sorting
    public List<Service> searchServices(String keyword, String category, Boolean isActive, 
                                       String sortBy, String sortOrder) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("FROM Service WHERE 1=1");
            
            // Add keyword search
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append(" AND (LOWER(serviceName) LIKE :keyword OR LOWER(description) LIKE :keyword)");
            }
            
            // Add category filter
            if (category != null && !category.trim().isEmpty()) {
                hql.append(" AND category = :category");
            }
            
            // Add active status filter
            if (isActive != null) {
                hql.append(" AND isActive = :isActive");
            }
            
            // Add sorting
            if (sortBy != null && !sortBy.trim().isEmpty()) {
                hql.append(" ORDER BY ").append(sortBy);
                if (sortOrder != null && sortOrder.equalsIgnoreCase("DESC")) {
                    hql.append(" DESC");
                } else {
                    hql.append(" ASC");
                }
            } else {
                hql.append(" ORDER BY serviceId DESC");
            }
            
            Query<Service> query = session.createQuery(hql.toString(), Service.class);
            
            // Set parameters
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.toLowerCase() + "%");
            }
            if (category != null && !category.trim().isEmpty()) {
                query.setParameter("category", category);
            }
            if (isActive != null) {
                query.setParameter("isActive", isActive);
            }
            
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // Get all active services
    public List<Service> getActiveServices() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Service WHERE isActive = true ORDER BY serviceName", Service.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // Get services by category
    public List<Service> getServicesByCategory(String category) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Service> query = session.createQuery(
                "FROM Service WHERE category = :category ORDER BY serviceName", Service.class);
            query.setParameter("category", category);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // Get all distinct categories
    public List<String> getAllCategories() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("SELECT DISTINCT category FROM Service WHERE category IS NOT NULL ORDER BY category", String.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
