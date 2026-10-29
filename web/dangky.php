<?php
session_start();
include "config.php";

header('Content-Type: application/json');

// ===== ANTI: TOKEN + FINGERPRINT =====
if(empty($_POST['token']) || empty($_POST['fp'])){
    echo json_encode([
        "status"=>"error",
        "message"=>"Request không hợp lệ"
    ]);
    exit;
}

// ===== ANTI: RATE LIMIT (SESSION) =====
if(!isset($_SESSION['reg_limit'])){
    $_SESSION['reg_limit'] = time();
    $_SESSION['reg_count'] = 0;
}

if(time() - $_SESSION['reg_limit'] < 60){
    $_SESSION['reg_count']++;

    if($_SESSION['reg_count'] > 5){
        echo json_encode([
            "status"=>"error",
            "message"=>"Bạn thao tác quá nhanh!"
        ]);
        exit;
    }

}else{
    $_SESSION['reg_limit'] = time();
    $_SESSION['reg_count'] = 0;
}

// ===== INPUT =====
$user = trim((string)($_POST['username'] ?? ''));
$pass = (string)($_POST['password'] ?? '');
// ===== VALIDATE =====
if(!preg_match('/^[A-Za-z0-9_]{4,12}$/', $user)){
    echo json_encode([
        "status"=>"error",
        "message"=>"Tên tài khoản 4-12 ký tự"
    ]);
    exit;
}

if(strlen($pass) < 6 || strlen($pass) > 100){
    echo json_encode([
        "status"=>"error",
        "message"=>"Mật khẩu phải >=6 ký tự"
    ]);
    exit;
}

// ===== INSERT =====
try {
    $token = bin2hex(random_bytes(16));
    $xsrfToken = bin2hex(random_bytes(16));
    $stmt = $conn->prepare('INSERT INTO account (username, password, email, token, xsrf_token, newpass, ip_address) VALUES (?, ?, ?, ?, ?, ?, ?)');
    $empty = '';
    $ip = $_SERVER['REMOTE_ADDR'] ?? '';
    $stmt->bind_param('sssssss', $user, $pass, $empty, $token, $xsrfToken, $empty, $ip);
    $stmt->execute();
    $stmt->close();
    echo json_encode(['status' => 'success']);
} catch (mysqli_sql_exception $e) {
    if ($e->getCode() === 1062) {
        echo json_encode(['status' => 'error', 'message' => 'Tài khoản đã tồn tại']);
    } else {
        error_log('Registration failed: ' . $e->getMessage());
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => 'Không thể tạo tài khoản. Vui lòng thử lại.']);
    }
}
