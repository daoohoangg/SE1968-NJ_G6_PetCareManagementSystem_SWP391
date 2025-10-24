package com.petcaresystem.enities;

import com.petcaresystem.enities.enu.AccountRoleEnum;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "staff")
@DiscriminatorValue("STAFF")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Staff extends Account {

    @Column(name = "specialization", length = 100)
    private String specialization;
    
    @Column(name = "employee_id", unique = true, length = 20)
    private String employeeId;
    
    @Column(name = "hire_date")
    private LocalDate hireDate;
    
    @Column(name = "salary", precision = 10, scale = 2)
    private BigDecimal salary;
    
    @Column(name = "department", length = 50)
    private String department;
    
    @Column(name = "is_available", nullable = false)
    private Boolean isAvailable = true;
    
    @OneToMany(mappedBy = "staff", cascade = CascadeType.ALL)
    private List<Appointment> appointments = new ArrayList<>();
    
    @OneToMany(mappedBy = "staff", cascade = CascadeType.ALL)
    private List<PetServiceHistory> serviceHistories = new ArrayList<>();
    
    protected void onStaffCreate() {
        super.onCreate();
        setRole(AccountRoleEnum.STAFF);
        this.hireDate = LocalDate.now();
    }
    
    // Business logic methods
    public void markAvailable() {
        this.isAvailable = true;
    }
    
    public void markUnavailable() {
        this.isAvailable = false;
    }

}
