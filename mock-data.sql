-- Mock data for Pet Care Management System

-- Accounts
SET IDENTITY_INSERT accounts ON;
INSERT INTO accounts (
    account_id,
    username,
    password,
    email,
    full_name,
    phone,
    role,
    is_active,
    is_verified,
    last_login,
    created_at,
    updated_at,
    account_type
)VALUES
     (1, 'admin.sophia', 'Admin#2025', 'sophia.nguyen@petcare.com', 'Sophia Nguyen', '555-100-0001', 'ADMIN', 1, 1, '2025-09-28 07:45:00', '2025-08-15 09:00:00', '2025-09-28 11:30:00', 'ADMIN'),
     (2, 'staff.mason', 'StaffMason!1', 'mason.lee@petcare.com', 'Mason Lee', '555-210-1001', 'STAFF', 1, 1, '2025-09-27 08:15:00', '2024-11-20 08:00:00', '2025-09-27 08:15:00', 'STAFF'),
     (3, 'staff.emma', 'EmmaStaff@2024', 'emma.torres@petcare.com', 'Emma Torres', '555-210-1002', 'STAFF', 1, 1, '2025-09-27 09:00:00', '2023-04-10 08:00:00', '2025-09-27 09:00:00', 'STAFF'),
     (4, 'cust.liam', 'CustLiam#2025', 'liam.chu@example.com', 'Liam Chu', '555-410-2001', 'CUSTOMER', 1, 1, '2025-09-26 18:20:00', '2025-02-15 10:30:00', '2025-09-26 18:20:00', 'CUSTOMER'),
     (5, 'cust.olivia', 'CustOlivia#2025', 'olivia.fernandez@example.com', 'Olivia Fernandez', '555-410-2002', 'CUSTOMER', 1, 0, '2025-09-20 19:05:00', '2025-03-12 11:45:00', '2025-09-20 19:05:00', 'CUSTOMER'),
     (6, 'cust.evelyn', 'CustEvelyn#2025', 'evelyn.nguyen@example.com', 'Evelyn Nguyen', '555-410-2003', 'CUSTOMER', 1, 1, NULL, '2025-04-02 09:20:00', '2025-09-21 13:10:00', 'CUSTOMER'),
     (7, 'cust.noah', 'CustNoah#2025', 'noah.davis@example.com', 'Noah Davis', '555-410-2004', 'CUSTOMER', 1, 1, '2025-09-25 17:45:00', '2025-05-18 14:40:00', '2025-09-25 17:45:00', 'CUSTOMER'),
     (8, 'cust.amelia', 'CustAmelia#2025', 'amelia.patel@example.com', 'Amelia Patel', '555-410-2005', 'CUSTOMER', 1, 0, NULL, '2025-06-05 16:25:00', '2025-09-24 12:05:00', 'CUSTOMER');
SET IDENTITY_INSERT accounts OFF;

-- Administration profiles
INSERT INTO administration (
    account_id,
    employee_id,
    department,
    access_level
) VALUES
    (1, 'ADM-1001', 'Operations', 'FULL');

-- Staff profiles
INSERT INTO staff (
    account_id,
    specialization,
    employee_id,
    hire_date,
    salary,
    department,
    is_available
) VALUES
      (2, 'Veterinary Nurse', 'STF-2001', '2023-03-15', 4500.00, 'Clinic', 1),
      (3, 'Pet Groomer', 'STF-2002', '2022-07-10', 3800.00, 'Grooming', 1);

-- Customers
INSERT INTO customers (
    account_id,
    address,
    date_of_birth
) VALUES
      (4, '742 Evergreen Terrace, Springfield', '1989-06-14'),
      (5, '128 Market Street, Austin', '1992-11-08'),
      (6, '55 Riverside Drive, Seattle', '1995-05-21'),
      (7, '908 Lakeview Avenue, Denver', '1987-03-03'),
      (8, '41 Orchard Lane, Boston', '1990-09-18');

-- Service categories
SET IDENTITY_INSERT service_category ON;
INSERT INTO service_category (
    category_id,
    name,
    description,
    created_at,
    updated_at
)VALUES
     (1, 'Wellness', 'Preventive health services including exams and vaccinations.', '2025-08-01 09:00:00', '2025-09-20 10:15:00'),
     (2, 'Grooming', 'Professional grooming and spa treatments for pets.', '2025-08-01 09:10:00', '2025-09-20 10:20:00'),
     (3, 'Training', 'Behavioral and obedience training programs.', '2025-08-01 09:20:00', '2025-09-20 10:25:00');
