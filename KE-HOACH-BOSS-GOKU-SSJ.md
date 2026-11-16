# Kế hoạch: Boss Goku SSJ 1/2/3 ở map Cold

Trạng thái: **đã làm 16/11/2026** (THAY-DOI mục 67, rơi đồ BOSS-ROI-DO.md mục 3c) (viết 16/11/2026). Tài liệu nội bộ, không đưa tỉ lệ/HP/cơ chế ra game hay web.

## Yêu cầu user

- 3 boss riêng: **Goku SSJ**, **Goku SSJ2**, **Goku SSJ3**. Mỗi con 1 mạng (không đổi dạng), sống độc lập.
- Mỗi lần xuất hiện, 3 con ở 3 map Cold **khác nhau**, ngẫu nhiên trong 105–110; số khu có thể trùng.
- HP 3 tỷ, sức đánh 250.000.
- Chiêu: đấm + chưởng của cả 3 hành tinh cấp 7, Tái tạo năng lượng cấp 7, Khiên năng lượng cấp 1.
- Chết 30 phút thì hồi sinh (mỗi con tính riêng).
- Mỗi lần chết rơi **đúng 1 món** cho người giết (tổng 100%):

| Tỉ lệ | Đồ |
|---|---|
| 2% | 1 món đồ Thần Linh (`ItemService.randDoTLBoss`) |
| 25% | Hộp quà giáng sinh (648) |
| 20% | Ngọc rồng 2 sao (15) |
| 10% | Ngọc rồng 3 sao (16) |
| 28% | 2–10 Thỏi vàng (457) |
| 15% | Cải trang cùng tên boss (bảng dưới) |

## Đã dò

- **Hình**: đủ ảnh x2/x3/x4 (ANH.md mục "Hình boss / cải trang SSJ"). Outfit `{head, body, leg}`:
  - Goku SSJ: `{1454, 1450, 1451}` → cải trang 1589 CT Goku SSJ
  - Goku SSJ2: `{1455, 1450, 1451}` → cải trang 1595 CT Goku SSJ2
  - Goku SSJ3: `{1449, 1450, 1451}` → cải trang 1587 CT Goku SSJ3
  - Không cần sửa client, không cần thêm ảnh.
- **Map Cold** 105 Cánh đồng tuyết, 106 Rừng tuyết, 107 Núi tuyết, 108 Dòng sông băng, 109 Rừng băng, 110 Hang băng (Cooler đang ở 110).
- **Chọn map**: `Boss.getMapJoin()` lấy ngẫu nhiên từ `mapJoin`, 3 con độc lập sẽ có lúc trùng map. Cần override `getMapJoin()` ở lớp boss mới: bỏ các map mà con SSJ khác còn sống đang đứng.
- **Boss mẫu**: `boss/Cold/Cooler.java` (reward, injured, autoLeaveMap "Không tự rời map"), khai báo `BossesData`, `BossID`, tạo trong `BossManager.loadBoss` (dòng ~339 `new Cooler()`). Hồi sinh qua `secondsRest` = 1800.
- **Chiêu** (`Skill.*`, cấp 7): DRAGON, DEMON, GALICK (đấm), KAMEJOKO, MASENKO, ANTOMIC (chưởng), TAI_TAO_NANG_LUONG 7, KHIEN_NANG_LUONG 1.
- **Cải trang Hit** (`RewardService.createCaiTrangHit`): 0,5% jackpot vĩnh viễn + chỉ số đẹp nhất, 5% vĩnh viễn, còn lại có hạn.
- **Chỉ số ẩn** = option `210` "# Dòng chỉ số ẩn" (`InventoryService.handleOption210`): lúc **mặc vào** mới lộ ra N dòng ngẫu nhiên không trùng nhau, lấy từ `{8, 14, 108 (ghi 2 lần nên ra nhiều hơn), 94, 16, 80, 81, 97, 100, 101, 104}` (bỏ 106 THAY-DOI 74), thêm 16/11/2026 (THAY-DOI 75) `50, 77, 103, 5, 96, 251, 175, 252, 19`. Giá trị: 8, 14, 108, 94, 77, 103, 252 ra 3–5; 50, 96, 251 ra 5–10; 5 ra 5–15; 16, 80, 81, 97, 100, 101, 104, 175, 19 ra 10–25.
- Option có sẵn: `50` sức đánh %, `5` sức đánh chí mạng %, `106` không ảnh hưởng bởi cái lạnh, `148` +#% tốc độ chạy, `93` hạn sử dụng (ngày), `154` không bán lại.
- **Chưa có option "% sát thương Laze / Bom / Quả cầu kênh khi"** trong `item_option_template`. Chỉ có option set 5 món (140, 141…), không dùng được cho 1 cải trang. Cũng không có option "% chiêu đặc biệt" chung. Gần nhất là `216` "Tuyệt kỹ +#% sát thương", `214` "Phạm vi tuyệt kỹ +#%", `181` "Dịch chuyển tức thời +#% sát thương", nhưng **không code nào đọc 3 option này** (216/214 chỉ được gán ngẫu nhiên khi giám định sách, `GiamDinhSach.java:74`): hiện chữ trên đồ mà không có tác dụng.

