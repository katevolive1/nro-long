# Cơ chế server đã dò (đọc trước khi quét code)

Ghi lại những gì đã đọc code để khỏi dò lại. Code ở `Teamobi2026/src/nro/models/`. Sửa cơ chế nào thì cập nhật mục đó. Tỉ lệ đập đồ: [TI-LE-DAP-DO.md](TI-LE-DAP-DO.md). Boss rơi đồ: [BOSS-ROI-DO.md](BOSS-ROI-DO.md). Bảng DB: [DB.md](DB.md).

## Doanh trại Độc Nhãn (`map/phoban/RedRibbonHQ.java`, `services_dungeon/RedRibbonHQService.java`, NPC `npc_list/LinhCanh.java`, `DocNhan.java`)
- Điều kiện (Lính canh): có bang, bang ≥ `N_PLAYER_CLAN` thành viên (đang thử nghiệm = 1, gốc 5), tài khoản `active` = 1, vào bang ≥ `MIN_DAYS_IN_CLAN` ngày (đang = 0, gốc 1; 24 giờ tính từ `join_time`), ≥ `N_PLAYER_MAP` đồng đội cùng bang đứng gần x 1285–1645 (đang thử nghiệm = 0, gốc 1). Miễn phí, mỗi bang 1 lần/ngày (qua 0h vào lại) và **mỗi người 1 lượt/ngày** (`RedRibbonHQService.daVaoHomNay`, theo `player.lastTimeJoinDT` = cột `player.doanhtrai` ms; vào lại được trại đang mở mà mình đã vào; tạo/đổi bang không vào lại được). Admin chỉnh: hằng số đầu `RedRibbonHQ.java` (`N_PLAYER_CLAN`, `N_PLAYER_MAP`, `MIN_DAYS_IN_CLAN`, `TIME_DOANH_TRAI`, `TIME_PICK_DOANH_TRAI`, `AVAILABLE`); cho 1 người vào lại trong ngày: tắt server, `UPDATE player SET doanhtrai = 0 WHERE name = '…'`. Tối đa 50 trại cùng lúc (`AVAILABLE`). Thành viên khác vào sau bằng "Tham gia".
- Kiểm tra "vào bang ≥ N ngày" (`clanMember.getNumDateFromJoinTimeToToday()`): doanh trại `< MIN_DAYS_IN_CLAN` ở `LinhCanh.java:36`, `RedRibbonHQService.java:51`, `RedRibbonHQ.java:108`; rắn độc `SnakeWayService.java:50` (< 2), khí gas `DestronGasService.java:48` (< 2), `MrPoPo.java:55` (< 2), `ThanVuTru.java:155` (< 1).
- 30 phút (`TIME_DOANH_TRAI`), hết giờ về nhà (map 21 + gender). Map 53–62 (`MapService.isMapDoanhTrai`). Boss: 59 Trung úy Trắng, 62 Trung úy Xanh Lơ, 55 Trung úy Thép, 54 Ninja áo tím (còn 50% HP gọi 2 Ninja clone 1/10 chỉ số), 57 4 Robot vệ sĩ + NPC Độc Nhãn.
- Giết hết quái + boss → "Mau đi tìm Độc Nhãn" → nói chuyện Độc Nhãn → 5 phút nhặt ngọc (`TIME_PICK_DOANH_TRAI`, `randomNR`): mỗi map 3 viên + 1/2, 1/3, 1/4, 1/5 thêm viên 4–7; mỗi viên (`NR`) 2% NR 3 sao, 14% NR 4–5 sao, 84% NR 6–7 sao (đã sửa 30/10/2026, cũ 1/500 NR 1–5 sao còn lại 5–7 sao).
- Chỉ số tính theo **mọi thành viên bang đang online** (`clan.membersInGame`, kể cả người ngoài trại): boss sát thương = tổng HP max / 20, HP = tổng sát thương × 50, nhân 1 / 1,1 / 1,15 / 1,2 / 1,3 theo map, trần 200 triệu sát thương, ~2,1 tỷ HP. Mỗi lần có người vào giữa chừng (`updateHPDame`) quái/boss còn sống bị đặt lại chỉ số và **hồi đầy máu** (chưa sửa).
- Quái doanh trại 20% rơi Cuốn chả giò (1778, `Mob.getItemMobReward`), nộp 100 cho nhiệm vụ KOL 1 ở Quy Lão (5 hoặc VIP 10 item 1821).
- Cậu Vàng (1824): mỗi boss trại (trừ clone) rơi 100%; nộp 10 cho nhiệm vụ KOL 2 ở Quy Lão (thường 5 + 5 hộp 1592/1757, VIP 10 + 10).