SET IDENTITY_INSERT service_category OFF;

-- Services
SET IDENTITY_INSERT service ON;
INSERT INTO service (
    service_id,
    service_name,
    description,
    price,
    duration_minutes,
    category_id,
    is_active,
    created_at,
    updated_at,
    created_by
)VALUES
     (1, 'Annual Wellness Exam', 'Comprehensive physical exam including bloodwork panel.', 75.00, 60, 1, 1, '2025-08-05 09:00:00', '2025-09-22 14:00:00', 1),
     (2, 'Vaccination Package', 'Core vaccine package tailored to pet age and lifestyle.', 55.00, 45, 1, 1, '2025-08-05 09:15:00', '2025-09-22 14:10:00', 1),
     (3, 'Deluxe Grooming', 'Full grooming with coat conditioning and nail trim.', 85.00, 90, 2, 1, '2025-08-05 09:30:00', '2025-09-22 14:15:00', 1),
     (4, 'Basic Grooming', 'Bath, brush, and light trim with ear cleaning.', 45.00, 60, 2, 1, '2025-08-05 09:40:00', '2025-09-22 14:20:00', 1),
     (5, 'Obedience Training Session', 'One-on-one training focused on essential commands.', 65.00, 75, 3, 1, '2025-08-05 09:50:00', '2025-09-22 14:30:00', 1);
SET IDENTITY_INSERT service OFF;

-- Vouchers
SET IDENTITY_INSERT vouchers ON;
INSERT INTO vouchers (
    voucher_id,
    code,
    discount_type,
    discount_value,
    expiry_date,
    max_uses,
    times_used,
    is_active,
    created_at,
    updated_at
)VALUES
     (1, 'WELCOME10', 'PERCENTAGE', 10.00, '2025-12-31 23:59:59', 100, 12, 1, '2025-01-05 08:00:00', '2025-09-15 09:45:00'),
     (2, 'FREESPA15', 'PERCENTAGE', 15.00, '2025-06-30 23:59:59', 50, 8, 1, '2025-02-10 08:00:00', '2025-09-10 09:30:00');
SET IDENTITY_INSERT vouchers OFF;

-- Pets
SET IDENTITY_INSERT pets ON;
INSERT INTO pets (
    pet_id,
    name,
    species,
    breed,
    age,
    date_of_birth,
    gender,
    weight,
    health_status,
    medical_notes,
    is_active,
    created_at,
    updated_at,
    customer_id
)VALUES
     (1, 'Bella', 'Dog', 'Labrador Retriever', 5, '2020-04-15', 'Female', 27.50, 'Healthy', 'Takes daily joint supplement.', 1, '2025-02-18 09:45:00', '2025-09-25 10:30:00', 4),
     (2, 'Milo', 'Cat', 'Siamese', 3, '2021-07-09', 'Male', 5.20, 'Healthy', 'Mild seasonal allergies.', 1, '2025-03-15 11:10:00', '2025-09-20 16:10:00', 5),
     (3, 'Luna', 'Dog', 'Border Collie', 2, '2022-05-20', 'Female', 18.40, 'Healthy', 'High energy; requires daily exercise.', 1, '2025-04-05 12:20:00', '2025-09-22 09:55:00', 6),
     (4, 'Rocky', 'Dog', 'Bulldog', 4, '2021-02-02', 'Male', 23.10, 'Healthy', 'Monitor breathing after intense activity.', 1, '2025-05-20 13:35:00', '2025-09-23 15:00:00', 7),
     (5, 'Coco', 'Cat', 'Maine Coon', 6, '2019-03-11', 'Female', 6.80, 'Healthy', 'Prefers hypoallergenic shampoo.', 1, '2025-06-12 10:50:00', '2025-09-24 12:15:00', 8);
SET IDENTITY_INSERT pets OFF;

