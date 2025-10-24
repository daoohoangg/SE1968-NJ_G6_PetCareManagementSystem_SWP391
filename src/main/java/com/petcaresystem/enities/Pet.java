package com.petcaresystem.enities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Table(name = "pets")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Pet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "pet_id")
    private Long idpet;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "species", length = 50)
    private String species;

    @Column(name = "breed", length = 100)
    private String breed;

    @Column(name = "gender", length = 10)
    private String gender;

    @Column(name = "age")
    private Integer age;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "weight")
    private Double weight;

    @Column(name = "health_status", length = 255)
    private String healthStatus;

    @Column(name = "medical_notes", columnDefinition = "TEXT")
    private String medicalNotes;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id")
    private Customer customer;
}
