package com.petcaresystem.dao;

import com.petcaresystem.enities.*;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.math.BigDecimal;
import java.time.LocalDateTime;

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
}
