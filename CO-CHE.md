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
- 500 triệu vàng, 100.000 ngọc (`server.test=true` thì 1 tỷ), 0 hồng ngọc. Đang mặc: áo cấp 1 (giáp +2, Xayda +3) và quần cấp 1 (HP +30 Trái Đất, +20 còn lại) của hành tinh. Hành trang: 10 Đậu thần cấp 5 (63, HP/KI +8000), 10.000 Thỏi vàng (457). Rương: Rada cấp 1 (12, chí mạng +1). Map 39 + gender, x 100 y 384. Sức mạnh, tiềm năng 2.000. Cây đậu cấp 1, 5 hạt.
- Không có quà tự động lần đầu vào game (`PlayerService.dailyLogin` chỉ reset nhiệm vụ huy hiệu, quà hằng ngày, lượt nhận…). Gift code tân thủ xem CLAUDE.md.
- Tài khoản: `active` mặc định 1, `vnd` mặc định 1.000.000 (đang test, xem DB.md).

## Shop (`shop/ShopService.java`, `database/ShopDAO.java`)
- Server nạp shop lúc khởi động (`shop` → `tab_shop` → `item_shop` có `is_sell = 1`, sắp theo `sort_order, id` → `item_shop_option`). NPC mở bằng `ShopService.gI().opendShop(player, "<tag_name>", false)`.
- `shop.type_shop`: 0 thường (`openShopType0`), 1 kỹ năng, 3 trả bằng vật phẩm (`openShopType3`, `SPEC_SHOP`). Shop thường: `type_sell` 0 vàng, 1 ngọc, 3 hồng ngọc, 4 coupon, không có thỏi vàng. Shop type 3: giá = `cost` vật phẩm có `icon_id` = `item_shop.icon_spec` (`subIemByItemShop`, `getItemIdByIcon` lấy item đầu tiên có icon đó; 4028 = Thỏi vàng 457), trừ từ **chồng đầu tiên** trong hành trang.
- Món mua ra (`ItemService.createItemFromItemShop`) mang đúng option trong `item_shop_option`.
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
- Chỉ cộng khi sức mạnh chưa chạm giới hạn (`power < getPowerLimit()`). Thứ tự: % TNSM từ đồ (`tlTNSM`) → cộng theo `tn` gốc: bùa Trí tuệ +1, Trí tuệ x3 +3, Trí tuệ x4 +4 (bị cộng 2 lần, thực tế +8), VIP thời gian (`timevip`) +3, Chibi loại 2 +2, tài khoản `vip` > 0 +3, item Đuôi khỉ/`isUseDK` +2, map kho báu có `isUseKhoBauX2` +2, vệ tinh trí tuệ +1/5, nội tại 24 +param%; sức mạnh ≥ 60 tỷ −80%; đệ tử: chủ dùng Bùa Santa +2, `tlTNSMPet`.
- Nhân theo map: Ngũ Hành Sơn 122–124 ×2 (gốc ×1), map lạnh 105–110 ×5, Bản đồ kho báu 135–138 ×3 (gốc ×1,5) (×10 toàn map 0–163 đang comment). Cờ PK: cờ 8 +10%, cờ khác +5%.
- Cuối cùng `calSubTNSM` chia theo sức mạnh: ≥ 40 tỷ /30, ≥ 50 tỷ /40, ≥ 60 tỷ /50, ≥ 80 tỷ /90, ≥ 90 tỷ /100.
- Danh sách map (id, tên, hành tinh): mục "Map" trong [ID-GAME.md](ID-GAME.md).

## Ngũ Hành Sơn (map 122–124)
- 3 map chỉ nối với nhau (122 ↔ 124 ↔ 123), không có cổng từ ngoài. Dịch chuyển (Yardrat, `ChangeMapService.checkMapCanJoinByYardart`) chặn mọi người trừ admin và boss.
- Vào/ra (sửa 30/10/2026): NPC **Ngộ Không** (48, `npc_list/NgoKhong.java`) ở Làng Aru map 0 x 800 → "Đến Ngũ Hành Sơn" đưa tới map 122 (x 900–1000, y 408); Ngộ Không trong map 122 (x 979) và **Đường Tăng** (49, `npc_list/DuongTang.java`, map 122 x 1060, map 123 x 140) → "Về Làng Aru" (map 0 x 750–850). Không có điều kiện (sức mạnh, phí). DB không theo git, máy khác chạy: `UPDATE map_template SET npcs='[[7,228,432],[67,590,432],[74,426,432],[84,950,432],[48,800,432]]' WHERE id=0;`
- Quái: 122 Quỷ chim (50) + Khỉ lông vàng (57), 123 Khỉ lông đỏ (56), 124 Khỉ lông vàng; level 20, HP 400–500 nghìn. TNSM ×2 riêng (×6 tính cả ×3 server).
