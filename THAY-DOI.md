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

## 34. Clone nhân vật 1368 sang Xayda `tata2` (account `xd`) và Namek `hoang` (account `nm`) — 31/10/2026, máy nhà

- Build: không. Client: không. Chỉ SQL. Chi tiết và các điểm đã chốt: [KE-HOACH-CLONE-NHAN-VAT.md](KE-HOACH-CLONE-NHAN-VAT.md).
- Chạy khi nhân vật 1368 (account `11`) offline. Chỉ chạy nếu máy này có player 1368 và chưa có account `xd`/`nm` (`SELECT id FROM account WHERE username IN ('xd','nm');` ra rỗng). Máy nhà đã tạo account 3735/3736, player 1370/1371; máy khác lấy id MAX+1 nên có thể khác.
- Mật khẩu không ghi vào git: SQL dưới lấy mật khẩu giống account 3729. Đặt lại bằng `UPDATE account SET password='<mật khẩu>' WHERE username IN ('xd','nm');` (hỏi user, bản ở máy nhà là `db/clone-xd-nm.sql`, bị gitignore).
- SQL:
```sql
SET NAMES utf8mb4;
START TRANSACTION;
SET @acc_xd = (SELECT MAX(id) + 1 FROM account);
SET @acc_nm = @acc_xd + 1;
SET @pl_xd = (SELECT MAX(id) + 1 FROM player);
SET @pl_nm = @pl_xd + 1;
CREATE TEMPORARY TABLE tmp_acc AS SELECT * FROM account WHERE id = 3729;
UPDATE tmp_acc SET id = @acc_xd, username = 'xd', token = '', xsrf_token = '', newpass = '', ip_address = '', create_time = NOW(), update_time = NOW();
INSERT INTO account SELECT * FROM tmp_acc;
UPDATE tmp_acc SET id = @acc_nm, username = 'nm';
INSERT INTO account SELECT * FROM tmp_acc;
DROP TEMPORARY TABLE tmp_acc;
CREATE TEMPORARY TABLE tmp_pl AS SELECT * FROM player WHERE id = 1368;
UPDATE tmp_pl SET clan_id = 0, create_time = NOW(), data_intrinsic = '[0,0,0,0,false,0,0,0]';
CREATE TEMPORARY TABLE tmp_xd AS SELECT * FROM tmp_pl;
UPDATE tmp_xd SET id = @pl_xd, account_id = @acc_xd, name = 'tata2', gender = 2, head = 27,
  items_body = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(items_body,
      '"[136,1,', '"[168,1,'), '"[242,1,', '"[250,1,'), '"[257,1,', '"[265,1,'), '"[268,1,', '"[276,1,'),
      '[129,1]', '[135,1]'), '[141,1]', '[138,1]'),
  skills = '["[4,7,0,0]","[5,7,0,0]","[8,7,0,0]","[13,0,0,0]","[14,0,0,0]","[21,0,0,0]","[23,7,0,0]","[19,7,0,0]"]',
  skills_shortcut = '[4,5,8,23,19,-1,-1,-1,-1,-1]',
  BoughtSkill = '[0,435,436,437,438,439,440,503,504,505,506,507,508,88,89,90,91,92,93,130,131,132,133,134,135,109,110,111,112,113,114]';
INSERT INTO player SELECT * FROM tmp_xd;
DROP TEMPORARY TABLE tmp_xd;
CREATE TEMPORARY TABLE tmp_nm AS SELECT * FROM tmp_pl;
UPDATE tmp_nm SET id = @pl_nm, account_id = @acc_nm, name = 'hoang', gender = 1, head = 29,
  items_body = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(items_body,
      '"[136,1,', '"[152,1,'), '"[242,1,', '"[246,1,'), '"[257,1,', '"[261,1,'), '"[268,1,', '"[272,1,'),
      '[129,1]', '[131,1]'), '[141,1]', '[143,1]'),
  skills = '["[2,7,0,0]","[3,7,0,0]","[7,7,0,0]","[11,0,0,0]","[12,0,0,0]","[17,7,0,0]","[18,0,0,0]","[19,7,0,0]"]',
  skills_shortcut = '[2,3,7,17,19,-1,-1,-1,-1,-1]',
  BoughtSkill = '[0,435,436,437,438,439,440,482,483,484,485,486,487,80,81,82,83,84,86,123,124,125,126,127,128,102,103,104,105,106,107]';
INSERT INTO player SELECT * FROM tmp_nm;
DROP TEMPORARY TABLE tmp_nm;
DROP TEMPORARY TABLE tmp_pl;
COMMIT;
```
- Kiểm tra: `SELECT a.username, p.id, p.name, p.gender, p.head FROM account a JOIN player p ON p.account_id = a.id WHERE a.username IN ('xd','nm');` ra `xd`/`tata2`/2/27 và `nm`/`hoang`/1/29.

