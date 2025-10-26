-- Mock data for Pet Care Management System
-- Updated to match exact entity structure

-- Clear existing data first
DELETE FROM rule_week_days WHERE 1=1;
DELETE FROM notifications WHERE 1=1;
DELETE FROM payments WHERE 1=1;
DELETE FROM invoices WHERE 1=1;
DELETE FROM bookings WHERE 1=1;
DELETE FROM appointments WHERE 1=1;
DELETE FROM pet_service_history WHERE 1=1;
DELETE FROM pets WHERE 1=1;
DELETE FROM customers WHERE 1=1;
DELETE FROM receptionists WHERE 1=1;
DELETE FROM staff WHERE 1=1;
DELETE FROM service WHERE 1=1;
DELETE FROM service_category WHERE 1=1;
DELETE FROM accounts WHERE 1=1;
DELETE FROM vouchers WHERE 1=1;
DELETE FROM rule_sets WHERE 1=1;
DELETE FROM administration WHERE 1=1;

-- Reset auto-increment counters
ALTER TABLE accounts AUTO_INCREMENT = 1;
ALTER TABLE administration AUTO_INCREMENT = 1;
ALTER TABLE staff AUTO_INCREMENT = 1;
ALTER TABLE receptionists AUTO_INCREMENT = 1;
ALTER TABLE customers AUTO_INCREMENT = 1;
ALTER TABLE pets AUTO_INCREMENT = 1;
ALTER TABLE service_category AUTO_INCREMENT = 1;
ALTER TABLE service AUTO_INCREMENT = 1;
ALTER TABLE vouchers AUTO_INCREMENT = 1;
ALTER TABLE appointments AUTO_INCREMENT = 1;
ALTER TABLE pet_service_history AUTO_INCREMENT = 1;
ALTER TABLE invoices AUTO_INCREMENT = 1;
ALTER TABLE payments AUTO_INCREMENT = 1;
ALTER TABLE notifications AUTO_INCREMENT = 1;
ALTER TABLE rule_sets AUTO_INCREMENT = 1;
ALTER TABLE rule_week_days AUTO_INCREMENT = 1;
ALTER TABLE bookings AUTO_INCREMENT = 1;

