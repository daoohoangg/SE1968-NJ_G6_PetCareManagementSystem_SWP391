package com.petcaresystem.controller.checkin_out;

import com.petcaresystem.service.checkin_out.BookingService;
import com.petcaresystem.enities.Booking;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckInController", urlPatterns = {"/reception/checkin"})
public class CheckInController extends HttpServlet {

    private BookingService bookingService;

    @Override
    public void init() {
        bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Booking> pending = bookingService.getPendingBookings();
        request.setAttribute("bookings", pending);

        request.getRequestDispatcher("/checkin_out/checkin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            bookingService.checkIn(bookingId);
            request.getSession().setAttribute("success", "Check-in completed successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to check-in: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/reception/checkin");
    }
}