## 35. `tata2` (Xayda): sao pha lê đổi từ sức đánh sang HP — 31/10/2026, máy nhà

- Build: không. Client: không. Chạy sau mục 34, khi `tata2` offline.
- Mỗi lỗ ép đá HP (Ngọc rồng 20) = `[77,5]`, đá SĐ (Ngọc rồng 16) = `[50,3]`. Trên 5 món (áo, quần, găng, giày, rada) đổi 7 sao `[50,21]` → `[77,35]`, 2 lỗ cường hóa `[50,3]` → `[77,5]`. Cải trang Hit: `[50,51]` (30 gốc + 21 sao) → `[50,30]`, HP `[77,29]` → `[77,64]`, 2 lỗ `[50,3]` → `[77,5]`. Đồ của đệ không đổi.
- SQL:
```sql
UPDATE player SET items_body = REPLACE(REPLACE(REPLACE(REPLACE(items_body,
    '[50,51]', '[50,30]'), '[77,29]', '[77,64]'), '[50,21]', '[77,35]'), '[50,3]', '[77,5]')
WHERE name = 'tata2' AND gender = 2;
```
- Kiểm tra: `items_body` của `tata2` có 5 chỗ `[77,35]`, 12 chỗ `[77,5]`, không còn `[50,3]`/`[50,21]`.

## 36. Ngọc rồng sao đen: sao 5 đổi sang +35% TN/SM, sao 6 KI tối đa còn +20% — 31/10/2026, máy nhà

- Build: có (`NPoint.java`, `RewardBlackBall.java`). Client: không. SQL: không.
- Sao 5: bỏ SĐ chí mạng +35%, thay bằng tiềm năng và sức mạnh nhận thêm +35% (`tlTNSM`). Sao 6: KI tối đa +40% → +20% (`R6S_1` = 20). Chi tiết: CO-CHE.md mục "Ngọc rồng sao đen". Gốc: GIA-TRI-GOC.md.
- Sau khi build, tắt rồi bật lại server (`bt` hoặc chạy `run.bat`). Hiệu ứng sao đang giữ trên người chơi sẽ tính lại khi họ đăng nhập lại.

## 37. Chữ NPC sao đen, nhắc boss 15 phút, đệ Mabư của `tata2` đổi sang HP — 31/10/2026, máy nhà