## Nhân vật mới (`database/PlayerDAO.createNewPlayer`)
- 500 triệu vàng, 100.000 ngọc (`server.test=true` thì 1 tỷ), 0 hồng ngọc. Đang mặc: áo cấp 1 (giáp +2, Xayda +3) và quần cấp 1 (HP +30 Trái Đất, +20 còn lại) của hành tinh. Hành trang: 10 Đậu thần cấp 5 (63, HP/KI +8000), 20.000 Thỏi vàng (457, khóa: option 30 không giao dịch, sửa 31/10/2026). Rương: Rada cấp 1 (12, chí mạng +1). Map 39 + gender, x 100 y 384. Sức mạnh, tiềm năng 2.000. Cây đậu cấp 1, 5 hạt.
- Không có quà tự động lần đầu vào game (`PlayerService.dailyLogin` chỉ reset nhiệm vụ huy hiệu, quà hằng ngày, lượt nhận…). Gift code tân thủ xem CLAUDE.md.
- Tài khoản: `active` mặc định 1, `vnd` mặc định 1.000.000 (đang test, xem DB.md).

## Shop (`shop/ShopService.java`, `database/ShopDAO.java`)
- Server nạp shop lúc khởi động (`shop` → `tab_shop` → `item_shop` có `is_sell = 1`, sắp theo `sort_order, id` → `item_shop_option`). NPC mở bằng `ShopService.gI().opendShop(player, "<tag_name>", false)`.
- `shop.type_shop`: 0 thường (`openShopType0`), 1 kỹ năng, 3 trả bằng vật phẩm (`openShopType3`, `SPEC_SHOP`). Shop thường: `type_sell` 0 vàng, 1 ngọc, 3 hồng ngọc, 4 coupon, không có thỏi vàng. Shop type 3: giá = `cost` vật phẩm có `icon_id` = `item_shop.icon_spec` (`subIemByItemShop`, `getItemIdByIcon` lấy item đầu tiên có icon đó; 4028 = Thỏi vàng 457), trừ từ **chồng đầu tiên** trong hành trang.
- Món mua ra (`ItemService.createItemFromItemShop`) mang đúng option trong `item_shop_option`.
- Mua số lượng (sửa 30/10/2026): gói 6 có short số lượng → `takeItem(..., quantity)` → `buyItemQuantity` (tối đa 1000/lần, món thường trừ tiền N lần, gửi hành trang và báo "Mua thành công xN" 1 lần; tab đặc biệt 30/44/45/49/59–62, shop kỹ năng, item 711/521/1523/1524 gọi `buyItem` N lần). Client cần `patch-mua-nhanh.ps1`.
- Santa (`npc_list/Santa.java`, npc 39, map 5/13/20): Cửa hàng `SANTA`, Giảm giá 80% (có phiếu 459), Mở rộng hành trang, Gift code, Hạn sử dụng, Hớt tóc `SANTA_HEAD`, Danh hiệu, **Shop thỏi vàng** `SANTA_THOI_VANG` (id 37, tab 64, Bình hút năng lượng 1795 giá 100 thỏi vàng, option 250:0). Shop VIP (`SHOP_VIP`, type 3, giá thỏi vàng) mở ở Chi Chi.
- Bán đồ (`showConfirmSellItem`/`sellItem`): đồ thường giá `item_template.gold / 4`; thỏi vàng 457 mở form nhập `Input.createFormBanSLL` (gói `-125`, 37 triệu vàng/thỏi, xử lý `Input` case `BANSLL`). Client: form `-125` là màn hình riêng, đã vá để không đóng cửa hàng (`client-patch/CLIENT-UNITY.md`).

## Bảo trì tự động (`server/AutoMaintenance.java`, `Maintenance.java`)
- Bật sẵn lúc khởi động (`ServerManager` dòng ~118, chạy luồng 2 lần → thông báo có thể lặp). 4:30 sáng: báo mỗi 15 giây trong 5 phút, rồi đếm ngược 60 giây, lưu người chơi/bang/ký gửi rồi `System.exit`.
- Lệnh console server (cửa sổ `run.bat`, không phải chat game): `bt` bảo trì sau 5 giây, `tat`/`bat` tắt/bật bảo trì tự động (tới lần khởi động sau). Trong game chỉ admin bảo trì được: chat `a` → nút "Bảo trì" → hỏi lại "Đồng ý/Hủy" (`ConstNpc.MENU_ADMIN_XAC_NHAN_BAO_TRI`, thêm 30/10/2026) → 5 giây.
- `run.bat` chạy lặp: server tắt thì 10 giây sau tự chạy lại (thay bản build mới nếu có).

