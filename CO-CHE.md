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
- Chỉ cộng khi sức mạnh chưa chạm giới hạn (`power < getPowerLimit()`). Thứ tự: % TNSM từ đồ (`tlTNSM`) → cộng theo `tn` gốc: bùa Trí tuệ +1, Trí tuệ x3 +3, Trí tuệ x4 +4 (đã sửa lỗi cộng 2 lần 30/10/2026; đệ tử dùng bùa trí tuệ của sư phụ), VIP thời gian (`timevip`) +3, Chibi loại 2 +2, tài khoản `vip` > 0 +3, item Đuôi khỉ/`isUseDK` +2, map kho báu có `isUseKhoBauX2` +2 (Rađa kho báu 1532: 30 phút `ItemTime.TIME_MAY_DO2`, icon thời gian 12834, đang dùng mà dùng tiếp thì cộng thêm 30 phút, cộng dồn trong túi `is_up_to_up=1`, `UseItem.useItemTime`), vệ tinh trí tuệ +1/5, nội tại 24 +param%; sức mạnh ≥ 60 tỷ −80%; đệ tử: chủ dùng Bùa Santa +2, `tlTNSMPet`. Đệ tử là `Player` riêng nên `charms`, `timevip`, `itemTime`, `satellite`, `intrinsic` là của đệ (trống), riêng bùa Trí tuệ/x3/x4 lấy `master.charms` (sửa 30/10/2026). VIP thời gian, rađa kho báu, vệ tinh, nội tại của sư phụ **không** cộng cho đệ; **Đuôi khỉ của sư phụ cộng cho đệ (+2, từ 31/10/2026)**, bùa x3 đệ tử 1826 (item `isUseBuaDeX3`, +3, 1 giờ/lần, cộng dồn, ghi ở `item_time` idx 30) cũng vậy; đệ chỉ ăn `vip` tài khoản của chủ (+3), Bùa Santa (+2), `tlTNSMPet` của chủ (+tn×(100+x)/100) và `tlTNSM` từ đồ đệ mặc. Đệ đánh thì sư phụ nhận lại cùng lượng nhân 3 (từ 31/10/2026; chủ ≥ 40 tỷ nhận 1/12 rồi nhân 3, `Service.addSMTN`).
- Nhân theo map: Ngũ Hành Sơn 122–124 ×2 (gốc ×1), map lạnh 105–110 ×5, Bản đồ kho báu 135–138 ×3 (gốc ×1,5) (×10 toàn map 0–163 đang comment). Cờ PK: cờ 8 +10%, cờ khác +5%.
- Cuối cùng `calSubTNSM` chia theo sức mạnh: ≥ 40 tỷ /30, ≥ 50 tỷ /40, ≥ 60 tỷ /50, ≥ 80 tỷ /90, ≥ 90 tỷ /100.
- Danh sách map (id, tên, hành tinh): mục "Map" trong [ID-GAME.md](ID-GAME.md).

