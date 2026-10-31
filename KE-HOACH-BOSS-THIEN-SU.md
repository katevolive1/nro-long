# Kế hoạch: boss Thiên Sứ + boss Hủy Diệt (ĐÃ LÀM 31/10/2026)

Đã code theo mục "Đã chốt". 2 điểm user chưa chốt dùng mặc định: Whis bản NPC (505), Beerus bản Hủy Diệt (1983), sức đánh 100.000 mỗi con (đổi ở `HuyDiet.DAME`, hình ở `HuyDiet.data`/`ThienSu.data`). Kết quả: BOSS-ROI-DO.md mục 3b, THAY-DOI.md mục 30.

Lập 31/10/2026. User duyệt / sửa các mục "Cần chốt" rồi mới code.

## Đã dò

**Hình boss (đều có đủ ảnh trong `data/icon/x2..x4`, client đã có sẵn):**

| Nhân vật | head / body / leg | Ghi chú |
|---|---|---|
| Whis (thiên sứ) | 505 / 506 / 507 | NPC Whis 56 |
| Whis (bản khác) | 838 / 839 / 840 | đang dùng cho boss luyện tập `BossesData.WHIS` |
| Vados (thiên sứ) | 530 / 531 / 532 | NPC Vados 58 |
| Bill / Beerus (hủy diệt) | 508 / 509 / 510 | NPC Bill 55 |
| Beerus Hủy Diệt | 1983 / 1986 / 1987 | cải trang 1999 |
| Champa (hủy diệt) | 511 / 512 / 513 | NPC Champa 57 |
| Bill Bí Ngô | 754 / 755 / 756 | cải trang 739 |

Đề xuất 2 cặp: **Whis + Beerus** và **Vados + Champa** (đúng cặp trong truyện).

**Gamma**: không có. Không có boss, NPC, cải trang hay vật phẩm nào tên Gamma (đã tìm trong `BossesData`, `BossID`, `item_template`, `npc_template`).

**Map vách núi**: 42 Vách núi Aru (sau Làng Aru 0), 43 Vách núi Moori (sau Làng Mori 7), 44 Vách núi Kakarot (sau Làng Kakarot 14). Cả 3 chỉ có cổng bên phải về làng, mép trái đang trống. (39/40 cũng tên Vách núi nhưng là map sau nhà Gôhan/Moori, không phải sau làng.)

**Map mới làm được ở server**: client nhận dữ liệu vẽ map từ server (`DataGame.sendMapTemp`, file `data/map/tile_map_data/<id>`) và danh sách tên map (`DataGame.updateMap`, tăng `vsMap` để client tải lại). Map lớn nhất hiện là 185 → 3 map mới 186, 187, 188. Không cần sửa `GameAssembly.dll`.

## Kế hoạch làm

1. **3 map mới** (186 TĐ, 187 Namếc, 188 Xayda): thêm dòng `map_template` (chép từ 42/43/44: tileset, nền, 10 khu, không quái, không NPC), chép `tile_map_data/42..44` sang `186..188`. Thêm cổng mép trái 42/43/44 → map mới, và cổng mép phải map mới → về vách núi. Tăng `DataGame.vsMap`.
2. **Boss** (`boss/thien_su/`): 4 lớp `Whis`/`Beerus`/`Vados`/`Champa` (tên tạm), `BossesData` + `BossID` mới. Mỗi hành tinh tạo 2 cặp trong `BossManager.loadBoss` (tổng 12 con). Thiên sứ và hủy diệt cùng cặp xuất hiện cùng map, cùng khu; 2 cặp được phép vào cùng 1 khu.
3. **Thiên sứ hồi máu cho hủy diệt cùng cặp**: trong `update()` của thiên sứ, mỗi 10 giây nếu hủy diệt còn sống và cùng khu thì hồi 10% HP tối đa (gói hồi máu như `PlayerService.hoiPhuc`). Còn lại đánh như boss thường. Hồi sinh theo cặp: lớp quản lý cặp đếm 10 phút khi cả 2 con đã chết rồi cho cả cặp vào lại map (khu ngẫu nhiên).
4. **Rơi đồ** (`reward()` dùng chung cho cả 2 con): xem mục "Đã chốt".
5. Thông báo dùng đúng câu `BOSS <tên> vừa xuất hiện tại <tên map>` (để mod client nhận). Cập nhật `BOSS-ROI-DO.md`, `ID-GAME.md` (map mới), `THAY-DOI.md` (SQL + build).

