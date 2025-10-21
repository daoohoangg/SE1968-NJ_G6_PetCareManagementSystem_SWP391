package com.petcaresystem.enities.embeddable;

import jakarta.persistence.*;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
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
public class EmailRule implements Serializable {

    @Column(name = "appointment_confirmation", nullable = false)
    private boolean appointmentConfirmation;  // gửi email xác nhận đặt lịch

    @Column(name = "reminder_notify", nullable = false)
    private boolean reminderNotify;          // gửi email nhắc lịch

    @Column(name = "promotional_email", nullable = false)
    private boolean promotionalEmail;        // gửi email khuyến mại

    // 0 < reminderHours < 24  => dùng 1..23
    @Min(value = 1, message = "reminderHours phải >= 1")
    @Max(value = 23, message = "reminderHours phải <= 23")
    @Column(name = "reminder_hours")
    private Integer reminderHours;

    @Size(max = 2000)
    @Column(name = "email_template", length = 2000)
    private String emailTemplate;

    @AssertTrue(message = "Khi bật reminderNotify, reminderHours phải trong 1..23")
    public boolean isReminderValid() {
        if (!reminderNotify) return true;
        return reminderHours != null && reminderHours >= 1 && reminderHours <= 23;
    }
}