## Đồ Hủy Diệt (650–662) và yêu cầu sức mạnh
- Yêu cầu sức mạnh khi mặc (`InventoryService.putItemBody`): `power_require` của template (đồ Thần 555–567 và Hủy Diệt đều = 0), nhưng món có **option 21** thì lấy `param × 1 tỷ`. Đồ Thần rơi từ boss có 21:15–17 (`ItemService` ~dòng 949/1079), Thiên Sứ `DoThienSu` 21:30, `otpts` 21:80 (không ai gọi).
- Hủy Diệt chỉ bán ở shop `BILL` (shop 11, NPC Bill 55 ở map 48 Hành tinh Kaio; tab 21 Trái Đất, 22 Namếc, 23 Xayda). Giá vàng: áo 800 tr, quần 1 tỷ, găng/nhẫn 2 tỷ, giày 720 tr. `ShopService.buyItemHD`: cần mặc đủ 5 món Thần (cấp 13), trừ 99 thức ăn (663–667: Bánh Pudding, Xúc xích, Kem dâu, Mì ly, Sushi), chỉ số gốc cộng ngẫu nhiên 0–15%, thêm option 30 (không giao dịch), **không thêm option 21 nên không yêu cầu sức mạnh**. Dòng item_shop 572 (Găng 657, tab 26) mồ côi vì tab 26 không còn.
- **Lỗi (chưa sửa)**: `Bill.confirmMenu` "Nói chuyện" → "OK" đặt `indexMenu` = 100, nhưng nhánh map 48 chỉ xử lý `BASE_MENU` và 10; nhánh mở shop lại nằm ở `case 2` của `switch (mapId)` (map 2) với `select == 100`. Nên không mở được shop Hủy Diệt. Ngày 30/10/2026 không ai có đồ Hủy Diệt.
- **Bà Hạt Mít (map 5 Đảo Kame) đổi đồ** (thêm 31/10/2026, `combine/DoiDoBaHatMit.java`, tab `CombineService.DOI_THAN_LINH_HUY_DIET` 998 / `DOI_HUY_DIET_KICH_HOAT` 999, 2 nút cuối menu; thỏi vàng 457 lấy từ hành trang, không cần đặt vào khung; thành công 100%):
  - Thần Linh → Hủy Diệt: đặt đúng 1 món Thần Linh (555–567) + 10 thỏi vàng → món Hủy Diệt cùng loại và hành tinh (id + 95). Chỉ số gốc lấy từ item_shop (`ItemService.getListOptionItemShop`, như shop Bill), mỗi chỉ số `optionCanUpgrade` (0, 14, 22, 23, 27, 28, 47) cộng thêm ngẫu nhiên 5–15% (cùng mức cho cả món, tối thiểu +1), thêm 21:60 và 30, bỏ option 164. Món Thần Linh bị mất; chỉ số cũ của nó không mang sang.
  - Hủy Diệt → Kích hoạt: đặt đúng 3 món Hủy Diệt (650–662, loại nào cũng được) + 20 thỏi vàng → 1 món kích hoạt ngẫu nhiên như capsule (`ItemService.randomItemSKH`, dùng chung bảng với `OpenSKH`/`OpenVeTangNgoc`): loại (áo/quần/găng/giày/rada) và hành tinh theo món đặt đầu tiên trong khung (`itemsCombine.get(0)`); nhẫn Hủy Diệt (gender 3) thì theo hành tinh người chơi.

