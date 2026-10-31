# Thay đổi cần áp dụng ở máy khác

Nhật ký những thay đổi **không tự theo git**: lệnh SQL (DB không theo git), build server, cập nhật client. Máy nào `git pull` về thì Claude ở máy đó đọc file này và chạy các mục chưa chạy.

## Cách dùng (cho Claude)

- **Sau khi `git pull` hoặc đầu phiên làm việc**: đọc file `.thay-doi-da-chay` ở thư mục gốc repo (bị gitignore, mỗi máy một file, mỗi dòng một số mục đã chạy ở máy này; chưa có file thì coi như chưa chạy mục nào). Mục nào có trong file này mà chưa có trong `.thay-doi-da-chay` thì làm theo thứ tự số tăng dần:
  1. **SQL**: ghi khối SQL ra file UTF-8 trong scratchpad rồi chạy `C:\xampp\mysql\bin\mysql.exe -u root --default-character-set=utf8mb4 team10_long < file.sql` (mật khẩu lấy từ `database.pass` trong `Teamobi2026/Config.properties`, trống thì bỏ `-p`). Không gõ tiếng Việt thẳng trong dòng lệnh Git Bash vì sẽ thành `?`. MySQL chưa chạy thì nhắc user bật trong XAMPP. Chạy xong kiểm tra lại bằng `SELECT`.
  2. **Build**: mục có "Build: có" thì chạy `cmd /c "<thư mục repo>\Teamobi2026\build.bat < NUL"` (phải ghi đường dẫn đầy đủ, gọi `build.bat` trần thì cmd báo không tìm thấy) một lần sau khi đã áp hết các mục, rồi nhắc user gõ `bt` trong console server hoặc chạy `run.bat`.
  3. **Client**: mục có "Client: có" thì nhắc user chạy `client-patch\cap-nhat-client.bat` (không tự chạy).
  4. Ghi số mục vào `.thay-doi-da-chay` (mỗi số một dòng), rồi báo user đã áp những mục nào.
- **Khi sửa mà có SQL / build / client**: thêm mục mới ở cuối file này (số tiếp theo, ngày, máy làm), và ghi số mục đó vào `.thay-doi-da-chay` của máy đang làm vì máy này đã có sẵn.
- Mục chỉ có code Java (không SQL, không client) vẫn ghi "Build: có" để máy kia biết phải build.
- Nạp nguyên DB từ file `Teamobi2026/team10_long.sql` thì DB đã có sẵn mọi SQL tới lúc xuất file: ghi luôn các số mục có trước lúc xuất vào `.thay-doi-da-chay`, không chạy lại SQL của chúng.

## Các mục

### 1. Rađa kho báu (1532) cộng dồn, hiện thời gian
- Ngày: 30/10/2026, máy làm: nhà.
- Build: có (`UseItem.java`, `ItemTimeService.java`, `DataGame.vsItem` = 16).
- Client: không (đổi `vsItem` thì client tự tải lại dữ liệu vật phẩm).
- SQL:
```sql
SET NAMES utf8mb4;
UPDATE item_template SET is_up_to_up=1, description='Trong 30 phút, tăng tiềm năng, sức mạnh khi đánh quái ở Bản đồ kho báu' WHERE id=1532;
```
- Kiểm tra: `SELECT is_up_to_up, description FROM item_template WHERE id=1532;` ra `1` và mô tả trên.

### 2. Đệ tử ăn bùa trí tuệ của sư phụ, bùa x4 về +4
- Ngày: 30/10/2026, máy làm: nhà.
- Build: có (`NPoint.calSucManhTiemNang`).
- Client: không.
- SQL: không.

### 3. Nâng tiềm năng đệ tử bằng tay, khung đệ tử cập nhật liên tục
- Ngày: 30/10/2026, máy làm: nhà.
- Build: có (`Controller.java` sub 18, `NPoint.increasePoint`, `Pet.sendInfoToMaster`, `Player.lastTimeXemDeTu`).
- Client: không (client mod có sẵn menu nâng điểm cho đệ, chỉ thiếu server).
- SQL: không.