- Build: có (`ConstNpc.HUONG_DAN_BLACK_BALL_WAR`: chữ hướng dẫn Trạm tàu vũ trụ khớp sao 5 = +35% TN/SM, sao 6 = KI+20%; `Boss.remindNotify` 5 phút → 15 phút, `900000`). Client: không.
- (Xem thêm mục 39: đệ tích giáp tập luyện theo thời gian thực 0,1 giây/điểm.)
- SQL (chạy sau mục 34 và 35, khi `tata2` offline): đệ của `tata2` (Mabư, gender 2). Sao pha lê SĐ → HP trên 7 món (áo, quần, găng, giày, nhẫn, cải trang 584, giáp tập luyện): mỗi lỗ SĐ `[50,3]` → HP `[77,5]`, 7 sao `[50,21]` → `[77,35]`; giày đã có `[77,1]` nên gộp thành `[77,36]`; cải trang 584 `[50,45]` → `[50,24]` (SĐ gốc 24), `[77,24]` → `[77,59]`. Quần Thiên Sứ 1053 lên +8: `[22,260]` → `[22,557]` (260 × 1,1^8, công thức `ChuyenHoaTrangBi_Ngoc`) và thêm `[72,8]`. Giáp tập luyện cấp 1 (529) → cấp 4 (1716), option 9 về 0, 9 sao HP 45% (`[77,35]` + 2 × `[77,5]`), chưa thêm `77:10, 94:3` như bản bán ở Santa.
```sql
SET NAMES utf8mb4;
SET @p = (SELECT LOCATE('[77,1]', pet) FROM player WHERE name = 'tata2');
SET @sep = (SELECT SUBSTRING(pet, @p + 6, LOCATE('[107,9]', pet, @p) - (@p + 6)) FROM player WHERE name = 'tata2');
UPDATE player SET pet = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(pet,
    CONCAT('[77,1]', @sep, '[107,9]', @sep, '[50,21]'), CONCAT('[77,36]', @sep, '[107,9]')),
    '[50,21]', '[77,35]'),
    '[50,3]', '[77,5]'),
    '[50,45]', '[50,24]'),
    '[77,24]', '[77,59]'),
    '[22,260]', CONCAT('[22,557]', @sep, '[72,8]')),
    '[529,1,', '[1716,1,'),
    '[9,31]', '[9,0]')
WHERE name = 'tata2' AND gender = 2;
```
- Kiểm tra: cột `pet` của `tata2` đọc đúng JSON, có 5 chỗ `[77,35]`, 14 chỗ `[77,5]`, 1 chỗ `[77,36]`, 1 chỗ `[77,59]`, `[22,557]`, không còn `[50,21]`/`[50,3]`/`[529,1,`. Chạy xong mới có `[1716,1,`.

## 38. Client: số lượng trong rương hết nhòe — 31/10/2026, máy nhà

- Client: có. **Đóng game** rồi chạy `client-patch\cap-nhat-client.bat` (thêm `patch-so-luong-ruong.ps1`). Build: không. SQL: không. Chi tiết: `client-patch/CLIENT-UNITY.md` mục "Số lượng trong rương bị nhòe". Máy nhà chưa áp vào `F:\nr-long` (game đang chạy lúc sửa); áp xong thì ghi `38` vào `.thay-doi-da-chay`.

## 39. Đệ tích giáp tập luyện mỗi 0,1 giây (cộng theo thời gian thực) — 31/10/2026, máy nhà

- Build: có (`EffectSkin.java`, `updateTrainArmor`). Client: không. SQL: không.
- Trước đây đệ +1 mỗi 1 giây khi đang đánh. Bây giờ cộng `elapsed / 100` mỗi lần `update()` (update chạy mỗi giây, cộng tối đa 10 điểm mỗi lần), vẫn giới hạn 1000 và chỉ khi đệ đánh trong 30 giây gần nhất. Gốc: GIA-TRI-GOC.md.
- Sau khi build, tắt rồi bật lại server (`bt` hoặc `run.bat`).

## 41. Nội tại Liên hoàn của Namek (gender 1) 5–25% → 5–35% — 31/10/2026, máy nhà

- SQL (không cần build, khởi động lại server để nạp lại bảng `intrinsic`; nhân vật đang có nội tại giữ chỉ số cũ đã roll, người mới roll theo 5–35):
```sql
UPDATE intrinsic SET param_to_1 = 35 WHERE id = 13 AND gender = 1;
```
- Kèm lệnh bỏ cột `rid` (đã thêm tạm lúc dò, không dùng): `ALTER TABLE intrinsic DROP COLUMN rid;` (chạy trước lệnh trên). Bảng `intrinsic` không có khóa chính như cũ.
- Client: không cần cập nhật.

## 42. Bỏ sự kiện nước mía; rơi đồ Thiên sứ/Hủy diệt mới; đổi Hủy diệt không trùng món — 31/10/2026, máy nhà

- Build: có (`build.bat` hoặc javac + `jar uf`, xem THAY-DOI mục 36). Client: không cần cập nhật. SQL: không.
- Bỏ nước mía: xóa `event/XeNuocMia.java`, bỏ case trong `NpcFactory`, `Map.initNpc` bỏ qua NPC id 84, `ChiChi` bỏ nút "Top Nước mía" (menu còn Hộp quà / Kem / Cửa hàng). Ly mía trong túi vẫn dùng được. Bảng top nước mía (`Manager.Topsukien1`) còn trong code nhưng không còn được dùng.
- Rơi đồ boss Thiên sứ + Hủy diệt (`ThienSuHuyDietReward.drop`): 2% Thần Linh, 30% Hủy Diệt, 20% Ngọc rồng 2 sao, 10% Ngọc rồng 3 sao, 38% thỏi vàng (457). Món Hủy Diệt chọn hành tinh ngẫu nhiên, không theo người giết. Bảng ở BOSS-ROI-DO.md mục 3b.
- Bà Hạt Mít đổi 3 món Hủy Diệt (`DoiDoBaHatMit.checkHuyDiet`): 3 món không được trùng món (cùng id), được khác hành tinh.
- Chữ "10 tỷ": xem mục 43.
- Sau khi build, tắt rồi bật lại server (`bt` hoặc `run.bat`).

