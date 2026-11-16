# Danh sách tính năng server (để theo dõi đã xem/sửa tới đâu)

Lập ngày 30/10/2026 từ các thư mục `Teamobi2026/src/nro/models/`. Đánh dấu: **[đã xem]** đã đọc code/giải thích cho user, **[đã sửa]** có thay đổi (chi tiết ở file ghi chú tương ứng). Xem hoặc sửa thêm phần nào thì cập nhật dấu ở đây.

## Phó bản / hoạt động theo giờ (`map/phoban`, `services_dungeon`)
- Doanh trại Độc Nhãn ([`RedRibbonHQ`](Teamobi2026/src/nro/models/map/phoban/RedRibbonHQ.java)) **[đã sửa]** (chi tiết: [CO-CHE.md](CO-CHE.md)): ngọc rơi sau khi Độc Nhãn thua ([`RedRibbonHQ.NR`](Teamobi2026/src/nro/models/map/phoban/RedRibbonHQ.java#L254)) 2% NR 3 sao, 14% NR 4–5 sao, 84% NR 6–7 sao (cũ: 1/500 NR 1–5 sao, còn lại 5–7 sao); boss trại rơi NR 4 hoặc 5 sao. Chưa sửa: vào lại giữa chừng thì boss/quái còn sống hồi đầy máu (`updateHPDame`), chỉ số tính theo cả thành viên bang online ngoài trại
- Bản đồ kho báu ([`BanDoKhoBau`](Teamobi2026/src/nro/models/map/phoban/BanDoKhoBau.java), [`TreasureUnderSeaService`](Teamobi2026/src/nro/models/services_dungeon/TreasureUnderSeaService.java)) **[đã sửa]** (chi tiết: [CO-CHE.md](CO-CHE.md)): không ép tiềm năng về 1 khi chênh cấp; Rađa kho báu 1532 cộng dồn. Còn mở: lỗi không trừ bản đồ 611 (chờ user nói rõ trường hợp)
- Khí Gas Hủy Diệt ([`DestronGas`](Teamobi2026/src/nro/models/map/phoban/DestronGas.java))
- Con đường rắn độc ([`SnakeWay`](Teamobi2026/src/nro/models/map/phoban/SnakeWay.java), `boss_con_duong_ran_doc`)
- Ngọc Rồng Sao Đen ([`BlackBallWar`](Teamobi2026/src/nro/models/map/phoban/BlackBallWar.java), NPC [`RongOmega`](Teamobi2026/src/nro/models/npc_list/RongOmega.java))
- Ngọc Rồng Namek ([`NgocRongNamecService`](Teamobi2026/src/nro/models/services_dungeon/NgocRongNamecService.java))
- Mabư 12h / 14h ([`MajinBuuService`](Teamobi2026/src/nro/models/services_dungeon/MajinBuuService.java), [`MajinBuu14H`](Teamobi2026/src/nro/models/map/phoban/MajinBuu14H.java), NPC [`Osin`](Teamobi2026/src/nro/models/npc_list/Osin.java))
- Nước thánh siêu cấp ([`SuperDivineWaterService`](Teamobi2026/src/nro/models/services_dungeon/SuperDivineWaterService.java))
- Luyện tập tự động với Karin, Thượng Đế, Whis… (`TrainingService`, `boss/luyen_tap_tu_dong`)

## Thi đấu / PvP (`matches`)
- Đại hội võ thuật (`DHVT`, NPC [`GhiDanh`](Teamobi2026/src/nro/models/npc_list/GhiDanh.java)), Đại hội võ thuật lần 23
- Võ đài Hạt Mít / sinh tử (`DeathOrAliveArena`), Siêu hạng (`SuperRank`)
- Thách đấu, Trả thù, PK Commeson, Đấu trường ([`ThachDau`](Teamobi2026/src/nro/models/matches/ThachDau.java), [`TraThu`](Teamobi2026/src/nro/models/matches/TraThu.java), `PKCommeson`, `PVP`)

## Đồ / nâng cấp (`combine`, NPC Bà Hạt Mít…)
- Pha lê hóa **[đã sửa]**, nâng cấp đồ +1..+8 **[đã xem]**, cường hóa lỗ sao 8/9 **[đã sửa]**: [TI-LE-DAP-DO.md](TI-LE-DAP-DO.md)
- Ép sao trang bị, đánh bóng sao pha lê, nâng cấp sao pha lê
- Bông tai Porata 2/3 (nâng cấp, nâng chỉ số)
- Sách tuyệt kỹ: giám định, tẩy, phân rã, hồi phục, nâng cấp, học, đổi, chế tạo cuốn sách cũ
- Trang bị Thiên Sứ **[đã sửa]** (viết lại chế tạo, công thức thường 50%/VIP 90%, yêu cầu 60 tỷ; chi tiết [CO-CHE.md](CO-CHE.md)), đồ Hủy Diệt ở Bill **[đã xem]** (yêu cầu 60 tỷ; lỗi Bill không mở shop chưa sửa), đồ kích hoạt (phân rã, tái tạo capsule), chuyển hóa trang bị (vàng/ngọc)
- Đá Hematite, đá mài, Dùi Đục, nhập ngọc rồng, làm phép nhập đá

## Nhân vật
- Đệ tử (Mabư, các loại pet), hợp thể ([`player/Pet.java`](Teamobi2026/src/nro/models/player/Pet.java)) **[đã sửa]** câu chat tục; nâng tiềm năng đệ bằng tay + khung đệ cập nhật liên tục 30/10/2026 (chi tiết: [CO-CHE.md](CO-CHE.md))
- Nội tại (`intrinsic`), Huy hiệu (`player_badges`), Thẻ Rada (`radar`), Bang hội (`clan`)
- Tạo nhân vật mới: 500 triệu vàng, 100k ngọc, 20.000 thỏi vàng khóa **[đã sửa]**
- Tiềm năng sức mạnh ([`NPoint.calSucManhTiemNang`](Teamobi2026/src/nro/models/player/NPoint.java#L1705)) **[đã sửa]**: đuôi khỉ + bùa x3 cho đệ, sư phụ nhận x3 khi đệ đánh (31/10); bùa trí tuệ cho cả đệ, bùa x4 về +4; từ 40 tỷ chia 30 **[đã xem]**
- Hành trang tối đa 125, rương 130 **[đã sửa]** (cần `patch-o-ruong.ps1`)
- Đổi khu ([`ChangeMapService.changeZone`](Teamobi2026/src/nro/models/map/service/ChangeMapService.java#L164)) **[đã xem]**: phó bản đã chặn, admin bỏ qua; chưa chốt thêm map nào

## Kinh tế / tiện ích
- Shop, bán đồ **[đã sửa]** (khung nhập số lượng nằm trên cùng, patch client; Santa thêm nút "Shop thỏi vàng" bán Bình hút năng lượng 1795 giá 100 thỏi vàng)
- Ký gửi (`shop_ky_gui`, NPC [`KyGui`](Teamobi2026/src/nro/models/npc_list/KyGui.java))
- Rương đồ **[đã sửa]** (không reload, không nhảy cuộn, món cuối thế chỗ)
- Lệnh admin chat ([`Command.matchCommand`](Teamobi2026/src/nro/models/server/Command.java#L272)) **[đã sửa]** không bắt nhầm chat thường
- Gift code **[đã sửa]** (tanthutd/tanthunm/tanthuxd), quà hằng ngày (`daily_Giftcode`)
- Gói VIP ở ToriBot **[đã sửa]** (bỏ item 1248; 1/11/2026: mùa 1/11/2026–30/4/2027, reset theo mã mùa, bỏ x3 kinh nghiệm)
- Minigame: Con số may mắn vàng/ngọc, Chọn ai đây (`minigame`)
- Nhiệm vụ KOL ở Quy Lão Kame, nhiệm vụ chính (`task`)

## Sự kiện (`event`, `event_list`, bật theo mùa)
- Trung thu, Halloween, Noel, Tết, Hùng Vương, 8/3, nạp thẻ ([`TopUp`](Teamobi2026/src/nro/models/event_list/TopUp.java))
- Nồi bánh, Vua Hùng (xe nước mía đã bỏ 31/10/2026: NPC không còn xuất hiện, bảng top Nước mía ở ChiChi đã bỏ)
- Hộp quà giáng sinh 648 **[đã sửa]** (3 nhóm quà, mảnh Thiên Sứ 50–100; chi tiết [CO-CHE.md](CO-CHE.md))

## Boss (`boss`)
- Rơi đồ: [BOSS-ROI-DO.md](BOSS-ROI-DO.md) **[đã xem]**
- Không tự rời map trừ boss theo giờ, thông báo 15 phút/lần, gửi danh sách boss lúc đăng nhập **[đã sửa]** (ghi trong CLAUDE.md)
- Mặt Trời (5 con, hồi 30 phút) **[đã sửa]**, Baby (khu ngẫu nhiên 0–9) **[đã sửa]**
- Hirudegarn (map 126) **[đã sửa]** tạm tắt bằng [`Hirudegarn.DISABLED`](Teamobi2026/src/nro/models/mob_bigboss/Hirudegarn.java#L16)
- Goku SSJ 1/2/3 map Cold 105–110 ([`boss/Cold/GokuSSJ.java`](Teamobi2026/src/nro/models/boss/Cold/GokuSSJ.java), option 251 chiêu đặc biệt) **[đã sửa]** 16/11/2026
- Chưa xem kỹ: Yardrat, Tàu Pảy Pảy, Mabư ngoài map, Nhân bản, Broly

## Client mod (chi tiết: `client-patch/CLIENT-UNITY.md`)
- AutoItem 50ms, dùng theo mã vật phẩm, còn 1 cái thì dừng, click chuột để dừng **[đã sửa]** (`patch-auto-item.ps1`)
- Ctrl+V dán chữ vào ô nhập **[đã sửa]** (`patch-dan-chu.ps1`)
- Nâng tiềm năng đệ tử bằng tay (client có sẵn, server thêm gói `-30` sub 18) **[đã sửa]**