## Hirudegarn (`mob_bigboss/Hirudegarn.java`)
- Quái to map 126, 3 mạng, hồi 10 phút. Đang tạm tắt (`DISABLED = true`: luôn chết, không hồi sinh, không rơi đồ). Giữ con quái trong danh sách để không lệch thứ tự quái của map (client dùng chỉ số quái).

## Bản đồ kho báu (`map/phoban/BanDoKhoBau.java`, `services_dungeon/TreasureUnderSeaService.java`, NPC Quy Lão Kame "Kho báu dưới biển")
- Điều kiện: có bang, sức mạnh ≥ 200 triệu (`POWER_CAN_GO_TO_DBKB`, sửa 30/10/2026, gốc 2 tỷ; admin bỏ qua), có **Bản đồ kho báu (611)** trong hành trang (mở thì mất 1). Chọn cấp 1–110 (`Input.createFormChooseLevelBDKB`). Không cần thời gian vào bang, không cần số thành viên. Mỗi bang 1 hang mở cùng lúc; thành viên khác vào bằng "Đồng ý" ở Quy Lão. Mỗi người vào tối đa 3 hang/ngày (`timesPerDayBDKB`, qua 0h reset). Tối đa 50 hang cùng lúc.
- Nguồn 611: boss doanh trại (Trung úy Xanh Lơ 100% x1–3, Trung úy Thép và Ninja áo tím 30% x1–2). Không bán ở shop.
- Map 135 Động hải tặc, 136 Hang Bạch Tuộc, 137 Động kho báu, 138 Cảng hải tặc (`isMapBanDoKhoBau`). Bay vào bằng hiệu ứng tàu (`ChangeMapService.goToDBKB`).
- 30 phút (`TIME_BAN_DO_KHO_BAU`). Giết hết quái + boss (hoặc còn 1 phút) → báo "Cái hang này sắp sập…" mỗi 10 giây, 60 giây sau đưa về map 5 (Đảo Kamê). Lúc kết thúc ghi thành tích bang (cấp cao nhất, thời gian nhanh nhất) cho Top bang/Thành tích bang ở Quy Lão.
- Chỉ số theo **cấp** (không theo người chơi): bẫy map 135 sát thương cấp × 100.000. Map 135–137: quái HP = cấp × 469.799 × tempId, sát thương cấp × 200 × tempId; quái to (thứ tự 5, 10 ở map 135; 5 ở 136, 137) sát thương × 30. Map 138: HP cấp × 15.539.950 × tempId, sát thương cấp × 1.550 × tempId. Trần int (~2,1 tỷ).
- Boss: Trung úy Xanh Lơ (`boss/ban_do_kho_bau/TrungUyXanhLo.java`) ở map 137, sát thương cấp × 200.000 (trần 200 triệu), HP cấp × 20 triệu (trần 2 tỷ). Chết: 100% Bí ngô 4 sao (705, chỉ người giết nhặt) + 5 điểm sự kiện.
- Quái trong hang (mọi phó bản, `Mob.getItemMobReward`, `isMapPhoBan`): 1% rơi 80.000–200.000 vàng (×1,15 nếu dùng Cỏ bốn lá). Tiềm năng đánh quái trong hang ×3 (`NPoint`, gốc ×1,5).
- Không có rương thưởng riêng (Rương gỗ 570 là quà Đại hội võ thuật, `GhiDanh`).

