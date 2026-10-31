# Boss rơi đồ – NRO Teamobi2026

Tổng hợp từ hàm `reward()` trong `Teamobi2026/src/nro/models/boss/**` (đọc ngày 28/10/2026, cập nhật 30/10/2026).
Tên item tra từ bảng `team10_long.item_template`. Nếu đã sửa code boss thì đọc lại file tương ứng để cập nhật.

Ghi chú chung:
- Đồ rơi thuộc về người kết liễu (`plKill.id`), trừ Khí Gas (ai nhặt cũng được).
- Hầu hết boss cộng thêm +5 điểm sự kiện (không ghi lại bên dưới).
- `Util.isTrue(a, b)` = tỉ lệ a/b.

## 1. Boss thường (Android, Cell, Fide, Nappa, Tiểu đội sát thủ TĐ)
Android 13/14/15/19, Dr.Kore, King Kong, Pic, Poc, Xên con 1–7, Xên bọ hung, Fide, Kuku, Mập đầu đinh, Rambo, Số 1–4, Tiểu đội trưởng.
- 100%: 20.000–30.000 vàng (id 190)
- 80%: 1 viên Ngọc rồng 5/6/7 sao (id 18/19/20)

## 2. Boss lớn
| Boss | Vàng 20–30k | Đồ Thần Linh | Đồ Goku + sao pha lê | Ngọc rồng (x1–3) | Thêm |
|---|---|---|---|---|---|
| Baby | 100% | 10% | 5% | 10% (2–7 sao + Nhẫn thời không 992) | 1%: CT Baby/Vegeta Baby/Baby khỉ (1785/1786/1788) |
| Black Goku, Cumber | 100% | 5% | 5% | 10% (2–7 sao + 992) | – |
| Cooler | 100% | 5% | 5% | 80% (2–7 sao) | – |
| Siêu bọ hung | 100% | 5% | 30% | 80% (2–7 sao) | – |
| Mabu 12h (Bui Bui 1/2, Cadic, Drabura 1/2/3, Goku, Yacon, Mabu) | 100% | 1% | 1% | 10% (2–7 sao) | điểm Mabu +10 (Drabura3 +20, Mabu +25) |

- Đồ Thần Linh (`ItemService.randDoTLBoss`, id 555–567): tỉ lệ thực tế Nhẫn 10%, Găng 22,5%, Quần 30,4%, Áo 27,8%, Giày 9,3%; chỉ số ×100–115%. (Comment trong code ghi sai tỉ lệ.)
- Đồ Goku (id 230–280): 70% Áo/Quần/Giày, 30% Găng/Rada; chỉ số shop ×100–115%; sao pha lê 1–3 (80%), 4–5 (17%), 6 (3%).

## 3. Doanh trại
| Boss | NR 4 hoặc 5 sao (17/18, mỗi loại 50%) | Bản đồ kho báu (611) | Cậu Vàng (1824) |
|---|---|---|---|
| Trung úy Trắng | 50% | – | 100% |
| Trung úy Thép | 50% | 30% (x1–2) | 100% |
| Trung úy Xanh Lơ | 50% | 100% (x1–3) | 100% |
| Ninja áo tím | 50% | 30% (x1–2) | 100% |
| Robot vệ sĩ | 30% | – | 100% |
| Ninja clone | 10% | – | – |

Trung úy Xanh Lơ (Bản đồ kho báu): 100% Bí ngô 4 sao (705).

## 4. Boss mini
- Ăn Trộm: chỉ khi đã trộm vàng → trả 80% vàng đã trộm + 100% Hộp quà Goku Day (1591, 1594).
- Ô Đô, Sói Hẹc Quyn, Virut: 100% 2 Hộp quà Goku Day (1591 + 1594).
- Mặt Trời: 50% Mặt trời tí hon (1562, +7–10% HP/KI/SĐ, HSD 2–5 ngày).
- Rồng Nhí: 20% có rơi → 4% Trứng vàng rồng nhí (1821), 16% NR 5/6/7 sao.
- Mabư ngoài map (`Mabu_ngoai/MabuNgoai.java`, 2 con, hồi sinh 15 phút): 20% Quả Trứng (568, trứng đệ tử Mabư).
- **Đang tạm tắt** (`Hirudegarn.DISABLED = true`, luôn chết, không rơi gì). Hirudegarn (quái to, `mob_bigboss/Hirudegarn.java`, map 126 Thành phố Santa, mỗi khu 1 con, 3 mạng, hồi sinh 10 phút): mỗi lần mất mạng rơi 30 đống vàng × 32.000, 20% Quả Trứng (568), 20% Bình hút năng lượng (1795), 1/40 Áo/Quần/Găng Thần Linh (555/557/559). Ai nhặt cũng được.

## 5. Golden Frieza + Death Beam 1–5
- 100% Cải trang Fide vàng (629, +20% HP/KI/SĐ, HSD 20 ngày).

## 6. Boss rơi ngọc kèm cải trang
| Boss | Ngọc (id 77) | 100% |
|---|---|---|
| Bujin/Kogu/Zangya/Bido/Bojack | 7–9 cục × 5–20 | CT id 423/424/425/426/427 + NR 6 sao + NR 7 sao |
| Super Bojack | 7–9 cục × 5–15 | CT 428 + NR 6s + NR 7s |
| TĐST Namek: Số 4/3/2/1, Đội trưởng | 7–9 cục × 1–5 | CT 429/430/431/432/433 + NR 6s + NR 7s |

(DB chỉ ghi tên "Cải trang"; ứng với boss nào là suy theo code.)