### 4. Lệnh admin không bắt nhầm chat "bao ve"; đệ bảo vệ đi theo sư phụ
- Ngày: 30/10/2026, máy làm: nhà.
- Build: có (`Command.matchCommand`, `Pet` chế độ PROTECT + `findMobAttackNear`).
- Client: không.
- SQL: không.

### 5. Phó bản không ép tiềm năng về 1 khi người cao hơn quái quá 5 cấp
- Ngày: 30/10/2026, máy làm: nhà.
- Build: có (`Mob.getTiemNangForPlayer`).
- Client: không.
- SQL: không.

### 6. Thiên Sứ và Hủy Diệt yêu cầu 60 tỷ; chế tạo Thiên Sứ nhân đôi cả sức đánh
- Ngày: 31/10/2026, máy làm: nhà.
- Build: có (`ItemService.DoThienSu` 21:60, `ShopService.buyItemHD` thêm 21:60 cho 650–662, `CheTaoTrangBiThienSu` nhân đôi mọi option trừ 20, 21, 30).
- Client: không.
- SQL: không.

### 7. Auto Item: 0,1 giây mỗi lần, phím P để dừng
- Ngày: 31/10/2026, máy làm: nhà.
- Build: không.
- Client: có. Đóng game rồi chạy `client-patch\cap-nhat-client.bat` (`patch-auto-item.ps1`: `ModFunc.Update` gọi `UseItemAuto` mỗi 100ms thay vì 1 giây, phím P tắt auto, thông báo thêm item đổi thành "Đã thêm X (P: dừng)"; sửa cả `GameAssembly.dll` và `global-metadata.dat`).
- SQL: không.

### 8. Hành trang tối đa 125 ô (gốc 80), rương 130 ô (gốc 100)
- Ngày: 31/10/2026, máy làm: nhà.
- Build: có (`Inventory.MAX_ITEMS_BAG/BOX`, `UseItem.getItem` đọc số ô không dấu).
- Client: có. Đóng game rồi chạy `client-patch\cap-nhat-client.bat` (thêm `patch-o-ruong.ps1`). Client chưa patch mà rương > 127 ô thì lỗi lúc vào game, nên người chơi phải tải client mới trước khi mở rương quá 127 ô.
- SQL: không.

### 9. AutoItem 50ms, dùng theo mã vật phẩm, còn 1 cái thì dừng
- Ngày: 31/10/2026, máy làm: nhà.
- Build: có (`UseItem.doItem`: gói dùng item với index -1 tìm món theo mã và dùng đúng ô của nó; `where = 9` (AutoItem) mà món còn <= 1 cái thì không dùng).
- Client: có. Đóng game rồi chạy `client-patch\cap-nhat-client.bat` (`patch-auto-item.ps1` bản mới, nâng cấp được từ bản 100ms của mục 7).
- SQL: không.

### 10. Ctrl+V dán chữ vào ô nhập (khung chat...)
- Ngày: 31/10/2026, máy làm: nhà.
- Build: không.
- Client: có. Đóng game rồi chạy `client-patch\cap-nhat-client.bat` (thêm `patch-dan-chu.ps1`).
- SQL: không.

### 11. Hộp quà giáng sinh (648): còn 3 nhóm quà, mảnh Thiên Sứ 50–100
- Ngày: 31/10/2026, máy làm: nhà.
- Build: có (`UseItem.NoelItemBox`).
- Client: không.
- SQL: không.

### 12. AutoItem: bỏ phím P, gợi ý "(click:dừng)"
- Ngày: 31/10/2026, máy làm: nhà.
- Build: không.
- Client: có. Đóng game rồi chạy `client-patch\cap-nhat-client.bat` (`patch-auto-item.ps1` bản mới: trả phím P về như cũ vì mod có sẵn click chuột để dừng; câu khi thêm item thành "Đã thêm X (click:dừng)").
- SQL: không.

### 13. Chế tạo Thiên Sứ: bấm Nâng cấp mới chế tạo, nhận công thức thường (50%) hoặc VIP (90%); thỏi vàng khởi đầu 20.000 khóa
- Ngày: 31/10/2026, máy làm: nhà.
- Build: có (`CheTaoTrangBiThienSu` viết lại, câu hướng dẫn trong `CombineService`, `PlayerDAO.createNewPlayer` thêm option 30 cho 457).
- Client: không.
- SQL: không.

