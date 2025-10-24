package com.petcaresystem.enities.embeddable;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BookingPolicy implements Serializable {

    @Min(0)
    @Column(name = "maximum_booking_days")
    private Integer maximumBookingDays;

    @Min(0)
    @Column(name = "cancel_notice_hours")
    private Integer cancelNoticeHours;

    @Column(name = "auto_confirm", nullable = false)
    private boolean autoConfirm;
}