-- Appointments
SET IDENTITY_INSERT appointments ON;
INSERT INTO appointments (
    appointment_id,
    appointment_date,
    end_date,
    status,
    notes,
    total_amount,
    created_at,
    updated_at,
    customer_id,
    pet_id,
    staff_id
)VALUES
     (1, '2025-10-05 09:00:00', '2025-10-05 10:30:00', 'COMPLETED', 'Annual check-up and grooming combo.', 160.00, '2025-09-20 10:00:00', '2025-10-05 11:00:00', 4, 1, 2),
     (2, '2025-10-06 14:00:00', '2025-10-06 15:15:00', 'CONFIRMED', 'Vaccination booster scheduled.', 55.00, '2025-09-22 09:15:00', '2025-09-28 16:00:00', 5, 2, 3),
     (3, '2025-10-07 11:00:00', '2025-10-07 12:15:00', 'SCHEDULED', 'First obedience training session.', 65.00, '2025-09-24 08:40:00', '2025-09-24 08:40:00', 6, 3, 3),
     (4, '2025-10-07 16:00:00', '2025-10-07 17:30:00', 'COMPLETED', 'Deluxe grooming for competition prep.', 85.00, '2025-09-25 09:05:00', '2025-10-07 18:00:00', 7, 4, 2),
     (5, '2025-10-08 10:30:00', '2025-10-08 11:45:00', 'IN_PROGRESS', 'Basic grooming before travel.', 45.00, '2025-09-26 10:20:00', '2025-10-08 10:45:00', 8, 5, 2);
SET IDENTITY_INSERT appointments OFF;

-- Appointment services junction
INSERT INTO appointment_services (
    appointment_id,
    service_id
) VALUES
      (1, 1),
      (1, 3),
      (2, 2),
      (3, 5),
      (4, 3),
      (5, 4);

-- Pet service history
SET IDENTITY_INSERT pet_service_history ON;
INSERT INTO pet_service_history (
    id,
    service_type,
    description,
    service_date,
    cost,
    staff_id,
    pet_id
)VALUES
     (1, 'Wellness Exam', 'Routine annual checkup with bloodwork analysis.', '2025-10-05', 75.00, 2, 1),
     (2, 'Vaccination', 'Booster vaccines administered and recorded.', '2025-10-06', 55.00, 3, 2),
     (3, 'Training', 'Obedience fundamentals introduction session.', '2025-10-07', 65.00, 3, 3),
     (4, 'Grooming', 'Show-level grooming with coat conditioning.', '2025-10-07', 85.00, 2, 4),
     (5, 'Grooming', 'Pre-travel grooming package with nail trim.', '2025-10-08', 45.00, 2, 5);
SET IDENTITY_INSERT pet_service_history OFF;

-- Invoices
SET IDENTITY_INSERT invoices ON;
INSERT INTO invoices (
    invoice_id,
    invoice_number,
    issue_date,
    due_date,
    subtotal,
    tax_amount,
    discount_amount,
    total_amount,
    amount_paid,
    amount_due,
    status,
    notes,
    created_at,
    updated_at,
    appointment_id,
    customer_id,
    voucher_id
)VALUES
     (1, 'INV-20251005-001', '2025-10-05 11:15:00', '2025-10-12 11:15:00', 160.00, 12.80, 16.00, 156.80, 156.80, 0.00, 'PAID', 'Paid in full using WELCOME10 voucher.', '2025-10-05 11:15:00', '2025-10-05 11:20:00', 1, 4, 1),
     (2, 'INV-20251006-001', '2025-10-06 15:30:00', '2025-10-13 15:30:00', 55.00, 4.40, 0.00, 59.40, 30.00, 29.40, 'PARTIALLY_PAID', 'Deposit collected at visit; awaiting balance.', '2025-10-06 15:30:00', '2025-10-06 15:45:00', 2, 5, NULL),
     (3, 'INV-20251007-001', '2025-10-07 12:30:00', '2025-10-14 12:30:00', 65.00, 5.20, 9.75, 60.45, 60.45, 0.00, 'PAID', 'Voucher FREESPA15 applied for training promo.', '2025-10-07 12:30:00', '2025-10-07 12:35:00', 3, 6, 2),
     (4, 'INV-20251007-002', '2025-10-07 17:45:00', '2025-10-14 17:45:00', 85.00, 6.80, 0.00, 91.80, 91.80, 0.00, 'PAID', 'Paid at checkout immediately after service.', '2025-10-07 17:45:00', '2025-10-07 17:50:00', 4, 7, NULL),
     (5, 'INV-20251008-001', '2025-10-08 12:00:00', '2025-10-15 12:00:00', 45.00, 3.60, 0.00, 48.60, 0.00, 48.60, 'SENT', 'Awaiting payment confirmation from customer.', '2025-10-08 12:00:00', '2025-10-08 12:00:00', 5, 8, NULL);
