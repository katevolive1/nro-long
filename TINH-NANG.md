# Danh sách tính năng server (để theo dõi đã xem/sửa tới đâu)

Lập ngày 30/10/2026 từ các thư mục `Teamobi2026/src/nro/models/`. Đánh dấu: **[đã xem]** đã đọc code/giải thích cho user, **[đã sửa]** có thay đổi (chi tiết ở file ghi chú tương ứng). Xem hoặc sửa thêm phần nào thì cập nhật dấu ở đây.

## Phó bản / hoạt động theo giờ (`map/phoban`, `services_dungeon`)
- Doanh trại Độc Nhãn (`RedRibbonHQ`) **[đã sửa]** (chi tiết: [CO-CHE.md](CO-CHE.md)): ngọc rơi sau khi Độc Nhãn thua (`RedRibbonHQ.NR`) 2% NR 3 sao, 14% NR 4–5 sao, 84% NR 6–7 sao (cũ: 1/500 NR 1–5 sao, còn lại 5–7 sao); boss trại rơi NR 4 hoặc 5 sao. Chưa sửa: vào lại giữa chừng thì boss/quái còn sống hồi đầy máu (`updateHPDame`), chỉ số tính theo cả thành viên bang online ngoài trại
- Bản đồ kho báu (`BanDoKhoBau`, `TreasureUnderSeaService`) **[đã sửa]** (chi tiết: [CO-CHE.md](CO-CHE.md)): không ép tiềm năng về 1 khi chênh cấp; Rađa kho báu 1532 cộng dồn. Còn mở: lỗi không trừ bản đồ 611 (chờ user nói rõ trường hợp)
- Khí Gas Hủy Diệt (`DestronGas`)
- Con đường rắn độc (`SnakeWay`, `boss_con_duong_ran_doc`)
- Ngọc Rồng Sao Đen (`BlackBallWar`, NPC `RongOmega`)
- Ngọc Rồng Namek (`NgocRongNamecService`)
- Mabư 12h / 14h (`MajinBuuService`, `MajinBuu14H`, NPC `Osin`)
- Nước thánh siêu cấp (`SuperDivineWaterService`)
- Luyện tập tự động với Karin, Thượng Đế, Whis… (`TrainingService`, `boss/luyen_tap_tu_dong`)

## Thi đấu / PvP (`matches`)
- Đại hội võ thuật (`DHVT`, NPC `GhiDanh`), Đại hội võ thuật lần 23
- Võ đài Hạt Mít / sinh tử (`DeathOrAliveArena`), Siêu hạng (`SuperRank`)
- Thách đấu, Trả thù, PK Commeson, Đấu trường (`ThachDau`, `TraThu`, `PKCommeson`, `PVP`)

## Đồ / nâng cấp (`combine`, NPC Bà Hạt Mít…)
- Pha lê hóa **[đã sửa]**, nâng cấp đồ +1..+8 **[đã xem]**, cường hóa lỗ sao 8/9 **[đã sửa]**: [TI-LE-DAP-DO.md](TI-LE-DAP-DO.md)
- Ép sao trang bị, đánh bóng sao pha lê, nâng cấp sao pha lê
- Bông tai Porata 2/3 (nâng cấp, nâng chỉ số)
- Sách tuyệt kỹ: giám định, tẩy, phân rã, hồi phục, nâng cấp, học, đổi, chế tạo cuốn sách cũ
- Trang bị Thiên Sứ **[đã sửa]** (viết lại chế tạo, công thức thường 50%/VIP 90%, yêu cầu 60 tỷ; chi tiết [CO-CHE.md](CO-CHE.md)), đồ Hủy Diệt ở Bill **[đã xem]** (yêu cầu 60 tỷ; lỗi Bill không mở shop chưa sửa), đồ kích hoạt (phân rã, tái tạo capsule), chuyển hóa trang bị (vàng/ngọc)
- Đá Hematite, đá mài, Dùi Đục, nhập ngọc rồng, làm phép nhập đá

