# Boss rơi đồ – NRO Teamobi2026

Tổng hợp từ hàm `reward()` trong `Teamobi2026/src/nro/models/boss/**` (đọc ngày 28/10/2026).
Tên item tra từ bảng `team10.item_template`. Nếu đã sửa code boss thì đọc lại file tương ứng để cập nhật.

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
| Boss | NR 4 sao (17) | Bản đồ kho báu (611) | Cậu Vàng (1824) |
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
- Hatchiyack / Dr Lychee (Khí Gas): CT Hatchiyack (729) / CT Dr Lychee (738), số lượng 1 + 2×số người trong khu, ai nhặt cũng được; chỉ số theo level Khí Gas.
- Yardrat: Bí kiếp (590) – Tập sự 1/5, Tân binh 1/4, Chiến binh 1/3, Đội trưởng 5 1/2, còn lại 1/5.
- Bí Ma, Dơi, Ma Trơi (Halloween): 100% Bí ngô (585).
- Khỉ Đột (Trung thu): 100% Đuôi khỉ (1045).
- Sơn Tinh / Thủy Tinh: CT 421 / 422 (+15–20% chỉ số, HSD 1–15 ngày; Sơn Tinh 1/15 có thêm option 116).
- Nguyệt Thần / Nhật Thần: code rơi item 2123/2124 nhưng DB không có → có thể lỗi/không rơi.
- Nhân Bản: 100% Bình chứa Commeson (638, HSD 30).

## 8. Không rơi đồ
Super Broly (chỉ tặng đệ tử nếu chưa có), Mabu 14h, Super Bu, Pocolo, Ông già Noel, Lân con, và mọi boss không override `reward()`.
