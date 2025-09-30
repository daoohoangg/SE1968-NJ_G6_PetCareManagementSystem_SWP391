package com.petcaresystem.enities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class Account {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idaccount;
    @Column(unique = true, nullable = false)
    private String username;
    @Column(nullable = false, length = 64)
    private String password;
    @Column(nullable = false, length = 16)
    private String role;
}
