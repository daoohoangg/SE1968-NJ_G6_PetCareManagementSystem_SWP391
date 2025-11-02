package com.petcaresystem.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ScheduleItemView {
    private String icon;
    private String primaryText;
    private String secondaryText;
    private String timeLabel;
    private String badgeLabel;
    private String badgeClass;
}
