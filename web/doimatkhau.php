<?php
session_start();
header('Content-Type: application/json');

// ===== LOAD CONFIG =====
require_once __DIR__ . "/config.php";

// ===== CHECK CONNECT =====
if($conn->connect_error){
    echo json_encode(["status"=>"error","message"=>"Lỗi kết nối DB"]);
    exit;
}
// ===== GET DATA =====
$username = trim($_POST['username'] ?? '');
$oldpass  = trim($_POST['oldpass'] ?? '');
$newpass  = trim($_POST['newpass'] ?? '');
$captcha  = trim($_POST['captcha'] ?? '');

// ===== CHECK CAPTCHA =====
if(!isset($_SESSION['captcha']) || strtolower($captcha) !== strtolower($_SESSION['captcha'])){
    echo json_encode(["status"=>"error","message"=>"Sai captcha"]);
    exit;
}

// ===== VALIDATE =====
if(strlen($username) < 4){
    echo json_encode(["status"=>"error","message"=>"Tên tài khoản không hợp lệ"]);
    exit;
}

if(strlen($newpass) < 6){
    echo json_encode(["status"=>"error","message"=>"Mật khẩu mới phải >= 6 ký tự"]);
    exit;
}

if($oldpass === $newpass){
    echo json_encode(["status"=>"error","message"=>"Mật khẩu mới phải khác mật khẩu cũ"]);
    exit;
}

// ===== CHECK ACCOUNT =====
$stmt = $conn->prepare("SELECT password FROM account WHERE username=? LIMIT 1");
$stmt->bind_param("s",$username);
$stmt->execute();
$result = $stmt->get_result();

if($result->num_rows === 0){
    echo json_encode(["status"=>"error","message"=>"Tài khoản không tồn tại"]);
    exit;
}

$row = $result->fetch_assoc();

// ===== CHECK OLD PASSWORD (TEXT) =====
if($row['password'] !== $oldpass){
    echo json_encode(["status"=>"error","message"=>"Sai mật khẩu cũ"]);
    exit;
}

// ===== UPDATE PASSWORD (TEXT) =====
$stmt = $conn->prepare("UPDATE account SET password=? WHERE username=?");
$stmt->bind_param("ss",$newpass,$username);

if($stmt->execute()){
    echo json_encode(["status"=>"success","message"=>"Đổi mật khẩu thành công"]);
}else{
    echo json_encode(["status"=>"error","message"=>"Lỗi database"]);
}