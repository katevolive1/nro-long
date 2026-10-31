# Kế hoạch: clone nhân vật 1368 (account 3729) sang Xayda và Namek

Lập 31/10/2026. Chỉ làm trong DB `team10_long`, không sửa code, không build, client không cần cập nhật.

**Đã chạy 31/10/2026 (máy nhà)**, theo đề xuất bên dưới, user chốt: mật khẩu (không ghi vào git, hỏi user) cho cả 2 account (`xd`, `nm`), tên nhân vật Xayda `tata2`, Namek `hoang`; set Namek = Ốc tiêu (Liên Hoàn); kỹ năng, nội tại (về chưa mở), vị trí như đề xuất. Kết quả: account 3735 `xd` → player 1370 `tata2` (gender 2, head 27); account 3736 `nm` → player 1371 `hoang` (gender 1, head 29). Head Namek 29 = kiểu tóc tương ứng head 30 của TĐ (TĐ 64/30/31, Namek 9/29/32, Xayda 6/27/28). SQL: [THAY-DOI.md](THAY-DOI.md) mục 34.

**Sửa thêm (mục 35):** `tata2` đổi sao pha lê từ SĐ sang HP. Mỗi lỗ: đá SĐ (Ngọc rồng 16) `[50,3]`, đá HP (Ngọc rồng 20) `[77,5]` (`Item.getOptionDaPhaLe`). 7 sao ép gộp thành 1 option (`[50,21]` → `[77,35]`), lỗ 8/9 cường hóa là 2 option riêng (`[50,3]` → `[77,5]`). Trên cải trang Hit, sao ép SĐ cộng thẳng vào SĐ gốc (`[50,51]` = 30 gốc + 21).

## Nguồn
- Tài khoản `11` (id 3729, `is_admin`=1, `vnd` 9.890.000) → nhân vật id 1368 tên `3313`, Trái Đất (gender 0), head 30.
- DB hiện có: account 3728/3729/3730/3734, player 1367/1368/1369. Auto-increment: account 3735, player 1370. `account.username` và `player.account_id` là UNIQUE, tên nhân vật không UNIQUE trong DB (game tự kiểm tra 5–10 ký tự khi tạo qua client, chèn thẳng DB thì không bị chặn).

## Đã dò ở nhân vật 1368
- Đang mặc (`items_body`): áo 136 (Áo vải Kame, cấp 5), quần 242 (Quần bạc Goku, cấp 9), găng 257 (Găng jean Calic, cấp 12), giày 268 (Giày da Calic, cấp 11), rada 280 (dùng chung, gender 3), cải trang Hit 884, 1766, 1254, 1252. Mỗi món có option set `129` (Set Sôngôku) + `141` (5 món +100% sát thương Kamejoko), sao pha lê (`107:9`, `102:9`, `228:9`…) và chỉ số gốc (`47` giáp, `6`+`27` HP, `0` sức đánh, `7`+`28` KI, `14` chí mạng).
- Set theo hành tinh (bảng `ACTIVATION_SET` trong `RewardService`): TĐ Sôngôku **129+141**; Xayda Nappa **135+138** (5 món +80% HP), Kakarot 133+136, Ca Đíc 134+137; Namek Ốc tiêu **131+143** (5 món +100% sát thương Liên Hoàn), Pikkoro Daimao 132+144, Picolo 130+142.
- Kỹ năng đang có cấp 7: Dragon 0, Kamejoko 1, Thái Dương Hạ San 6, Dịch chuyển 20, Khiên 19. Chưa học (cấp 0): Kaioken 9, Quả cầu kênh khí 10, Thôi miên 22. Phím tắt `[0,1,6,20,19]`.
- `BoughtSkill` là danh sách ID sách kỹ năng đã học (lv2–lv7 của Dragon, Kamejoko, Thái Dương Hạ San, Dịch chuyển, Khiên).
- Nội tại hiện tại là id 6 "Dịch chuyển tức thời" (chỉ Trái Đất).
- Đệ tử Mabư (typePet 1, gender 2), sức mạnh/tiềm năng, đồ trên đệ, `data_point`, nhiệm vụ, túi/rương, bùa… giữ nguyên.

