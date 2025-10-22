package com.petcaresystem.service.billing;

import com.petcaresystem.dao.InvoiceDAO;
import com.petcaresystem.enities.Invoice;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class InvoiceService {

    private final InvoiceDAO invoiceDAO = new InvoiceDAO();

    public List<Invoice> listAll() {
        return invoiceDAO.findAll();
    }

    public Invoice get(Long id) {
        return invoiceDAO.findById(id);
    }

    public Invoice createForAppointment(Long appointmentId, BigDecimal subtotal, BigDecimal tax, BigDecimal discount, LocalDateTime dueDate) {
        return invoiceDAO.createForAppointment(appointmentId, subtotal, tax, discount, dueDate);
    }
}