## 43. Thiên sứ rơi đồ như cũ (bảng mới chỉ cho Hủy diệt); client: số dưới 10 tỷ hiện đủ dấu chấm — 31/10/2026, máy nhà

- Build: có (`ThienSuHuyDietReward`: `drop` = Thiên sứ bảng cũ, món Hủy Diệt theo hành tinh người giết; `dropHuyDiet` = Hủy diệt bảng mới ở mục 42). SQL: không.
- Client: có. **Đóng hết cửa sổ game** rồi chạy `client-patch\cap-nhat-client.bat` (thêm `patch-ty-10.ps1`, kèm `patch-so-luong-ruong.ps1` của mục 38 nếu máy chưa áp). Chi tiết: `client-patch/CLIENT-UNITY.md` mục "Số dưới 10 tỷ hiện đủ dấu chấm". Máy nhà chưa áp (game đang mở lúc sửa); áp xong thì ghi `38` và `43` vào `.thay-doi-da-chay`.
- Sau khi build, tắt rồi bật lại server (`bt` hoặc `run.bat`).

## 44. Tổ sư Kaio: tách câu báo mở giới hạn đệ — 31/10/2026, máy nhà

- Build: có (`ToSuKaio.handleLimitPowerPet`: đệ bậc 9 báo "Sức mạnh của đệ tử đã đạt tới giới hạn", dưới bậc 5 báo "Đệ tử cần mở giới hạn tới bậc 5 ở Quốc Vương trước"; trước đây cả hai báo "cần đạt 50 tỷ sức mạnh"). Client: không. SQL: không.
- Sau khi build, tắt rồi bật lại server (`bt` hoặc `run.bat`).

## 45. Đệ Uub / Kid Beer / Jiren mặc được đồ cả 3 hành tinh — 31/10/2026, máy nhà

- Build: có (`InventoryService.putItemBody`: đệ `typePet` 2–4 bỏ qua kiểm tra hành tinh của đồ; đệ thường và Mabư vẫn chỉ mặc đồ cùng hành tinh). Client: không. SQL: không.
- Sau khi build, tắt rồi bật lại server (`bt` hoặc `run.bat`).

## 46. Boss lớn: HP, nhận đủ sát thương, tỉ lệ rơi mới; đổi kích hoạt theo hành tinh người chơi; ô đồ đệ VIP; client: số sát thương có dấu chấm — 31/10/2026, máy nhà

- Build: có. SQL: không.
- HP (`BossesData`): Cooler 1 tỷ, Cooler 2 1,5 tỷ, Black Goku 1 tỷ, Super Black Goku 3,5 tỷ, Cumber 2 tỷ (Super Cumber, Baby 3 dạng giữ 2 tỷ); Hủy diệt Beerus/Champa 3 tỷ (`HuyDiet.HP`), hồi sinh 20 phút (user sửa). Black Goku, Cumber, Baby, Xên bọ hung, Siêu bọ hung bỏ giảm sát thương. `NPoint.subDameInjureWithDeff` trả `long` (hết tràn số đòn > 2,1 tỷ).
- Rơi đồ: Thần Linh Baby 3/4/5%, Black Goku 5/7%, Cumber 7%, Cooler 5/7%, Siêu bọ hung 3/5%, Mabư 12h 0,15%; ngọc rồng boss lớn 10% x1 (2 sao 70%, 3 sao 30%), Mabư 12h không rơi ngọc rồng. Chi tiết BOSS-ROI-DO.md mục 2.
- Bà Hạt Mít đổi 3 Hủy Diệt → kích hoạt: hành tinh theo người chơi, loại theo món đặt đầu tiên.
- Đệ Uub/Kid Beer/Jiren: ô 8 mặc thú cưng (loại 27), đồ đeo lưng ô 9 hiện trên lưng đệ, kiểm tra đệ VIP bằng `typePet` (đổi đệ xong mặc được ngay); đệ không mặc sách tuyệt kỹ nữa. Đệ thường và Mabư vẫn 7 ô.
- Client: có. **Đóng game** rồi chạy `client-patch\cap-nhat-client.bat` (thêm `patch-so-sat-thuong.ps1`). Máy nhà đã áp vào `F:\nr-long`.
- Sau khi build, tắt rồi bật lại server (`bt` hoặc `run.bat`).