## Đồ Thiên Sứ (1048–1062) (`combine/CheTaoTrangBiThienSu.java`, `ItemService.DoThienSu`, NPC `npc_list/Whis.java`)
- Món: áo 1048–1050, quần 1051–1053, găng 1054–1056, giày 1057–1059, nhẫn 1060–1062 (thứ tự Trái Đất, Namếc, Xayda). Avatar 1063–1065 không chế tạo ở đây.
- NPC Whis (56) ở map 48 Hành tinh Kaio và 154 Hành tinh Bill: "Cửa hàng" `THIEN_SU` (shop 20, tab 37, giá thỏi vàng `icon_spec` 4028, đều không giao dịch): Đá nâng cấp 1–5 (1074–1078) 1–5 thỏi, Đá may mắn 1–5 (1079–1083) 1–5 thỏi, Công thức 1071–1073 10 thỏi, Công thức VIP 1084–1086 20 thỏi. "Chế tạo" chỉ mở khi **mặc đủ 5 món Hủy Diệt** (`SetClothes.checkSetDes`).
- Mảnh: 1066 áo, 1067 quần, 1068 giày, 1069 nhẫn, 1070 găng (cộng dồn). Rơi khi giết quái map 155 Hành tinh ngục tù (Osin map 50 → 154 Hành tinh Bill → Osin → 155) **chỉ khi mặc đủ 5 món Hủy Diệt**: 10% (+2/555 nếu tài khoản active) (`Mob.java` ~1035). Hộp quà giáng sinh 648: 1/7 ra 1–5 mảnh ngẫu nhiên. Rương Mảnh Thiên Sứ 1173 không có code mở.
- Chế tạo (viết lại 31/10/2026, `CheTaoTrangBiThienSu`): đúng 4 món = 1 công thức (thường 1071–1073 hoặc VIP 1084–1086) + ≥ 999 mảnh cùng loại + 1 đá nâng cấp + 1 đá may mắn. Bấm "Nâng cấp" ở khung (gói `-81`) → `showInfoCombine` chỉ kiểm tra và hiện xác nhận của Whis (menu 515, báo đúng món thiếu/thừa) → chọn "Nâng cấp" → `startCombine` → `CheTaoTS`: 10 triệu vàng; thành công VIP 90% / thường 50% + cấp đá nâng cấp (1–5); thành công thì mọi option trừ 20, 21, 30 ×2 (kể cả sức đánh); Đá may mắn cấp n: T = 5+5n, `nextInt(0,50) ≤ T` thì thêm option 15 (param = số dòng) + số dòng bằng: 3 nếu roll ∈ [T−3, T], 2 nếu [T−10, T−4], 1 nếu [0, T−11]. Dòng lấy không trùng trong 50 Sức đánh%, 77 HP%, 103 KI%, 94 Giảm #% sát thương, 5 Chí mạng% (mỗi dòng 1–3, **không bị ×2**). Xác suất có thêm dòng (/51): n=1 11, n=2 16, n=3 21, n=4 26, n=5 31 (trong đó 3 dòng luôn 4/51). Thất bại vẫn mất 1 công thức, 1 đá mỗi loại, 999 mảnh. Loại đồ theo loại mảnh, hành tinh theo công thức (gender > 2 thì theo người chơi). Nhánh cũ dùng món Hủy Diệt đã bỏ.
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
- Đệ tự cộng: `Pet.increasePoint` mỗi lần `update` cộng ngẫu nhiên 20 lần ×1 điểm vào HP/KI/SĐ (`Util.nextInt(0, 2)`, từ 31/10/2026; trước đó có cả giáp và chí mạng gốc), nên tiềm năng đệ thường gần hết. Giáp/chí mạng gốc của đệ chỉ tăng khi sư phụ nâng tay.
- Sửa chỉ số đệ bằng SQL (đọc/sửa cột `pet`, phải để sư phụ offline): xem [DB.md](DB.md) mục "Sửa chỉ số đệ tử".
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
- Chỉ cộng dồn khi `item_template.is_up_to_up = 1` và **option giống hệt nhau**. Đổi cờ này thì tăng `DataGame.vsItem` để client tải lại. Đã bật cho 1628 (Bùa x2 tn,sm đệ tử) và 1045 (Đuôi khỉ) ngày 31/10/2026, và cho Công thức thiên sứ Namếc/Xayda 1072, 1073 và VIP 1085, 1086 (Trái Đất 1071, 1084 vốn đã bật; `vsItem` = 21). Đuôi khỉ bán ở Santa "Shop thỏi vàng" là **579** (2 thỏi vàng, item_shop 1000), cùng tác dụng với 1045.

## Chiến đấu của quái thường (`mob/Mob.java`)
- Khiên năng lượng (`effectSkill.isShielding`): quái thường đánh chỉ gây 1 sát thương (10 trong phó bản) và **không** làm vỡ khiên (`Player.injured` chỉ vỡ khiên với đòn không phải quái). Trước 31/10/2026 quái bỏ qua khiên, đánh đủ sát thương. Quái to (`mob_bigboss`) vẫn gọi `injured` riêng, chưa đổi.
- Bản đồ kho báu (`isMapBanDoKhoBau`, map 135–138): quái không đuổi đánh người đã đánh nó (bỏ `getFirstPlayerCanAttack`, tầm 300), chỉ đánh người đứng cách ≤ `BDKB_MOB_RANGE` (60, chỗ khác là 100).
- Người chơi đã chết (sửa 31/10/2026): vẫn dùng được vật phẩm. Chặn riêng: đổi khu (`ChangeMapService.changeZone`/`openZoneUI`, chặn lặng lẽ không thông báo theo yêu cầu user), capsule (`UseItem.openCapsuleUI`/`choseMapCapsule`), map riêng tư (`MapRiengTu`) vì `changeMapBySpaceShip` hồi sinh miễn phí khi đang chết, và ăn đậu (`eatPea` cộng HP thẳng làm sống lại không qua hồi sinh). Chưa kiểm tra: mua shop, giao dịch, ký gửi, đập đồ khi đã chết.

