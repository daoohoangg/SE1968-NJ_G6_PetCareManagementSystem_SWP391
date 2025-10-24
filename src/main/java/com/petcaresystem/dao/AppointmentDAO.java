package com.petcaresystem.dao;

import com.petcaresystem.enities.*;
import com.petcaresystem.enities.enu.AppointmentStatus;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.time.LocalDateTime;
import java.util.List;

public class AppointmentDAO {

    /** Danh sách lịch hẹn của 1 khách, mới nhất trước */
    public List<Appointment> findByCustomer(Long customerId) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "from Appointment a " +
                    "where a.customer.id = :cid " +
                    "order by a.appointmentDate desc";
            return s.createQuery(hql, Appointment.class)
                    .setParameter("cid", customerId)
                    .list();
        }
    }

    /** Upcoming (>= now) cho trang khách hàng */
    public List<Appointment> findUpcomingByCustomer(Long customerId) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "from Appointment a " +
                    "where a.customer.id = :cid and a.appointmentDate >= :now " +
                    "order by a.appointmentDate asc";
            return s.createQuery(hql, Appointment.class)
                    .setParameter("cid", customerId)
                    .setParameter("now", LocalDateTime.now())
                    .list();
        }
    }

    /** Lấy chi tiết 1 lịch */
    public Appointment findById(Long id) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(Appointment.class, id);
        }
    }

    /** Tạo lịch hẹn: load Customer/Pet/Services theo id, staff có thể để null */
    public boolean create(Long customerId,
                          Long petId,
                          List<Long> serviceIds,
                          LocalDateTime start,
                          LocalDateTime end,
                          String notes) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();

            Customer customer = s.get(Customer.class, customerId);
            Pet pet = s.get(Pet.class, petId);
            if (customer == null || pet == null) throw new IllegalArgumentException("Customer/Pet not found");

            Appointment a = new Appointment();
            a.setCustomer(customer);
            a.setPet(pet);
            a.setStaff(null);
            a.setAppointmentDate(start);
            a.setEndDate(end);
            a.setStatus(AppointmentStatus.SCHEDULED);
            a.setNotes(notes);

            // nạp services
            if (serviceIds != null) {
                for (Long sid : serviceIds) {
                    Service sv = s.get(Service.class, sid);
                    if (sv != null) a.getServices().add(sv);
                }
            }
            a.calculateTotalAmount();

            s.persist(a);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    /** Hủy lịch nếu thuộc về customer và còn được hủy */
    public boolean cancelIfOwnedBy(Long appointmentId, Long customerId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Appointment a = s.get(Appointment.class, appointmentId);
            if (a == null || a.getCustomer() == null ||
                    !a.getCustomer().getCustomerId().equals(customerId)) {
                return false;
            }
            if (!a.canBeCancelled()) return false;

            a.cancel();
            s.merge(a);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
}
