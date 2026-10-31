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
