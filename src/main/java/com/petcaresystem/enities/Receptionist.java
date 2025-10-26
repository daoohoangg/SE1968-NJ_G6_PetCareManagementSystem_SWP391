package com.petcaresystem.enities;

import com.petcaresystem.enities.enu.AccountRoleEnum;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "receptionists")
//@DiscriminatorValue("RECEPTIONIST")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Receptionist extends Account {

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @PrePersist
    protected void onReceptionistCreate() {
        super.onCreate();
        setRole(AccountRoleEnum.RECEPTIONIST);
    }

    // Helper method to get receptionist ID
    public Long getReceptionistId() {
        return super.getAccountId();
    }
}
