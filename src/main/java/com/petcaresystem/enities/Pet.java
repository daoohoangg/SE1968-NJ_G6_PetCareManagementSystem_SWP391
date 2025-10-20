package com.petcaresystem.enities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

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

    @Column(name = "breed", length = 100)
    private String breed;

    @Column(name = "age")
    private Integer age;

    @Column(name = "health_status", length = 255)
    private String healthStatus;

    // ✅ Liên kết ngược lại Customer
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id") // cột foreign key trỏ đến bảng customers
    private Customer customer;
}