## Nhân vật
- Đệ tử (Mabư, các loại pet), hợp thể (`player/Pet.java`) **[đã sửa]** câu chat tục; nâng tiềm năng đệ bằng tay + khung đệ cập nhật liên tục 30/10/2026 (chi tiết: [CO-CHE.md](CO-CHE.md))
- Nội tại (`intrinsic`), Huy hiệu (`player_badges`), Thẻ Rada (`radar`), Bang hội (`clan`)
- Tạo nhân vật mới: 500 triệu vàng, 100k ngọc, 20.000 thỏi vàng khóa **[đã sửa]**
- Tiềm năng sức mạnh (`NPoint.calSucManhTiemNang`) **[đã sửa]**: đuôi khỉ + bùa x3 cho đệ, sư phụ nhận x3 khi đệ đánh (31/10); bùa trí tuệ cho cả đệ, bùa x4 về +4; từ 40 tỷ chia 30 **[đã xem]**
- Hành trang tối đa 125, rương 130 **[đã sửa]** (cần `patch-o-ruong.ps1`)
- Đổi khu (`ChangeMapService.changeZone`) **[đã xem]**: phó bản đã chặn, admin bỏ qua; chưa chốt thêm map nào

## Kinh tế / tiện ích
- Shop, bán đồ **[đã sửa]** (khung nhập số lượng nằm trên cùng, patch client; Santa thêm nút "Shop thỏi vàng" bán Bình hút năng lượng 1795 giá 100 thỏi vàng)
- Ký gửi (`shop_ky_gui`, NPC `KyGui`)
- Rương đồ **[đã sửa]** (không reload, không nhảy cuộn, món cuối thế chỗ)
- Lệnh admin chat (`Command.matchCommand`) **[đã sửa]** không bắt nhầm chat thường
- Gift code **[đã sửa]** (tanthutd/tanthunm/tanthuxd), quà hằng ngày (`daily_Giftcode`)
- Gói VIP ở ToriBot **[đã sửa]** (bỏ item 1248)
- Minigame: Con số may mắn vàng/ngọc, Chọn ai đây (`minigame`)
- Nhiệm vụ KOL ở Quy Lão Kame, nhiệm vụ chính (`task`)

## Sự kiện (`event`, `event_list`, bật theo mùa)
- Trung thu, Halloween, Noel, Tết, Hùng Vương, 8/3, nạp thẻ (`TopUp`)
- Nồi bánh, xe nước mía, Vua Hùng
- Hộp quà giáng sinh 648 **[đã sửa]** (3 nhóm quà, mảnh Thiên Sứ 50–100; chi tiết [CO-CHE.md](CO-CHE.md))

## Boss (`boss`)
- Rơi đồ: [BOSS-ROI-DO.md](BOSS-ROI-DO.md) **[đã xem]**
- Không tự rời map trừ boss theo giờ, thông báo 5 phút/lần, gửi danh sách boss lúc đăng nhập **[đã sửa]** (ghi trong CLAUDE.md)
- Mặt Trời (5 con, hồi 30 phút) **[đã sửa]**, Baby (khu ngẫu nhiên 0–9) **[đã sửa]**
- Hirudegarn (map 126) **[đã sửa]** tạm tắt bằng `Hirudegarn.DISABLED`
- Chưa xem kỹ: Yardrat, Tàu Pảy Pảy, Mabư ngoài map, Nhân bản, Broly

## Client mod (chi tiết: `client-patch/CLIENT-UNITY.md`)
- AutoItem 50ms, dùng theo mã vật phẩm, còn 1 cái thì dừng, click chuột để dừng **[đã sửa]** (`patch-auto-item.ps1`)
- Ctrl+V dán chữ vào ô nhập **[đã sửa]** (`patch-dan-chu.ps1`)
- Nâng tiềm năng đệ tử bằng tay (client có sẵn, server thêm gói `-30` sub 18) **[đã sửa]**
