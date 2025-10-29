-- Fix ai_data table column type for SQL Server
-- Run this if the table already exists with wrong column type

-- Check if table exists and column type
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ai_data')
BEGIN
    -- Check current column type
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'ai_data' AND COLUMN_NAME = 'prompt';
    
    -- Alter column to support larger text
    ALTER TABLE ai_data ALTER COLUMN prompt NVARCHAR(MAX) NOT NULL;
    
    PRINT 'ai_data table column updated successfully';
END
ELSE
BEGIN
    -- Create table if it doesn't exist
    CREATE TABLE ai_data (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        creativity_level INT NOT NULL DEFAULT 40,
        prompt NVARCHAR(MAX) NOT NULL
    );
    
    PRINT 'ai_data table created successfully';
END

-- Insert default AI configuration
IF NOT EXISTS (SELECT 1 FROM ai_data)
BEGIN
    INSERT INTO ai_data (creativity_level, prompt) VALUES (
        40,
        'You are a helpful AI assistant for a pet care management system. Provide professional, caring, and accurate advice about pet care services, scheduling, and customer support. Always prioritize pet welfare and customer satisfaction.

Guidelines:
- Be friendly and professional
- Provide accurate pet care information
- Help with appointment scheduling
- Offer service recommendations
- Maintain a caring and supportive tone
- Address users by their name when appropriate
- Keep responses concise but informative'
    );
    
    PRINT 'Default AI configuration inserted successfully';
END

-- Verify table structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ai_data'
ORDER BY ORDINAL_POSITION;

-- Show current data
SELECT id, creativity_level, LEN(prompt) as prompt_length FROM ai_data;
