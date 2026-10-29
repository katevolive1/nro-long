<!DOCTYPE html>
<html lang="vi">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Ngọc Rồng Online</title>

<link rel="icon" type="image/jpg" href="img/icon.jpg">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>

:root{
--blue:#3b82f6;
--blue2:#2563eb;
--green:#22c55e;
--green2:#16a34a;
--red:#f43f5e;
--red2:#e11d48;
}

*{
box-sizing:border-box;
margin:0;
padding:0;
}

body{
min-height:100vh;
font-family:'Inter',sans-serif;

background:
radial-gradient(circle at 20% 20%,#7dd3fc,transparent),
radial-gradient(circle at 80% 0%,#60a5fa,transparent),
linear-gradient(135deg,#bae6fd,#60a5fa);

display:flex;
justify-content:center;
padding:25px 0;
}

/* CARD */

.main-card{
background:linear-gradient(160deg,#4a4a4a,#2b2b2b 65%,#1b1b1b);
width:100%;
max-width:720px;
border-radius:22px;
padding:35px 25px;

box-shadow:
0 25px 60px rgba(0,0,0,.55),
inset 0 2px 8px rgba(255,255,255,.12),
inset 0 -2px 6px rgba(0,0,0,.5),
0 0 15px rgba(255,255,255,.04);

border:1px solid rgba(255,255,255,.15);

text-align:center;
margin:auto;
color:white;
}

/* LOGO */

.logo-main{
font-size:clamp(32px,6vw,50px);
font-weight:900;
margin-bottom:10px;
letter-spacing:1px;
}

.logo-main span{
display:inline-block;
-webkit-text-stroke:1.5px rgba(0,0,0,.3);
text-shadow:0 4px 8px rgba(0,0,0,.25);
transition:transform .25s,filter .25s;
}

.logo-main span:hover{
transform:translateY(-4px) scale(1.08);
filter:brightness(1.2);
}

.blue{color:#4285F4}
.red{color:#f43f5e}
.yellow{color:#FBBC05}
.green{color:#34A853}

/* IMAGE */

.logo-box{
width:90%;
max-width:700px;
aspect-ratio:16/9;
margin:20px auto;
border-radius:20px;
overflow:hidden;
box-shadow:0 15px 35px rgba(0,0,0,.25);
border:3px solid rgba(255,255,255,.7);
}

.logo-box img{
width:100%;
height:100%;
object-fit:cover;
}
.download-box{
display:flex;
flex-wrap:wrap;
justify-content:center;
gap:12px;
}

/* nút chung */
.download-btn{
padding:12px 18px;
border-radius:14px;
font-weight:800;
font-size:clamp(13px,2.5vw,15px);
color:white;
text-decoration:none;
display:flex;
align-items:center;
justify-content:center;
gap:8px;

transition:all .15s ease; /* mượt hơn */

flex:0 0 auto;
}
.download-btn:active{
transform:scale(0.92);
filter:brightness(0.85);
}
/* hover (PC) */
.download-btn:hover{
transform:translateY(-2px);
box-shadow:0 8px 18px rgba(0,0,0,.25);
}

/* click (mobile + PC) */
.download-btn:active{
transform:scale(0.92);
box-shadow:0 3px 8px rgba(0,0,0,.25);
filter:brightness(0.85);
}
/* Windows riêng 1 dòng */
.windows{
flex:0 0 100%;
max-width:220px;
margin:0 auto;
order:1;
}

/* APK + iOS cùng 1 dòng */
.android,
.ios{
flex:1;
max-width:160px;
}
.windows{
background:linear-gradient(135deg,var(--blue),var(--blue2));
}

.android{
background:linear-gradient(135deg,var(--green),var(--green2));
}

.ios{
background:linear-gradient(135deg,var(--red),var(--red2));
}
/* DESC */

.desc-box{
margin-top:20px;
display:flex;
flex-direction:column;
align-items:center;
gap:8px;
}

.desc-line{
display:flex;
align-items:center;
gap:8px;
padding:10px 16px;
font-size:clamp(12px,2.5vw,14px);
font-weight:700;
color:#1e40af;
background:#f8fbff;
border:1px solid #bfdbfe;
border-radius:14px;
}

/* TOP BAR */

.top-bar{
margin-top:20px;
display:flex;
justify-content:center;
gap:10px;
flex-wrap:wrap;
}

.top-item{
flex:1;
min-width:130px;
max-width:200px;
display:flex;
align-items:center;
justify-content:center;
gap:6px;
padding:12px;
font-size:clamp(12px,2.5vw,14px);
font-weight:800;
border-radius:14px;
text-decoration:none;
color:white;

transition:transform .2s, box-shadow .2s;
}

.top-item:hover{
transform:scale(1.05);
box-shadow:0 8px 18px rgba(0,0,0,.3);
}

.rank1{
background:linear-gradient(135deg,var(--red),var(--red2));
}

.rank2{
background:linear-gradient(135deg,var(--green),var(--green2));
}
.feature-wrapper{
margin-top:25px;
padding:20px;

border-radius:22px;

background:linear-gradient(160deg,#1f2937,#111827);
border:1px solid rgba(255,255,255,.15);

box-shadow:
0 20px 50px rgba(0,0,0,.5),
inset 0 2px 8px rgba(255,255,255,.08);

display:flex;
flex-direction:column;
gap:18px;
position:relative;
overflow:hidden;
}

/* viền glow nhẹ */
.feature-wrapper::before{
content:"";
position:absolute;
inset:0;
border-radius:22px;
padding:1px;
background:linear-gradient(120deg,#3b82f6,#22c55e,#3b82f6);
-webkit-mask:
linear-gradient(#fff 0 0) content-box,
linear-gradient(#fff 0 0);
-webkit-mask-composite: xor;
mask-composite: exclude;
opacity:.25;
animation:borderRun 6s linear infinite;
}

@keyframes borderRun{
0%{filter:hue-rotate(0deg);}
100%{filter:hue-rotate(360deg);}
}

/* đảm bảo nội dung nổi trên effect */
.feature-wrapper > *{
position:relative;
z-index:1;
}
/* REGISTER */

.register-box{
margin-top:15px;
display:flex;
flex-direction:column;
align-items:center;
gap:10px;
}

.register-btn{
    width:240px;
    padding:16px;              /* 12px -> 14px (~+20%) */
    border-radius:30px;
    font-weight:900;
    font-size:clamp(16px,3.3vw,20px); /* tăng ~20% */
    text-decoration:none;
    color:white;
    background:linear-gradient(135deg,var(--blue),var(--blue2));
    display:flex;
    align-items:center;
    justify-content:center;
    gap:10px;      

transition:transform .2s, box-shadow .2s;

border:none;
outline:none;
box-shadow:0 6px 15px rgba(0,0,0,.25);
cursor:pointer;
}

.register-btn:hover{
transform:scale(1.07);
box-shadow:0 12px 30px rgba(0,0,0,.45);
}

/* STATS */

.stat{
background:linear-gradient(135deg,#e0f2fe,#bfdbfe);
border:1px solid #60a5fa;
color:#1e3a8a;
}
/* ZALO BUTTON */

.zalo-box{
margin-top:12px;
display:flex;
justify-content:center;
}

.zalo-btn{
background:linear-gradient(135deg,#0ea5e9,#0284c7);
color:white;
font-weight:800;
font-size:14px;
padding:12px 22px;
border-radius:30px;
text-decoration:none;
display:flex;
align-items:center;
gap:8px;
box-shadow:0 6px 15px rgba(0,0,0,.25);
transition:transform .2s, box-shadow .2s;
}

.zalo-btn:hover{
transform:scale(1.07);
box-shadow:0 10px 22px rgba(0,0,0,.35);
}

/* GIFT */

.giftcode-section{
background:linear-gradient(135deg,#eff6ff,#dbeafe);
border-radius:18px;
padding:16px;
border:1px solid #bfdbfe;
margin-top:20px;
}

.giftcode-title{
font-size:clamp(15px,3vw,18px);
font-weight:800;
margin-bottom:12px;
color:#1d4ed8;
display:flex;
justify-content:center;
gap:8px;
}
.bxh-bar{
margin-top:30px;
}
.bacday-list{
list-style:none;
display:flex;
flex-direction:column;
align-items:center;
gap:6px;
}
.submit-btn:disabled{
opacity:0.4;
cursor:not-allowed;
filter:grayscale(40%);
}

.submit-btn:enabled{
opacity:1;
filter:none;
}
.bacday-list li{
display:flex;
align-items:center;
gap:8px;
padding:10px 14px;
font-size:clamp(11px,2.4vw,13px);
font-weight:600;
color:#1e3a8a;
background:#f0f9ff;
border-radius:10px;
border:1px solid #bfdbfe;
}
.popup-box h2 i{
color:#f59e0b;
margin-right:6px;
}
.download-wrapper{
margin-top:20px;
padding:18px;

border-radius:20px;

background:linear-gradient(145deg,#f8fafc,#e0f2fe);
border:1px solid #93c5fd;

box-shadow:
0 12px 30px rgba(0,0,0,.25),
inset 0 2px 6px rgba(255,255,255,.7);

display:flex;
flex-direction:column;
align-items:center;
gap:15px;
position:relative;
overflow:hidden;
}
@media (min-width: 769px){
    body{
        font-size:105%;
    }

    .download-btn,
    .top-item,
    .desc-line,
    .security-item,
    .bacday-list li{
        font-size:1.2em;
    }
}
/* ánh sáng nhẹ */
.download-wrapper::before{
content:"";
position:absolute;
width:200%;
height:200%;
top:-50%;
left:-50%;
background:radial-gradient(circle,rgba(255,255,255,.35),transparent 60%);
animation:spinLight 8s linear infinite;
}

@keyframes spinLight{
0%{transform:rotate(0deg);}
100%{transform:rotate(360deg);}
}

/* đảm bảo nội dung nằm trên hiệu ứng */
.download-wrapper > *{
position:relative;
z-index:1;
}
/* NOTIFY */

/* NOTIFY DƯỚI NÚT ĐĂNG KÝ */

.notify{
margin-top:15px;
padding:14px 18px;

border-radius:12px;
font-weight:700;
font-size:18px;

text-align:center;

opacity:0;
transform:translateY(-5px);

transition:.3s;
}

.notify.show{
opacity:1;
transform:translateY(0);
}

.notify.success{
background:#22c55e;
}

.notify.error{
background:#ef4444;
}
/* SECURITY */

.security-section{
margin-top:20px;
background:#f0fdf4;
border:1px solid #bbf7d0;
border-radius:14px;
padding:16px;
}

.security-title-box{
display:inline-block;
background:#047857;
border-radius:10px;
padding:6px 12px;
margin-bottom:10px;
}

.security-title{
font-weight:700;
font-size:11px;
color:#fff;
letter-spacing:1px;
}

.security-grid{
display:grid;
grid-template-columns:1fr 1fr;
gap:8px;
font-size:clamp(11px,2.4vw,13px);
}

.security-item{
background:white;
padding:10px;
border-radius:10px;
border:1px solid #d1fae5;
font-weight:700;
color:#065f46;
display:flex;
align-items:center;
justify-content:center;
gap:8px;
}

.footer-section{
margin-top:25px;
font-size:clamp(10px,2vw,12px);
color:#9ca3af;
}

/* MOBILE */

@media (max-width:600px){

.main-card{
padding:25px 15px;
}

.download-btn{
width:140px;
}

.register-btn{
width:200px;
}

.logo-box{
width:95%;
}
}
/* POPUP REGISTER */
.popup-bg{
position:fixed;
top:0;
left:0;
width:100vw;
height:100vh;

background:rgba(0,0,0,0.99); /* giảm lag */
backdrop-filter:none;        /* 🔥 tắt blur */

display:none;
justify-content:center;
align-items:center;

z-index:9999;
}
.popup-box{
width:90%;
max-width:500px;
min-width:260px;

min-height:420px;

background:linear-gradient(160deg,#3b3b3b,#1e1e1e);
border-radius:20px;

padding:28px;

color:white;

/* shadow nhẹ lại */
box-shadow:0 10px 30px rgba(0,0,0,.5);

position:relative;
animation:pop .25s ease;
}
/* khoảng cách tiêu đề */

.popup-box h2{
margin-bottom:22px;
font-size:36px;
}

/* khoảng cách sau username */

.form-box input[name="username"]{
margin-bottom:10px;
}

/* khoảng cách sau password */

.form-box input[name="password"]{
margin-bottom:22px;
}
/* tiêu đề */


/* input */
.form-box input{
font-size:24px;
padding:16px;
}

/* captcha input */
.captcha-box input{
font-size:24px;
}

/* điều khoản */
.rules-box{
font-size:24px;
}

/* checkbox */
.rules-check{
font-size:28px;
}

/* nút đăng ký */
@keyframes pop{
from{transform:scale(.8);opacity:0}
to{transform:scale(1);opacity:1}
}

.close-btn{
position:absolute;
top:-18px;        /* đẩy lên cao hơn khung */
right:-10px;

font-size:48px;   /* to hơn tiêu đề */
font-weight:900;

width:60px;
height:60px;

display:flex;
align-items:center;
justify-content:center;

border-radius:50%;
background:#ef4444; /* nền đỏ nổi bật */
color:white;

box-shadow:0 10px 25px rgba(0,0,0,.4);

cursor:pointer;
transition:.2s;
}
/* VIỀN NGOÀI POPUP ĐĂNG KÝ */
.popup-box::before{
display:none;
}


/* lớp viền ngoài */
.popup-box::before{
content:"";
position:absolute;
inset:-3px; /* độ dày viền ngoài */
border-radius:22px;

background:linear-gradient(120deg,#3b82f6,#22c55e,#a855f7,#3b82f6);
background-size:300% 300%;

z-index:-1;
filter:blur(6px);
opacity:.9;

animation:borderMove 6s linear infinite;
}

/* lớp viền nét bên trong (sắc nét hơn) */
.popup-box::after{
content:"";
position:absolute;
inset:0;
border-radius:20px;

border:1px solid rgba(255,255,255,.2);
z-index:-1;
}

/* animation chạy màu */
@keyframes borderMove{
0%{background-position:0% 50%;}
100%{background-position:100% 50%;}
}
/* KHUNG NGOÀI CÙNG (lớn hơn nữa) */
.popup-box{
box-shadow:
0 0 0 6px rgba(255,255,255,0.05),   /* lớp mờ ngoài */
0 0 0 12px rgba(59,130,246,0.15),  /* lớp xanh */
0 30px 80px rgba(0,0,0,.6);        /* shadow cũ */
}

/* thêm 1 vòng glow nhẹ chạy */
.popup-box::before{
inset:-6px; /* rộng hơn lớp trước */
filter:blur(10px);
opacity:0.6;
}
/* hover cho xịn hơn */
.close-btn:hover{
transform:scale(1.15) rotate(90deg);
background:#dc2626;
}
.close-btn{
padding:5px 10px;
}
.form-box{
    display:flex;
    flex-direction:column;
    gap:12px; /* thêm khoảng cách */
}
.form-box input{
padding:12px;
border-radius:10px;
border:none;
font-size:14px;
}

.captcha-box{
display:flex;
gap:10px;
align-items:center;
flex-wrap:wrap; /* cho phép xuống dòng */
}

.captcha-box img{
height:50px;
min-width:150px;
flex-shrink:0; /* không bị co ảnh */
}

.captcha-box input{
flex:1;
min-width:0; /* QUAN TRỌNG: tránh tràn */
}

.submit-btn{
margin-top:14px;
background:linear-gradient(135deg,#3b82f6,#2563eb);
border:none;
padding:16px;
border-radius:12px;
font-weight:700;
color:white;
cursor:pointer;
font-size:30px;
}

.rules-box{
text-align:center;
margin-top:10px;
font-size:13px;
}

.rule-top{
display:flex;
flex-direction:column;
gap:4px;
margin-bottom:8px;
font-weight:600;
color:#e5e7eb;
}

.rule-more{
display:none;
margin-top:8px;
flex-direction:column;
gap:4px;
font-weight:600;
color:#d1fae5;
}

.rules-check{
display:flex;
justify-content:center;
align-items:center;
gap:8px;
font-weight:700;
cursor:pointer;
}

/* checkbox nổi bật */

.rules-check input{
width:18px;
height:18px;
accent-color:#22c55e;
cursor:pointer;
}

.rules-check:hover{
color:#22c55e;
}

</style>
</head>

<body>

<div class="main-card">

<div class="logo-main">

<span class="blue">N</span>
<span class="red">g</span>
<span class="yellow">ọ</span>
<span class="green">c</span>

<span class="space"></span>

<span class="space"></span>
<span class="red">R</span>
<span class="yellow">ồ</span>
<span class="green">n</span>
<span class="blue">g</span>

<br>

<span class="red">O</span>
<span class="yellow">n</span>
<span class="green">l</span>
<span class="blue">i</span>
<span class="red">n</span>
<span class="yellow">e</span>

</div>

<div class="logo-box">
<img src="img/logo1.jpg" loading="lazy">
</div>

<div class="download-wrapper">

<div class="download-box">

<a class="download-btn windows" href="download/NRO-long.rar" download>
    <i class="fa-brands fa-windows"></i>
    Windows
    <i class="fa-solid fa-download"></i>
</a>

<a class="download-btn android" href="download/NRO.apk" download>
    <i class="fa-brands fa-android"></i>
    APK
    <i class="fa-solid fa-download"></i>
</a>

<a class="download-btn ios" href="https://www.youtube.com/@sourcenrogoc" target="_blank">
    <i class="fa-brands fa-apple"></i>
    iOS
    <i class="fa-solid fa-link"></i>
</a>

</div>

<div class="desc-box">
  
<div class="desc-line"><i class="fa-solid fa-medal"></i> DAME GỐC _ KHÔNG MÀU MÈ</div>
<div class="desc-line"><i class="fa-solid fa-trophy"></i> Free MTV _ KHÔNG NẠP VIP</div>
<div class="desc-line"><i class="fa-solid fa-face-kiss-wink-heart"></i> ADMIN CÓ TÂM NHƯNG THIẾU TÀI</div>
</div>

</div>
<div class="feature-wrapper">

<div class="top-bar bxh-bar">
    <button class="top-item rank1" type="button" onclick="return false;" style="border:none; cursor:pointer;">
        <i class="fa-solid fa-key"></i>
        Đổi Pass
    </button>

    <button class="top-item rank2" onclick="location.href='/dang-ky.php'" style="border:none; cursor:pointer;">
        <i class="fa-solid fa-user-plus"></i>
        Đăng Ký
    </button>
</div>

<div class="register-box">
    <div class="quantum-login-wrapper">
        <a href="/dang-nhap.php" class="register-btn login-special">
            <i class="fa-solid fa-right-to-bracket"></i>
            Đăng Nhập
        </a>
    </div>
</div>

<div class="top-bar">

<div class="top-item stat">
<i class="fa-solid fa-users"></i>
Hôm nay: <b id="today">0</b>
</div>

<div class="top-item stat">
<i class="fa-solid fa-clock-rotate-left"></i>
Hôm qua: <b id="yesterday">0</b>
</div>

</div>

<div class="zalo-box" style="flex-direction: column; gap: 12px; align-items: center;">
   
    <a class="zalo-btn" href="https://zalo.me/g/hfaysi616" target="_blank">
        <i class="fa-solid fa-comments"></i>
        Tham Gia Nhóm Zalo
    </a>
</div>

</div>
<div class="giftcode-section">

<div class="giftcode-title">
<i class="fa-solid fa-star"></i> 5 Điều Bác Hồ Dạy
</div>

<ul class="bacday-list">
<li><i class="fa-solid fa-flag"></i> Yêu Tổ quốc, yêu đồng bào</li>
<li><i class="fa-solid fa-book"></i> Học tập tốt, lao động tốt</li>
<li><i class="fa-solid fa-people-group"></i> Đoàn kết tốt, kỷ luật tốt</li>
<li><i class="fa-solid fa-broom"></i> Giữ gìn vệ sinh thật tốt</li>
<li><i class="fa-solid fa-shield-heart"></i> Khiêm tốn, thật thà, dũng cảm</li>
</ul>

</div>

<div class="security-section">

<div class="security-title-box">
<div class="security-title">🔐 MÃ HÓA CHUẨN QUÂN ĐỘI</div>
</div>

<div class="security-grid">

<div class="security-item"><i class="fa-solid fa-lock"></i> HTTPS SSL<br>256-bit</div>
<div class="security-item"><i class="fa-solid fa-shield-halved"></i> Anti DDoS<br>Shield</div>
<div class="security-item"><i class="fa-solid fa-fire"></i> Firewall<br>Protection</div>
<div class="security-item"><i class="fa-solid fa-chart-line"></i> Real-time<br>Monitoring</div>

</div>

</div>

<div class="footer-section">
    <a style="color:#9ca3af; text-decoration:none; cursor:default; pointer-events:none;">
        @dotiendat
    </a>
</div>

</div>

<script>

fetch("counter.php")
.then(r=>r.json())
.then(d=>{
if(d){
today.textContent=d.today||0
yesterday.textContent=d.yesterday||0
}
})
.catch(()=>{});

</script>
<div class="popup-bg" id="registerPopup">

<div class="popup-box">

<div class="close-btn" onclick="closeRegister()">✖</div>

<h2 style="text-align:center;margin-bottom:15px;">
<i class="fa-solid fa-pen-to-square"></i> Đăng Ký
</h2>

<form id="registerForm" class="form-box">

<input type="text" name="username" placeholder="Tên tài khoản (4-12 ký tự)" required>

<input type="password" name="password" placeholder="Mật khẩu (>=6 ký tự)" required>

<div class="rules-box">

<div class="rule-top">
<div><i class="fa-solid fa-heart-crack"></i>, Không tà dâm</div>
<div><i class="fa-solid fa-comment-slash"></i>, Không nói dối</div>
</div>

<label class="rules-check">
<input type="checkbox" name="rules" id="ruleCheck" onclick="toggleRules()">
Tôi Đồng Tính
</label>

<div class="rule-more" id="ruleMore">
<div><i class="fa-solid fa-dove"></i>, Không sát sinh</div>
<div><i class="fa-solid fa-lock"></i>, Không trộm cắp</div>
<div><i class="fa-solid fa-handshake"></i>, Không khinh ngữ</div>
</div>


</div>
<button class="submit-btn" id="registerBtn" disabled>
Đăng ký Ngay
</button>

<div id="notify" class="notify"></div>

</form>

</div>
</div>
<div class="popup-bg" id="changePassPopup">

<div class="popup-box">

<div class="close-btn" onclick="closeChangePass()">✖</div>

<h2 style="text-align:center;">
<i class="fa-solid fa-key"></i> Đổi Mật Khẩu
</h2>

<form id="changePassForm" class="form-box">

<input type="text" name="username" placeholder="Tên tài khoản" required>

<input type="password" name="oldpass" placeholder="Mật khẩu cũ" required>
<input type="password" name="newpass" placeholder="Mật khẩu mới (>=6 ký tự)" required>

<div class="captcha-box">
<img id="captchaChangePass" src="captcha.php" onclick="this.src='captcha.php?'+Date.now()">
<input type="text" name="captcha" placeholder="Nhập captcha" required>
</div>

<button class="submit-btn">Đổi mật khẩu</button>

<div id="notifyChange" class="notify"></div>

</form>

</div>
</div>
<script>

function showNotify(message,type){

let box=document.getElementById("notify");

box.textContent=message;
box.className="notify "+type+" show";

setTimeout(()=>{
box.classList.remove("show");
},3000);

}

</script>
<script>

function openRegister(){
    document.getElementById("registerPopup").style.display="flex";
}
function closeRegister(){
document.getElementById("registerPopup").style.display="none";
}
function toggleRules(){

let check=document.getElementById("ruleCheck");
let more=document.getElementById("ruleMore");

if(check.checked){
more.style.display="flex";
}else{
more.style.display="none";
}

}
</script>
<script>

function openChangePass(){
    return false;
}

function closeChangePass(){
document.getElementById("changePassPopup").style.display="none";
}

function showNotifyChange(msg,type){
let box=document.getElementById("notifyChange");
box.textContent=msg;
box.className="notify "+type+" show";
setTimeout(()=>box.classList.remove("show"),3000);
}

document.getElementById("changePassForm").addEventListener("submit", function(e){
e.preventDefault();

const formData = new FormData(this);
const oldpass = formData.get("oldpass");
const newpass = formData.get("newpass");

if(oldpass === newpass){
    showNotifyChange("⚠ Mật khẩu mới phải khác mật khẩu cũ","error");
    return;
}
fetch("doimatkhau.php",{
method:"POST",
body:formData
})
.then(res=>res.json())
.then(data=>{document.getElementById("captchaChangePass").src = "captcha.php?" + Date.now();
if(data.status==="success"){
showNotifyChange("✅ Đổi mật khẩu thành công","success");
this.reset();
setTimeout(()=>closeChangePass(),1500);
}else{
showNotifyChange(data.message || "Lỗi","error");
}
})
.catch(()=>{
showNotifyChange("⚠ Lỗi kết nối","error");
});
});

</script>
<script>

const registerForm = document.getElementById("registerForm");

const username = registerForm.querySelector('input[name="username"]');
const password = registerForm.querySelector('input[name="password"]');
const rules = document.getElementById("ruleCheck");
const btn = document.getElementById("registerBtn");

function checkForm(){
    if(
        username.value.length >= 4 &&
        password.value.length >= 6 &&
        rules.checked
    ){
        btn.disabled = false;
    }else{
        btn.disabled = true;
    }
}

/* 🔥 debounce chống lag */
let t;
function debounceCheck(){
    clearTimeout(t);
    t = setTimeout(checkForm, 120);
}

username.addEventListener("input",debounceCheck);
password.addEventListener("input",debounceCheck);
rules.addEventListener("change",checkForm);
</script>
<script>

// ===== ANTI SPAM CLICK =====
let lastClick = 0;

function canClick(){
    let now = Date.now();
    if(now - lastClick < 2000){ // 2s mới cho submit
        showNotify("⚠ Thao tác quá nhanh","error");
        return false;
    }
    lastClick = now;
    return true;
}

// ===== SIMPLE TOKEN =====
function generateToken(){
    return btoa(navigator.userAgent + "|" + Date.now());
}

// ===== FINGERPRINT (basic) =====
function getFingerprint(){
    return btoa(
        navigator.userAgent +
        screen.width +
        screen.height +
        navigator.language
    );
}

</script>

<script>
document.getElementById("registerForm").addEventListener("submit", function(e){
    e.preventDefault();

    if(!canClick()) return;

    btn.disabled = true; // 🔥 khóa nút chống spam

    const formData = new FormData(this);

    formData.append("token", generateToken());
    formData.append("fp", getFingerprint());

    fetch("dangky.php", {
        method: "POST",
        body: formData
    })
    .then(res => res.text())
    .then(text => {

        btn.disabled = false; // 🔥 mở lại

        console.log("RESPONSE:", text);

        let data;
        try{
            data = JSON.parse(text);
        }catch(e){
            showNotify("⚠ Sai Database", "error");
            return;
        }

        if(data.status === "success"){

            showNotify("🎉 Đăng ký thành công!", "success");

            document.getElementById("registerForm").reset();
            btn.disabled = true;

            document.getElementById("ruleMore").style.display = "none";
            document.getElementById("ruleCheck").checked = false;

            setTimeout(() => { closeRegister(); }, 1500);

        }else{
            showNotify(data.message || "Đăng ký thất bại", "error");

            document.getElementById("ruleMore").style.display = "none";
            document.getElementById("ruleCheck").checked = false;
        }

    })
    .catch(err => {

        btn.disabled = false; // 🔥 tránh bị khóa luôn

        console.log("FETCH ERROR:", err);
        showNotify("⚠ Không kết nối được Database", "error");
    });
});

</script>
</body>
</html>
