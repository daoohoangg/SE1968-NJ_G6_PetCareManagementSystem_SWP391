package com.petcaresystem.enities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "pet_service_history")
public class PetServiceHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String serviceType;
    private String description;
    private LocalDate serviceDate;
    private double cost;
    private String staffName;

    @ManyToOne
    @JoinColumn(name = "pet_id")
    private Pet pet;
}