## 47. Đổi tên 3 item thành hộp thú cưng / đồ đeo lưng / thú cưỡi — 1/11/2026, máy nhà

- SQL (chạy từ file UTF-8 hoặc phpMyAdmin). Chưa có code mở hộp, chờ duyệt [KE-HOACH-HOP-QUA.md](KE-HOACH-HOP-QUA.md). Không dùng 1453 (để dành).
```sql
SET NAMES utf8mb4;
UPDATE item_template SET NAME='Hộp thú cưng', description='Mở ra ngẫu nhiên 1 thú cưng', icon_id=14514 WHERE id=1135;
UPDATE item_template SET NAME='Hộp đồ đeo lưng', description='Mở ra ngẫu nhiên 1 đồ đeo lưng', icon_id=14514 WHERE id=1136;
UPDATE item_template SET NAME='Hộp thú cưỡi', description='Mở ra ngẫu nhiên 1 thú cưỡi', icon_id=14514 WHERE id=1397;
UPDATE item_template SET is_up_to_up = 1 WHERE id IN (1135, 1136, 1397); -- cộng dồn trong túi
```
- Build: có (`DataGame.vsItem` 21 → 23 để client tải lại tên và cộng dồn). Client: không cần cập nhật.
- Kiểm tra: `SELECT id, NAME, is_up_to_up FROM item_template WHERE id IN (1135, 1136, 1397);` ra 3 tên hộp và `1`.

## 48. Gói VIP Tori Bot: hết lỗi reset mỗi ngày, mùa 1/11/2026–30/4/2027, bỏ x3 kinh nghiệm — 1/11/2026, máy nhà

- Build: có. SQL: không. Client: không.
- Trước đây `PlayerService.dailyLogin` lấy mốc hết mùa 5/7 nên từ 6/7 ngày nào cũng xóa lượt mua, cấp VIP và `timevip`. Giờ mùa khai báo một chỗ trong `ToriBot` (`VIP_SEASON_ID` = 1, mở 1/11/2026 đến hết 30/4/2027, ngoài khoảng đó đóng). `data_vip` thêm phần tử thứ 9 là mã mùa; nạp nhân vật thấy khác mã mùa thì reset lượt mua và cấp VIP, giữ `timevip`.
- VIP không cộng kinh nghiệm nữa (bỏ +3 của `timevip` và của cột `account.vip` trong `NPoint`), bỏ dòng "X3 Kinh nghiệm" trong menu Tori Bot và thông báo lúc đăng nhập.
- Sau khi build, tắt rồi bật lại server (`bt` hoặc `run.bat`).

## 49. Boss 12h giảm rơi đồ Thần Linh và đồ shop, Mabu rơi Bình 1795, đồ shop boss tối đa 8 sao — 6/11/2026, máy nhà

- Build: có. SQL: không. Client: không.
- Tỉ lệ nằm ở 1 chỗ, đầu `Teamobi2026/src/nro/models/boss/Boss.java` (số tính trên 10000):

| Hằng số | Giá trị | Nghĩa | Trước |
|---|---|---|---|
| `TL_BOSS_12H` | 5 = 0,05% | Đồ Thần Linh, 8 boss 12h | 0,15% |
| `TL_MABU_12H` | 30 = 0,3% | Đồ Thần Linh, riêng Mabu | 0,15% |
| `SHOP_BOSS_12H` | 15 = 0,15% | Đồ shop, cả 9 boss 12h | 1% |
| `BINH_KILIS_MABU_12H` | 500 = 5% | Bình 1795, riêng Mabu | không có |

