package com.petcaresystem.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecentActivityView {
    private String icon;
    private String primaryText;
    private String secondaryText;
    private String badgeLabel;
    private String badgeClass;
    private String timeLabel;
    private boolean urgent;
}
