package com.petcaresystem.enities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "receptionists")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Receptionist extends Account {

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;


}