### 14. Cộng dồn bùa x2 đệ tử (1628) và đuôi khỉ (1045), bán đuôi khỉ 579 ở Shop thỏi vàng 2 thỏi; khiên không bị quái thường phá; chết không dùng đồ; quái BDKB chỉ đánh sát; KOL 5 tính nhiệm vụ địa ngục
- Ngày: 31/10/2026, máy làm: nhà.
- Build: có (`UseItem.doItem` chặn khi chết, `Mob.mobAttackPlayer` khiên, `Mob.getPlayerCanAttack` BDKB `BDKB_MOB_RANGE` = 60, `TaskService.paySideTask`, `DataGame.vsItem` = 17).
- Client: không (đổi `vsItem` thì client tự tải lại dữ liệu vật phẩm).
- SQL:
```sql
SET NAMES utf8mb4;
UPDATE item_template SET is_up_to_up=1 WHERE id IN (1628,1045);
UPDATE item_template SET description='Tăng tiềm năng sức mạnh khi đánh quái trong 30 phút' WHERE id=579;
INSERT INTO item_shop (id,tab_id,temp_id,is_new,is_sell,type_sell,cost,icon_spec,sort_order) VALUES (1000,64,579,1,1,1,2,4028,1);
```
- Kiểm tra: `SELECT id,is_up_to_up FROM item_template WHERE id IN (1628,1045,579);` ra 1,1,1; `SELECT * FROM item_shop WHERE id=1000;` có dòng.

### 15. Đuôi khỉ cho đệ, bùa x3 đệ tử (1826) ở Bà Hạt Mít, sư phụ nhận x3 khi đệ đánh, Cải trang Mabư Còm 50%, chết dùng đồ (trừ đổi khu/capsule/ăn đậu), gộp thêm đồ
- Ngày: 31/10/2026, máy làm: nhà.
- Build: có (`NPoint` đuôi khỉ + bùa đệ x3, `Service.addSMTN` x3, `ItemTime`/`ItemTimeService`/`UseItem`/`PlayerDAO`/`MrBlue` bùa 1826, `UseItem`/`ChangeMapService` chặn khi chết, `DataGame.vsItem` = 18).
- Client: không.
- SQL (chạy từ file UTF-8, không gõ tiếng Việt qua Git Bash):
```sql
SET NAMES utf8mb4;
UPDATE item_template t JOIN item_template s ON s.id=1628 SET t.type=s.type,t.gender=s.gender,t.name='Bùa x3 tn,sm đệ tử',t.description='Có thể cộng dồn thời gian',t.level=s.level,t.icon_id=s.icon_id,t.part=s.part,t.is_up_to_up=1,t.power_require=s.power_require,t.gold=s.gold,t.gem=s.gem,t.head=s.head,t.body=s.body,t.leg=s.leg WHERE t.id=1826;
INSERT INTO item_shop (id,tab_id,temp_id,is_new,is_sell,type_sell,cost,icon_spec,sort_order) VALUES (1001,14,1826,1,1,1,20,0,0);
UPDATE item_shop_option SET param=50 WHERE item_shop_id=913 AND option_id=160;
UPDATE item_template SET is_up_to_up=1 WHERE id IN (1233,1703,1717,1537,1775,1480,1481,1552,1306,1307,1308);
```
- Ghi chú: 1826 dùng lại item trống (type 75), icon 13540 như bùa 1628; bán tab 14 (Bùa 1 giờ, Bà Hạt Mít) 20 ngọc. Cải trang Mabư Còm (1255) bán ở Santa: đồ đã mua trước đó vẫn giữ 30%.
- Kiểm tra: `SELECT id,name,is_up_to_up FROM item_template WHERE id IN (1826,1233,1552);` ra 1; `SELECT param FROM item_shop_option WHERE item_shop_id=913 AND option_id=160;` ra 50.

## 16. Bùa x3 đệ tử 8 giờ (1827) và 1 tháng (1828) — 31/10/2026