- `Boss.randSaoDoShop` dùng chung cho 14 boss rơi đồ shop (9 boss 12h, Baby, Black Goku, Cooler, Cumber, Siêu bọ hung): 1–3 sao 79,49%, 4–5 sao 17%, 6 sao 3%, 7 sao 0,5%, 8 sao 0,01%. Đã mô phỏng 20 triệu lần, ra đúng các tỉ lệ này.
- `SHOP_BOSS_12H`: yêu cầu ghi "5%" rồi dòng dưới "0,15%". Đang hiểu là 0,15% vì đồ shop gốc 1% và yêu cầu là giảm. Muốn 5% thì đổi thành `500`.
- Kiểm tra sau khi build và bật lại server (tỉ lệ thấp nên muốn thấy nhanh thì tạm tăng hằng số, nhớ trả về):
  1. Đánh Mabu 12h nhiều lần: thỉnh thoảng rơi Bình hút năng lượng, nhặt được, xem chi tiết có dòng Kilis.
  2. Đánh Goku, Cadic...: không bao giờ rơi Bình.
  3. Đồ shop rơi từ boss: xem số sao trong chi tiết, có thể tới 7–8 sao. Pha lê hóa vẫn lên được tối đa 9 sao (`MAX_STAR_ITEM`).
  4. Tăng `SHOP_BOSS_12H` lên `10000` để test thì mọi boss 12h đều rơi đồ shop, nhớ trả về `15`.


## 50. Client: Né Boss, Tàn sát Boss (tab BOSS, lệnh chat neboss / tsboss), bỏ nút Hướng Dẫn Xài Mod — 6/11/2026, máy nhà

- Build: không. SQL: không. **Client: có.**
- Chạy `client-patch\cap-nhat-client.bat` (đã thêm `patch-ne-tan-sat-boss`). Tắt game và manager đang mở slot trước; slot của manager tự dựng lại khi client gốc đổi. Sao lưu `GameAssembly.dll.truoc-ne-tan-sat-boss`.
- Kiểm tra trong game (chưa thử):
  1. Phím X → menu không còn tab "Hướng Dẫn Xài Mod".
  2. Tab BOSS có thêm "Tàn sát Boss [Tắt]" và "Né Boss [Tắt]" sau "Focus BOSS"; bấm thì hiện thông báo Bật/Tắt, mở lại menu thấy chữ đổi.
  3. Chat `tsboss` và `neboss` cũng bật/tắt được.
  4. Bật Né Boss + tàn sát quái (`ts`), gọi boss vào khu: tự đổi khu. Sang map có boss: tự đổi khu.
  5. Bật Tàn sát Boss, trỏ vào boss: đánh boss đó; boss chết thì đứng yên.
  6. Map chỉ 1 khu: Né Boss không gửi đổi khu liên tục.


## 51. Mua số lượng trong shop tối đa 10000 mỗi lần (trước là 1000) — 6/11/2026, máy nhà

- Build: có (`ShopService.buyItemQuantity`, `Math.min(quantity, 10000)`). SQL: không. Client: không.
- Kiểm tra: mua món thường (vd Trang sách cũ) nhập 9999, thấy "Mua thành công x9999" nếu đủ tiền và đủ ô hành trang.
- **Bổ sung mục 51 (client)**: khung nhập số lượng khi mua ở shop đổi chữ thành "Mua (tối đa 10000)" (`client-patch/patch-nhap-so-luong.ps1`, sửa `global-metadata.dat`). **Client: có**, chạy `client-patch\cap-nhat-client.bat` trên mỗi máy (tắt game trước).


## 52. Chế tạo Cuốn sách cũ cần 999 Trang sách cũ (trước là 9999) — 6/11/2026, máy nhà

