package com.petcaresystem.dao;

import com.petcaresystem.enities.Booking;
import jakarta.persistence.*;
import java.util.List;

public class BookingDAO {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("petcare");

    public List<Booking> getBookingsByStatus(String status) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT b FROM Booking b WHERE b.status = :status", Booking.class)
                    .setParameter("status", status)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Booking getBookingById(int id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Booking.class, id);
        } finally {
            em.close();
        }
    }

    public void updateStatus(int bookingId, String newStatus) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Booking booking = em.find(Booking.class, bookingId);
            if (booking != null) {
                booking.setStatus(newStatus);
                em.merge(booking);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