- Build lại server (`build.bat`, `bt`); `DataGame.vsItem` = 19 (client tự tải lại dữ liệu vật phẩm, không cần cập nhật client). `ItemTime.lastTimeBuaDeX3` nay là thời điểm hết hạn.
- SQL (chạy từ file UTF-8 hoặc phpMyAdmin):
```sql
SET NAMES utf8mb4;
UPDATE item_template t JOIN item_template s ON s.id=1826 SET t.type=s.type,t.gender=s.gender,t.name='Bùa x3 tn,sm đệ tử 8 giờ',t.description='Có thể cộng dồn thời gian',t.level=s.level,t.icon_id=s.icon_id,t.part=s.part,t.is_up_to_up=1,t.power_require=s.power_require,t.gold=s.gold,t.gem=s.gem,t.head=s.head,t.body=s.body,t.leg=s.leg WHERE t.id=1827;
UPDATE item_template t JOIN item_template s ON s.id=1826 SET t.type=s.type,t.gender=s.gender,t.name='Bùa x3 tn,sm đệ tử 1 tháng',t.description='Có thể cộng dồn thời gian',t.level=s.level,t.icon_id=s.icon_id,t.part=s.part,t.is_up_to_up=1,t.power_require=s.power_require,t.gold=s.gold,t.gem=s.gem,t.head=s.head,t.body=s.body,t.leg=s.leg WHERE t.id=1828;
UPDATE item_template SET name='Bùa x3 tn,sm đệ tử 1 giờ' WHERE id=1826;
INSERT INTO item_shop (id,tab_id,temp_id,is_new,is_sell,type_sell,cost,icon_spec,sort_order) VALUES (1002,15,1827,1,1,1,80,0,0),(1003,16,1828,1,1,1,2000,0,0);
```

## 17. Bùa x3 đệ tử thành bùa Bà Hạt Mít (mua là áp dụng, xem thời gian còn lại) — 31/10/2026

- Build lại server (`build.bat`, `bt`); `DataGame.vsItem` = 20. Code: `Charms.addTimeCharms` (case 1826/1827/1828), `ShopService.resolveShopBua`.
- SQL:
```sql
SET NAMES utf8mb4;
UPDATE item_template SET type=13, description='Tăng 3 lần tiềm năng, sức mạnh đệ tử nhận được. Mua là áp dụng luôn, cộng dồn thời gian' WHERE id IN (1826,1827,1828);
```

## 18. Client: thanh máu xanh giữa màn khi click mục tiêu → chữ đỏ "Tên" + "HP/HP tối đa" — 31/10/2026

- Cập nhật client: chạy `client-patch\cap-nhat-client.bat` (đã thêm `patch-bo-thanh-muc-tieu`, cùng `patch-bo-man-trang`). Không có SQL, không cần build server.

## 19. Chống roll back: tự lưu 5 phút, lưu khi đóng cửa sổ server, sửa đăng nhập đọc dữ liệu cũ; bỏ thông báo "đang chết không thể đổi khu" — 31/10/2026

- Build lại server (`build.bat`, rồi `bt` trong console). Không có SQL, client không cần cập nhật.
- `restart_server.bat` giờ chỉ `exit` (server cũ gọi file này sau bảo trì làm sinh thêm server thứ 2). Sau `git pull` kiểm tra chỉ có 1 cửa sổ server; nếu còn cửa sổ "Sever Se Tu Khoi Dong Lai Sau 5 Phut Nua..." thì đóng nó.

## 20. Đệ tử tự cộng tiềm năng chỉ vào HP/KI/SĐ (không cộng giáp gốc, chí mạng gốc) — 31/10/2026

- Build lại server (`build.bat`, `bt`). Code: `Pet.increasePoint` (`Util.nextInt(0, 2)`, trước là `0..4`). Không có SQL, client không cần cập nhật.

## 21. Client: sửa crash khi mua số lượng (vd 5 món ở Santa) — 31/10/2026

- Cập nhật client: chạy `client-patch\cap-nhat-client.bat` (`patch-mua-nhanh.ps1` bản mới, nhận cả bản cũ). Không có SQL, không cần build server.

## 22. Gift code `danangcap`: 9999 mỗi loại đá + 999 Đá bảo vệ — 31/10/2026

