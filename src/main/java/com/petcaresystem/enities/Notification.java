package com.petcaresystem.enities;

import com.petcaresystem.enities.enu.NotificationPriority;
import com.petcaresystem.enities.enu.NotificationStatus;
import com.petcaresystem.enities.enu.NotificationType;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "notifications")
@NoArgsConstructor
@AllArgsConstructor
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id")
    private Long notificationId;

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false, length = 30)
    private NotificationType type;

    @Column(name = "title", nullable = false, length = 200)
    private String title;

    @Lob
    @Column(name = "message", nullable = false)
    private String message;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private NotificationStatus status = NotificationStatus.PENDING;

    @Column(name = "scheduled_time")
    private LocalDateTime scheduledTime;

    @Column(name = "sent_time")
    private LocalDateTime sentTime;

    @Enumerated(EnumType.STRING)
    @Column(name = "priority", nullable = false, length = 20)
    private NotificationPriority priority = NotificationPriority.NORMAL;

    @Column(name = "is_read", nullable = false)
    private Boolean isRead = false;

    @Column(name = "read_time")
    private LocalDateTime readTime;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recipient_id", nullable = false)
    private Account recipient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "configured_by")
    private Administration configuredBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "related_appointment_id")
    private Appointment relatedAppointment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "related_invoice_id")
    private Invoice relatedInvoice;

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
    public void send() {
        if (this.status == NotificationStatus.PENDING) {
            this.status = NotificationStatus.SENT;
            this.sentTime = LocalDateTime.now();
        }
    }

    public void markAsRead() {
        if (!this.isRead) {
            this.isRead = true;
            this.readTime = LocalDateTime.now();
        }
    }

    public void markAsUnread() {
        this.isRead = false;
        this.readTime = null;
    }

    public void markAsFailed(String reason) {
        this.status = NotificationStatus.FAILED;
        this.message += "\n[Failed: " + reason + "]";
    }

    public void schedule(LocalDateTime time) {
        this.scheduledTime = time;
        this.status = NotificationStatus.SCHEDULED;
    }

    public void cancel() {
        if (this.status == NotificationStatus.PENDING || this.status == NotificationStatus.SCHEDULED) {
            this.status = NotificationStatus.CANCELLED;
        }
    }

    public boolean canBeSent() {
        return this.status == NotificationStatus.PENDING ||
               (this.status == NotificationStatus.SCHEDULED &&
                this.scheduledTime != null &&
                LocalDateTime.now().isAfter(this.scheduledTime));
    }

    public boolean isOverdue() {
        return this.status == NotificationStatus.SCHEDULED &&
               this.scheduledTime != null &&
               LocalDateTime.now().isAfter(this.scheduledTime.plusDays(1));
    }
}