## Tiềm năng sức mạnh (TNSM) khi đánh (`player/NPoint.calSucManhTiemNang`, ~dòng 1672)
- Hệ số toàn server: `server.expserver` trong `Teamobi2026/Config.properties` (đang 3) → `Manager.RATE_EXP_SERVER` (kiểu byte, tối đa 127), nhân ở cuối (`tiemNang *= RATE_EXP_SERVER`). Đổi số này rồi khởi động lại server, không cần build.
- Chỉ cộng khi sức mạnh chưa chạm giới hạn (`power < getPowerLimit()`). Thứ tự: % TNSM từ đồ (`tlTNSM`) → cộng theo `tn` gốc: bùa Trí tuệ +1, Trí tuệ x3 +3, Trí tuệ x4 +4 (đã sửa lỗi cộng 2 lần 30/10/2026; đệ tử dùng bùa trí tuệ của sư phụ), VIP thời gian (`timevip`) +3, Chibi loại 2 +2, tài khoản `vip` > 0 +3, item Đuôi khỉ/`isUseDK` +2, map kho báu có `isUseKhoBauX2` +2 (Rađa kho báu 1532: 30 phút `ItemTime.TIME_MAY_DO2`, icon thời gian 12834, đang dùng mà dùng tiếp thì cộng thêm 30 phút, cộng dồn trong túi `is_up_to_up=1`, `UseItem.useItemTime`), vệ tinh trí tuệ +1/5, nội tại 24 +param%; sức mạnh ≥ 60 tỷ −80%; đệ tử: chủ dùng Bùa Santa +2, `tlTNSMPet`. Đệ tử là `Player` riêng nên `charms`, `timevip`, `itemTime`, `satellite`, `intrinsic` là của đệ (trống), riêng bùa Trí tuệ/x3/x4 lấy `master.charms` (sửa 30/10/2026). VIP thời gian, Đuôi khỉ, rađa kho báu, vệ tinh, nội tại của sư phụ **không** cộng cho đệ; đệ chỉ ăn `vip` tài khoản của chủ (+3), Bùa Santa (+2), `tlTNSMPet` của chủ (+tn×(100+x)/100) và `tlTNSM` từ đồ đệ mặc. Đệ đánh thì sư phụ nhận lại cùng lượng (chủ ≥ 40 tỷ nhận 1/12, `Service.addSMTN`).
- Nhân theo map: Ngũ Hành Sơn 122–124 ×2 (gốc ×1), map lạnh 105–110 ×5, Bản đồ kho báu 135–138 ×3 (gốc ×1,5) (×10 toàn map 0–163 đang comment). Cờ PK: cờ 8 +10%, cờ khác +5%.
- Cuối cùng `calSubTNSM` chia theo sức mạnh: ≥ 40 tỷ /30, ≥ 50 tỷ /40, ≥ 60 tỷ /50, ≥ 80 tỷ /90, ≥ 90 tỷ /100.
- Danh sách map (id, tên, hành tinh): mục "Map" trong [ID-GAME.md](ID-GAME.md).

## Đồ Hủy Diệt (650–662) và yêu cầu sức mạnh
- Yêu cầu sức mạnh khi mặc (`InventoryService.putItemBody`): `power_require` của template (đồ Thần 555–567 và Hủy Diệt đều = 0), nhưng món có **option 21** thì lấy `param × 1 tỷ`. Đồ Thần rơi từ boss có 21:15–17 (`ItemService` ~dòng 949/1079), Thiên Sứ `DoThienSu` 21:30, `otpts` 21:80 (không ai gọi).
- Hủy Diệt chỉ bán ở shop `BILL` (shop 11, NPC Bill 55 ở map 48 Hành tinh Kaio; tab 21 Trái Đất, 22 Namếc, 23 Xayda). Giá vàng: áo 800 tr, quần 1 tỷ, găng/nhẫn 2 tỷ, giày 720 tr. `ShopService.buyItemHD`: cần mặc đủ 5 món Thần (cấp 13), trừ 99 thức ăn (663–667: Bánh Pudding, Xúc xích, Kem dâu, Mì ly, Sushi), chỉ số gốc cộng ngẫu nhiên 0–15%, thêm option 30 (không giao dịch), **không thêm option 21 nên không yêu cầu sức mạnh**. Dòng item_shop 572 (Găng 657, tab 26) mồ côi vì tab 26 không còn.
- **Lỗi (chưa sửa)**: `Bill.confirmMenu` "Nói chuyện" → "OK" đặt `indexMenu` = 100, nhưng nhánh map 48 chỉ xử lý `BASE_MENU` và 10; nhánh mở shop lại nằm ở `case 2` của `switch (mapId)` (map 2) với `select == 100`. Nên không mở được shop Hủy Diệt. Ngày 30/10/2026 không ai có đồ Hủy Diệt.

