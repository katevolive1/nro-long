# Kế hoạch: 3 hộp quà thú cưng / đồ đeo lưng / thú cưỡi

Trạng thái: **chờ duyệt** (31/10/2026). Chưa code. Đã đổi tên 3 item trong DB (1/11/2026, THAY-DOI mục 47).

## Yêu cầu
Mỗi loại 1 hộp: mở ra ngẫu nhiên 1 món thuộc loại đó. Hình: lấy trong tài nguyên có sẵn, không có thì dùng hình hộp cải trang Hit.

## Đã dò
- Hộp Hit 1747 là mẫu: tái dùng item bỏ không, `UseItem` case 1747 → `openHopCaiTrangHit`, tăng `DataGame.vsItem` để client tải lại tên/mô tả (không phải sửa client).
- Item tái dùng (không có code, không có shop, không có trong giftcode): **1135** Capsule World Cup (loại 27) → **Hộp thú cưng**, **1136** Capsule World Cup VIP (loại 27) → **Hộp đồ đeo lưng**, **1397** Rương radar (loại 29, `UseItem` vẫn rẽ theo id) → **Hộp thú cưỡi**. **Không dùng 1453** Rương sao pha lê VIP (user để dành). Đã đổi tên, mô tả, icon 14514, cộng dồn (`is_up_to_up = 1`), `vsItem` 23.
- Hình: không có item hộp nào mang chủ đề thú cưng / thú cưỡi / đeo lưng (đã tìm theo tên). Đề xuất dùng icon **14514** (hộp Hit) cho cả 3.
- Nguồn đồ (bảng `item_template`):
  - **Thú cưng** (loại 27, ô 8): 69 món có code tạo con đi theo trong `Player.sendNewPet` (892 Thỏ xám, 893 Thỏ trắng, 908 Ma phong ba, 1039–1046, 1107, 1114, 1188, 1202–1226, 1243–1256, 1318, 1347, 1414–1458, 1482–1497, 1550–1633, 1654–1771…). Loại 27 còn lẫn đồ ăn, capsule… nên chỉ lấy danh sách này.
  - **Đồ đeo lưng** (loại 11, ô 9): 173 món có hình (`part > 0`), lẫn cờ bang, khăn, lồng đèn, Đứa bé (78, đồ nhiệm vụ)…
  - **Thú cưỡi** (loại 23/24, chỉ sư phụ mặc): 55 món; 346–351 (Cân đẩu vân / Phi Long / Ván bay và bản VIP) theo hành tinh, còn lại dùng chung.
- Xuất xứ (code, shop, giftcode) và chỉ số từng món: bảng ở cuối file (dò 1/11/2026, công cụ `tools/xuat-xu-item/`). Có nguồn: thú cưng 25/69, đồ đeo lưng 66/173, thú cưỡi 22/55; còn lại không tìm thấy cách nào lấy được trong game. Bảng cũ chỉ xét shop nên thiếu (vd Bé Rồng Cute có ở Tori Bot VIP 4 và Trứng vàng rồng nhí).

## Cách làm
1. SQL đổi tên (đã làm, THAY-DOI mục 47).
2. `UseItem`: case 1135 / 1136 / 1397 → hàm mở hộp (cần 1 ô trống, trừ 1 hộp, báo tên món nhận được, hiệu ứng mở như hộp Hit).
3. Danh sách món mỗi hộp để trong code (mảng id), lọc theo hành tinh với món có giới hạn hành tinh.
4. Chỉ số món nhận được: theo điểm chốt bên dưới.
5. Ghi CO-CHE (tỉ lệ chỉ ghi nội bộ).

## Cần chốt
1. **Danh sách món**: lấy hết các món ở trên, hay bạn chọn món (vd chỉ món đang bán trong shop, bỏ cờ bang / khăn / lồng đèn / đồ nhiệm vụ)?
2. **Chỉ số**: (a) giữ chỉ số như bán trong shop (món không bán thì không có chỉ số), (b) ngẫu nhiên kiểu hộp Hit (vd HP/KI/SĐ 5–15%), hay (c) số khác?
3. **Hạn dùng**: vĩnh viễn, hay có hạn (bao nhiêu ngày, có tỉ lệ ra vĩnh viễn không)?
4. **Giao dịch**: món nhận được có khóa giao dịch không?
5. **Nguồn hộp**: hộp lấy ở đâu (shop nào, giá bao nhiêu; hay chỉ admin/giftcode phát)?
6. **Thú cưỡi theo hành tinh** (346–351): ra theo hành tinh người mở, hay bỏ khỏi danh sách?
7. **Cộng dồn**: 3 hộp đã chốt cộng dồn (1/11/2026). Món mở ra là đồ mặc (thú cưng, đeo lưng, thú cưỡi) nên không cộng dồn, trừ khi bạn muốn khác.

## Bảng xuất xứ và chỉ số (dò 1/11/2026)

