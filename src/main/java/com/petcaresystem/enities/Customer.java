package com.petcaresystem.enities;

import com.petcaresystem.enities.enu.AccountRoleEnum;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "customers")
@DiscriminatorValue("CUSTOMER")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Customer extends Account {

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "date_of_birth")
    private java.time.LocalDate dateOfBirth;


    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Pet> pets = new ArrayList<>();

    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL)
    private List<Appointment> appointments = new ArrayList<>();

    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL)
    private List<Payment> payments = new ArrayList<>();

    protected void onCustomerCreate() {
        super.onCreate();
        setRole(AccountRoleEnum.CUSTOMER);
    }

    // Helper methods following SOLID principles
    public void addPet(Pet pet) {
        pets.add(pet);
        pet.setCustomer(this);
    }

    public void removePet(Pet pet) {
        pets.remove(pet);
        pet.setCustomer(null);
    }

    public void addAppointment(Appointment appointment) {
        appointments.add(appointment);
        appointment.setCustomer(this);
    }

    public Object getCustomerId() {
        return super.getAccountId();
    }
}