## Kame bị "hụt" (dò 31/10/2026)
- `SkillService.useSkillAttack`: Kamejoko/Masenko/Antomic không đặt `miss` theo khoảng cách (chỉ chiêu đấm, Kaioken, Lốc xoáy...). Hụt do server chỉ đến từ bên bị đánh:
  - Mục tiêu là người chơi: `Player.injured` né nếu `tlNeDon − tlchinhxac` của người đánh (chặn trần 90%) trúng; thêm Xinbato (`tlNeDonXinbato`, trần 90%).
  - Mục tiêu là boss: `Util.isTrue(nPoint.tlNeDon, 1000)` (xem BOSS-ROI-DO.md, hiện hầu hết 0%), Dr Lychee/Hatchiyack theo Lv.
  - Quái thường không né.
- Đòn bị bỏ hẳn (client hiện hụt): `useSkill` trả `false` khi đang choáng/trói/ngủ (`isHaveEffectSkill`), mục tiêu chết hoặc không đánh được (`canAttackPlayer`), thiếu KI, chiêu chưa hết hồi.

## Lưu nhân vật và "roll back" (dò 31/10/2026)
- **Đã sửa 31/10/2026** (các ý bên dưới là tình trạng trước khi sửa):
  - `Client.saveAll()` tự lưu mọi người online mỗi `Client.AUTO_SAVE_MINUTES` = 5 phút (bỏ qua khi đang bảo trì).
  - Shutdown hook trong `ServerManager.run` ("Luu khi tat"): đóng cửa sổ / Ctrl+C thì lưu người chơi + bang (không lưu ký gửi vì `save()` TRUNCATE rồi ghi lại). Bảo trì thường đặt `savedOnClose = true` để hook không lưu lần 2. Windows chỉ cho ~5 giây khi đóng cửa sổ console, ít người thì đủ.
  - `PlayerDAO.updatePlayer` khóa `player.saveLock` (thân cũ thành `doUpdatePlayer`, bỏ qua nếu `idMark == null` tức đã dispose); `Client.remove(MySession)` dispose trong cùng khóa. Lỗi lưu ghi thêm ra `Teamobi2026/log/loi_luu_nhan_vat_log.txt`.
  - `MrBlue.login`: đá phiên cũ (lưu xong) rồi mới `select * from player`.
  - `ServerManager.close` không mở `restart_server.bat` nữa; file đó giờ chỉ `exit` (bản jar cũ vẫn gọi).
- Ghi thẳng MySQL qua `LocalManager` (Hikari), không có lớp đệm. `PlayerDAO.updatePlayer` chỉ được gọi khi **thoát** (`Client.remove(Player)` ← `kickSession` ← mất kết nối / bị đá / `Client.close()` lúc bảo trì) và vài chỗ lẻ (bang, Whis, rồng Namek, ngọc đen cho người offline). **Không có tự lưu định kỳ, không có shutdown hook.**
- Hệ quả: server chết hay bị tắt mà không qua bảo trì (đóng cửa sổ `run.bat`, Ctrl+C, crash, hết RAM `-Xmx512m`, tắt/sleep máy) thì mất hết thay đổi từ lúc đăng nhập → vào lại thấy "roll back". Lệnh `bt` và bảo trì 4h30 thì có lưu (`ServerManager.close` → `Client.close` lưu từng người).
- `updatePlayer` lỗi (vd ConcurrentModification do luồng update của người chơi đang sửa túi đồ) chỉ in "Lỗi save player <tên>" ra console, không ghi file → không lưu lần đó.
- `MrBlue.login` nhánh `else` (dòng ~104–116): đọc `select * from player` **trước** rồi mới `kickSession` phiên cũ (phiên cũ lưu xong) và `loadPlayer` từ kết quả đọc cũ → nạp dữ liệu cũ, lần thoát sau ghi đè lên → mất phần chơi ở phiên cũ. Chỉ xảy ra khi tài khoản còn trong `Client` mà `last_time_login <= last_time_logout`.
- `ServerManager.close` chạy `cmd /c start restart_server.bat` (đợi 5 phút rồi `call run.bat`) trong khi `run.bat` đã tự chạy lại sau 10 giây → sau mỗi lần bảo trì có thể có thêm một cửa sổ server thứ 2 (không giữ được port 14446). Bản thứ 2 khi tới bảo trì sẽ `ClanService.close()` + `ConsignShopManager.save()` bằng dữ liệu nó nạp lúc khởi động → có thể ghi đè bang/ký gửi cũ. Kiểm tra: chỉ nên có 1 `java ... Teamobi2026.jar`.

