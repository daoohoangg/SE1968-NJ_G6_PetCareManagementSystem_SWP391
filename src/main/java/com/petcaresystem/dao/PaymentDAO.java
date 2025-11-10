package com.petcaresystem.dao;

import com.petcaresystem.enities.*;
import com.petcaresystem.enities.enu.PaymentStatus;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.petcaresystem.enities.enu.PaymentMethod;
import com.petcaresystem.enities.Payment;
import com.petcaresystem.enities.Invoice;


import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import org.hibernate.query.Query;
import java.util.UUID;

public class PaymentDAO {

    public Payment create(Long invoiceId, BigDecimal amount, String method, String notes) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();

            Invoice inv = s.get(Invoice.class, invoiceId);
            if (inv == null) throw new IllegalArgumentException("Invoice not found");

            LocalDateTime now = LocalDateTime.now();
            BigDecimal safeAmount = (amount == null ? BigDecimal.ZERO : amount);

            // map string -> enum; DEFAULT = OTHER (vì enum của bạn: CASH, CREDIT_CARD, DEBIT_CARD, BANK_TRANSFER, OTHER)
            PaymentMethod methodEnum = PaymentMethod.OTHER;
            if (method != null && !method.isBlank()) {
                try { methodEnum = PaymentMethod.valueOf(method.trim().toUpperCase()); }
                catch (IllegalArgumentException ignore) { /* giữ OTHER */ }
            }

            Payment p = new Payment();
            p.setInvoice(inv);
            p.setCustomer(inv.getCustomer());
            p.setAmount(safeAmount);
            p.setPaymentDate(now);
            p.setNotes(notes);

            // các cột thường NOT NULL
            p.setPaymentNumber("PAY-" + System.currentTimeMillis());
            p.setPaymentMethod(methodEnum);                 // ✅ enum
            p.setStatus(PaymentStatus.PENDING);           // ✅ enum
            p.setTransactionId("TRX-" + UUID.randomUUID());
            p.setReferenceNumber("REF-" + inv.getInvoiceId());
            p.setCreatedAt(now);
            p.setUpdatedAt(now);

            s.persist(p);
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