- SQL (code chỉ có trong DB, id 1266; phát đúng item/số lượng ghi trong JSON, không option, cần 19 ô hành trang trống, mỗi nhân vật dùng 1 lần). Đá: 220–224 (lục bảo, Saphia, Ruby, Titan, thạch anh tím), 674 ngũ sắc, 935 xanh lam, 1074–1078 nâng cấp cấp 1–5, 1079–1083 may mắn cấp 1–5, 1439 mài (mỗi loại 9999), 987 Đá bảo vệ (999). Không có 1143 (Đá bảo vệ khóa).
  ```sql
  INSERT INTO giftcode (code, count_left, detail, expired) VALUES ('danangcap', 999999999,
  '[{"id":220,"quantity":9999,"options":[]},{"id":221,"quantity":9999,"options":[]},{"id":222,"quantity":9999,"options":[]},{"id":223,"quantity":9999,"options":[]},{"id":224,"quantity":9999,"options":[]},{"id":674,"quantity":9999,"options":[]},{"id":935,"quantity":9999,"options":[]},{"id":1074,"quantity":9999,"options":[]},{"id":1075,"quantity":9999,"options":[]},{"id":1076,"quantity":9999,"options":[]},{"id":1077,"quantity":9999,"options":[]},{"id":1078,"quantity":9999,"options":[]},{"id":1079,"quantity":9999,"options":[]},{"id":1080,"quantity":9999,"options":[]},{"id":1081,"quantity":9999,"options":[]},{"id":1082,"quantity":9999,"options":[]},{"id":1083,"quantity":9999,"options":[]},{"id":1439,"quantity":9999,"options":[]},{"id":987,"quantity":999,"options":[]}]',
  '2030-01-01 00:00:00');
  INSERT INTO giftcode_reload_request () VALUES ();
  ```
- Build: không. Client: không cần cập nhật.

## 23. Bà Hạt Mít (map 5): đổi đồ Thần Linh → Hủy Diệt (10 thỏi vàng), 3 Hủy Diệt → 1 món kích hoạt (20 thỏi vàng) — 31/10/2026

- Build lại server (`build.bat`, rồi `bt`). Không có SQL, client không cần cập nhật. Code: `combine/DoiDoBaHatMit.java`, `CombineService` (tab 998/999), `BaHatMit` (2 nút cuối menu map 5), `ItemService.randomItemSKH` (tách bảng món kích hoạt dùng chung, capsule không đổi hành vi), `Item.isHuyDiet`. Chi tiết trong CO-CHE.md mục "Đồ Hủy Diệt".

## 24. Công thức thiên sứ Namếc/Xayda cộng dồn; gift code `giangsinh` (2000 Hộp quà giáng sinh 648) — 31/10/2026

- Build lại server (`build.bat`, `bt`; `DataGame.vsItem` = 21, client tự tải lại dữ liệu vật phẩm, không cần cập nhật client).
- SQL (Công thức 1072, 1073 và VIP 1085, 1086 trước đây `is_up_to_up = 0` nên mỗi cái chiếm 1 ô; code `giangsinh` id 1267, mỗi nhân vật dùng 1 lần, cần 1 ô trống):
  ```sql
  UPDATE item_template SET is_up_to_up = 1 WHERE id IN (1072, 1073, 1085, 1086);
  INSERT INTO giftcode (code, count_left, detail, expired) VALUES ('giangsinh', 999999999,
  '[{"id":648,"quantity":2000,"options":[]}]', '2030-01-01 00:00:00');
  INSERT INTO giftcode_reload_request () VALUES ();
  ```

## 25. Gift code `danangcap`: bỏ đá nâng cấp/may mắn cấp 1–4, thêm 999 Hematite + 999 Dùi đục, mọi món khóa — 31/10/2026

- SQL (chạy sau mục 22; còn lại đá 220–224, 674, 935, 1078 nâng cấp cấp 5, 1083 may mắn cấp 5, 1439 mài mỗi loại 9999, 987 Đá bảo vệ 999, 1423 Hematite 999, 1438 Dùi đục 999; mọi món có option `30:0` không thể giao dịch; cần 13 ô trống). Nhân vật đã nhập code này trước đó không nhập lại được.
  ```sql
  UPDATE giftcode SET detail = '[{"id":220,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":221,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":222,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":223,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":224,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":674,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":935,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":1078,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":1083,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":1439,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":987,"quantity":999,"options":[{"id":30,"param":0}]},{"id":1423,"quantity":999,"options":[{"id":30,"param":0}]},{"id":1438,"quantity":999,"options":[{"id":30,"param":0}]}]' WHERE code = 'danangcap';
  INSERT INTO giftcode_reload_request () VALUES ();
  ```