Ảnh ghép thử dáng đứng 6 bộ hình: [ke-hoach-boss-thien-su.png](ke-hoach-boss-thien-su.png) (ghép từ khung 0 của head/body/leg, vị trí gần đúng; Bill/Champa NPC là dáng ngồi bay nên không thấy chân). Xem trong game: NPC Whis + Bill ở map 48 Hành tinh Kaio (lệnh `m48`), boss Whis luyện tập gọi ở NPC Whis, cải trang Beerus Hủy Diệt `i 1999 1`. Map mới chép hình từ Vách núi nên trông y hệt map 42/43/44 (`m42`, `m43`, `m44`).

## Đã chốt (31/10/2026)

1. 2 cặp mỗi hành tinh: **Whis + Beerus** và **Vados + Champa** (6 cặp, 12 boss). Khu ngẫu nhiên, 2 cặp có thể vào cùng khu.
2. Rơi đồ (**cả 2 con** đều rơi): 40% 1 món Hủy Diệt (650–662) theo hành tinh người giết, **như đồ Hủy Diệt mua ở shop Bill** (chỉ số gốc cộng ngẫu nhiên 0–15%, yêu cầu 60 tỷ sức mạnh `21:60`, không giao dịch `30`); 20% Ngọc rồng 2 sao hoặc 3 sao; 20% 1 trong Cuồng nộ 2 / Bổ huyết 2 / Bổ khí 2 / Giáp Xên 2 (1150–1153), số lượng ngẫu nhiên 1–5; **20% còn lại không rơi gì**.
3. Thiên sứ hồi cho hủy diệt cùng cặp **10% HP tối đa mỗi 10 giây** (hủy diệt còn sống, cùng khu).
4. HP **2 tỷ mỗi con**, **không giới hạn sát thương mỗi đòn**.
5. Hồi sinh: xuất hiện **cả cặp**; phải **chết cả 2 con** mới bắt đầu đếm **10 phút** rồi cặp đó xuất hiện lại.
6. Map mới tên **"Trạm hủy diệt"**, không có quái thường.

## Hình map mới (user 31/10/2026)

User muốn map rừng cây xanh, nền cỏ phẳng như ảnh mẫu (nghĩ là map bên Rừng Karin). Các map cùng bộ tile rừng Karin (`tile_id` 4, `bg_id` 3): **6 Đông Karin**, **47 Rừng Karin** (có Tháp Karin ở giữa, cổng lên tháp), **111 Đông Nam Karin**, **146 Tây Karin** (`type` 8). Map mới sẽ chép `tile_map_data` + `tile_id`/`bg_id` của map được chọn (thay vì Vách núi), cả 3 hành tinh dùng chung một kiểu. **User chốt: giống Rừng Karin (47).** Chép `tile_map_data/47` + `tile_id` 4, `bg_id` 3, `bg_type` 0 cho cả 3 map mới, không chép cổng lên Tháp Karin (cổng nằm ở DB, không ở file tile). Nếu Tháp Karin vẽ bằng tile/vật trang trí thì map mới cũng có tháp: khi đó đổi sang chép 111 Đông Nam Karin (cùng bộ tile, không tháp) — kiểm tra lúc làm.

## Còn cần chốt

1. **Bộ hình**: Whis dùng bản NPC (505) hay bản boss luyện tập (838)? Beerus dùng bản NPC (508) hay "Beerus Hủy Diệt" (1983)? Vados và Champa chỉ có 1 bản.
2. **Sức đánh** mỗi con (vd Broly / Super Broly / Black Goku đang đánh bao nhiêu thì mình tra cho bạn so sánh).
