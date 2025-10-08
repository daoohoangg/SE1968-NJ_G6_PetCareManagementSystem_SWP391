package com.petcaresystem.enities;

import com.petcaresystem.enities.enu.AccountRoleEnum;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "administration")
@DiscriminatorValue("ADMIN")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Administration extends Account {

    @Column(name = "employee_id", unique = true, length = 20)
    private String employeeId;

    @Column(name = "department", length = 50)
    private String department;


    @Column(name = "access_level", length = 20)
    private String accessLevel = "FULL";

    @OneToMany(mappedBy = "createdBy", cascade = CascadeType.ALL)
    private List<Service> managedServices = new ArrayList<>();

    @OneToMany(mappedBy = "configuredBy", cascade = CascadeType.ALL)
    private List<Notification> configuredNotifications = new ArrayList<>();


    public void addManagedService(Service service) {
        managedServices.add(service);
        service.setCreatedBy(this);
    }

    public void addConfiguredNotification(Notification notification) {
        configuredNotifications.add(notification);
        notification.setConfiguredBy(this);
    }
}
