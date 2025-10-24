package com.petcaresystem.service.checkin_out;


import com.petcaresystem.dao.BookingDAO;
import com.petcaresystem.enities.Booking;
import java.util.List;

public class BookingService {

    private final BookingDAO bookingDAO = new BookingDAO();

    public List<Booking> getPendingBookings() {
        return bookingDAO.getBookingsByStatus("Pending");
    }

    public List<Booking> getCheckedInBookings() {
        return bookingDAO.getBookingsByStatus("Checked-In");
    }

    public Booking findBookingById(int id) {
        return bookingDAO.getBookingById(id);
    }

    public void checkIn(int bookingId) {
        bookingDAO.updateStatus(bookingId, "Checked-In");
    }

    public void checkOut(int bookingId) {
        bookingDAO.updateStatus(bookingId, "Checked-Out");
    }
}