- Build: có (`combine/CheTaoCuonSachCu.java`, `REQUIRED_TRANG_SACH_CU` 9999 → 999, user tự sửa). SQL: không. Client: không.
- Sửa thêm: chế tạo Cuốn sách cũ và Đổi Sách Tuyệt kỹ (`DoiSachTuyetKy`) trước đây **không gửi lại hành trang** sau khi trừ/thêm đồ (hiệu ứng `-81` không kèm hành trang), nên client còn hiện số cũ tới khi vào lại. Đã thêm `InventoryService.gI().sendItemBags(player)` sau hiệu ứng thành công/thất bại ở cả 2 file, giống các combine khác.
- Các chỗ khác không phải sửa: số cần được hiện từ hằng số này (`formatRequirement`), mô tả item 1281/1282/1283 trong DB không ghi số lượng. Thất bại vẫn mất 99 trang + 1 bìa (`TRANG_SACH_CU_LOSS_ON_FAIL`, chữ "mất 99 trang sách" trong menu ghi cứng, khớp).
- Kiểm tra: Bà Hạt Mít → chế tạo Cuốn sách cũ, menu hiện `Trang sách cũ x/999`; đủ 999 trang + 1 bìa thì nút Đồng ý sáng.


## 53. Mảnh hồn bông tai rơi 20%, tối đa 500 mỗi ngày, báo khi đủ lượt — 6/11/2026, máy nhà

- Build: có (`mob/Mob.java`, `player/ItemEvent.java`). SQL: không. Client: không.
- Rơi từ quái map Thánh địa 156–159 (map `isMapUpPorata`). Mỗi quái giết: 10% Mảnh vỡ bông tai (933); nếu không trúng thì **20%** Mảnh hồn bông tai (934, trước 5%) nhưng chỉ khi người đó còn lượt trong ngày; nếu không thì 1/500 Đá xanh lam (935). Cổ Bồn La vẫn cộng +5/+3/+1 (934 thành 23%). Vì chỉ tung 934 khi 933 không trúng nên thực tế ≈ 18% mỗi quái.
- Giới hạn **500** mảnh hồn mỗi ngày mỗi người (trước 150, `canDropManhVo(500)`), tính lại sau nửa đêm. Sửa luôn lỗi cũ: lần đầu trong ngày không bị trừ lượt nên cho được 151 thay vì 150.
- Khi đã đủ lượt, **mỗi lần** lẽ ra rơi mảnh hồn (tức mỗi lần tung trúng 20% mà hết lượt) server báo "Hôm nay ngươi đã nhận đủ Mảnh hồn bông tai, hãy quay lại vào ngày mai" (không ghi số), mảnh không rơi. Ra khỏi map hoặc ngừng đánh thì không báo nữa.
- Chưa sửa: lượt còn lại lưu trong bộ nhớ (`ItemEvent`), không lưu DB, nên đăng xuất rồi đăng nhập lại là reset về đủ 500.
- Kiểm tra (tạm hạ 500 xuống 2 để test): giết quái ở map 156–159 tới khi đủ 2 mảnh hồn thì hiện thông báo, sau đó không rơi thêm.


## 54. Mảnh vỡ bông tai mua ở Santa có option 31 (đuôi 31) — 6/11/2026, máy nhà

- Build: không. Client: không. **SQL: có** (chạy lại ở máy kia, DB không theo git):
  ```sql
  INSERT INTO item_shop_option (item_shop_id, option_id, param) VALUES (911, 31, 1);
  INSERT INTO shop_reload_request () VALUES ();   -- server đang chạy tự nạp lại shop
  ```
- Lý do: logic nâng bông tai cấp 2 đọc số mảnh vỡ từ option 31 (`InventoryService.getParam`), món mua ở Santa (item_shop 911, 50 ngọc) không có option nên đếm ra 0. Giờ mỗi mảnh mua có `31:1` và tự gộp vào 1 ô như mảnh nhặt từ quái. Đá xanh lam (item_shop 910) đếm theo số lượng ô nên không cần.
- Chưa sửa: ô Mảnh vỡ/Mảnh hồn **cũ** không có option 31 mà người chơi đang giữ (lúc kiểm tra chỉ có `hoang`, đã sửa tay) vẫn đếm 0; mua thêm vào ô cũ đó thì món mua biến mất (hàm gộp không có option 31 để cộng). Nếu có người khác bị thì đổi ô đó sang dạng `[933,1,option 31 = số mảnh]` như mục chuyển của `hoang`.
- Kiểm tra: mua 1 Mảnh vỡ bông tai ở Santa, xem chi tiết có dòng "Số lượng 1"; mua thêm thì thành "Số lượng 2" trong cùng 1 ô; vào Bà Hạt Mít nâng bông tai thì đếm đúng.


## 55. Mảnh vỡ bông tai cấp 3 (1820) rơi 30% ở map Thánh địa, không giới hạn mỗi ngày — 6/11/2026, máy nhà