## Cách làm
1. **Nhân vật 1368 phải offline** lúc clone (server lưu bản trong RAM mỗi 5 phút, DB có thể cũ). Tạo 2 account/nhân vật mới là thêm dòng, không sửa dòng cũ nên không cần tắt server.
2. Mỗi hành tinh, cho `account` mới: `INSERT ... SELECT` từ account 3729 (giữ `vnd`, `is_admin`, `active`…), đổi `username`, `password`, `ip_address`/`token` rỗng, `id` mới.
3. `player` mới: `INSERT ... SELECT` từ player 1368 (mọi cột y chang: `data_point`, `data_inventory`, `items_bag`, `items_box`, `pet`, nhiệm vụ…), đổi `id` mới, `account_id` mới, `name` mới, `gender` 2 (Xayda) hoặc 1 (Namek), `head` đúng hành tinh (Xayda 27 như player 1369; Namek sẽ đọc `PlayerDAO.createNewPlayer` để lấy đúng head), `clan_id` 0.
4. Đổi đồ mặc (`items_body`) bằng cách thay ID món + option set, giữ nguyên mọi option khác và cấp độ:

| Cấp | Món | Trái Đất (nguồn) | Xayda | Namek |
|---|---|---|---|---|
| 5 | áo | 136 | 168 Áo giáp bạc | 152 Áo choàng len |
| 9 | quần | 242 | 250 Quần lông đỏ | 246 Quần sắt Tron |
| 12 | găng | 257 | 265 Găng lưỡng long | 261 Găng vàng Zealot |
| 11 | giày | 268 | 276 Giày Kaio | 272 Giày bạc Zealot |

   Option set: Xayda đổi `[129,1]`→`[135,1]` và `[141,1]`→`[138,1]` (Set Nappa, +80% HP). Namek đổi `[129,1]`→`[131,1]` và `[141,1]`→`[143,1]` (Set Ốc tiêu, +100% Liên Hoàn). Rada, cải trang, 1766, 1254, 1252 giữ nguyên.
5. Đổi kỹ năng sang hành tinh mới (xem điểm cần chốt 3): `skills`, `skills_shortcut`, `BoughtSkill` (ID sách lv2–lv7 tương ứng, lấy từ `item_template`), cấp 7 giữ nguyên.
6. Nội tại: đặt về chưa mở `[0,0,0,0,false,0,0,0]` (xem điểm cần chốt 4).
7. Kiểm tra sau khi chạy: đọc lại 2 dòng player, kiểm tra JSON hợp lệ (`JSON_VALID`), đếm option set trên 4 món, đăng nhập thử bằng client.
8. Ghi vào [THAY-DOI.md](THAY-DOI.md) lệnh SQL (DB không theo git, máy kia phải chạy lại). Script SQL để ở `db/` (bị gitignore); nội dung vào THAY-DOI.md.

## Điểm cần user chốt
1. **Tên tài khoản, mật khẩu, tên nhân vật.** Đề xuất: account `xd` / `nm`, tên nhân vật `3313xd` / `3313nm` (6 ký tự, không trùng).
2. **Set Namek "liên hoàn HP".** Trong game Namek không có set nào cộng HP: Ốc tiêu là +100% sát thương Liên Hoàn (131+143), HP +80% là của Nappa (Xayda). Em hiểu là Ốc tiêu (Liên Hoàn). Đúng không, hay muốn set Namek khác (Pikkoro Daimao = Đẻ trứng, Picolo = Masenkosappo)?
3. **Kỹ năng.** TĐ đang học 5 chiêu cấp 7 (đấm, chưởng, Thái Dương Hạ San, Dịch chuyển, Khiên). Đề xuất:
   - Xayda: Galick 4, Antomic 5, Tái tạo năng lượng 8, Trói 23, Khiên 19 cấp 7; Biến hình 13, Tự phát nổ 14, Huýt sáo 21 cấp 0. Phím tắt `[4,5,8,23,19]`.
   - Namek: Demon 2, Masenko 3, Trị thương 7, Liên hoàn 17, Khiên 19 cấp 7; Makankosappo 11, Đẻ trứng 12, Biến Sôcôla 18 cấp 0. Phím tắt `[2,3,7,17,19]`.
   Hành tinh khác không có Dịch chuyển, nên mỗi bên thay bằng chiêu cùng cấp ở trên. Muốn khác thì nói.
4. **Nội tại.** Id 6 là của Trái Đất, đặt về chưa mở (đề xuất) hay chọn nội tại cùng loại cho Xayda/Namek?
5. **Vị trí nhân vật** (`data_location` map 2, x 664, y 384) giữ nguyên cho cả hai, ok không?
