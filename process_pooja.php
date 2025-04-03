<?php
require_once 'includes/config.php';

header('Content-Type: application/json');

try {
    // Validate request method
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        throw new Exception('Invalid request method');
    }

    // Get and validate POST data
    $pooja_id = filter_input(INPUT_POST, 'pooja_id', FILTER_VALIDATE_INT);
    $booking_date = filter_input(INPUT_POST, 'booking_date', FILTER_SANITIZE_STRING);
    $preferred_time = filter_input(INPUT_POST, 'preferred_time', FILTER_SANITIZE_STRING);
    $devotee_name = filter_input(INPUT_POST, 'devotee_name', FILTER_SANITIZE_STRING);
    $devotee_email = filter_input(INPUT_POST, 'devotee_email', FILTER_VALIDATE_EMAIL);
    $devotee_phone = filter_input(INPUT_POST, 'devotee_phone', FILTER_SANITIZE_STRING);
    $star_birth = filter_input(INPUT_POST, 'star_birth', FILTER_SANITIZE_STRING);
    $rashi = filter_input(INPUT_POST, 'rashi', FILTER_SANITIZE_STRING);
    $payment_id = filter_input(INPUT_POST, 'payment_id', FILTER_SANITIZE_STRING);

    // Validate required fields
    if (!$pooja_id || !$booking_date || !$devotee_name || !$devotee_email || !$payment_id) {
        throw new Exception('Missing required fields');
    }

    // Validate booking date
    $booking_timestamp = strtotime($booking_date);
    if ($booking_timestamp === false || $booking_timestamp < strtotime('today')) {
        throw new Exception('Invalid booking date');
    }

    // Generate unique reference number
    $reference_number = 'POOJA' . date('Ymd') . rand(1000, 9999);

    // Get pooja details and amount
    $stmt = $pdo->prepare("SELECT amount FROM poojas WHERE id = ?");
    $stmt->execute([$pooja_id]);
    $pooja = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$pooja) {
        throw new Exception('Invalid pooja selected');
    }

    // Insert booking into database
    $stmt = $pdo->prepare("
        INSERT INTO pooja_bookings (
            reference_number, pooja_id, booking_date, preferred_time,
            devotee_name, devotee_email, devotee_phone,
            star_birth, rashi, amount, payment_status, payment_id
        ) VALUES (
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'completed', ?
        )
    ");

    $stmt->execute([
        $reference_number,
        $pooja_id,
        $booking_date,
        $preferred_time,
        $devotee_name,
        $devotee_email,
        $devotee_phone,
        $star_birth,
        $rashi,
        $pooja['amount'],
        $payment_id
    ]);

    // Send confirmation email
    $to = $devotee_email;
    $subject = "Pooja Booking Confirmation - " . $reference_number;
    $message = "Dear $devotee_name,\n\n";
    $message .= "Thank you for booking a pooja at Kuriyanvila Sree Bhadrakali Temple.\n\n";
    $message .= "Booking Details:\n";
    $message .= "Reference Number: $reference_number\n";
    $message .= "Booking Date: $booking_date\n";
    $message .= "Amount: ₹" . number_format($pooja['amount'], 2) . "\n\n";
    $message .= "May the divine mother's blessings be with you.\n\n";
    $message .= "Regards,\nKuriyanvila Sree Bhadrakali Temple";
    
    $headers = "From: noreply@temple.com";

    mail($to, $subject, $message, $headers);

    // Return success response
    echo json_encode([
        'status' => 'success',
        'message' => 'Pooja booking successful',
        'reference_number' => $reference_number
    ]);

} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}