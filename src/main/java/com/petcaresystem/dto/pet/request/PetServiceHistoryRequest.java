package com.petcaresystem.dto.pet.request;

import lombok.Data;

import java.time.LocalDate;

@Data
public class PetServiceHistoryRequest {
    private int petId;
    private String serviceType;
    private String description;
    private LocalDate serviceDate;
    private double cost;
    private String staffName;
}
