package com.petcaresystem.enities;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class Pet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idpet;

    @Column(nullable = false, length = 50)
    private String name;

    @Column(nullable = false, length = 50)
    private String breed;

    @Column(nullable = false)
    private int age;

    @Column(length = 100)
    private String healthStatus;

    // Liên kết với Account (chủ sở hữu thú cưng)
    @ManyToOne
    @JoinColumn(name = "idaccount", nullable = false)
    private Account owner;
}

