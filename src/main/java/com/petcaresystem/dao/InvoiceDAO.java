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

    public List<Invoice> findAll() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery("from Invoice i order by i.createdAt desc", Invoice.class).list();
        }
    }

    public Invoice findById(Long id) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(Invoice.class, id);
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
}
