package com.petcaresystem.enities;

import com.petcaresystem.enities.enu.AppointmentStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Entity
@Table(name = "appointments")
@NoArgsConstructor
@AllArgsConstructor
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "appointment_id")
    private Long appointmentId;

    @Column(name = "appointment_date", nullable = false)
    private LocalDateTime appointmentDate;



    @Column(name = "end_date")
    private LocalDateTime endDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private AppointmentStatus status = AppointmentStatus.PENDING;

    @Lob
    @Column(name = "notes")
    private String notes;

    @Column(name = "total_amount", precision = 10, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    private Pet pet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "staff_id")
    private Staff staff;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receptionist_id")
    private Receptionist receptionist;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "appointment_services",
        joinColumns = @JoinColumn(name = "appointment_id"),
        inverseJoinColumns = @JoinColumn(name = "service_id")
    )
    private List<Service> services = new ArrayList<>();

    @OneToOne(mappedBy = "appointment", cascade = CascadeType.ALL, orphanRemoval = true)
    private Invoice invoice;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Business logic methods following SOLID principles
    public void addService(Service service) {
        services.add(service);
        calculateTotalAmount();
    }

    public void removeService(Service service) {
        services.remove(service);
        calculateTotalAmount();
    }

    public void calculateTotalAmount() {
        this.totalAmount = services.stream()
                .map(Service::getPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public void confirm() {
        if (this.status == AppointmentStatus.PENDING || this.status == AppointmentStatus.SCHEDULED) {
            this.status = AppointmentStatus.CONFIRMED;
        }
    }

    public void complete() {
        if (this.status == AppointmentStatus.CONFIRMED || this.status == AppointmentStatus.IN_PROGRESS || this.status == AppointmentStatus.CHECKED_IN) {
            this.status = AppointmentStatus.COMPLETED;
        }
    }

    public void cancel() {
        if (this.status == AppointmentStatus.PENDING || this.status == AppointmentStatus.SCHEDULED || this.status == AppointmentStatus.CONFIRMED) {
            this.status = AppointmentStatus.CANCELLED;
        }
    }

    public void startService() {
        if (this.status == AppointmentStatus.CONFIRMED || this.status == AppointmentStatus.CHECKED_IN) {
            this.status = AppointmentStatus.IN_PROGRESS;
        }
    }

    public void noShow() {
        if (this.status == AppointmentStatus.SCHEDULED || this.status == AppointmentStatus.CONFIRMED) {
            this.status = AppointmentStatus.NO_SHOW;
        }
    }

    public void checkIn() {
        if (this.status == AppointmentStatus.SCHEDULED) {
            this.status = AppointmentStatus.CONFIRMED;
            this.updatedAt = LocalDateTime.now();
        }
    }

    public void checkOut() {
        if (this.status == AppointmentStatus.CONFIRMED || this.status == AppointmentStatus.IN_PROGRESS) {
            this.status = AppointmentStatus.COMPLETED;
            this.updatedAt = LocalDateTime.now();
        }
    }

    public boolean canCheckIn() {
        return this.status == AppointmentStatus.SCHEDULED || this.status == AppointmentStatus.CONFIRMED;
    }

    public boolean canCheckOut() {
        return this.status == AppointmentStatus.CONFIRMED || this.status == AppointmentStatus.IN_PROGRESS;
    }

    public boolean canBeCancelled() {
        return this.status == AppointmentStatus.SCHEDULED || this.status == AppointmentStatus.CONFIRMED;
    }

    public boolean isCompleted() {
        return this.status == AppointmentStatus.COMPLETED;
    }

    public void generateInvoice(Invoice invoice) {
        this.invoice = invoice;
        invoice.setAppointment(this);
    }



    @Transient
    private String formattedDate;

    @Transient
    private String formattedUpdatedAt;

    public String getFormattedDate() {
        return formattedDate;
    }
    public void setFormattedDate(String formattedDate) {
        this.formattedDate = formattedDate;
    }

    public String getFormattedUpdatedAt() {
        return formattedUpdatedAt;
    }
    public void setFormattedUpdatedAt(String formattedUpdatedAt) {
        this.formattedUpdatedAt = formattedUpdatedAt;
    }
}
