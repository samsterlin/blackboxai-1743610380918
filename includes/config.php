<?php
// Database configuration
$db_host = 'localhost';
$db_name = 'temple_db';
$db_user = 'root';
$db_pass = '';

try {
    // Create PDO instance
    $pdo = new PDO(
        "mysql:host=$db_host;dbname=$db_name;charset=utf8mb4",
        $db_user,
        $db_pass,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false
        ]
    );
} catch (PDOException $e) {
    // Log error (to a file in a secure location)
    error_log($e->getMessage());
    
    // Show generic error message to user
    die('A database error occurred. Please try again later.');
}

// Set default timezone
date_default_timezone_set('Asia/Kolkata');

// Common functions
function generateReferenceNumber($prefix) {
    return $prefix . date('Ymd') . rand(1000, 9999);
}

// Email configuration
ini_set('SMTP', 'localhost');
ini_set('smtp_port', 25);