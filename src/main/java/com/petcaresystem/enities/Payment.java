package com.petcaresystem.enities;

import com.petcaresystem.enities.enu.PaymentMethod;
import com.petcaresystem.enities.enu.PaymentStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "payments")
@NoArgsConstructor
@AllArgsConstructor
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "payment_id")
    private Long paymentId;

    @Column(name = "payment_number", unique = true, nullable = false, length = 50)
    private String paymentNumber;

    @Column(name = "amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal amount;

    @Column(name = "payment_date", nullable = false)
    private LocalDateTime paymentDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method", nullable = false, length = 30)
    private PaymentMethod paymentMethod;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private PaymentStatus status = PaymentStatus.PENDING;

    @Column(name = "transaction_id", length = 100)
    private String transactionId;

    @Column(name = "reference_number", length = 100)
    private String referenceNumber;

    @Lob
    @Column(name = "notes")
    private String notes;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "invoice_id", nullable = false)
    private Invoice invoice;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receptionist_id")
    private Receptionist receptionist;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        paymentDate = LocalDateTime.now();
        generatePaymentNumber();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Business logic methods following SOLID principles
    private void generatePaymentNumber() {
        if (this.paymentNumber == null || this.paymentNumber.isEmpty()) {
            this.paymentNumber = "PAY-" + System.currentTimeMillis();
        }
    }

    public void markAsCompleted(String transactionId) {
        this.status = PaymentStatus.COMPLETED;
        this.transactionId = transactionId;
    }

    public void markAsFailed(String reason) {
        this.status = PaymentStatus.FAILED;
        this.notes = (this.notes != null ? this.notes + "\n" : "") + "Failed: " + reason;
    }

    public void markAsCancelled() {
        if (this.status == PaymentStatus.PENDING) {
            this.status = PaymentStatus.CANCELLED;
        }
    }

    public boolean isCompleted() {
        return this.status == PaymentStatus.COMPLETED;
    }

    public boolean canBeRefunded() {
        return this.status == PaymentStatus.COMPLETED;
    }

    public boolean canBeCancelled() {
        return this.status == PaymentStatus.PENDING;
    }

    public void processPayment() {
        if (this.status == PaymentStatus.PENDING) {
            this.status = PaymentStatus.PROCESSING;
        }
    }
}
