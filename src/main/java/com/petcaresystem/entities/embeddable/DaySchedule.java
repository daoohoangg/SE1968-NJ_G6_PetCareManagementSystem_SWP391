package com.petcaresystem.enities.embeddable;

import jakarta.persistence.*;
import jakarta.validation.constraints.AssertTrue;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.Objects;
@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DaySchedule implements Serializable {

    // Sử dụng DayOfWeek chuẩn Java: SUNDAY..SATURDAY
    @Enumerated(EnumType.STRING)
    @Column(name = "day_of_week", nullable = false, length = 10)
    private DayOfWeek dayOfWeek;

    @Column(name = "is_open", nullable = false)
    private boolean open;

    // Giờ mở/đóng (nếu open=true). Cho phép null khi đóng cửa cả ngày.
    @Column(name = "open_time")
    private LocalTime openTime;

    @Column(name = "close_time")
    private LocalTime closeTime;

    @AssertTrue(message = "Khi 'open' = true, cần 'openTime' và 'closeTime', và closeTime > openTime")
    public boolean isTimeValid() {
        if (!open) return true;
        if (openTime == null || closeTime == null) return false;
        return closeTime.isAfter(openTime);
    }

    // Đảm bảo mỗi ngày xuất hiện tối đa 1 lần trong Set
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof DaySchedule that)) return false;
        return dayOfWeek == that.dayOfWeek;
    }
    @Override public int hashCode() { return Objects.hash(dayOfWeek); }
}