- **Giới hạn số option**: `ItemData` gửi số option bằng `writeByte` (đang 251, id 0–250, client đọc không dấu). `ItemService` lấy option theo `ITEM_OPTION_TEMPLATES.get(id)` nên id phải liền nhau. Chỉ thêm được tới id **254**; quá nữa phải sửa client.

## Đã chốt

- 16/11/2026: tạo **1 option chung id 251 "+#% sát thương chiêu đặc biệt"**, cộng vào sát thương Laze (`Skill.MAKANKOSAPPO`), Bom (`Skill.TU_SAT`), Quả cầu kênh khi (`Skill.QUA_CAU_KENH_KHI`). SQL `INSERT INTO item_option_template (id, NAME) VALUES (251, '+#% sát thương chiêu đặc biệt');`, tăng `DataGame.vsItem` (client tự tải lại option, không sửa client). Ghi mục THAY-DOI khi làm.
- Dòng 10–30% của cải trang: ngẫu nhiên giữa `5` sức đánh chí mạng và `251` chiêu đặc biệt.
- Jackpot: **0,075%** (75/100.000) vĩnh viễn + chỉ số trần (SĐ 68–70%, dòng chí mạng/chiêu đặc biệt 28–30%); **3%** vĩnh viễn chỉ số ngẫu nhiên như thường; 96,925% còn lại hạn 1–3 ngày.
- Mỗi boss rơi cải trang đúng tên mình (SSJ → 1589, SSJ2 → 1595, SSJ3 → 1587).
- Thông báo giữ mẫu `BOSS <tên> vừa xuất hiện tại <map>`. Câu chat do Claude viết, giọng tự nhiên kiểu game (không văn AI), làm xong chỉ chỗ sửa cho user (`BossesData` mục GOKU_SSJ*).

## Cách làm

1. `BossID`: thêm `GOKU_SSJ`, `GOKU_SSJ2`, `GOKU_SSJ3` (số âm chưa dùng).
2. `BossesData`: 3 `BossData` (tên, gender Xayda, outfit trên, dame 250000, hp `{3_000_000_000L}`, mapJoin `{105..110}`, chiêu trên, câu chat, `secondsRest` 1800).
3. Lớp mới `boss/Cold/GokuSSJ.java` (một lớp, nhận dạng 1/2/3 qua tham số):
   - `getMapJoin()`: chọn map trong 105–110 chưa có con SSJ khác còn sống; khu ngẫu nhiên.
   - `reward()`: quay 1–100 theo bảng tỉ lệ, rơi 1 món cho `plKill.id`.
   - `autoLeaveMap()`: không tự rời map (giống Cooler).
   - Không giới hạn sát thương mỗi đòn, không né (user không yêu cầu).
4. Hàm tạo cải trang trong `RewardService` (ví dụ `createCaiTrangGokuSSJ(int itemId)`), cạnh `createCaiTrangHit`:
   - Sức đánh `50`: 40–70%.
   - `106` Không ảnh hưởng bởi cái lạnh.
   - Một dòng ngẫu nhiên 10–30%: sức đánh chí mạng (`5`) hoặc Laze / Bom / QCKK (xem mục cần chốt 1).
   - Tốc độ chạy `148`: 5–10%.
   - `210` chỉ số ẩn: 4–5 dòng.
   - `154` không bán lại; `93` hạn 1–3 ngày, trừ khi trúng jackpot.
5. `BossManager.loadBoss`: tạo 3 con.
6. Cập nhật BOSS-ROI-DO.md (bảng rơi), CLAUDE.md (dòng trỏ), TINH-NANG.md, THAY-DOI.md (nếu có SQL), build.

## Cần chốt

1. ~~Laze / Bom / QCKK chưa có option~~ → đã chốt option chung 251 (mục "Đã chốt").
2. ~~Jackpot~~ → đã chốt (mục "Đã chốt").
3. Mỗi con rơi cải trang **đúng tên mình** (SSJ → 1589, SSJ2 → 1595, SSJ3 → 1587)?
4. ~~Câu chat~~ → Claude viết, chỉ chỗ sửa cho user.
5. Có cần chốt version mới (v4) sau khi làm xong không?