## Đệ tử tự cộng tiềm năng (`Pet.increasePoint`)
- Mỗi lần `Pet.update` (khoảng 1 giây) thử cộng 20 lần, mỗi lần 1 điểm vào loại ngẫu nhiên. Từ 31/10/2026 chỉ chọn 0 HP / 1 KI / 2 SĐ (trước là 0..4 gồm cả 3 giáp gốc, 4 chí mạng gốc). Chạm giới hạn sức mạnh (`getHpMpLimit`/`getDameLimit`) thì loại đó không cộng thêm; giáp/chí mạng của đệ chỉ tăng khi sư phụ nâng tay.

## Capsule kích hoạt 1 món tự chọn (item 1655) — dò 31/10/2026
- Dùng → menu (`UseItem.CapsuleKichHoat`) chọn Áo/Quần/Găng/Giày/Rada → `NpcFactory` case `ConstNpc.CAPSULE_KICH_HOAT` → `ItemService.OpenSKH(player, 1655, select)`. Cần 1 ô trống. Nguồn: ToriBot (2 và 5 viên), tái tạo `TaiTaoCapsuleKichHoat`.
- Món: chọn đều trong danh sách theo hành tinh của người mở (cấp 1→12), set: chọn đều 1 trong 5 (mỗi set 20%). Đồ nhận chỉ số gốc như shop + option set + option phụ của set + `30` (không giao dịch), không có chỉ số ngẫu nhiên.
  - Set TĐ: 127 Thên Xin Hăng, 128 Kirin, 129 Sôngôku, 233 Gohan, 245 Thần Vũ Trụ Kaio. Namek: 130 Picolo, 131 Ốc tiêu, 132 Pikkoro Daimao, 233 Gohan, 237 Nail. Xayda: 133 Kakarot, 134 Ca Đíc, 135 Nappa, 233 Gohan, 241 Cađic M.
  - Mỗi danh sách 12 món → mỗi cấp 1/12 (8,33%). Lệch: TĐ găng thiếu 255 Găng vàng Goku (11 món, 9,09%/món); Namek áo thiếu 234 Áo sắt Tron và Namek găng thiếu 258 Găng sắt Tron (11 món); Xayda quần ghi `174` hai lần (Quần lông Xayda 16,7%) và không có 175 Quần da Xayda. Rada giống nhau cả 3 hành tinh. `OpenVeTangNgoc` dùng y hệt bảng này.

## Chuỗi đá sao pha lê ở Bà Hạt Mít (map 5, "Chức năng pha lê") — dò 31/10/2026
- Sao pha lê cấp 1 (441–447) + 1 Hematite 1423 → cấp 2 (1416–1422): `NangCapSaoPhaLe`, 200 triệu vàng, 10 ngọc, 50%.
- 2 sao cấp 2 cùng màu + 1 Đá mài 1439 → 1 sao lấp lánh (1426–1432), mỗi option +1: `DanhBongSaoPhaLe`, 100 triệu vàng, tỉ lệ 100% (nhánh thất bại không bao giờ chạy; hàm `saoPhaLeLapLanhId` bỏ không).
- 5 sao pha lê cấp 1 cùng màu → Hematite: `TAO_DA_HEMATITE` (nút "Tạo đá Hematite").
- 5 Hematite → 1 Dùi đục 1438 (`CheTaoDuiDuc`, `CombineService.DUI_DUC` 109, 50 triệu vàng, 100%) và 5 Dùi đục → 1 Đá mài (`TaoDaMai`, `DA_MAI` 110): code có nhưng **không NPC nào mở tab** (menu `BaHatMit` không có nút). Nguồn Dùi đục duy nhất trong game: Bánh chưng ở Vua Hùng (`VuaHung.randomBanhChung`, sự kiện) và gift code `danangcap`.
- Cường hóa lỗ sao 8/9 (`CuongHoaLoSaoPhaLe`) cần 1 Hematite + 1 Dùi đục mỗi lần.
- Đồ đục lỗ được (`CombineSystem.isTrangBiPhaLeHoa`, `Item.canPhaLeHoa`): type 0–4 (áo, quần, găng, giày, rada), **5 cải trang (từ 31/10/2026)**, 32 giáp tập luyện. Áp dụng chung cho pha lê hóa, ép sao, cường hóa lỗ 8/9. Option sao trên cải trang tính như đồ khác (NPoint duyệt mọi món đang mặc).