## Đồ Thiên Sứ (1048–1062) (`combine/CheTaoTrangBiThienSu.java`, `ItemService.DoThienSu`, NPC `npc_list/Whis.java`)
- Món: áo 1048–1050, quần 1051–1053, găng 1054–1056, giày 1057–1059, nhẫn 1060–1062 (thứ tự Trái Đất, Namếc, Xayda). Avatar 1063–1065 không chế tạo ở đây.
- NPC Whis (56) ở map 48 Hành tinh Kaio và 154 Hành tinh Bill: "Cửa hàng" `THIEN_SU` (shop 20, tab 37, giá thỏi vàng `icon_spec` 4028, đều không giao dịch): Đá nâng cấp 1–5 (1074–1078) 1–5 thỏi, Đá may mắn 1–5 (1079–1083) 1–5 thỏi, Công thức 1071–1073 10 thỏi, Công thức VIP 1084–1086 20 thỏi. "Chế tạo" chỉ mở khi **mặc đủ 5 món Hủy Diệt** (`SetClothes.checkSetDes`).
- Mảnh: 1066 áo, 1067 quần, 1068 giày, 1069 nhẫn, 1070 găng (cộng dồn). Rơi khi giết quái map 155 Hành tinh ngục tù (Osin map 50 → 154 Hành tinh Bill → Osin → 155) **chỉ khi mặc đủ 5 món Hủy Diệt**: 10% (+2/555 nếu tài khoản active) (`Mob.java` ~1035). Hộp quà giáng sinh 648: 1/7 ra 1–5 mảnh ngẫu nhiên. Rương Mảnh Thiên Sứ 1173 không có code mở.
- Chế tạo (viết lại 31/10/2026, `CheTaoTrangBiThienSu`): đúng 4 món = 1 công thức (thường 1071–1073 hoặc VIP 1084–1086) + ≥ 999 mảnh cùng loại + 1 đá nâng cấp + 1 đá may mắn. Bấm "Nâng cấp" ở khung (gói `-81`) → `showInfoCombine` chỉ kiểm tra và hiện xác nhận của Whis (menu 515, báo đúng món thiếu/thừa) → chọn "Nâng cấp" → `startCombine` → `CheTaoTS`: 10 triệu vàng; thành công VIP 90% / thường 50% + cấp đá nâng cấp (1–5); thành công thì mọi option trừ 20, 21, 30 ×2 (kể cả sức đánh); Đá may mắn cấp n: `nextInt(0,50) ≤ 5+5n` thêm option 15 + 1–3 dòng ngẫu nhiên trong 50/77/103/94/5 (1–3). Thất bại vẫn mất 1 công thức, 1 đá mỗi loại, 999 mảnh. Loại đồ theo loại mảnh, hành tinh theo công thức (gender > 2 thì theo người chơi). Nhánh cũ dùng món Hủy Diệt đã bỏ.
- Chỉ số gốc (`DoThienSu`; "×1,1" là hành tinh được ưu ái): áo giáp 2.800–4.000 (Xayda ×1,1); quần HP 120–130K (80%) hoặc 130–150K (Trái Đất ×1,1); găng sức đánh 10.350–11.000 (80%) hoặc 10.500–11.500 (Xayda ×1,1); giày KI 90–110K (80%) hoặc 110–130K (Namếc ×1,1); nhẫn chí mạng 18–20% (Namếc ×1,1). Thêm option 21:60 (**yêu cầu 60 tỷ sức mạnh**, sửa 31/10/2026) và 30 (không giao dịch). Khi chế tạo qua ô (`showInfoCombine`) thành công thì mọi option trừ 20, 21, 30 bị ×2 (kể cả sức đánh). Đồ Hủy Diệt mua ở Bill cũng được gắn 21:60 (`ShopService.buyItemHD`).
- Ngày 30/10/2026 không ai có đồ Thiên Sứ; cả chuỗi bị chặn vì không mua được Hủy Diệt (lỗi Bill ở mục trên).

