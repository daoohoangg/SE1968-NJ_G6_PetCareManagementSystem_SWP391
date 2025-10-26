package com.petcaresystem.enities;

import com.petcaresystem.enities.enu.InvoiceStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Entity
@Table(name = "invoices")
@NoArgsConstructor
@AllArgsConstructor
public class Invoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "invoice_id")
    private Long invoiceId;

    @Column(name = "invoice_number", unique = true, nullable = false, length = 50)
    private String invoiceNumber;

    @Column(name = "issue_date", nullable = false)
    private LocalDateTime issueDate;

    @Column(name = "due_date", nullable = false)
    private LocalDateTime dueDate;

    @Column(name = "subtotal", nullable = false, precision = 10, scale = 2)
    private BigDecimal subtotal;

    @Column(name = "tax_amount", precision = 10, scale = 2)
    private BigDecimal taxAmount = BigDecimal.ZERO;

    @Column(name = "discount_amount", precision = 10, scale = 2)
    private BigDecimal discountAmount = BigDecimal.ZERO;

    @Column(name = "total_amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "amount_paid", precision = 10, scale = 2)
    private BigDecimal amountPaid = BigDecimal.ZERO;

    @Column(name = "amount_due", precision = 10, scale = 2)
    private BigDecimal amountDue;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private InvoiceStatus status = InvoiceStatus.PENDING;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relationships
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "appointment_id", nullable = false)
    private Appointment appointment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "voucher_id") // Optional, as an invoice might not use a voucher
    private Voucher voucher;

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Payment> payments = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        generateInvoiceNumber();
        calculateAmountDue();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Business logic methods following SOLID principles
    private void generateInvoiceNumber() {
        if (this.invoiceNumber == null || this.invoiceNumber.isEmpty()) {
            this.invoiceNumber = "INV-" + System.currentTimeMillis();
        }
    }

    public void calculateTotalAmount() {
        this.totalAmount = this.subtotal
                .add(this.taxAmount)
                .subtract(this.discountAmount);
        calculateAmountDue();
    }

    public void calculateAmountDue() {
        this.amountDue = this.totalAmount.subtract(this.amountPaid);
        updateStatus();
    }

    public void addPayment(Payment payment) {
        payments.add(payment);
        payment.setInvoice(this);
        this.amountPaid = this.amountPaid.add(payment.getAmount());
        calculateAmountDue();
    }

    public void applyDiscount(BigDecimal discount) {
        this.discountAmount = discount;
        calculateTotalAmount();
    }

    public void applyTax(BigDecimal tax) {
        this.taxAmount = tax;
        calculateTotalAmount();
    }

    private void updateStatus() {
        if (this.amountDue.compareTo(BigDecimal.ZERO) == 0) {
            this.status = InvoiceStatus.PAID;
        } else if (this.amountPaid.compareTo(BigDecimal.ZERO) > 0
                && this.amountDue.compareTo(BigDecimal.ZERO) > 0) {
            this.status = InvoiceStatus.PARTIALLY_PAID;
        } else if (LocalDateTime.now().isAfter(this.dueDate)
                && this.amountDue.compareTo(BigDecimal.ZERO) > 0) {
            this.status = InvoiceStatus.OVERDUE;
        }
    }

    public void markAsPaid() {
        this.status = InvoiceStatus.PAID;
        this.amountPaid = this.totalAmount;
        this.amountDue = BigDecimal.ZERO;
    }

    public void markAsCancelled() {
        this.status = InvoiceStatus.CANCELLED;
    }

    public boolean isPaid() {
        return this.status == InvoiceStatus.PAID;
    }

    public boolean isOverdue() {
        return this.status == InvoiceStatus.OVERDUE;
    }

    public boolean canBeModified() {
        return this.status == InvoiceStatus.PENDING || this.status == InvoiceStatus.SENT;
    }
    
    // Helper methods for JSP display
    public String getFormattedIssueDate() {
        if (issueDate == null) return "";
        return issueDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
    
    public String getFormattedDueDate() {
        if (dueDate == null) return "";
        return dueDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
    
    public String getFormattedTotal() {
        return String.format("$%,.2f", totalAmount);
    }
    
    public String getFormattedAmountDue() {
        return String.format("$%,.2f", amountDue);
    }
    
    public String getStatusBadgeClass() {
        switch (status) {
            case PAID: return "success";
            case PARTIALLY_PAID: return "warning";
            case OVERDUE: return "danger";
            case CANCELLED: return "secondary";
            default: return "primary";
        }
    }
}