Nguồn đã quét: code server (mọi chỗ tạo item: `createNewItem`, `new ItemMap`, mảng id, dải `nextInt(a, b)`, kèm chỉ số gán ngay sau), shop (`item_shop`, từng shop riêng), giftcode (`giftcode`). Món có nhiều nguồn thì mỗi nguồn 1 dòng, cột Chỉ số cùng thứ tự với cột Xuất xứ. "Ngẫu nhiên trong mảng N món" = hộp/quà chọn ngẫu nhiên 1 trong N món, trong đó có món này. Khoảng "a–b" = ngẫu nhiên trong khoảng. Chưa quét: quà nhiệm vụ trong DB, client.

Tổng: thú cưng 25/69 món có nguồn, đồ đeo lưng 66/173, thú cưỡi 22/55.

### Thú cưng (ô 8, loại 27, 69 món theo `Player.sendNewPet`)

| ID | Tên | Hành tinh | Xuất xứ | Chỉ số |
|---|---|---|---|---|
| 892 | Thỏ xám | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 893 | Thỏ trắng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 908 | Ma phong ba | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 909 | Thần chết cute | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 910 | Bí ngô nhí nhảnh | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 916 | Lính bảo vệ tam giác | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 917 | Lính bảo vệ vuông | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 918 | Lính bảo vệ tròn | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 919 | Búp bê | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 936 | Tuần lộc nhí | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 942 | Hổ mặp vàng | Chung | KHÔNG RA ĐƯỢC (hàm rewardCapsuleTet không ai gọi) (ngẫu nhiên trong mảng 3 món)<br>Ước Rồng thần Namếc<br>Ước Rồng thần Namếc<br>Ước Rồng thần Namếc | Hạn sử dụng 1–30 ngày; Không thể giao dịch<br>Không thể giao dịch<br>Không thể giao dịch<br>Không thể giao dịch |
| 943 | Hổ mặp trắng | Chung | KHÔNG RA ĐƯỢC (hàm rewardCapsuleTet không ai gọi) (ngẫu nhiên trong mảng 3 món) | Hạn sử dụng 1–30 ngày; Không thể giao dịch |
| 944 | Hổ mặp xanh | Chung | KHÔNG RA ĐƯỢC (hàm rewardCapsuleTet không ai gọi) (ngẫu nhiên trong mảng 3 món) | Hạn sử dụng 1–30 ngày; Không thể giao dịch |
| 967 | Sao la | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1008 | Cua đỏ | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1039 | Pet Thỏ ốm | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1040 | Pet Thỏ mập | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1046 | Pet Khỉ Bong Bóng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1107 | Pet Bí Ma Vương | Chung | Shop Quy Lão Kame (QDDN, tab Đổi Thưởng), giá 99  | không có chỉ số |
| 1114 | Pet Ma vàng phù thủy | Chung | Shop Quy Lão Kame (QDDN, tab Đổi Thưởng), giá 59  | không có chỉ số |
| 1188 | Pet mèo đen đuôi vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1202 | Pet mèo trắng đuôi vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1203 | Pet mèo trắng đuôi vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1207 | Pet Minion | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1224 | Pet Voi Chín Ngà | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1225 | Pet Gà Chín Cựa | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1226 | Pet Ngựa Chín Hồng mao | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1243 | Pet bọ cánh cứng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1244 | Pet ngài đêm | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1256 | Pet heo bướm | Chung | Tori Bot: mua gói VIP 1 | Sức đánh+10%; HP+10%; KI +10%; Hạn sử dụng 30 ngày |
| 1318 | Pet Mông Quỷ | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1347 | Pet Mèo Phù Thủy | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1414 | Pet Shiba | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1435 | Pet chim cánh cụt | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1452 | Pet Ông già Noel | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1458 | Pet Shiba đeo nơ | Chung | Shop Santa (SHOP_VIP, tab Pet), giá 150 Thỏi vàng | Sức đánh+15%; HP+15%; KI +15% |
| 1482 | Pet rồng Pikachu thanh long | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1497 | Pet rồng con thần tài | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1550 | Pet Godzilla | Chung | Shop Santa (SHOP_VIP, tab Pet), giá 150 Thỏi vàng<br>Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+15%; HP+15%; KI +15%<br>Sức đánh+10%; HP+10%; KI +10% |
| 1551 | Pet Kong | Chung | Shop Santa (SHOP_VIP, tab Pet), giá 150 Thỏi vàng<br>Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+15%; HP+15%; KI +15%<br>Sức đánh+10%; HP+10%; KI +10% |
| 1564 | Pet Po | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1568 | Pet Shimo | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1573 | Xe tăng Santa | Chung | Shop Santa (SHOP_VIP, tab Pet), giá 150 Thỏi vàng<br>Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+15%; HP+15%; KI +15%<br>Sức đánh+10%; HP+10%; KI +10% |
| 1596 | Pet Albart | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1597 | Pet Albart Cup | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1611 | Pet Minion Otto | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1620 | Pet Baby Shark | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt<br>Shop Bill (SHOP_SU_KIEN_VL, tab Đổi Thưởng), giá 19 Phiếu thức ăn | Sức đánh+10%; HP+10%; KI +10%<br>4 Dòng chỉ số ẩn; Hạn sử dụng hoặc vĩnh viễn |
| 1621 | Pet Baby Shark | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1622 | Pet Baby Shark | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1629 | Pet Capybara đeo ba lô | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+10%; HP+10%; KI +10% |
| 1630 | Pet Capybara xì mũi | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+10%; HP+10%; KI +10% |
| 1631 | Pet Zịt vàng bối rối | Chung | Shop Santa (SHOP_VIP, tab Pet), giá 150 Thỏi vàng<br>Shop Chi Chi (SHOP_CHI_CHI, tab Shop sự kiện), giá 1.500.000.000 vàng<br>Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+15%; HP+15%; KI +15%<br>Không thể giao dịch; Sức đánh+7%; HP+8%; +10% tiềm năng, sức mạnh; KI +8%; +10% May mắn<br>Sức đánh+10%; HP+10%; KI +10% |
| 1633 | Pet Mini Desutoron Gas | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1654 | Pet Cerberus | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1668 | Pet Capybara hồng | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+10%; HP+10%; KI +10% |
| 1682 | Pet Hải Ly | Chung | Shop Quy Lão Kame (SHOP_DOI_DIEM, tab Đổi thưởng), giá 499 <br>Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Không thể giao dịch; Sức đánh+15%; HP+15%; KI +18%; Hạn sử dụng hoặc vĩnh viễn; +15% May mắn<br>Sức đánh+10%; HP+10%; KI +10% |
| 1683 | Pet Hải Ly Ong Vàng | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+10%; HP+10%; KI +10% |
| 1686 | Pet Thỏ Ú | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1727 | Pet Ma cầu mưa | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+10%; HP+10%; KI +10% |
| 1729 | Pet Rồng Xanh | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+10%; HP+10%; KI +10% |
| 1750 | Pet Khủng Long ngok | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Của Hàng Pet), giá 50 Capsule 1 món kích hoạt | Sức đánh+10%; HP+10%; KI +10% |
| 1765 | Bé Rồng Cute | Chung | Mở Trứng vàng rồng nhí (1821) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–18%; +5–10% sức đánh chí mạng; Chí mạng+5–10%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1766 | Bé Rồng Cute | Chung | Mở Trứng vàng rồng nhí (1821) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–18%; +5–10% sức đánh chí mạng; Chí mạng+5–10%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1767 | Bé Rồng Cute | Chung | Mở Trứng vàng rồng nhí (1821) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–18%; +5–10% sức đánh chí mạng; Chí mạng+5–10%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1768 | Bé Rồng Cute | Chung | Mở Trứng vàng rồng nhí (1821) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–18%; +5–10% sức đánh chí mạng; Chí mạng+5–10%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1769 | Bé Rồng Cute | Chung | Mở Trứng vàng rồng nhí (1821) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–18%; +5–10% sức đánh chí mạng; Chí mạng+5–10%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1770 | Bé Rồng Cute | Chung | Mở Trứng vàng rồng nhí (1821) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–18%; +5–10% sức đánh chí mạng; Chí mạng+5–10%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1771 | Bé Rồng Cute | Chung | Tori Bot: mua gói VIP 4<br>Mở Trứng vàng rồng nhí (1821) (ngẫu nhiên trong mảng 7 món) | Sức đánh+18%; HP+18%; +18% sức đánh chí mạng; Chí mạng+10%; +15% May mắn<br>Sức đánh+10–18%; +5–10% sức đánh chí mạng; Chí mạng+5–10%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1789 | Thỏ may mắn | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |

