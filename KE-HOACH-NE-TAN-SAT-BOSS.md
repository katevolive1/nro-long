# Né boss và Tàn sát boss trong tab BOSS (6/11/2026, đã làm theo các đề xuất, chưa thử trong game)

Thêm 2 ô vào tab BOSS của menu mod (phím X). Chỉ sửa client, **server không đổi**. Chưa vá gì. Offset dưới đây là Game1 (runtime dùng Game1), lấy theo tên hàm trong `script.json`.

## Mod đã có sẵn gì

| Có sẵn | Ở đâu | Dùng để |
|---|---|---|
| Tab BOSS | `ModFunc.OpenMenu` `0x3DBA70` → `ModFunc.perform` `0x3E9C20`, tạo nút ở quanh `0x3EB014` | Thêm 2 nút cạnh "Focus BOSS" (lệnh `0x34`) |
| Tàn sát quái | `PickMob.tanSat` (static `+10h`), vòng lặp `PickMobController.Update` `0x4CD700` | Giữ nguyên |
| Tàn sát người | `PickMob.tsPlayer` (`+11h`), kiểm tra tại `0x4CDE5F`; chọn mục tiêu `GetCharTanSat` `0x4CBF40`, lọc `IsCharTanSat` `0x4CCE50` | **Tàn sát boss dựa trên nhánh này** |
| Né siêu quái | `PickMob.neSieuQuai` (`+12h`) | Chỉ bỏ qua quái siêu cấp, không né boss |
| Nhận diện boss | Lọc của `AutoFocusBoss` `0x3D4280`: `charID` (+90h) < 0, `cTypePk` (+295h) == 5, tên (+190h) không bắt đầu bằng "Đ" | Dùng chung cho cả 2 tính năng |
| Quét nhân vật trong khu | `GameScr.vCharInMap` (static `+0F0h`), cách làm giống phím Q | Né boss |
| Đổi khu | `Service.requestChangeZone(zoneId, indexUI)` `0x4908E0`; khu hiện tại `TileMap.zoneID` (static `+84h`) | Né boss |

**Giới hạn server:** `ChangeMapService.changeZone` chặn đổi khu **5 giây** một lần (`getLastTimeChangeZone`, admin không bị). Vừa đổi khu xong mà khu mới cũng có boss thì phải chờ đủ 5 giây mới né tiếp.

Lưu ý: "Focus BOSS" và phím Q đã có sẵn, nhưng chúng chỉ nhắm hoặc bay tới boss, không tự đánh và không né.

## Cách làm

### Cờ và nút
- Cờ mới dùng 2 byte trống trong static của `PickMob`: `+16h` tanSatBoss, `+17h` neBoss (giữa `telePem`/`isGoBack` và `mapGoback +18h`). Phải quét không ai đọc 2 byte này trước khi dùng.
- Thêm nút "Né Boss [Bật/Tắt]", "Tàn sát Boss [Bật/Tắt]" vào tab BOSS, thêm lệnh mới vào switch của `ModFunc.perform`.
- Chuỗi mới ghi vào `global-metadata.dat` đè lên chuỗi không dùng, cách như `patch-port.ps1`.
- Mã máy đặt ở thân hàm Game2 không chạy (`Game2.ModFunc.UpdateKey` còn trống `0x59C130`–`0x59C3A0`, đủ khoảng 620 byte). Script mới: `client-patch/patch-ne-tan-sat-boss.ps1`, thêm vào `cap-nhat-client.bat`.

### Tàn sát boss
Giống tàn sát quái nhưng mục tiêu là boss.

- Bật cờ thì `PickMobController.Update` chạy nhánh tàn sát người, `GetCharTanSat` đổi sang: **boss đang trỏ vào trước** (`Char.charFocus` +2C8h, nếu đúng là boss và còn sống), không có thì boss gần nhất trong khu.
- Không có boss nào trong khu thì đứng yên chờ, không đánh quái, không đánh người chơi khác.
- Di chuyển, chọn chiêu, tự nhặt dùng lại đúng code tàn sát hiện có.

### Né boss
Kiểm tra trong `ModFunc.Update`, cách 300 ms một lần:

