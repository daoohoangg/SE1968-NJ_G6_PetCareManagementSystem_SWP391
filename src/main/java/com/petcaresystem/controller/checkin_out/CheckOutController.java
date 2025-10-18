package com.petcaresystem.controller.checkin_out;

import com.petcaresystem.service.checkin_out.BookingService;
import com.petcaresystem.enities.Booking;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckOutController", urlPatterns = {"/reception/checkout"})
public class CheckOutController extends HttpServlet {

    private BookingService bookingService;

    @Override
    public void init() {
        bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Booking> checkedIn = bookingService.getCheckedInBookings();
        request.setAttribute("bookings", checkedIn);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/checkin_out/checkout.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        bookingService.checkOut(bookingId);

        response.sendRedirect(request.getContextPath() + "/reception/checkout");
    }
}