### Đồ đeo lưng (ô 9, loại 11, có hình, 173 món)

| ID | Tên | Hành tinh | Xuất xứ | Chỉ số |
|---|---|---|---|---|
| 78 | Đứa bé | Chung | Rơi sẵn trên map (đồ nhiệm vụ)<br>Rơi sẵn trên map (đồ nhiệm vụ)<br>Rơi sẵn trên map (đồ nhiệm vụ) | không có chỉ số<br>không có chỉ số<br>không có chỉ số |
| 467 | Lồng đèn Ông Sao | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 468 | Lồng đèn Cá chép | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 469 | Lồng đèn Kéo Quân | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 470 | Lồng đèn Ông trăng | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 471 | Lồng đèn Hội An | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 740 | Lưỡi hái Thần Chết | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 741 | Cánh dơi Dracula | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 745 | Bông tuyết | Chung | KHÔNG RA ĐƯỢC (hàm OpenItem648 không ai gọi)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | HP+5–9%; KI +5–9%; +5–9% sức đánh; Không thể giao dịch; Hạn sử dụng 1–3 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 767 | Cờ đen | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 768 | Cờ xanh lá | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 769 | Cờ xanh biển | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 770 | Cờ hồng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 771 | Cờ cam | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 772 | Cờ vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 773 | Cờ tím | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 774 | Cờ xanh dạ | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 775 | Cờ đỏ | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 776 | Khăn xanh lá | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 777 | Khăn xanh dương | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 778 | Khăn vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 779 | Khăn tím | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 780 | Khăn nâu | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 781 | Khăn xám | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 782 | Khăn đỏ | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 783 | Khăn hồng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 784 | Khăn xanh dạ | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 785 | Ba lô | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 786 | Đao | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 787 | Gậy | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 788 | Mai rùa | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 789 | Giỏ bơ | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 790 | Giỏ dưa hấu | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 791 | Giỏ củ cải trắng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 792 | Giỏ cà rốt | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 793 | Giỏ chuối | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 794 | Gậy phép | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 800 | Lồng đèn Cô Vy | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 801 | Lồng đèn Con tàu | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 802 | Lồng đèn Con gà | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 803 | Lồng đèn Con bướm | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 804 | Lồng đèn Đôrêmon | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món) | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày |
| 805 | Vòng sáng thiên thần | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 814 | Ma trơi | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 815 | Hồn ma Goku | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 816 | Hồn ma Ca đíc | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 817 | Hồn ma Pôcôlô | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 822 | Cây thông | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 823 | Túi quà | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 852 | Cây trúc | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 865 | Kiếm Z | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 954 | Bó Hoa Hồng | Chung | Mở Hộp quà 5 sao (736)<br>KHÔNG RA ĐƯỢC (hàm OpenItem648 không ai gọi) (ngẫu nhiên trong mảng 20 món) | HP+5–9%; KI +5–9%; +5–9% sức đánh; Không thể giao dịch; Hạn sử dụng 1–3 ngày<br>Hạn sử dụng 1–7 ngày; Không thể giao dịch |
| 955 | Bó Hoa Vàng | Chung | KHÔNG RA ĐƯỢC (hàm OpenItem648 không ai gọi) (ngẫu nhiên trong mảng 20 món)<br>Vòng quay may mắn | Hạn sử dụng 1–7 ngày; Không thể giao dịch<br>Sức đánh+1–10%; HP+1–10%; KI +1–10%; Hạn sử dụng 3–15 ngày |
| 966 | Trái bóng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 982 | Cúp vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 983 | Cờ cổ động | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 994 | Vỏ ốc | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 995 | Cây kem | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 996 | Cá heo | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 997 | Con diều | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 998 | Diều rồng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 999 | Mèo mun | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 14 món)<br>KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>– |
| 1000 | Xiên cá | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 12 món)<br>Vòng quay may mắn (ngẫu nhiên trong mảng 14 món)<br>KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>– |
| 1001 | Phóng lợn | Chung | Vòng quay may mắn (ngẫu nhiên trong mảng 14 món)<br>Shop Quy Lão Kame (QDDN, tab Đổi Thưởng), giá 59 <br>KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | Không thể giao dịch; Hạn sử dụng 1–30 ngày<br>không có chỉ số<br>– |
| 1007 | Ván lướt sóng | Chung | KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | – |
| 1013 | Kiếm ánh sáng | Chung | KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | – |
| 1021 | Búa Mjolnir | Chung | Shop Quy Lão Kame (QDDN, tab Đổi Thưởng), giá 99 <br>KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | không có chỉ số<br>– |
| 1022 | Búa Stormbreaker | Chung | Shop Quy Lão Kame (QDDN, tab Đổi Thưởng), giá 79 <br>KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | không có chỉ số<br>– |
| 1023 | Quạt ba tiêu | Chung | Shop Quy Lão Kame (QDDN, tab Đổi Thưởng), giá 69 <br>KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | không có chỉ số<br>– |
| 1024 | Như Ý Kim Cô Bổng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1025 | Cửu Xỉ Đinh Ba | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1026 | Nguyệt Nha Sản | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1027 | Cửu Hoàn Thiên Tích Trượng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1028 | Dao răng cưa | Chung | KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | – |
| 1030 | Cờ Hoa đăng | Chung | KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | – |
| 1031 | Cờ Hoa sen | Chung | KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | – |
| 1047 | Lồng đèn lon | Chung | KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab 24 đã bị xóa | – |
| 1100 | Chậu hoa ăn thịt | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1108 | Đinh ba Satan | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1109 | Chổi phù thủy | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1110 | Cánh thiên thần | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1111 | Cánh thiên thần 2 | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1112 | Cây nắp ấm | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1113 | Cá Chà Bá | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1128 | Cờ logo Quatar 1 | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1129 | Cờ logo Quatar 2 | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1130 | Cờ giày vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1137 | Cờ GOAL | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1138 | Cờ FIFA | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1139 | Quả Bóng Vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1140 | Mèo mun đột biến | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1142 | Bong bóng heo | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1149 | Cánh thiên sứ hắc ám | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1158 | Chú lùn | Chung | Mở Túi 7 chú lùn (1171) (ngẫu nhiên trong mảng 7 món) | Sức đánh+11%; HP+13%; KI +13%; Hạn sử dụng 1–3 ngày;  |
| 1159 | Chú lùn | Chung | Mở Túi 7 chú lùn (1171) (ngẫu nhiên trong mảng 7 món) | Sức đánh+11%; HP+13%; KI +13%; Hạn sử dụng 1–3 ngày;  |
| 1160 | Chú lùn | Chung | Mở Túi 7 chú lùn (1171) (ngẫu nhiên trong mảng 7 món) | Sức đánh+11%; HP+13%; KI +13%; Hạn sử dụng 1–3 ngày;  |
| 1161 | Chú lùn | Chung | Mở Túi 7 chú lùn (1171) (ngẫu nhiên trong mảng 7 món) | Sức đánh+11%; HP+13%; KI +13%; Hạn sử dụng 1–3 ngày;  |
| 1162 | Chú lùn | Chung | Mở Túi 7 chú lùn (1171) (ngẫu nhiên trong mảng 7 món) | Sức đánh+11%; HP+13%; KI +13%; Hạn sử dụng 1–3 ngày;  |
| 1163 | Chú lùn | Chung | Mở Túi 7 chú lùn (1171) (ngẫu nhiên trong mảng 7 món) | Sức đánh+11%; HP+13%; KI +13%; Hạn sử dụng 1–3 ngày;  |
| 1164 | Chú lùn | Chung | Mở Túi 7 chú lùn (1171) (ngẫu nhiên trong mảng 7 món) | Sức đánh+11%; HP+13%; KI +13%; Hạn sử dụng 1–3 ngày;  |
| 1185 | Cành mai | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1186 | Cành đào | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1197 | Bóng Vịt Vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1206 | Trái tim Valentine | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1213 | Cờ mèo Hoàng Thượng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1223 | Bóng khí Gas | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1230 | Hào Quang Rực Rỡ | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1231 | Gậy thượng đế | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1254 | Búa hắc hường | Chung | Tori Bot: mua gói VIP 2<br>Tori Bot: mua gói VIP 3 | Sức đánh+12%; HP+12%; KI +12%; Hạn sử dụng 30 ngày<br>Sức đánh+12%; HP+12%; KI +12% |
| 1301 | Cờ khỉ hoàng đế | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1303 | Lồng đèn thỏ trắng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1344 | Con Cat hường | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1358 | Cờ hồn Mabư | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1359 | Cờ hồn Xên Bọ Hung | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1360 | Cờ Ma đèn nhảy múa | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1361 | Cờ Ma đèn hút hồn | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1386 | Bút chì hồng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1456 | Kiếm Kitetsu | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1467 | Gấu bắc cực | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1478 | Cờ bao lì xì | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1479 | Cờ dây pháo | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1502 | Thanh Long Yển Nguyệt đao | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1515 | Chậu hoa hồng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1519 | Bong bóng thiên thần | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1520 | Bong bóng hoa hồng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1531 | Cánh thiên thần 3 | Chung | Shop Santa (SANTA_HAN_SU_DUNG, tab Vàng), giá 129.000.000 vàng<br>Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Không thể giao dịch; Sức đánh+3%; HP+3%; Hạn sử dụng 7 ngày; KI +3%; +30% TN, SM cho đệ tử khi sư phụ mặc<br>Sức đánh+10%; HP+10%; KI +10% |
| 1539 | Bụi tre | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1562 | Mặt trời tí hon | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1571 | Gậy phép của Frieren | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1572 | Goku bay | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1574 | Cánh sấm sét | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1577 | Cánh sấm sét hoàng kim | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1579 | 1 sao | Chung | Dùng Rada ngọc rồng (1822) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–17%; HP+10–17%; KI +10–17%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1580 | 2 sao | Chung | Dùng Rada ngọc rồng (1822) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–17%; HP+10–17%; KI +10–17%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1581 | 3 sao | Chung | Dùng Rada ngọc rồng (1822) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–17%; HP+10–17%; KI +10–17%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1582 | 4 sao | Chung | Dùng Rada ngọc rồng (1822) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–17%; HP+10–17%; KI +10–17%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1583 | 5 sao | Chung | Dùng Rada ngọc rồng (1822) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–17%; HP+10–17%; KI +10–17%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1584 | 6 sao | Chung | Dùng Rada ngọc rồng (1822) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–17%; HP+10–17%; KI +10–17%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1585 | 7 sao | Chung | Dùng Rada ngọc rồng (1822) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–17%; HP+10–17%; KI +10–17%; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1586 | Super 1 sao | Chung | Dùng Rada ngọc rồng Vip (1823) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–20%; HP+10–20%; KI +10–20%; 3 Dòng chỉ số ẩn; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1617 | Cá nóc nâu | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1618 | Cá nóc vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1619 | Túi nước mía | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1623 | Trái bóng Euro | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1624 | Cup Euro | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1626 | Thẻ trọng tài | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1669 | Balo Capybara | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1670 | Balo Capybara hồng | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1675 | Lồng đèn kéo quân NRO | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1679 | Cờ Olympic | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1680 | Hỏa tiêm thương | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1681 | Cờ Hải Ly xe máy | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1687 | Cờ Goku bay | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1688 | Cờ Hắc Vô Thường | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1689 | Cờ Bạch Vô Thường | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1694 | Labubu | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1699 | Bồ cào 9 răng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1702 | Lưỡi hái hồng | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1706 | Lưỡi hái | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1713 | Khủng Long Thơ Mộng | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng<br>Shop Quy Lão Kame (SHOP_DOI_DIEM, tab Đổi thưởng), giá 499  | Sức đánh+10%; HP+10%; KI +10%<br>Không thể giao dịch; Sức đánh+18%; HP+15%; KI +15%; Cute +3% SĐ cho mình và người xung quanh; Hạn sử dụng hoặc vĩnh viễn; +15% May mắn |
| 1721 | Cá Koi zombie | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1722 | Cánh Thiên thần - Ác quỷ | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1735 | Đeo lưng dụng cụ học tập | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1751 | Diều rồng băng | Chung | Shop Santa (SHOP_VIP, tab Deo Lưng), giá 100 Thỏi vàng | Sức đánh+10%; HP+10%; KI +10% |
| 1772 | búa sơn tinh | Chung | Tori Bot: mua gói VIP 4<br>Mở Hộp quà sự kiện (1776) (ngẫu nhiên trong mảng 2 món) | Sức đánh+15%; HP+15%; KI +15%; +15% May mắn<br>Sức đánh+10%; HP+10%; KI +10%; Chí mạng+10%; Hạn sử dụng 0 ngày; Hạn sử dụng 3 ngày |
| 1773 | bút thủy tinh | Chung | Mở Hộp quà sự kiện (1776) (ngẫu nhiên trong mảng 2 món) | Sức đánh+10%; HP+10%; KI +10%; Chí mạng+10%; Hạn sử dụng 0 ngày; Hạn sử dụng 3 ngày |
| 1806 | Kem que | Chung | Shop Bill (SHOP_SU_KIEN_VL, tab Đổi Thưởng), giá 55 Phiếu thức ăn | +9% sức đánh chí mạng; +5 KI/30s; Không thể giao dịch; Sức đánh+15%; HP+18%; KI +15%; Hạn sử dụng hoặc vĩnh viễn |
| 1809 | Super 2 sao | Chung | Dùng Rada ngọc rồng Vip (1823) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–20%; HP+10–20%; KI +10–20%; 3 Dòng chỉ số ẩn; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1810 | Super 3 sao | Chung | Dùng Rada ngọc rồng Vip (1823) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–20%; HP+10–20%; KI +10–20%; 3 Dòng chỉ số ẩn; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1811 | Super 4 sao | Chung | Dùng Rada ngọc rồng Vip (1823) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–20%; HP+10–20%; KI +10–20%; 3 Dòng chỉ số ẩn; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1812 | Guardian Angel | Chung | Dùng Rada ngọc rồng Vip (1823) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–20%; HP+10–20%; KI +10–20%; 3 Dòng chỉ số ẩn; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1813 | Fallen Angel | Chung | Dùng Rada ngọc rồng Vip (1823) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–20%; HP+10–20%; KI +10–20%; 3 Dòng chỉ số ẩn; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |
| 1814 | Eternal Hope | Chung | Dùng Rada ngọc rồng Vip (1823) (ngẫu nhiên trong mảng 7 món) | Sức đánh+10–20%; HP+10–20%; KI +10–20%; 3 Dòng chỉ số ẩn; Không thể giao dịch; Hạn sử dụng 0 hoặc 15 ngày |

