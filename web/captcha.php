<?php
session_start();

// ===== ANTI SPAM CAPTCHA =====
if(!isset($_SESSION['captcha_time'])){
    $_SESSION['captcha_time'] = time();
    $_SESSION['captcha_count'] = 0;
}

if(time() - $_SESSION['captcha_time'] < 10){
    $_SESSION['captcha_count']++;

    if($_SESSION['captcha_count'] > 10){
        http_response_code(429);
        exit;
    }

}else{
    $_SESSION['captcha_time'] = time();
    $_SESSION['captcha_count'] = 0;
}

// GD may be disabled in XAMPP. Keep registration usable with an SVG fallback.
if (!function_exists('imagecreatetruecolor')) {
    $captcha = '';
    for ($i = 0; $i < 4; $i++) $captcha .= (string)random_int(0, 9);
    $_SESSION['captcha'] = $captcha;
    header('Content-Type: image/svg+xml; charset=utf-8');
    header('Cache-Control: no-store, no-cache, must-revalidate');
    header('Pragma: no-cache');
    echo '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="80" viewBox="0 0 200 80">';
    echo '<rect width="200" height="80" fill="#edf4ff"/>';
    echo '<path d="M4 19L195 61 M8 69L192 12 M0 42L200 35" stroke="#a9c4e8" stroke-width="2"/>';
    foreach (str_split($captcha) as $i => $digit) {
        $x = 22 + $i * 43;
        $angle = random_int(-14, 14);
        echo '<text x="' . $x . '" y="56" transform="rotate(' . $angle . ' ' . $x . ' 56)" font-size="46" font-weight="bold" font-family="Arial" fill="#183153">' . $digit . '</text>';
    }
    echo '</svg>';
    exit;
}

// ===== HEADER =====
header("Content-Type: image/png");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Pragma: no-cache");

// ===== SIZE =====
$width = 200;
$height = 80;

$image = imagecreatetruecolor($width, $height);

// ===== BACKGROUND (gradient nhẹ) =====
$bg1 = imagecolorallocate($image, 240, 245, 255);
$bg2 = imagecolorallocate($image, 220, 235, 255);

for ($y = 0; $y < $height; $y++) {
    $color = imagecolorallocate(
        $image,
        240 - ($y * 0.2),
        245 - ($y * 0.2),
        255
    );
    imageline($image, 0, $y, $width, $y, $color);
}

// ===== TEXT COLOR RANDOM =====
$textColor = imagecolorallocate(
    $image,
    rand(0,50),
    rand(0,50),
    rand(0,50)
);

// ===== CAPTCHA =====
$chars = "0123456789";
$captcha = "";

for ($i = 0; $i < 4; $i++) {
    $captcha .= $chars[rand(0, 9)];
}

$_SESSION['captcha'] = $captcha;

// ===== FONT =====
$fontPath = __DIR__ . '/segoesc.ttf';

// ===== DRAW TEXT (cong nhẹ) =====
$fontSize = 46;
$spacing  = 38;
$startX   = 20;
$baseY    = 58;

for ($i = 0; $i < 4; $i++) {

    $angle = rand(-20, 20); // cong mạnh hơn

    $x = $startX + ($i * $spacing);
    $y = $baseY + rand(-5,5);

    imagettftext(
        $image,
        $fontSize,
        $angle,
        $x,
        $y,
        $textColor,
        $fontPath,
        $captcha[$i]
    );
}

// ===== NOISE LINE =====
for ($i = 0; $i < 4; $i++) {

    $lineColor = imagecolorallocate(
        $image,
        rand(100,180),
        rand(100,180),
        rand(100,180)
    );

    imageline(
        $image,
        rand(0,$width),
        rand(0,$height),
        rand(0,$width),
        rand(0,$height),
        $lineColor
    );
}

// ===== DOT NOISE =====
for ($i = 0; $i < 150; $i++) {

    $dotColor = imagecolorallocate(
        $image,
        rand(120,200),
        rand(120,200),
        rand(120,200)
    );

    imagesetpixel(
        $image,
        rand(0, $width),
        rand(0, $height),
        $dotColor
    );
}

// ===== OUTPUT =====
imagepng($image);
imagedestroy($image);
