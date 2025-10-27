package com.petcaresystem.enities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@Table(name = "ai_data")
@NoArgsConstructor
@AllArgsConstructor
public class AiData {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    @Column(name = "creativity_level")
    private int creativityLevel;
    @Column(name = "prompt")
    private String prompt;
}