## Giáp tập luyện (type 32, ô mặc 6) — dò 31/10/2026
- Món: 529/534 cấp 1 (10%), 530/535 cấp 2 (20%), 531/536 cấp 3 (30%), 1716 cấp 4 (40%), 1869 cấp 5 (50%, thêm vào `ItemService.isTrainArmor`/`getPercentTrainArmor` 31/10/2026; trước đó code không nhận). Option 9 = số "phút tập luyện" tích được, tối đa 1000.
- Mua: 529–531 (ngọc 30/300/3000) và 534–536 (vàng 10 tr/100 tr/1 tỷ) ở BUNMA, DENDE, APPULE, SANTA; 1716 ở SANTA (9999 ngọc, kèm 77:10, 94:3) và SHOP_VIP (80 thỏi vàng). **1869 không bán ở đâu, không rơi, không có trong gift code.**
- Sư phụ mặc (`NPoint.setDameTrainArmor`): giảm X% sức đánh; mỗi 60 giây nếu đã đánh trong 30 giây gần nhất thì option 9 +1 (`EffectSkin.updateTrainArmor`). Tháo ra để trong hành trang: +X% sức đánh khi option 9 > 0; mỗi 60 giây mọi giáp trong hành trang/rương −1. `lastTimeAttack` chỉ cập nhật khi dùng chiêu đánh (Kamejoko, Masenko, Antomic, Dragon, Demon, Galick, Liên hoàn, Kaioken, Quả cầu kênh khí, Makankosappo, Dịch chuyển tức thời) (`SkillService` ~dòng 588).
- **Đệ tử mặc (từ 31/10/2026)**: đệ bị giảm X% sức đánh; đệ đánh trong 30 giây gần nhất thì option 9 +1 **mỗi giây** (chạy trong `EffectSkin.updateTrainArmor` của sư phụ). Giáp đang ở trên đệ không bị trừ. Lấy về hành trang sư phụ thì tính như trên. Sư phụ chỉ hưởng % từ giáp còn nằm trong hành trang mình (trước đây vẫn giữ tham chiếu giáp cũ sau khi đưa cho đệ).

## Vật phẩm dùng tăng SĐ/HP/KI (`UseItem.useItemTime`, `NPoint`, `ItemTime`) — dò 31/10/2026
- Không shop nào bán các món dưới (kiểm tra `item_shop`). Thời gian 10 phút (`TIME_ITEM`, `TIME_EAT_MEAL`, `TIME_NUOC_MIA*`).
- Cuồng nộ 381 (SĐ ×2), Bổ huyết 382 (HP ×2), Bổ khí 383 (KI ×2), Giáp Xên 384 (giảm sát thương). Bản 2: 1150 Cuồng nộ 2 (SĐ ×2,2), 1151 Bổ khí 2 (KI ×2,2), 1152 Bổ huyết 2 (HP ×2,2), 1153 Giáp Xên 2. Bản 1 và 2 cùng loại không dùng chung được.
  - Nguồn 381–385: Capsule kì bí 380 (`openCSKB`), Rương gỗ (`openRuongGo`), Hộp quà giáng sinh 648 (`OpenItem648` → `randomRac2`, chỉ 381/384/385), hộp Noel (`NoelItemBox`, 381–384), Hộp quà nhẹ nhàng (`HopQuaNheNhang`), Bánh dầy ở Vua Hùng (`VuaHung.randomBanhDay`).
  - Nguồn 1150–1154: Hộp quà chỉnh chu (`HopQuaChinhChu`), Bánh chưng ở Vua Hùng (`randomBanhChung`).
