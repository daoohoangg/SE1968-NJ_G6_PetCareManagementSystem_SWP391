package com.petcaresystem.enities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.DayOfWeek;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;


@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WeeklySchedule implements Serializable {


    @ElementCollection
    @CollectionTable(name = "rule_week_days", joinColumns = @JoinColumn(name = "rule_set_id"))
    private Set<DaySchedule> days = new HashSet<>();

    public Optional<DaySchedule> get(DayOfWeek dayOfWeek) {
        return days.stream().filter(d -> d.getDayOfWeek() == dayOfWeek).findFirst();
    }
}