- Build: không. Client: không cần cập nhật.

## 26. Gọi rồng 3 phút/lần, tắt boss Mặt Trời, `danangcap`: đá 220–224 và Đá bảo vệ giao dịch được — 31/10/2026

- Build lại server (`build.bat`, rồi `bt`). Code: `SummonDragon.timeResummonShenron` 180000 (gốc 600000), `BossManager.loadBoss` comment dòng Mặt Trời. Client không cần cập nhật.
- SQL (chạy sau mục 25; bỏ option 30 khỏi 220–224 và 987, các món khác vẫn khóa):
  ```sql
  UPDATE giftcode SET detail = '[{"id":220,"quantity":9999,"options":[]},{"id":221,"quantity":9999,"options":[]},{"id":222,"quantity":9999,"options":[]},{"id":223,"quantity":9999,"options":[]},{"id":224,"quantity":9999,"options":[]},{"id":674,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":935,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":1078,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":1083,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":1439,"quantity":9999,"options":[{"id":30,"param":0}]},{"id":987,"quantity":999,"options":[]},{"id":1423,"quantity":999,"options":[{"id":30,"param":0}]},{"id":1438,"quantity":999,"options":[{"id":30,"param":0}]}]' WHERE code = 'danangcap';
  INSERT INTO giftcode_reload_request () VALUES ();
  ```

## 27. Giáp tập luyện cho đệ tử tích theo giây, nhận Giáp tập luyện cấp 5 (1869), cho đục lỗ cải trang — 31/10/2026

- Build lại server (`build.bat`, rồi `bt`). Không có SQL, client không cần cập nhật. Code: `EffectSkin.updateTrainArmor` (đệ mặc +1/giây khi đệ đánh), `NPoint.setDameTrainArmor` (đệ mặc bị giảm sức đánh; sư phụ chỉ tính giáp còn trong hành trang), `ItemService.isTrainArmor`/`getPercentTrainArmor` (1869 = 50%), `CombineSystem.isTrangBiPhaLeHoa` + `Item.canPhaLeHoa` (thêm type 5). Chi tiết: CO-CHE.md mục "Giáp tập luyện".

## 28. Client: khung hành trang bị lem khi trúng Thái Dương Hạ San — 31/10/2026

- Cập nhật client: **đóng game** rồi chạy `client-patch\cap-nhat-client.bat` (`patch-bo-man-trang.ps1` bản 4: trúng Thái Dương chỉ bị choáng, không trắng màn, màn hình vẽ như gốc; nhận bản gốc và bản 1–3). Không có SQL, không cần build server.

## 29. Bí ngô gọi rồng, nhiệm vụ hằng ngày 99 lượt + Bí ngô 1/2 sao — 31/10/2026

- Build lại server (`build.bat`, rồi `bt`). Không có SQL, client không cần cập nhật. Code: `services/shenron/Shenron_BiNgo.java` (mới), `models/ShenronEvent.java`, `Player.shenronBiNgo`, `Client` (mất kết nối), `NpcFactory` (menu Con mèo + menu ước), `ConstNpc.SUMMON_SHENRON_BI_NGO`, `UseItem.controllerCallRongThan`, `ConstTask.MAX_SIDE_TASK` = 99, `TaskService.paySideTask` (địa ngục ra Bí ngô 702–704). Chi tiết: CO-CHE.md mục "Bí ngô" và "Nhiệm vụ hằng ngày".

## 30. Boss Thiên sứ + Hủy diệt, map Trạm hủy diệt 186–188 — 31/10/2026

