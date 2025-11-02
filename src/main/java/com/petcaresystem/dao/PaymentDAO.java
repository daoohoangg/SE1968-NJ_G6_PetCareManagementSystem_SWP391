package com.petcaresystem.dao;

import com.petcaresystem.enities.*;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import org.hibernate.query.Query;

public class PaymentDAO {

    public Payment create(Long invoiceId, BigDecimal amount, String method, String notes) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();

            Invoice inv = s.get(Invoice.class, invoiceId);
            if (inv == null) throw new IllegalArgumentException("Invoice not found");

            Payment p = new Payment();
            p.setInvoice(inv);
            p.setCustomer(inv.getCustomer());
            p.setAmount(amount);
            p.setPaymentDate(LocalDateTime.now());
            p.setNotes(notes);
            // Default method if enum exists, set via controller/service

            inv.addPayment(p);
            s.persist(p);
            s.merge(inv);

            tx.commit();
            return p;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    public BigDecimal getTotalRevenue(LocalDate startDate, LocalDate endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder sql = new StringBuilder(
                    "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE UPPER(status) = 'COMPLETED'");

            if (startDate != null) {
                sql.append(" AND COALESCE(payment_date, created_at) >= :from");
            }
            if (endDate != null) {
                sql.append(" AND COALESCE(payment_date, created_at) <= :to");
            }

            Query<?> query = session.createNativeQuery(sql.toString());

            if (startDate != null) {
                query.setParameter("from", Timestamp.valueOf(startDate.atStartOfDay()));
            }
            if (endDate != null) {
                query.setParameter("to", Timestamp.valueOf(endDate.atTime(LocalTime.MAX)));
            }

            Object result = query.getSingleResult();
            if (result == null) {
                return BigDecimal.ZERO;
            }
            if (result instanceof BigDecimal) {
                return (BigDecimal) result;
            }
            if (result instanceof Number) {
                return BigDecimal.valueOf(((Number) result).doubleValue());
            }
            return new BigDecimal(result.toString());
        }
    }
}
