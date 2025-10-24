package com.petcaresystem.enities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "vouchers")
public class Voucher {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "voucher_id")
    private Long voucherId;

    @Column(name = "code", unique = true, nullable = false, length = 20)
    private String code;

    @Column(name = "discount_type", nullable = false, length = 10) // e.g., PERCENTAGE, FIXED
    private String discountType;

    @Column(name = "discount_value", nullable = false, precision = 5, scale = 2)
    private BigDecimal discountValue;

    @Column(name = "expiry_date")
    private LocalDateTime expiryDate;

    @Column(name = "max_uses")
    private Integer maxUses;

    @Column(name = "times_used")
    private Integer timesUsed = 0; // Tracks how many times this specific voucher code has been used

    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
