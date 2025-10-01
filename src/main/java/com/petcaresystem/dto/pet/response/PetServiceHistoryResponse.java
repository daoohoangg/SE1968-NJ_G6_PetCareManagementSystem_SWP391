package com.petcaresystem.dto.pet.response;

import lombok.Data;

import java.time.LocalDate;

@Data
public class PetServiceHistoryResponse {
    private int id;
    private int petId;
    private String petName; // optional, helpful for UI
    private String serviceType;
    private String description;
    private LocalDate serviceDate;
    private double cost;
    private String staffName;
}