- Build: có (`mob/Mob.java`, cùng khối map 156–159 với mục 53). SQL: không. Client: không.
- Mỗi quái giết ở Tây/Đông/Bắc/Nam thánh địa: tung **riêng** 30% rơi 1 Mảnh vỡ bông tai cấp 3 (item 1820, option `31:1` nên tự gộp vào 1 ô), không phụ thuộc 3 lần tung của 933/934/935 và không có giới hạn mỗi ngày. Không tính Cổ Bồn La. Dùng để nâng bông tai cấp 2 → 3 (`NangCapBongTai3`: 20000 mảnh, 200 triệu vàng, 1000 ngọc).
- Kiểm tra: giết quái ở map 156–159, nhặt thấy "Mảnh vỡ bông tai cấp 3", giết thêm thì "Số lượng" cộng dồn trong cùng 1 ô; vào Bà Hạt Mít nâng bông tai cấp 2 thì đếm đúng.


## 56. Boss Hủy diệt (Beerus, Champa) rơi 5–20 thỏi vàng — 7/11/2026, máy nhà

- Build: có (`boss/thien_su/ThienSuHuyDietReward.dropHuyDiet`). SQL: không. Client: không.
- Nhánh 38% Thỏi vàng (457) trước rơi 1, giờ rơi ngẫu nhiên 5–20 (`Util.nextInt(5, 20)`). Thiên sứ Whis/Vados không rơi thỏi vàng nên không đổi. Đã cập nhật BOSS-ROI-DO.md mục 3b.
- Kiểm tra: giết Beerus hoặc Champa nhiều lần, khi rơi thỏi vàng thì số lượng nằm trong 5–20.


## 57. Cải trang Hắc Mị Nương trong quà VIP 4: hsd 30 ngày, May mắn → chí mạng 25–30% — 7/11/2026, máy nhà

- Build: có (`npc_list/ToriBot.java`, bản quà VIP 4). SQL: có (2 nick test). Client: không.
- Quà VIP 4 của ToriBot: Hắc Mị Nương (1557) từ vĩnh viễn thành **hạn 30 ngày** (option `93:30`, như quà VIP 1/2), option `236:25` (May mắn, server không dùng) đổi thành `5` (+% sức đánh chí mạng) ngẫu nhiên 25–30. Giữ `50:25`, `77:25`, `117:25` (117 là "Đẹp +SĐ", không phải HP; lỗi nhân đôi 117 xem CO-CHE.md). Đã sửa chữ trong menu VIP 4 ("hsd 30 ngày").
- SQL đã chạy cho 2 nick `tata2` và `hoang` (mỗi nick 2 cải trang 1557 trong hành trang, vẫn vĩnh viễn, không thêm option 93), chạy lại ở máy khác nếu có 2 nick này, lúc không ai đang online: `UPDATE player SET items_bag = REPLACE(items_bag,'[236,25]','[5,30]') WHERE name IN ('tata2','hoang') AND items_bag LIKE '%[1557,%';`
- Kiểm tra: nâng VIP 4 nick mới, cải trang có "Hạn sử dụng 30 ngày" và chí mạng 25–30%; nick `tata2`/`hoang` thấy dòng sức đánh chí mạng 30%, không còn May mắn.


## 58. Sửa lỗi option 117 "Đẹp +#% SĐ" bị cộng 2 lần vào sức đánh — 7/11/2026, máy nhà

- Build: có (`player/NPoint.setDame`). SQL: không. Client: không.
- Trước: `dame += dame * tlSexyDame / 100` viết 2 lần, nên 117 = 25% cho +56,25% sức đánh. Giờ cộng 1 lần đúng p%. Ảnh hưởng mọi món có 117 (Em xinh em đẹp 1514, CT Frieren 1567, Hắc Mị Nương quà VIP 4) ; buff 11 giây cho người xung quanh không đổi (tính riêng). Người chơi đang mặc các cải trang này sẽ thấy sức đánh giảm.
- Kiểm tra: mặc Hắc Mị Nương quà VIP 4 (50:25, 117:25), sức đánh so với lúc tháo ra tăng khoảng +56% (1,25 × 1,25), không còn khoảng +95% (1,25 × 1,5625).
