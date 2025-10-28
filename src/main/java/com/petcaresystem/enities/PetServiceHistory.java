package com.petcaresystem.enities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "pet_service_history")
public class PetServiceHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    @Column(name = "service_type", nullable = false)
    private String serviceType;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "service_date", nullable = false)
    private LocalDate serviceDate;
    
    @Column(name = "cost", nullable = false)
    private double cost;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "rating")
    private Integer rating; // 1-5 stars

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "staff_id")
    private Staff staff;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    private Pet pet;
    
    // Helper method for formatted date display
    public String getFormattedDate() {
        if (serviceDate == null) return "";
        return serviceDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
    
    // Helper method for formatted cost display
    public String getFormattedCost() {
        return String.format("$%.2f", cost);
    }
}
