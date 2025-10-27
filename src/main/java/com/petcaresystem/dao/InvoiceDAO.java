package com.petcaresystem.dao;

import com.petcaresystem.enities.*;
import com.petcaresystem.enities.enu.InvoiceStatus;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class InvoiceDAO {

    private static final int PAGE_SIZE = 10;

    // ✅ Get all invoices with pagination
    public List<Invoice> findAll(int page, int pageSize) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery(
                    "select i from Invoice i " +
                    "left join fetch i.customer " +
                    "left join fetch i.appointment " +
                    "order by i.createdAt desc", Invoice.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .getResultList();
        }
    }
    
    // Overload: without pagination (backward compatibility)
    public List<Invoice> findAll() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery(
                    "select i from Invoice i " +
                    "left join fetch i.customer " +
                    "left join fetch i.appointment " +
                    "order by i.createdAt desc", Invoice.class)
                    .getResultList();
        }
    }
    
    // Count total invoices
    public long countAll() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery("select count(i) from Invoice i", Long.class)
                    .uniqueResult();
        }
    }

    public Invoice findById(Long id) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery(
                    "select i from Invoice i " +
                    "left join fetch i.customer " +
                    "left join fetch i.appointment " +
                    "where i.invoiceId = :id", Invoice.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    public Invoice findByAppointmentId(Long appointmentId) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "from Invoice i where i.appointment.appointmentId = :aid";
            return s.createQuery(hql, Invoice.class)
                    .setParameter("aid", appointmentId)
                    .uniqueResult();
        }
    }

    public Invoice createForAppointment(Long appointmentId, BigDecimal subtotal, BigDecimal tax, BigDecimal discount, LocalDateTime dueDate) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();

            Appointment a = s.get(Appointment.class, appointmentId);
            if (a == null) throw new IllegalArgumentException("Appointment not found");

            Invoice i = new Invoice();
            i.setAppointment(a);
            i.setCustomer(a.getCustomer());
            i.setIssueDate(LocalDateTime.now());
            i.setDueDate(dueDate != null ? dueDate : LocalDateTime.now().plusDays(7));
            i.setSubtotal(subtotal != null ? subtotal : a.getTotalAmount());
            i.setTaxAmount(tax != null ? tax : BigDecimal.ZERO);
            i.setDiscountAmount(discount != null ? discount : BigDecimal.ZERO);
            i.calculateTotalAmount();
            i.setStatus(InvoiceStatus.PENDING);

            s.persist(i);
            a.generateInvoice(i);
            s.merge(a);

            tx.commit();
            return i;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    public void update(Invoice invoice) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            s.merge(invoice);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }
    
    // ✅ Search & Filter with pagination
    public List<Invoice> searchAndFilter(String searchTerm, InvoiceStatus status, int page, int pageSize) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "select i from Invoice i " +
                    "left join fetch i.customer c " +
                    "left join fetch i.appointment " +
                    "where 1=1 ");
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                hql.append("and (lower(i.invoiceNumber) like lower(:term) " +
                          "or lower(c.fullName) like lower(:term)) ");
            }
            
            if (status != null) {
                hql.append("and i.status = :status ");
            }
            
            hql.append("order by i.createdAt desc");
            
            var query = s.createQuery(hql.toString(), Invoice.class);
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                query.setParameter("term", "%" + searchTerm + "%");
            }
            
            if (status != null) {
                query.setParameter("status", status);
            }
            
            return query.setFirstResult((page - 1) * pageSize)
                       .setMaxResults(pageSize)
                       .list();
        }
    }
    
    // Count search/filter results
    public long countSearchAndFilter(String searchTerm, InvoiceStatus status) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "select count(i) from Invoice i " +
                    "join i.customer c " +
                    "where 1=1 ");
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                hql.append("and (lower(i.invoiceNumber) like lower(:term) " +
                          "or lower(c.fullName) like lower(:term)) ");
            }
            
            if (status != null) {
                hql.append("and i.status = :status ");
            }
            
            var query = s.createQuery(hql.toString(), Long.class);
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                query.setParameter("term", "%" + searchTerm + "%");
            }
            
            if (status != null) {
                query.setParameter("status", status);
            }
            
            return query.uniqueResult();
        }
    }
    
    // Get invoices by customer
    public List<Invoice> findByCustomerId(Long customerId) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery(
                    "select i from Invoice i " +
                    "left join fetch i.customer " +
                    "left join fetch i.appointment " +
                    "where i.customer.accountId = :customerId " +
                    "order by i.createdAt desc", Invoice.class)
                    .setParameter("customerId", customerId)
                    .getResultList();
        }
    }
    
    // Delete invoice
    public void delete(Long invoiceId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Invoice invoice = s.get(Invoice.class, invoiceId);
            if (invoice != null) {
                s.remove(invoice);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }
}
