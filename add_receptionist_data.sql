-- Add Receptionist account to the system

-- Insert receptionist account
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
) VALUES
    (9, 'receptionist', '123', 'receptionist@petcare.com', 'Sarah Johnson', '555-310-3001', 'RECEPTIONIST', 1, 1, NULL, '2025-10-25 12:00:00', '2025-10-25 12:00:00', 'RECEPTIONIST');
SET IDENTITY_INSERT accounts OFF;

-- Insert receptionist profile
INSERT INTO receptionists (
    account_id,
    address,
    date_of_birth
) VALUES
    (9, '123 Main Street, City Center', '1995-03-15');