## Nguồn tăng tiềm năng sức mạnh (ai được hưởng, lấy ở đâu) (lập 31/10/2026)
Công thức ở mục "Tiềm năng sức mạnh". Giá: shop thường `type_sell` 0 vàng / 1 ngọc; shop type 3 trả vật phẩm theo `icon_spec` (4028 = thỏi vàng).
- **Chỉ sư phụ:**
  - Bùa Trí Tuệ 213 (+1), x3 671 (+3), x4 672 (+4): NPC Bà Hạt Mít (npc 21) shop `BUA_1H` / `BUA_8H` / `BUA_1M` (213: 5/20/500 ngọc; 671: 15/60/1500; 672: 45/180/4500). **Đệ cũng hưởng bùa của sư phụ** (sửa 30/10/2026).
  - Đuôi khỉ 1045 (+2, 30 phút `TIME_DK`): rơi từ boss sự kiện Trung thu Khỉ Đột (`boss/event_trung_thu/KhiDot.java`), không bán.
  - Rađa kho báu 1532 (+2, chỉ trong Bản đồ kho báu 135–138, 30 phút): Santa (npc 39) shop `SANTA`, 2 ngọc.
  - Vệ tinh trí tuệ 343 (+1/5, đặt ra map): Uron (npc 16) shop `URON`, 5 ngọc.
  - Option 101 "+#% TN,SM" / 88 "Cộng #% exp khi đánh quái" / 156 (giảm 50% SĐ/HP/KI, +#% SM, TN, vàng) trên đồ đang mặc (`tlTNSM`): Cải trang 461 (101:10) Santa `SANTA` 2000 ngọc; Cải trang 452 (101:20) `SANTA_GIAM_GIA_1` 400 ngọc; Pet Zịt vàng bối rối 1631 (101:10) `SHOP_CHI_CHI` 1,5 tỷ vàng, `SHOP_VIP` 150 thỏi, `SHOP_CLAN`; Avatar 683/687/690 (156:50) `URON` 599 ngọc; sao pha lê 447 ép vào đồ (101:5); balo pet 1360 (101:20) thưởng KOL ở Quy Lão Kame (`QuyLaoKame` ~dòng 549).
  - Nội tại 24 (+param%), VIP thời gian `timevip` (+3).
- **Cả hai:** tài khoản `vip` > 0 (+3, đệ lấy theo tài khoản chủ).
- **Chỉ đệ tử:**
  - Bùa x2 tn,sm đệ tử 1628 (`isUseBuaSanta`, +2 cho đệ, 30 phút `TIME_BUA_SANTA`, dùng tiếp thì +30 phút): Santa shop `SANTA`, 5 ngọc.
  - Option 160 "TNSM PET" trên đồ **sư phụ** mặc (`tlTNSMPet`, đệ +tn×(100+x)/100): Cải trang Mabư Còm 1255 (160:30) Santa `SANTA` 5000 ngọc; Cánh thiên thần 3 1531 (160:30) `SANTA_HAN_SU_DUNG` 129 triệu vàng, `SHOP_VIP` 100 thỏi.
- Hệ số theo map (cả hai): Ngũ Hành Sơn 122–124, map lạnh 105–110, Bản đồ kho báu 135–138, cờ PK (mục "Tiềm năng sức mạnh").

## Đổi khu (`map/service/ChangeMapService.openZoneUI` / `changeZone`)
- Người thường không đổi khu được ở: map loại offline (`type` 1, nhà 21–23…), phó bản (`isMapPhoBan`: doanh trại 53–62, kho báu 135–138, con đường rắn độc 141–144, khí gas 147–152 trừ 150), Mabư 114–120, Mabư 2H 127–128. **Admin và boss bỏ qua mọi chặn** (nên admin thử thấy vẫn đổi được). Chờ 5 giây giữa 2 lần đổi. Cột `zones` trong `map_template` đang = 10 cho mọi map.

## Tiềm năng đánh quái phụ thuộc HP quái (`Mob.injured`, `Mob.getTiemNangForPlayer`)
- Sát thương bị cắt bằng HP còn lại của quái (quái đầy máu không chết 1 đòn: còn 1 HP). Tiềm năng gốc = sát thương thực gây ra + HP max × 0,0005, chia (chênh cấp × 0,5 + 1,25), rồi nhân các hệ số ở mục TNSM. Người cao hơn quái **quá 5 cấp** thì tiềm năng gốc = 1, **trừ phó bản** (sửa 30/10/2026: quái kho báu luôn cấp 8 dù chỉ số theo cấp hang; người ≥ 40 tỷ là cấp 14 nên trước đây chỉ được vài điểm). Cấp người theo sức mạnh (`Service.getCurrLevel`): < 10 tỷ cấp 12, < 40 tỷ cấp 13, < 50,01 tỷ cấp 14, rồi +1 mỗi 10 tỷ tới cấp 19. Nên đánh mạnh vào quái ít máu thì phần lớn sát thương bị bỏ: map lạnh 105–110 quái 1,35–1,5 triệu HP (×5), kho báu quái HP = cấp × 469.799 × tempId (hàng trăm triệu – 2,1 tỷ, ×3) nên mỗi đòn ăn đủ sát thương.

## Nâng tiềm năng đệ tử (`player/Pet.java`, `NPoint.increasePoint`, `server/Controller.java`)
- Đệ tự cộng: `Pet.increasePoint` mỗi lần `update` cộng ngẫu nhiên 20 lần ×1 điểm vào HP/KI/SĐ/Giáp/Chí mạng (giữ nguyên theo ý user 30/10/2026), nên tiềm năng đệ thường gần hết.
- Nâng tay: client gửi `-30` sub 18 (loại, số điểm) → `pet.nPoint.increasePoint(type, point, sư phụ)` (thông báo lỗi gửi cho sư phụ; đệ tự cộng thì không báo) → `showInfoPet`. Chi phí giống sư phụ.
- Gói `-107` loại 2 (`Service.showInfoPet`): client mod chỉ cập nhật dữ liệu, không mở khung. Client mở khung đệ thì gửi `-107` → server ghi `Player.lastTimeXemDeTu`; trong 5 phút sau đó `Pet.sendInfoToMaster` gửi lại khi số liệu đệ đổi, tối đa 1 lần/giây (gói này làm client `InfoDlg.hide` nên không gửi lúc không xem).

## Khí Gas Hủy Diệt / Destron Gas (`map/phoban/DestronGas.java`, `services_dungeon/DestronGasService.java`, NPC `npc_list/MrPoPo.java`)
- Vào: Mr PoPo làng Aru (map 0) → "OK" → nhập cấp 1–110 (`Input.CHOOSE_LEVEL_KGHD`). Bang chủ mở; cần vào bang ≥ 2 ngày (`DestronGasService.java:48`, `MrPoPo.java:55`) và đã mở thành viên. Thành viên khác gặp Mr PoPo để đi theo.
- Giới hạn: mỗi bang 3 lần/ngày (`timesPerDayKGHD > 3`), cả server 50 phó bản cùng lúc (`AVAILABLE`), 30 phút (`TIME_KHI_GAS_HUY_DIET`). `POWER_CAN_GO_TO_KHI_GAS_HUY_DIET` (2 tỷ) không được kiểm tra ở đâu; `N_PLAYER_CLAN = 0` nên bang 1 người vào được (câu "ít nhất 5 thành viên" ở MrPoPo không bao giờ hiện).
- Map 147 Sa mạc, 148 (map boss), 149 Thành phố Santa, 151 Hành tinh bóng tối, 152 Vùng đất băng giá (`MapService.isMapKhiGasHuyDiet`, 150 không thuộc). Phải hết quái + boss map hiện tại mới sang map khác.
- Số quái lấy từ DB `map_template.mobs` (`[temp, level, hp, x, y]`, nạp ở `Map.java:162`), code không thêm/bớt: 147 Sa mạc 17 con (73×7, 75×8, 76×2), 148 Lâu đài Lychee 11 (73×3, 74×3, 75×5), 149 Thành phố Santa 14 (74×7, 75×6, 76×1), 151 Hành tinh bóng tối 9 (73×2, 74×2, 75×4, 76×1), 152 Vùng đất băng giá 30 (73×8, 74×7, 75×13, 76×2). Tổng 81. Bớt quái thì giữ con đứng vị trí quái mạnh (chọn theo thứ tự trong `init()`); sửa DB phải khởi động lại server.
- Đang thử nghiệm: máu + sát thương quái và 2 boss chia `DestronGas.GIAM = 20` (gốc 1, xem [GIA-TRI-GOC.md](GIA-TRI-GOC.md)); số dưới đây và bảng mục 7a BOSS-ROI-DO.md là số gốc.
- Quái (`DestronGas.init()`): thường sát thương Lv×155×tempId, máu Lv×225×tempId; quái mạnh (quái đầu ở 147/151/152, thứ 8 ở 149, thứ 34 ở 152) sát thương ×10, máu Lv×201.000×tempId. Còn Cỗ máy hủy diệt (quái 76) sống thì Liên hoàn/Antomic/Masenko/Kamejoko chỉ gây 1 (`Mob.java:132`).
- Hết quái mọi map → Dr Lychee ở map 148 → chết thì Hatchiyack → chết (hoặc còn 1 phút) báo "Nơi này sắp nổ tung", 60 giây sau về làng Aru. Chỉ số boss và phần thưởng theo cấp: mục 7a [BOSS-ROI-DO.md](BOSS-ROI-DO.md).

## Ngũ Hành Sơn (map 122–124)
- 3 map chỉ nối với nhau (122 ↔ 124 ↔ 123), không có cổng từ ngoài. Dịch chuyển (Yardrat, `ChangeMapService.checkMapCanJoinByYardart`) chặn mọi người trừ admin và boss.
- Vào/ra (sửa 30/10/2026): NPC **Ngộ Không** (48, `npc_list/NgoKhong.java`) ở Làng Aru map 0 x 800 → "Đến Ngũ Hành Sơn" đưa tới map 122 (x 900–1000, y 408); Ngộ Không trong map 122 (x 979) và **Đường Tăng** (49, `npc_list/DuongTang.java`, map 122 x 1060, map 123 x 140) → "Về Làng Aru" (map 0 x 750–850). Không có điều kiện (sức mạnh, phí). DB không theo git, máy khác chạy: `UPDATE map_template SET npcs='[[7,228,432],[67,590,432],[74,426,432],[84,950,432],[48,800,432]]' WHERE id=0;`
- Quái: 122 Quỷ chim (50) + Khỉ lông vàng (57), 123 Khỉ lông đỏ (56), 124 Khỉ lông vàng; level 20, HP 400–500 nghìn. TNSM ×2 riêng (×6 tính cả ×3 server).

## Mở rộng hành trang / rương (`InventoryService` ~dòng 815, `player/Inventory.java`)
- Dùng item 517 thêm 1 ô hành trang, 518 thêm 1 ô rương. Tối đa `MAX_ITEMS_BAG` = 125 (gốc 80), `MAX_ITEMS_BOX` = 130 (gốc 100), sửa 31/10/2026. Item shop 1627 (hành trang) giá tăng theo số ô trên 35 (`ShopService` ~dòng 72).
- Rương > 127 ô cần client đã chạy `patch-o-ruong.ps1` (xem `client-patch/CLIENT-UNITY.md`).

## Hộp quà giáng sinh (648) (`UseItem.NoelItemBox`)
- Cần 1 ô trống hành trang, không có thì báo "Hàng trang đã đầy" và không mất hộp.
- Sửa 31/10/2026: chia đều 3 nhóm (~33,3% mỗi nhóm, trong nhóm chia đều): Cuồng nộ/Bổ huyết/Bổ khí/Giáp Xên 381–384 (1–5 cái) · Ngọc rồng băng 1–7 sao 925–931 (1) · Mảnh Thiên Sứ 1066–1070 (50–100 mảnh). Đã bỏ ngọc xanh, sao pha lê 441–445, ngọc rồng 4–7 sao 17–20, kẹo giáng sinh 533, capsule kì bí 380.
- Nhánh cải trang Noel 387–393, tuần lộc 936, cây thông 822, xe trượt tuyết 746, 821 có trong code nhưng không nằm trong danh sách quay nên không bao giờ ra.

## Nhiệm vụ KOL (Quy Lão Kame, `npc_list/QuyLaoKame.java`) và điểm sự kiện
- KOL **không reset**, không phải nhiệm vụ ngày/tuần: làm tuần tự 7 nhiệm vụ (`kolQuestStage`, lưu cùng người chơi), xong nhận thưởng thì sang nhiệm vụ kế, hết 7 là hết. KOL thường và KOL VIP (`kolVIPQuestStage`) chạy riêng. VIP cần có **Vé Nhiệm Vụ KOL VIP (1825)** trong hành trang (chỉ kiểm tra, không trừ vé). 1825 **chưa có nguồn**: không shop bán, không code cho rơi (chỉ admin cấp).
- Bộ đếm: Nhiệm vụ 3 `destronGas70CompletionCount` (khí gas cấp ≥ 70, `DestronGas.java`), 4 `martialArtsTournamentWins` (đại hội võ thuật), 5 `dailySuperHardQuestCompletionCount` (nhiệm vụ phụ độ khó địa ngục `ConstTask.HELL`, tính ở `TaskService.paySideTask`, thêm 31/10/2026 vì trước đó không ai cộng nên không làm được), 6 `bossBabyDefeatParticipationCount` (`Baby.java`), 7 `monsterKillCountAutoTrain` (`Mob.java`, mọi quái giết ở map `AllMap`).
- Điểm sự kiện: `player.event.addEventPoint(n)` khi giết boss (`reward()` của từng boss, đa số +5, 4 boss +1; Rồng Nhi/Trung úy Xanh Lơ BDKB +5…). Đổi ở Quy Lão (shop `SHOP_DOI_DIEM`, id 34, giá = điểm sự kiện, icon_spec 14116): Hộp quà Goku Day VIP 1840 (99), 1757 (99), Trứng vàng rồng nhí 1821 (199), 1731 (999)…; shop `SHOP_SU_KIEN_VL` đổi Rađa ngọc rồng 1822 (19 điểm).

## Cộng dồn vật phẩm (`InventoryService.addItemList`)
- Chỉ cộng dồn khi `item_template.is_up_to_up = 1` và **option giống hệt nhau**. Đổi cờ này thì tăng `DataGame.vsItem` để client tải lại. Đã bật cho 1628 (Bùa x2 tn,sm đệ tử) và 1045 (Đuôi khỉ) ngày 31/10/2026. Đuôi khỉ bán ở Santa "Shop thỏi vàng" là **579** (2 thỏi vàng, item_shop 1000), cùng tác dụng với 1045.

## Chiến đấu của quái thường (`mob/Mob.java`)
- Khiên năng lượng (`effectSkill.isShielding`): quái thường đánh chỉ gây 1 sát thương (10 trong phó bản) và **không** làm vỡ khiên (`Player.injured` chỉ vỡ khiên với đòn không phải quái). Trước 31/10/2026 quái bỏ qua khiên, đánh đủ sát thương. Quái to (`mob_bigboss`) vẫn gọi `injured` riêng, chưa đổi.
- Bản đồ kho báu (`isMapBanDoKhoBau`, map 135–138): quái không đuổi đánh người đã đánh nó (bỏ `getFirstPlayerCanAttack`, tầm 300), chỉ đánh người đứng cách ≤ `BDKB_MOB_RANGE` (60, chỗ khác là 100).
- Người chơi đã chết: `UseItem.doItem` chặn dùng/vứt vật phẩm (DO_USE/ACCEPT_USE/DO_THROW/ACCEPT_THROW). Chưa kiểm tra: mua shop, giao dịch, ký gửi, đập đồ, chuyển map khi đã chết.