- File dữ liệu map đã theo git: `Teamobi2026/data/map/tile_map_data/186..188` (chép Rừng Karin 47), `item_bg_map_data/186..188` (cây của Rừng Karin, bỏ Tháp Karin và lều).
- SQL (tạo 3 map, nối cổng mép trái Vách núi 42/43/44):
  ```sql
  INSERT INTO map_template (id, NAME, zones, max_player, data, type, planet_id, bg_type, tile_id, bg_id, waypoints, mobs, npcs, is_map_double) VALUES
  (186, 'Trạm hủy diệt', 10, 15, '[1,0,0,4,3]', 0, 0, 0, 4, 3, '[["Vách núi Aru",936,312,960,336,0,0,42,60,264]]', '[]', '[]', 0),
  (187, 'Trạm hủy diệt', 10, 15, '[1,0,0,4,3]', 0, 1, 0, 4, 3, '[["Vách núi Moori",936,312,960,336,0,0,43,60,240]]', '[]', '[]', 0),
  (188, 'Trạm hủy diệt', 10, 15, '[1,0,0,4,3]', 0, 2, 0, 4, 3, '[["Vách núi Kakarot",936,312,960,336,0,0,44,60,264]]', '[]', '[]', 0);
  UPDATE map_template SET waypoints = '[["Làng Aru",1416,408,1440,432,0,0,0,60,432],["Trạm hủy diệt",0,240,24,264,0,0,186,900,336]]' WHERE id = 42;
  UPDATE map_template SET waypoints = '[["Làng Mori",1416,408,1440,432,0,0,7,60,408],["Trạm hủy diệt",0,216,24,240,0,0,187,900,336]]' WHERE id = 43;
  UPDATE map_template SET waypoints = '[["Làng Kakarot",1416,408,1440,432,0,0,14,60,408],["Đại hội võ thuật",936,408,1008,432,1,0,52,620,336],["Trạm hủy diệt",0,240,24,264,0,0,188,900,336]]' WHERE id = 44;
  ```
- Build lại server (`build.bat`), **tắt hẳn rồi bật lại server** (map mới chỉ nạp lúc khởi động; `bt` cũng được vì `run.bat` tự chạy lại). Code: `boss/thien_su/` (mới), `BossID`, `BossManager.loadBoss`/`createBoss`, `DataGame.vsMap` = 3 (client tự tải lại danh sách map). Client không cần cập nhật `GameAssembly.dll`. Chi tiết: BOSS-ROI-DO.md mục 3b, KE-HOACH-BOSS-THIEN-SU.md.

## 31. Client: danh sách server lấy từ `Config.properties`, thêm server `home` — 31/10/2026

- Cập nhật client: **đóng game** rồi chạy `client-patch\cap-nhat-client.bat` (thêm `patch-danh-sach-server.ps1`: tắt `isMultiSever`, client dùng đúng danh sách server gửi, hết nút "DragonBoy"/"0"/nút trống). Không có SQL.
- `Teamobi2026/Config.properties`: tắt `server.ip` (để `server.name` chỉ dùng cho câu chào), danh sách = `server.sv1=Home:127.0.0.1:14446`, `server.sv2=sv1:ngocrongprivate.kozow.com:14446`. Khởi động lại server (`bt`) để nạp. Danh sách server trên client = `server.name`/`server.ip`/`server.port` rồi `server.sv1..10`, sửa ở đây là người chơi thấy sau khi kết nối 1 lần.

## 32. Đi bộ từ mép trái Vách núi 42/43/44 sang Trạm hủy diệt — 31/10/2026

- Cột tile ngoài cùng của map là tường; cổng ở mép map phải có 1 ô trống (tile 0) ở cột 0 (mép trái) hoặc cột cuối (mép phải), hàng = `minY/24` của cổng. 42/43/44 chưa có ô này nên đi bộ bị chặn (phím L của mod dịch chuyển thẳng nên vẫn qua). Đã mở ô: `tile_map_data/42` và `44` hàng 10, `43` hàng 9 (file theo git). Không có SQL, client không cần cập nhật. Khởi động lại server (`bt`) và thoát game vào lại.

## 33. Client: tự đánh `ak` vẫn đánh khi mở hành trang — 31/10/2026

- Cập nhật client: **đóng game** rồi chạy `client-patch\cap-nhat-client.bat` (thêm `patch-ak-hanh-trang.ps1`). Không có SQL, không cần build server. Chi tiết: `client-patch/CLIENT-UNITY.md` mục "Tự đánh `ak` dừng khi mở hành trang".