- Thức ăn 663–667 (Pudding, Xúc xích, Kem dâu, Mì ly, Sushi): ăn +10% SĐ (đệ hưởng của sư phụ). Rơi từ quái khi mặc đủ set Thần Linh (`Mob.java` ~dòng 1004, `checkSetGod`). Gom 99 để mua đồ Hủy Diệt ở Bill.
- 880 Cua rang me (+5% SĐ), 881 Bạch tuộc nướng (+5% ST chí mạng), 882 Tôm chiên xù (+5% HP): code có hiệu ứng (`isEatMeal2`, theo icon 8060/8061/8062) nhưng **không có nguồn** (không shop, không rơi, không gift code).
- Nước mía (NPC Xe nước mía `event/XeNuocMia.java`, sự kiện: 5 khúc mía + 2 nước đá + 5 triệu vàng → 1 ly ngẫu nhiên): 1614 HP +10%; 1615 HP +10%, chí mạng +10; 1616 HP +10%, SĐ +10%, ST chí mạng +10%, giáp +10%. Chỉ dùng 1 loại một lúc. **Lỗi**: `ItemTime.update` tính hết hạn của ly 2 và ly 3 theo `lastTimeUseNuocMia1` (dòng ~247, ~253), nên ly 2/3 hết hiệu lực gần như ngay nếu chưa uống ly 1.
- Khác: điều ước rồng thần sự kiện (`isUseRX`, +10% HP/KI/SĐ, `Shenron_Event`), mua ×HP/KI và ×SĐ bằng vàng trong Ngọc rồng sao đen (`BlackBallWarService`, mất khi rời map), Ngọc rồng 2 sao đen 373 (+20% HP/KI toàn bang).

## Nhiệm vụ hằng ngày (Bò Mộng, `TaskService.paySideTask`) — dò 31/10/2026
- **Không cộng sức mạnh/tiềm năng.** Thưởng mỗi lần trả: vàng (`ConstTask.GOLD_*`: dễ 5.000, thường 20.000, khó 50.000, rất khó 200.000, địa ngục **25** — số rất thấp, nghi gõ nhầm) + 1 Bí ngô (dễ 708 7 sao … địa ngục 704 3 sao, HSD 30 ngày). Cần ≥ 2 ô trống. Tối đa `MAX_SIDE_TASK` = **99** lần/ngày (gốc 10, đổi 31/10/2026; nhân vật đang có lượt cũ nhận 99 sau 0h). Địa ngục: Bí ngô ngẫu nhiên 1/2/3 sao (702–704).
- Địa ngục (trước đây kèm điều kiện còn < 15 lượt, luôn đúng khi tối đa 10, đã bỏ để giữ nguyên khi lên 99): thay Bí ngô bằng Cây thông 822 (cánh, 50% có option 11–13 = 100, option 110, HSD 30 ngày), nhưng cờ `canNhanCayThong` nằm trong `TaskService` dùng chung cả server nên **chỉ 1 người nhận được 1 lần mỗi lần bật server**.
- Nhiệm vụ bang (`payClanTask`): chỉ cộng capsule bang = (cấp + 1) × 10, không có sức mạnh.

## Bí ngô 702–708 (type 12) — dò 31/10/2026
- **Từ 31/10/2026**: dùng 1 viên → `UseItem.controllerCallRongThan` → `Shenron_BiNgo.openMenuSummonShenron` (menu Con mèo `ConstNpc.SUMMON_SHENRON_BI_NGO` 31720030) → `summonShenron`: cần đủ 7 viên 702–708 (mỗi viên trừ 1), không gọi ở map 0, 7, 14, 21–23, chờ `ShenronEvent.timeResummonShenron` (5 phút, tính chung `lastTimeShenronAppeared` với các rồng khác). Rồng là `models/ShenronEvent` (cập nhật mỗi giây ở `ShenronEventManager`, chờ ước 5 phút, gói `-83` loại 1 như Rồng băng), 4 điều ước: đổi chiêu 3/4 đệ, chiêu 5 đệ +1 cấp, +10% HP/KI/SĐ 30 phút (`isUseRX`), quần đang mặc +1 cấp (+10% chỉ số nâng cấp, tối đa cấp 7). `Player.shenronBiNgo`; menu ước dùng chung `SHOW_SHENRON_EVENT_CONFIRM`/`SHENRON_EVENT_CONFIRM` với Rồng băng (`NpcFactory` ưu tiên `shenronBiNgo`); mất kết nối thì đăng nhập lại ở map khác gọi lại rồng.
- Nguồn Bí ngô: nhiệm vụ hằng ngày (dễ 708 … rất khó 705, địa ngục ngẫu nhiên 702/703/704 từ 31/10/2026), Trung úy Xanh Lơ (705), Cađích (706), hộp quà giáng sinh 648 (704).
