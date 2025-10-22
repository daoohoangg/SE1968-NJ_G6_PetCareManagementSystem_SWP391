package com.petcaresystem.enities;

import com.petcaresystem.enities.embeddable.BookingPolicy;
import com.petcaresystem.enities.embeddable.EmailRule;
import com.petcaresystem.enities.embeddable.VoucherRule;
import com.petcaresystem.enities.embeddable.WeeklySchedule;
import jakarta.persistence.*;
import jakarta.validation.Valid;
import lombok.*;

@Entity
@Table(name = "rule_sets",
        uniqueConstraints = @UniqueConstraint(columnNames = {"owner_type", "owner_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RuleSet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "rule_set_id")
    private Long ruleSetId;

    @Column(name = "owner_type", nullable = false, length = 30)
    private String ownerType;

    @Column(name = "owner_id", nullable = false)
    private Long ownerId;

    @Embedded
    @Valid
    private WeeklySchedule weeklySchedule;

    // Voucher (đơn)
    @Embedded
    @Valid
    private VoucherRule voucher;

    // Cấu hình email
    @Embedded
    @Valid
    private EmailRule emailRule;

    // Chính sách đặt lịch
    @Embedded
    @Valid
    private BookingPolicy bookingPolicy;

    // Bật/tắt toàn bộ RuleSet (tuỳ nhu cầu)
    @Column(name = "is_active", nullable = false)
    private boolean active = true;
}
