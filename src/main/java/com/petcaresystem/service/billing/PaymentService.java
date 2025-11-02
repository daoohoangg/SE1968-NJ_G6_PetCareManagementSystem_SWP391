package com.petcaresystem.service.billing;

import com.petcaresystem.dao.PaymentDAO;
import com.petcaresystem.enities.Payment;

import java.math.BigDecimal;
import java.time.LocalDate;

public class PaymentService {

    private final PaymentDAO paymentDAO = new PaymentDAO();

    public Payment addPayment(Long invoiceId, BigDecimal amount, String method, String notes) {
        return paymentDAO.create(invoiceId, amount, method, notes);
    }

    public BigDecimal getTotalRevenue(LocalDate startDate, LocalDate endDate) {
        return paymentDAO.getTotalRevenue(startDate, endDate);
    }
}
