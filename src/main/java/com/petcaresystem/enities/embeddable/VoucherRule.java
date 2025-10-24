package com.petcaresystem.enities.embeddable;

import com.petcaresystem.enities.enu.DiscountType;
import jakarta.persistence.*;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VoucherRule implements Serializable {

    @Size(max = 50)
    @Column(name = "voucher_code", length = 50)
    private String voucherCode;

    @DecimalMin(value = "0.0", inclusive = false, message = "amount phải > 0")
    @Digits(integer = 12, fraction = 2)
    @Column(name = "amount", precision = 14, scale = 2)
    private BigDecimal amount;

    @Enumerated(EnumType.STRING)
    @Column(name = "discount_type", length = 20)
    private DiscountType discountType;

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "voucher_active", nullable = false)
    private boolean active = false;

    @AssertTrue(message = "Với PERCENTAGE, amount phải trong (0,100]")
    public boolean isPercentValid() {
        if (discountType != DiscountType.PERCENTAGE || amount == null) return true;
        return amount.compareTo(BigDecimal.ZERO) > 0 &&
                amount.compareTo(new BigDecimal("100")) <= 0;
    }
}