## 7. Phó bản / sự kiện
- Hatchiyack / Dr Lychee (Khí Gas): CT Hatchiyack (729) / CT Dr Lychee (738), số lượng 1 + 2×số người trong khu, ai nhặt cũng được; chỉ số theo level Khí Gas → chi tiết mục 7a.

### 7a. Khí Gas Hủy Diệt – boss và phần thưởng (`boss/khi_gas/DrLychee.java`, `Hatchiyack.java`)
Cơ chế phó bản: mục "Khí Gas Hủy Diệt" trong [CO-CHE.md](CO-CHE.md). Lv = cấp độ chọn lúc mở (1–110). Số máu/sát thương dưới đây là gốc; đang thử nghiệm chia 20 (`DestronGas.GIAM`, [GIA-TRI-GOC.md](GIA-TRI-GOC.md)). Phần thưởng không đổi.
- Dr Lychee (ngoại hình 742/743/744): sát thương 10.000 + 1.000×Lv, máu 1 triệu + 15 triệu×Lv (gốc ở `DestronGas.update()`, phần +10.000/+1 triệu ở constructor DrLychee). Né "Xí hụt" Lv/1000, giảm sát thương nhận (Lv/10)% và trừ thêm ngẫu nhiên 0–100×Lv.
- Hatchiyack (639/640/641, tên trống): hiện khi Dr Lychee rời map, ×1,5 sát thương (tối đa 200 triệu) và ×1,5 máu (tối đa 2 tỷ) của Dr Lychee (`DrLychee.leaveMap()`). Né (Lv+10)/1000, giảm (Lv/5)% và trừ thêm 0–200×Lv. Chết → 60 giây sau đưa về làng Aru.
- Cả 2: chiêu Demon cấp 1–7; đòn xuyên giáp không bị né và phá khiên; đang khiên thì đòn thường = 1; người cầm NR Namek đánh = 1.
- Cải trang rơi (`dropCt()`): P = 14 nếu Lv < 10, còn lại 14 + Lv/10. Sức đánh/HP/KI mỗi cái +(P+8 đến P+11)%; Dr Lychee thêm giảm sát thương nhận +(P đến P+3)% (option 94, cộng vào tlGiap, bị xuyên giáp trừ), Hatchiyack thêm sát thương chí mạng +(P đến P+3)% (option 5, không phải tỉ lệ chí mạng option 14); HSD 3–P ngày (tối đa 21); không giao dịch. Số lượng 1 + 2×số người trong khu, mỗi boss rơi riêng.

| Lv | Dr Lychee sát thương / máu | Hatchiyack sát thương / máu | SĐ/HP/KI | Giảm ST nhận (738) / ST chí mạng (729) | HSD (ngày) |
|---|---|---|---|---|---|
| 1 | 11.000 / 16 triệu | 16.500 / 24 triệu | 22–25% | 14–17% | 3–14 |
| 10 | 20.000 / 151 triệu | 30.000 / 226,5 triệu | 23–26% | 15–18% | 3–15 |
| 50 | 60.000 / 751 triệu | 90.000 / 1,1265 tỷ | 27–30% | 19–22% | 3–19 |
| 100 | 110.000 / 1,501 tỷ | 165.000 / 2 tỷ (trần) | 32–35% | 24–27% | 3–21 |
| 110 | 120.000 / 1,651 tỷ | 180.000 / 2 tỷ (trần) | 33–36% | 25–28% | 3–21 |

Ngoài cải trang: không có quà khác; kết thúc lưu thành tích bang (cấp cao nhất, thời gian nhanh nhất → Top Khí Gas), xong cấp ≥ 70 thì +1 `destronGas70CompletionCount` cho người chơi.
- Yardrat: Bí kiếp (590) – Tập sự 1/5, Tân binh 1/4, Chiến binh 1/3, Đội trưởng 5 1/2, còn lại 1/5.
- Bí Ma, Dơi, Ma Trơi (Halloween): 100% Bí ngô (585).
- Khỉ Đột (Trung thu): 100% Đuôi khỉ (1045).
- Sơn Tinh / Thủy Tinh: CT 421 / 422 (+15–20% chỉ số, HSD 1–15 ngày; Sơn Tinh 1/15 có thêm option 116).
- Nguyệt Thần / Nhật Thần: code rơi item 2123/2124 nhưng DB không có → có thể lỗi/không rơi.
- Nhân Bản: 100% Bình chứa Commeson (638, HSD 30).

## 8. Không rơi đồ
Broly thường, Super Broly (chỉ tặng đệ tử nếu chưa có), Mabu 14h, Super Bu, Pocolo, Ông già Noel, Lân con, và mọi boss không override `reward()`.

## Tỉ lệ né của boss (dò 31/10/2026)

- Boss né đòn theo 2 cách trong `injured()`:
  - Chung: `Util.isTrue(this.nPoint.tlNeDon, 1000)` (Boss, Baby, Broly, SuperBroly, Cumber, XenBoHung, SieuBoHung, RobotVeSi, MabuNgoai, Drabura3, SonTinh, ThuyTinh, NhatThan, NguyetThan, KhiDot, GoldenFrieza, BlackGoku, SAIBAMEN, CADICH). Cadic, Goku, TaoPaiPai dùng `isTrue(tlNeDon, 1)`.
  - Riêng: DrLychee `isTrue(level, 1000)`, Hatchiyack `isTrue(level + 10, 1000)`.
- `nPoint.tlNeDon` chỉ được cộng từ option 108/111 (NPoint `calPoint`, option danh hiệu, vật phẩm, đá đen R7S) và bị reset về 0 khi tính lại. Code boss không gán giá trị nào cho `tlNeDon`, nên boss dùng `tlNeDon` hiện tại né 0% (trừ khi sau này có gán).
- Dr Lychee: né Lv/1000. Hatchiyack: né (Lv+10)/1000.