SET IDENTITY_INSERT invoices OFF;

-- Payments
SET IDENTITY_INSERT payments ON;
INSERT INTO payments (
    payment_id,
    payment_number,
    amount,
    payment_date,
    payment_method,
    status,
    transaction_id,
    reference_number,
    notes,
    created_at,
    updated_at,
    invoice_id,
    customer_id
)VALUES
     (1, 'PAY-20251005-001', 156.80, '2025-10-05 11:18:00', 'CREDIT_CARD', 'COMPLETED', 'TRX-105-456', 'POS-77701', 'Stripe confirmation 105-456.', '2025-10-05 11:18:00', '2025-10-05 11:18:00', 1, 4),
     (2, 'PAY-20251006-001', 30.00, '2025-10-06 15:40:00', 'CASH', 'COMPLETED', NULL, 'RCPT-88910', 'Cash deposit recorded at front desk.', '2025-10-06 15:40:00', '2025-10-06 15:40:00', 2, 5),
     (3, 'PAY-20251007-001', 60.45, '2025-10-07 12:33:00', 'DEBIT_CARD', 'COMPLETED', 'TRX-107-222', 'POS-77705', 'Chip transaction approved.', '2025-10-07 12:33:00', '2025-10-07 12:33:00', 3, 6),
     (4, 'PAY-20251007-002', 91.80, '2025-10-07 17:50:00', 'CREDIT_CARD', 'COMPLETED', 'TRX-107-678', 'POS-77708', 'Tap to pay receipt generated.', '2025-10-07 17:50:00', '2025-10-07 17:50:00', 4, 7),
     (5, 'PAY-20251008-002', 29.40, '2025-10-08 09:00:00', 'BANK_TRANSFER', 'PROCESSING', NULL, 'TRF-55231', 'Bank transfer initiated; awaiting settlement.', '2025-10-08 09:00:00', '2025-10-08 09:00:00', 2, 5);
SET IDENTITY_INSERT payments OFF;

-- Notifications
SET IDENTITY_INSERT notifications ON;
INSERT INTO notifications (
    notification_id,
    type,
    title,
    message,
    status,
    scheduled_time,
    sent_time,
    priority,
    is_read,
    read_time,
    created_at,
    updated_at,
    recipient_id,
    configured_by,
    related_appointment_id,
    related_invoice_id
)VALUES
     (1, 'APPOINTMENT_REMINDER', 'Reminder: Bella wellness and grooming', 'Hi Liam, Bella is scheduled for an annual wellness exam and grooming on Oct 5 at 9:00 AM.', 'SENT', '2025-10-04 09:00:00', '2025-10-04 09:00:05', 'NORMAL', 1, '2025-10-04 10:00:00', '2025-09-28 08:00:00', '2025-10-04 09:00:05', 4, 1, 1, NULL),
     (2, 'PAYMENT_CONFIRMATION', 'Payment received for INV-20251005-001', 'Thank you for your payment of $156.80. Your balance is now cleared.', 'SENT', NULL, '2025-10-05 11:19:00', 'HIGH', 1, '2025-10-05 11:30:00', '2025-10-05 11:18:00', '2025-10-05 11:19:00', 4, 1, 1, 1),
     (3, 'APPOINTMENT_CONFIRMATION', 'Appointment confirmed for Milo', 'Your vaccination appointment on Oct 6 at 2:00 PM is confirmed.', 'SENT', NULL, '2025-09-28 16:05:00', 'NORMAL', 0, NULL, '2025-09-28 16:00:00', '2025-09-28 16:05:00', 5, 1, 2, NULL),
     (4, 'PAYMENT_REMINDER', 'Payment reminder for INV-20251006-001', 'A balance of $29.40 remains due by Oct 13. Please submit payment to avoid late fees.', 'SCHEDULED', '2025-10-09 09:00:00', NULL, 'HIGH', 0, NULL, '2025-10-07 08:30:00', '2025-10-07 08:30:00', 5, 1, 2, 2),
     (5, 'PROMOTIONAL', 'Training bundle offer for Luna', 'Book three obedience sessions and receive 15 percent off your next grooming.', 'SENT', NULL, '2025-09-25 12:00:00', 'LOW', 0, NULL, '2025-09-24 10:00:00', '2025-09-25 12:00:00', 6, 1, 3, NULL);
SET IDENTITY_INSERT notifications OFF;