### Thú cưỡi (loại 23/24, 55 món)

| ID | Tên | Hành tinh | Xuất xứ | Chỉ số |
|---|---|---|---|---|
| 346 | Cân đẩu vân | Trái Đất | KHÔNG RA ĐƯỢC: có trong Shop Uron (URON, tab Phụ kiện) nhưng đang ẩn (is_sell = 0) | – |
| 347 | Phi Long | Namếc | Shop Uron (URON, tab Phụ kiện), giá 50 ngọc<br>KHÔNG RA ĐƯỢC: có trong Shop Uron (URON, tab Phụ kiện) nhưng đang ẩn (is_sell = 0) | Dùng để bay không tốn KI<br>– |
| 348 | Ván bay | Xayda | KHÔNG RA ĐƯỢC: có trong Shop Uron (URON, tab Phụ kiện) nhưng đang ẩn (is_sell = 0) | – |
| 349 | Cân đẩu vân VIP | Trái Đất | KHÔNG RA ĐƯỢC: có trong Shop Uron (URON, tab Phụ kiện) nhưng đang ẩn (is_sell = 0) | – |
| 350 | Phi Long VIP | Namếc | Shop Uron (URON, tab Phụ kiện), giá 500 ngọc<br>KHÔNG RA ĐƯỢC: có trong Shop Uron (URON, tab Phụ kiện) nhưng đang ẩn (is_sell = 0) | Dùng để bay và phục hồi KI<br>– |
| 351 | Ván bay VIP | Xayda | KHÔNG RA ĐƯỢC: có trong Shop Uron (URON, tab Phụ kiện) nhưng đang ẩn (is_sell = 0) | – |
| 396 | Thú cưỡi cực VIP | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 532 | Quỷ Chim | Chung | Shop Uron (URON, tab Phụ kiện), giá 1.000 ngọc<br>KHÔNG RA ĐƯỢC: có trong Shop Uron (URON, tab Phụ kiện) nhưng đang ẩn (is_sell = 0) | Dùng để bay và phục hồi HP, KI<br>– |
| 733 | Cân đẩu vân ngũ sắc | Chung | Quy Lão Kame: quà sau khi hạ Lân con (sự kiện Tết) (ngẫu nhiên trong mảng 5 món)<br>KHÔNG RA ĐƯỢC (hàm rewardCapsuleTet không ai gọi) (ngẫu nhiên trong mảng 5 món) | Hạn sử dụng 1–30 ngày; Dùng để bay và phục hồi HP, KI; Không thể giao dịch<br>Hạn sử dụng 1–30 ngày; Dùng để bay và phục hồi HP, KI; Không thể giao dịch |
| 734 | Ngọc Thố | Chung | Quy Lão Kame: quà sau khi hạ Lân con (sự kiện Tết) (ngẫu nhiên trong mảng 5 món)<br>KHÔNG RA ĐƯỢC (hàm rewardCapsuleTet không ai gọi) (ngẫu nhiên trong mảng 5 món) | Hạn sử dụng 1–30 ngày; Dùng để bay và phục hồi HP, KI; Không thể giao dịch<br>Hạn sử dụng 1–30 ngày; Dùng để bay và phục hồi HP, KI; Không thể giao dịch |
| 735 | Lồng đèn cá chép | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 743 | Chổi bay Phù Thủy | Chung | Quy Lão Kame: quà sau khi hạ Lân con (sự kiện Tết) (ngẫu nhiên trong mảng 5 món)<br>KHÔNG RA ĐƯỢC (hàm rewardCapsuleTet không ai gọi) (ngẫu nhiên trong mảng 5 món) | Hạn sử dụng 1–30 ngày; Dùng để bay và phục hồi HP, KI; Không thể giao dịch<br>Hạn sử dụng 1–30 ngày; Dùng để bay và phục hồi HP, KI; Không thể giao dịch |
| 744 | Cột nhà | Chung | Shop Uron (URON, tab Phụ kiện), giá 1.000 ngọc | Dùng để bay không tốn KI; +25% tốc độ chạy; Ngầu +20% sức đánh lên quái khi bay với Cải Trang Tàu Pảy Pảy |
| 746 | Xe tuần lộc | Chung | KHÔNG RA ĐƯỢC (hàm OpenItem648 không ai gọi) | Dùng để bay và phục hồi HP, KI; Không thể giao dịch; Hạn sử dụng 1–3 ngày |
| 795 | Ghế bay | Chung | Mở Hộp quà 5 sao (736)<br>Shop Uron (URON, tab Phụ kiện), giá 1.500 ngọc | Dùng để bay và phục hồi HP, KI; Không thể giao dịch; Hạn sử dụng 1–3 ngày<br>Dùng để bay không tốn KI; +25% tốc độ chạy; Ngầu +22% sức đánh lên quái khi bay với Cải Trang nhà Fide |
| 849 | Pháo Thăng Thiên | Chung | Quy Lão Kame: quà sau khi hạ Lân con (sự kiện Tết) (ngẫu nhiên trong mảng 5 món)<br>KHÔNG RA ĐƯỢC (hàm rewardCapsuleTet không ai gọi) (ngẫu nhiên trong mảng 5 món)<br>Shop Uron (URON, tab Phụ kiện), giá 999 ngọc | Hạn sử dụng 1–30 ngày; Dùng để bay và phục hồi HP, KI; Không thể giao dịch<br>Hạn sử dụng 1–30 ngày; Dùng để bay và phục hồi HP, KI; Không thể giao dịch<br>Dùng để bay không tốn KI; +25% tốc độ chạy |
| 897 | Rùa bay | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 920 | Gậy như ý | Chung | Quy Lão Kame: quà sau khi hạ Lân con (sự kiện Tết) (ngẫu nhiên trong mảng 5 món)<br>KHÔNG RA ĐƯỢC (hàm rewardCapsuleTet không ai gọi) (ngẫu nhiên trong mảng 5 món) | Hạn sử dụng 1–30 ngày; Dùng để bay và phục hồi HP, KI; Không thể giao dịch<br>Hạn sử dụng 1–30 ngày; Dùng để bay và phục hồi HP, KI; Không thể giao dịch |
| 1092 | Gậy Quy Lão | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1131 | Quả bóng siêu việt | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1144 | Phượng hoàng lửa | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1172 | Xe heo tuần lộc | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1252 | Ve Sầu Xên | Chung | Tori Bot: mua gói VIP 1<br>Tori Bot: mua gói VIP 2<br>Tori Bot: mua gói VIP 3 | Sức đánh+10%; HP+10%; KI +10%; Hạn sử dụng 30 ngày<br>Sức đánh+12%; HP+12%; KI +12%; Hạn sử dụng 30 ngày<br>Sức đánh+12%; HP+12%; KI +12% |
| 1253 | Ve Sầu Xên Tiến Hóa | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1272 | Đài sen hồng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1273 | Đài sen vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1345 | Thú cưỡi mèo kéo xương | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1346 | Thú cưỡi Xe bí ngô | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1363 | Thú cưỡi con Cat hường | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1443 | Phượng hoàng băng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1455 | Quả bóng tuyết | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1465 | Máy bay trực thăng Noel | Chung | Shop Quy Lão Kame (QDDN, tab Đổi Thưởng), giá 79  | không có chỉ số |
| 1466 | Tuần lộc Machine | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1468 | Thú cưỡi Rồng PiLong | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1477 | Thỏi vàng bay | Chung | Shop Quy Lão Kame (QDDN, tab Đổi Thưởng), giá 199  | không có chỉ số |
| 1487 | Cá chép rồng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1513 | Song mã hoàng gia | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1534 | Thuyền Âu Lạc | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1541 | Môtô Bun ma | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Cửa Hàng Ván Bay), giá 50 Capsule 1 món kích hoạt | Sức đánh+10%; HP+10%; KI +10% |
| 1554 | Tàu ngầm 19 Cam | Chung | Tori Bot: mua gói VIP 4 | Sức đánh+15%; HP+15%; KI +15%; Chí mạng+10% |
| 1555 | Tàu ngầm 19 Vàng | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1563 | Ván bay té nước | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Cửa Hàng Ván Bay), giá 50 Capsule 1 món kích hoạt | Sức đánh+10%; HP+10%; KI +10% |
| 1578 | Mây mưa | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1598 | Trực thăng thỏ đế | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1603 | Tên lửa cá mập | Chung | Shop Santa (SHOP_VIP, tab Ván bay), giá 50 Thỏi vàng | Sức đánh+5%; HP+5%; KI +5% |
| 1625 | Tivi bay | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1676 | Phong hỏa luân | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1677 | Xe xanh Chi Chi | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1678 | Xe đỏ Bun ma | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1704 | Bí Ngô Cánh Dơi | Chung | không có (không tìm thấy nguồn trong code, shop, giftcode) | – |
| 1711 | Cân Đẩu Vân Thơ Mộng | Chung | Shop Santa (SHOP_VIP, tab Ván bay), giá 50 Thỏi vàng<br>Shop Quy Lão Kame (SHOP_DOI_DIEM, tab Đổi thưởng), giá 750  | Sức đánh+5%; HP+5%; KI +5%<br>Sức đánh+8%; HP+8%; Dùng để bay và phục hồi KI; Hạn sử dụng 30 ngày; KI +8%; Cute +3% SĐ cho mình và người xung quanh; Hạn sử dụng hoặc vĩnh viễn; +10% May mắn |
| 1724 | Ván bay Sọ Dừa | Chung | Shop Santa (SHOP_VIP, tab Ván bay), giá 50 Thỏi vàng<br>Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Cửa Hàng Ván Bay), giá 50 Capsule 1 món kích hoạt | Sức đánh+5%; HP+5%; KI +5%<br>Sức đánh+10%; HP+10%; KI +10% |
| 1733 | Thú cưỡi Thích Kim Quy | Chung | Shop Santa (SHOP_VIP, tab Ván bay), giá 50 Thỏi vàng<br>Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Cửa Hàng Ván Bay), giá 50 Capsule 1 món kích hoạt | Sức đánh+5%; HP+5%; KI +5%<br>Sức đánh+10%; HP+10%; KI +10% |
| 1734 | Thú cưỡi Phong Xích Lan | Chung | Shop Santa (SHOP_VIP, tab Ván bay), giá 50 Thỏi vàng<br>Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Cửa Hàng Ván Bay), giá 50 Capsule 1 món kích hoạt | Sức đánh+5%; HP+5%; KI +5%<br>Sức đánh+10%; HP+10%; KI +10% |
| 1749 | Thú cưỡi Cây thông | Chung | Shop Giu-ma Đầu Bò (SHOP_CLAN, tab Cửa Hàng Ván Bay), giá 50 Capsule 1 món kích hoạt | Sức đánh+10%; HP+10%; KI +10% |