1. Có boss trong khu (kể cả boss vừa vào, vừa sang map, vừa đổi khu) thì đổi khu.
2. Chờ đủ 5 giây từ lần đổi trước (client tự đếm, tránh gửi thừa).
3. Chọn khu đích (xem Cần chốt 2), thoát nếu map chỉ có 1 khu.
4. Sang khu mới, tàn sát quái và tự nhặt vẫn chạy bình thường.

Không làm trong: màn hình tải map, lúc đang chết, phó bản và map cấm đổi khu (server từ chối thì thôi, không gửi lại liên tục).

## Giới hạn cần biết
- **Né không tuyệt đối.** Có khoảng 5 giây chờ giữa 2 lần đổi khu, boss vẫn có thể đánh trong lúc đó.
- Boss lọc theo tên chữ "Đ" như mod đang làm, nên "Đội trưởng-5" và "Đracula" sẽ **bị bỏ sót**. Drabura không bị vì viết chữ D thường. Lọc này nhằm loại đệ tử. Đề xuất đổi sang loại đúng chữ "Đệ tử".
- Chỉ sửa Game1. Bản Android/iOS không có.

## Thử sau khi vá
1. Mở tab BOSS: có 2 nút, bấm đổi Bật/Tắt.
2. Bật tàn sát quái + Né boss, gọi boss vào khu: tự đổi khu, tiếp tục đánh quái.
3. Sang map có boss sẵn, tự nhiên gặp boss: tự đổi khu.
4. Map 1 khu: không gửi đổi khu liên tục, không lỗi.
5. Bật Tàn sát boss có 2 boss, trỏ vào con xa hơn: đánh con đang trỏ. Chết hết thì đứng yên.
6. Client slot của manager dựng lại được và vẫn chạy.

## Cần chốt
1. **Bật cả 2 cùng lúc:** đề xuất bật cái này tự tắt cái kia, vì một cái đuổi boss còn một cái tránh boss.
2. **Khu đích khi né:** đề xuất khu kế tiếp (hết thì quay về 0), đơn giản và không phụ thuộc bảng khu. Chọn khu ít người nhất thì cần "Cập Nhật Khu" đang bật.
3. **Né cả boss khi đang đánh chính boss đó không?** Đề xuất có, đã bật Né là luôn né.
4. **Lọc tên boss:** đổi sang loại đúng "Đệ tử" để không sót "Đội trưởng-5", "Đracula"?
5. **Lưu trạng thái:** đề xuất không lưu, mỗi lần mở game đều tắt, giống Focus BOSS.

## Đã làm (6/11/2026) và khác gì kế hoạch
User xem lại và bảo làm ("tôi chưa thấy"), nên làm theo toàn bộ đề xuất ở mục "Cần chốt": bật cái này tự tắt cái kia; khu đích là khu kế tiếp (vòng về 0, bỏ qua khu đang đứng); né cả khi đang đánh boss; lọc tên chỉ loại "Đệ…" (nên "Đội trưởng-5", "Đracula" được tính là boss); không lưu trạng thái.
- Script `client-patch/patch-ne-tan-sat-boss.ps1`, đã thêm vào `cap-nhat-client.bat`. Chi tiết offset, cờ, id lệnh: `client-patch/CLIENT-UNITY.md` mục cuối.
- Thêm lệnh chat `tsboss`, `neboss` (bảng ở ID-GAME.md), và **bỏ nút "Hướng Dẫn Xài Mod"** khỏi menu phím X (user yêu cầu thêm).
- Khác kế hoạch: Tàn sát Boss ưu tiên boss đang trỏ (nhờ giữ `charFocus`), còn không trỏ thì chọn **boss cuối danh sách khu**, không phải gần nhất. Tàn sát Boss bật còn tắt thêm tàn sát quái/người. Thời gian chờ đổi khu lưu ở .bss của hàm Game2 không chạy (static `PickMob` hết chỗ).
- Giới hạn còn lại: server chặn đổi khu 5 giây (client chờ 5,2 giây); khu đích có thể đầy hoặc có boss khác thì lần sau đổi tiếp; map 1 khu thì Né không làm gì. Bật tsBoss rồi bấm `t`/`ts` (tàn sát quái) thì tsBoss vẫn được ưu tiên.
- Chưa thử trong game: mở menu X, bấm 2 nút, lệnh chat, boss vào khu, đổi khu.
