# Kế hoạch: quái rơi đồ shop làng theo map (đã duyệt 16/11/2026)

Viết 16/11/2026. Tỉ lệ rơi hiện tại: [QUAI-ROI-DO.md](QUAI-ROI-DO.md).

## Đã chốt (16/11/2026)
1. Tỉ lệ mỗi con quái: đầu **5%**, giữa **2%**, xa **1%**, Fide **0,5%**, Tương lai và lạnh **0,3% nhưng đang tắt** (THAY-DOI 80) (comment trong [`ItemService.capDoShopTheoMap`](Teamobi2026/src/nro/models/services/ItemService.java#L705), chỉ rơi tới Fide) (đổi 16/11/2026, THAY-DOI 77; trước Fide 2%, Tương lai/lạnh 1%); Cỏ bốn lá ×1,15. Đồ kích hoạt cấp ngẫu nhiên từ 1 tới cấp cao nhất của vùng. Khi rơi: **85% đồ sao** (trước 70%, THAY-DOI 79; phần kích hoạt 15% nhân may mắn 236 và Cỏ, tối đa 27% khi 200 điểm may mắn, THAY-DOI 81–82) (chỉ số shop ×100–115% + sao pha lê [`Boss.randSaoDoShop`](Teamobi2026/src/nro/models/boss/Boss.java#L699), giao dịch được), **15% đồ kích hoạt** (chỉ số shop ×100–115% + set [`ItemService.randOptionItemKichHoat`](Teamobi2026/src/nro/models/services/ItemService.java#L883), option 30 không giao dịch). Map Tương lai / lạnh: thêm 10% có Ký gửi vàng (86) hoặc Ký gửi ngọc (87).
2. Bảng map → cấp như bên dưới. Map khác không rơi.
3. Đồ sao giao dịch được, đồ kích hoạt khóa giao dịch.
4. Lỗ sao dùng [`Boss.randSaoDoShop`](Teamobi2026/src/nro/models/boss/Boss.java#L699) (như boss rơi đồ Goku), đổi thành `public static`.
5. Bán lại cho NPC giữ `gold / 4`.
6. ~~Chặn theo sức mạnh~~: đã làm rồi bỏ theo yêu cầu user (16/11/2026), ai đánh cũng rơi.
7. Comment hai khối cũ "Đồ sao khác vải thô" và "Đồ sao 3 map đầu" trong [`Mob.getItemMobReward`](Teamobi2026/src/nro/models/mob/Mob.java#L613).
8. Không cộng dồn (đồ mặc vốn không cộng dồn, không đổi DB).
- Đệ tử kết liễu: hành tinh và sức mạnh lấy theo sư phụ; đồ thuộc người kết liễu như các đồ khác.

## Đã dò
- Hiện quái **không rơi** đồ shop làng. Chỉ đồ cấp 1–2 rơi ở map up SKH dưới dạng đồ sao có lỗ (rất hiếm) hoặc đồ kích hoạt.
- Shop làng: BUNMA (Trái Đất, shop 1), DENDE (Namếc, shop 2), APPULE (Xayda, shop 3). Mỗi shop có tab "Áo Quần" (áo, quần) và "Phụ kiện" (găng, giày, rađa, bình tập luyện). Mỗi loại có **12 cấp**, rađa dùng chung cho cả 3 hành tinh.
- Ví dụ Trái Đất. Sức mạnh yêu cầu lấy từ `item_template.power_require`, giá lấy từ `item_shop.cost`:

| Cấp | Áo | Quần | Găng | Giày | Rađa | Sức mạnh yêu cầu (áo) | Giá shop (áo) |
|---|---|---|---|---|---|---|---|
| 1 | 0 | 6 | 21 | 27 | 12 | 1.200 | 500 |
| 2 | 33 | 35 | 24 | 30 | 57 | 12.000 | 5.000 |
| 3 | 3 | 9 | 37 | 39 | 58 | 26.000 | 10.000 |
| 4 | 34 | 36 | 38 | 40 | 59 | 80.000 | 20.000 |
| 5 | 136 | 140 | 144 | 148 | 184 | 240.000 | 50.000 |
| 6 | 137 | 141 | 145 | 149 | 185 | 720.000 | 100.000 |
| 7 | 138 | 142 | 146 | 150 | 186 | 2,2 triệu | 200.000 |
| 8 | 139 | 143 | 147 | 151 | 187 | 6,4 triệu | 500.000 |
| 9 | 230 | 242 | 254 | 266 | 278 | 20 triệu | 2 triệu |
| 10 | 231 | 243 | 255 | 267 | 279 | 58 triệu | 5,8 triệu |
| 11 | 232 | 244 | 256 | 268 | 280 | 170 triệu | 17 triệu |
| 12 | 233 | 245 | 257 | 269 | 281 | 520 triệu | 52 triệu |

  Namếc và Xayda lấy ID theo cùng thứ tự trong `item_shop` (tab 4–5 Namếc, 7–8 Xayda).
- Bán lại cho NPC được `item_template.gold / 4` ([`ShopService.sellItem`](Teamobi2026/src/nro/models/shop/ShopService.java#L1121)). Ví dụ áo cấp 12 bán được khoảng 13 triệu vàng. Tỉ lệ rơi cao thì người chơi cày quái bán đồ lấy vàng, nên phải cân với vàng rơi sẵn (map lạnh: 30% × 150–250k).
- Đồ rơi tự hút vào túi khi đánh gần ([`Mob.hutItem`](Teamobi2026/src/nro/models/mob/Mob.java#L567)), nên rơi nhiều sẽ làm đầy túi nhanh.

## Cách làm
1. Thêm hàm [`ItemService.randDoShopTheoMap(int mapId, int gender)`](Teamobi2026/src/nro/models/services/ItemService.java). Hàm có bảng ID 12 cấp × 5 loại × 3 hành tinh như trên, và bảng map → khoảng cấp (bên dưới). Map không có trong bảng thì trả -1.
2. Trong [`Mob.getItemMobReward`](Teamobi2026/src/nro/models/mob/Mob.java#L613), tung thêm một lần: trúng thì tạo [`ItemMap`](Teamobi2026/src/nro/models/map/ItemMap.java) của món đó. Chỉ số món lấy như shop (`getListOptionItemShop`, giống đoạn rơi đồ kích hoạt), có thể thêm lỗ sao (option 107) theo điểm cần chốt 4.
3. Hành tinh của món theo người kết liễu. Nếu đệ tử kết liễu thì lấy hành tinh sư phụ, đồ vẫn rơi cho đệ như các đồ khác.
4. Cập nhật QUAI-ROI-DO.md và THAY-DOI.md. Không đổi DB, không đổi client.

Bảng map đề xuất (theo đường đi lên của từng hành tinh):

| Vùng | Map | Cấp rơi | Sức mạnh cần để mặc |
|---|---|---|---|
| Đầu | 1, 2, 3 / 8, 9, 11 / 15, 16, 17 (map up SKH) | 1–3 | 1.200 – 26.000 |
| Giữa | 4, 5, 6 / 10, 12, 13 / 18, 19, 20 | 3–5 | 26.000 – 240.000 |
| Xa | 27–30 / 31–34 / 35–38 | 5–7 | 240.000 – 2,2 triệu |
| Fide (Nappa) | 63–83 | 7–9 | 2,2 – 20 triệu |
| Tương lai | 92–94, 96–100, 102, 103 | 9–11 | 20 – 170 triệu |
| Lạnh | 105–110 | 11–12 | 170 – 520 triệu |

Trong khoảng cấp của vùng, cấp thấp ra nhiều hơn, ví dụ 50% / 35% / 15%. Loại đồ chia đều 5 loại, mỗi loại 20%.

## Cần chốt
1. **Tỉ lệ rơi** mỗi con quái. Đề xuất: **1%** (Cỏ bốn lá ×1,15), như nhau ở mọi vùng. Hoặc giảm dần theo vùng: 2% vùng đầu, còn 0,5% ở map lạnh.
2. **Bảng map → cấp** ở trên có hợp không? Map Yardrat 131–133, Ngũ Hành Sơn, nguyên thủy 160–163, thánh địa… đề xuất không rơi.
3. **Khóa giao dịch** (option 30)? Đề xuất **khóa**, để không thành hàng buôn. Đồ vẫn bán lại được cho NPC.
4. **Lỗ sao pha lê**: đề xuất 20% có lỗ (1 lỗ 60%, 2 lỗ 30%, 3 lỗ 10%) giống đồ sao rơi hiện có, còn lại là đồ trơn như shop.
5. **Chặn bán lại lấy vàng**: giữ nguyên `gold/4`, hay cho đồ rơi từ quái bán chỉ được 1 vàng (nhận ra qua option 30 hoặc một option đánh dấu)?
6. **Chênh sức mạnh**: người đã mạnh vượt xa vùng (ví dụ ≥ 10 lần sức mạnh yêu cầu của cấp cao nhất vùng) thì có còn rơi không? Đề xuất **không rơi**, để người mạnh khỏi bị đầy túi rác khi đi qua map thấp.
7. Có giữ "Đồ sao 3 map đầu" và "Đồ sao khác vải thô" (mục 4 QUAI-ROI-DO.md) không, hay bỏ vì trùng với tính năng này? Đề xuất **giữ**.
8. Không thêm item mới nên không cần chốt cộng dồn.
