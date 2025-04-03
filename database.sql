-- Create database
CREATE DATABASE IF NOT EXISTS temple_db;
USE temple_db;

-- Create poojas table
CREATE TABLE poojas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    amount DECIMAL(10,2) NOT NULL,
    duration VARCHAR(50),
    is_special BOOLEAN DEFAULT FALSE,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create pooja_bookings table
CREATE TABLE pooja_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reference_number VARCHAR(50) UNIQUE NOT NULL,
    pooja_id INT NOT NULL,
    booking_date DATE NOT NULL,
    preferred_time TIME,
    devotee_name VARCHAR(100) NOT NULL,
    devotee_email VARCHAR(100),
    devotee_phone VARCHAR(20),
    star_birth VARCHAR(50),
    rashi VARCHAR(50),
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    payment_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pooja_id) REFERENCES poojas(id)
);

-- Create donations table
CREATE TABLE donations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reference_number VARCHAR(50) UNIQUE NOT NULL,
    donor_name VARCHAR(100) NOT NULL,
    donor_email VARCHAR(100),
    donor_phone VARCHAR(20),
    amount DECIMAL(10,2) NOT NULL,
    purpose VARCHAR(100),
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    payment_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create content_sections table for managing website content
CREATE TABLE content_sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    section_name VARCHAR(100) NOT NULL,
    title VARCHAR(255),
    content TEXT,
    image_url VARCHAR(255),
    page_location VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create image_gallery table
CREATE TABLE image_gallery (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    image_url VARCHAR(255) NOT NULL,
    category VARCHAR(50),
    is_featured BOOLEAN DEFAULT FALSE,
    display_order INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create events table
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_date DATE,
    event_time TIME,
    image_url VARCHAR(255),
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create admin_users table
CREATE TABLE admin_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100),
    role ENUM('super_admin', 'admin', 'editor') DEFAULT 'editor',
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create activity_logs table
CREATE TABLE activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    description TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES admin_users(id)
);

-- Insert default admin user (password: admin123)
INSERT INTO admin_users (username, password, full_name, email, role) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Temple Administrator', 'admin@temple.com', 'super_admin');

-- Insert sample content sections
INSERT INTO content_sections (section_name, title, content, page_location) VALUES
('home_hero', 'Welcome to Kuriyanvila Sree Bhadrakali Temple', 'A sacred abode of divine mother Bhadrakali, where spirituality and tradition unite in harmony', 'home'),
('about_temple', 'About Our Temple', 'Kuriyanvila Sree Bhadrakali Temple stands as a testament to centuries of spiritual devotion and architectural brilliance.', 'about'),
('contact_info', 'Contact Information', 'Visit us at: Kuriyanvila, Kerala, India\nPhone: +91 XXX XXX XXXX\nEmail: info@temple.com', 'contact');

-- Insert sample poojas
INSERT INTO poojas (name, description, amount, duration, is_special) VALUES
('Archana', 'Simple pooja performed with flowers and mantras', 51.00, '30 mins', FALSE),
('Pushpanjali', 'Special flower offering with sacred mantras', 101.00, '45 mins', FALSE),
('Udayasthamana Pooja', 'Full day pooja from sunrise to sunset', 1001.00, 'Full Day', TRUE),
('Ganapathi Homam', 'Sacred fire ritual for Lord Ganesha', 751.00, '2 hours', TRUE),
('Mandala Pooja', 'Special 41-day pooja during Mandalam', 2001.00, '41 days', TRUE),
('Makam Thozhal', 'Special pooja on Makam star day', 1501.00, '3 hours', TRUE);