-- Insert Accounts (Base table for all users)
INSERT INTO accounts (
    username, password, email, full_name, phone, role, is_active, is_verified, 
    is_deleted, verification_token, last_login, created_at, updated_at, account_type
) VALUES
    -- Admin accounts
    ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'admin@petcare.com', 'Admin User', '555-000-0001', 'ADMIN', 1, 1, 0, NULL, '2025-10-25 08:00:00', '2025-01-01 00:00:00', '2025-10-25 08:00:00', 'ADMIN'),
    
    -- Staff accounts
    ('staff1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'staff1@petcare.com', 'Dr. Sarah Johnson', '555-000-0002', 'STAFF', 1, 1, 0, NULL, '2025-10-25 07:30:00', '2025-01-01 00:00:00', '2025-10-25 07:30:00', 'STAFF'),
    ('staff2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'staff2@petcare.com', 'Dr. Michael Brown', '555-000-0003', 'STAFF', 1, 1, 0, NULL, '2025-10-25 08:15:00', '2025-01-01 00:00:00', '2025-10-25 08:15:00', 'STAFF'),
    
    -- Receptionist accounts
    ('recep1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'recep1@petcare.com', 'Emma Wilson', '555-000-0004', 'RECEPTIONIST', 1, 1, 0, NULL, '2025-10-25 08:00:00', '2025-01-01 00:00:00', '2025-10-25 08:00:00', 'RECEPTIONIST'),
    ('recep2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'recep2@petcare.com', 'James Davis', '555-000-0005', 'RECEPTIONIST', 1, 1, 0, NULL, '2025-10-25 08:00:00', '2025-01-01 00:00:00', '2025-10-25 08:00:00', 'RECEPTIONIST'),
    
    -- Customer accounts
    ('customer1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'customer1@example.com', 'John Smith', '555-000-0006', 'CUSTOMER', 1, 1, 0, NULL, '2025-10-24 18:00:00', '2025-01-01 00:00:00', '2025-10-24 18:00:00', 'CUSTOMER'),
    ('customer2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'customer2@example.com', 'Jane Doe', '555-000-0007', 'CUSTOMER', 1, 1, 0, NULL, '2025-10-24 19:30:00', '2025-01-01 00:00:00', '2025-10-24 19:30:00', 'CUSTOMER'),
    ('customer3', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'customer3@example.com', 'Bob Johnson', '555-000-0008', 'CUSTOMER', 1, 1, 0, NULL, '2025-10-23 16:45:00', '2025-01-01 00:00:00', '2025-10-23 16:45:00', 'CUSTOMER');

-- Insert Administrations
INSERT INTO administration (account_id, employee_id, department, access_level) VALUES
    (1, 'EMP001', 'Management', 'FULL');

-- Insert Staff
INSERT INTO staff (account_id, specialization, employee_id, hire_date, salary, department, is_available) VALUES
    (2, 'Veterinary Medicine', 'EMP002', '2025-01-15', 75000.00, 'Clinic', 1),
    (3, 'Surgery', 'EMP003', '2025-02-01', 80000.00, 'Surgery', 1);

-- Insert Receptionists
INSERT INTO receptionists (account_id, address, date_of_birth) VALUES
    (4, '123 Reception St, City, State 12345', '1990-05-15'),
    (5, '456 Front Desk Ave, City, State 12345', '1988-08-22');

-- Insert Customers
INSERT INTO customers (account_id, address, date_of_birth) VALUES
    (6, '123 Main St, City, State 12345', '1985-05-15'),
    (7, '456 Oak Ave, City, State 12345', '1990-08-22'),
    (8, '789 Pine Rd, City, State 12345', '1988-12-10');

-- Insert Service Categories
INSERT INTO service_category (category_id, name, description, created_at, updated_at) VALUES
    (1, 'General Health', 'General health checkups and consultations', '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
    (2, 'Surgery', 'Surgical procedures and operations', '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
    (3, 'Grooming', 'Pet grooming and hygiene services', '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
    (4, 'Emergency', 'Emergency medical services', '2025-01-01 00:00:00', '2025-01-01 00:00:00');

-- Insert Services
INSERT INTO service (service_id, service_name, description, price, duration_minutes, category_id, is_active, created_at, updated_at, created_by) VALUES
    (1, 'General Checkup', 'Comprehensive health examination', 75.00, 30, 1, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00', 1),
    (2, 'Vaccination', 'Core and non-core vaccinations', 45.00, 15, 1, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00', 1),
    (3, 'Spay/Neuter Surgery', 'Spaying or neutering procedure', 200.00, 120, 2, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00', 1),
    (4, 'Dental Cleaning', 'Professional dental cleaning', 150.00, 60, 2, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00', 1),
    (5, 'Basic Grooming', 'Bath, brush, and nail trim', 40.00, 45, 3, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00', 1),
    (6, 'Emergency Consultation', 'Urgent medical consultation', 100.00, 30, 4, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00', 1);

-- Insert Vouchers
INSERT INTO vouchers (code, discount_type, discount_value, expiry_date, max_uses, times_used, is_active, created_at, updated_at) VALUES
    ('WELCOME10', 'PERCENTAGE', 10.00, '2025-12-31 23:59:59', 100, 5, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
    ('SAVE20', 'FIXED', 20.00, '2025-12-31 23:59:59', 50, 2, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
    ('FIRSTTIME', 'PERCENTAGE', 15.00, '2025-12-31 23:59:59', 200, 10, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
    ('LOYALTY50', 'FIXED', 50.00, '2025-12-31 23:59:59', 25, 0, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
    ('EMERGENCY25', 'PERCENTAGE', 25.00, '2025-12-31 23:59:59', 30, 3, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
    ('GROOMING30', 'FIXED', 30.00, '2025-12-31 23:59:59', 40, 8, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00');

-- Insert Pets
INSERT INTO pets (name, species, breed, gender, age, date_of_birth, weight, health_status, medical_notes, customer_id) VALUES
    ('Buddy', 'Dog', 'Golden Retriever', 'Male', 3, '2022-03-15', 65.5, 'Healthy', 'No known allergies', 6),
    ('Whiskers', 'Cat', 'Persian', 'Female', 2, '2023-01-20', 8.2, 'Healthy', 'Indoor cat, very friendly', 6),
    ('Max', 'Dog', 'German Shepherd', 'Male', 5, '2020-06-10', 75.0, 'Healthy', 'Active dog, needs regular exercise', 7),
    ('Luna', 'Cat', 'Siamese', 'Female', 1, '2024-02-14', 6.8, 'Healthy', 'Young cat, very playful', 7),
    ('Rocky', 'Dog', 'Bulldog', 'Male', 4, '2021-09-05', 50.0, 'Healthy', 'Calm temperament', 8);

-- Insert Appointments
INSERT INTO appointments (appointment_date, end_date, status, notes, total_amount, created_at, updated_at, customer_id, pet_id, staff_id, receptionist_id) VALUES
    ('2025-10-26 09:00:00', '2025-10-26 09:30:00', 'SCHEDULED', 'Regular checkup for Buddy', 75.00, '2025-10-25 10:00:00', '2025-10-25 10:00:00', 6, 1, 2, 4),
    ('2025-10-26 10:30:00', '2025-10-26 11:00:00', 'SCHEDULED', 'Vaccination for Whiskers', 45.00, '2025-10-25 10:15:00', '2025-10-25 10:15:00', 6, 2, 2, 4),
    ('2025-10-27 14:00:00', '2025-10-27 16:00:00', 'SCHEDULED', 'Spay surgery for Luna', 200.00, '2025-10-25 11:00:00', '2025-10-25 11:00:00', 7, 4, 3, 5);

-- Insert Pet Service History
INSERT INTO pet_service_history (service_type, description, service_date, cost, staff_id, pet_id) VALUES
    ('Wellness Exam', 'Annual checkup completed', '2025-10-20', 75.00, 2, 1),
    ('Vaccination', 'Vaccination administered', '2025-10-15', 45.00, 2, 2),
    ('Dental Cleaning', 'Dental cleaning performed', '2025-10-10', 150.00, 3, 3);

-- Insert Invoices
INSERT INTO invoices (invoice_number, issue_date, due_date, subtotal, tax_amount, discount_amount, total_amount, amount_paid, amount_due, status, notes, created_at, updated_at, appointment_id, customer_id, voucher_id) VALUES
    ('INV-001', '2025-10-25 10:00:00', '2025-11-24 10:00:00', 75.00, 6.00, 0.00, 81.00, 0.00, 81.00, 'PENDING', 'Regular checkup invoice', '2025-10-25 10:00:00', '2025-10-25 10:00:00', 1, 6, NULL),
    ('INV-002', '2025-10-25 10:15:00', '2025-11-24 10:15:00', 45.00, 3.60, 0.00, 48.60, 0.00, 48.60, 'PENDING', 'Vaccination invoice', '2025-10-25 10:15:00', '2025-10-25 10:15:00', 2, 6, NULL),
    ('INV-003', '2025-10-25 11:00:00', '2025-11-24 11:00:00', 200.00, 16.00, 0.00, 216.00, 0.00, 216.00, 'PENDING', 'Surgery invoice', '2025-10-25 11:00:00', '2025-10-25 11:00:00', 3, 7, NULL);

-- Insert Payments
INSERT INTO payments (payment_number, amount, payment_date, payment_method, status, transaction_id, reference_number, notes, created_at, updated_at, invoice_id, customer_id) VALUES
    ('PAY-001', 75.00, '2025-10-25 10:30:00', 'CREDIT_CARD', 'COMPLETED', 'TRX-001', 'POS-001', 'Credit card payment', '2025-10-25 10:30:00', '2025-10-25 10:30:00', 1, 6),
    ('PAY-002', 45.00, '2025-10-25 10:45:00', 'CASH', 'COMPLETED', NULL, 'RCPT-001', 'Cash payment', '2025-10-25 10:45:00', '2025-10-25 10:45:00', 2, 6);

-- Insert Notifications
INSERT INTO notifications (type, title, message, status, scheduled_time, sent_time, priority, is_read, read_time, created_at, updated_at, recipient_id, configured_by, related_appointment_id, related_invoice_id) VALUES
    ('APPOINTMENT_REMINDER', 'Appointment Reminder', 'Your appointment with Buddy is scheduled for tomorrow at 9:00 AM', 'SENT', '2025-10-25 18:00:00', '2025-10-25 18:00:00', 'NORMAL', 0, NULL, '2025-10-25 18:00:00', '2025-10-25 18:00:00', 6, 1, 1, NULL),
    ('PAYMENT_CONFIRMATION', 'Payment Confirmation', 'Your payment of $75.00 has been processed successfully', 'SENT', NULL, '2025-10-25 10:35:00', 'HIGH', 0, NULL, '2025-10-25 10:35:00', '2025-10-25 10:35:00', 6, 1, NULL, 1),
    ('APPOINTMENT_CONFIRMATION', 'New Appointment', 'A new appointment has been scheduled for Luna on October 27th', 'SENT', NULL, '2025-10-25 11:05:00', 'NORMAL', 0, NULL, '2025-10-25 11:05:00', '2025-10-25 11:05:00', 7, 1, 3, NULL);

-- Insert Rule Sets (with embeddable structure)
INSERT INTO rule_sets (owner_type, owner_id, active, appointment_confirmation, reminder_notify, promotional_email, reminder_hours, maximum_booking_days, cancel_notice_hours, auto_confirm) VALUES
    ('CLINIC', 1, 1, 1, 1, 0, 24, 30, 24, 1),
    ('SERVICE_CATEGORY', 1, 1, 1, 1, 0, 24, 30, 24, 1),
    ('SERVICE_CATEGORY', 2, 1, 1, 0, 1, NULL, 14, 48, 0);

-- Insert Rule Week Days (Business Hours) - matches DaySchedule embeddable
INSERT INTO rule_week_days (rule_set_id, day_of_week, open, open_time, close_time) VALUES
    -- CLINIC schedule
    (1, 'MONDAY', 1, '08:00:00', '18:00:00'),
    (1, 'TUESDAY', 1, '08:00:00', '18:00:00'),
    (1, 'WEDNESDAY', 1, '08:00:00', '18:00:00'),
    (1, 'THURSDAY', 1, '08:00:00', '18:00:00'),
    (1, 'FRIDAY', 1, '08:00:00', '18:00:00'),
    (1, 'SATURDAY', 1, '09:00:00', '17:00:00'),
    (1, 'SUNDAY', 0, NULL, NULL),
    
    -- Service Category 1 schedule
    (2, 'MONDAY', 1, '08:00:00', '18:00:00'),
    (2, 'TUESDAY', 1, '08:00:00', '18:00:00'),
    (2, 'WEDNESDAY', 1, '08:00:00', '18:00:00'),
    (2, 'THURSDAY', 1, '08:00:00', '18:00:00'),
    (2, 'FRIDAY', 1, '08:00:00', '18:00:00'),
    (2, 'SATURDAY', 1, '09:00:00', '17:00:00'),
    (2, 'SUNDAY', 0, NULL, NULL),
    
    -- Service Category 2 schedule
    (3, 'MONDAY', 1, '08:00:00', '18:00:00'),
    (3, 'TUESDAY', 1, '08:00:00', '18:00:00'),
    (3, 'WEDNESDAY', 1, '08:00:00', '18:00:00'),
    (3, 'THURSDAY', 1, '08:00:00', '18:00:00'),
    (3, 'FRIDAY', 1, '08:00:00', '18:00:00'),
    (3, 'SATURDAY', 1, '09:00:00', '17:00:00'),
    (3, 'SUNDAY', 0, NULL, NULL);

-- Insert Bookings
INSERT INTO bookings (booking_id, pet_name, customer_name, booking_date, status) VALUES
    (1, 'Buddy', 'John Smith', '2025-10-25 09:00:00', 'Checked-In'),
    (2, 'Whiskers', 'John Smith', '2025-10-25 10:30:00', 'Pending'),
    (3, 'Max', 'Jane Doe', '2025-10-25 14:00:00', 'Checked-Out');

-- Verify data insertion
SELECT 'accounts' as table_name, COUNT(*) as row_count FROM accounts
UNION ALL
SELECT 'administration', COUNT(*) FROM administration
UNION ALL
SELECT 'staff', COUNT(*) FROM staff
UNION ALL
SELECT 'receptionists', COUNT(*) FROM receptionists
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'pets', COUNT(*) FROM pets
UNION ALL
SELECT 'service_category', COUNT(*) FROM service_category
UNION ALL
SELECT 'service', COUNT(*) FROM service
UNION ALL
SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'pet_service_history', COUNT(*) FROM pet_service_history
UNION ALL
SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'notifications', COUNT(*) FROM notifications
UNION ALL
SELECT 'vouchers', COUNT(*) FROM vouchers
UNION ALL
SELECT 'rule_sets', COUNT(*) FROM rule_sets
UNION ALL
SELECT 'rule_week_days', COUNT(*) FROM rule_week_days
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings;

-- Show completion message
SELECT 'Mock data inserted successfully! All tables populated with sample data.' as status;