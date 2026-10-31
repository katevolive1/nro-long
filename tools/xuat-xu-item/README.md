# Dò xuất xứ và chỉ số item

Tìm item được tạo ra ở đâu (code server, shop, giftcode) và chỉ số gán kèm. Dùng lần đầu 1/11/2026 cho KE-HOACH-HOP-QUA.md.

1. Xuất từ DB vào một thư mục tạm `<dir>` (Git Bash, `M="/c/xampp/mysql/bin/mysql.exe -uroot team10_long --default-character-set=utf8mb4 -N -r"`):
   - `ids.tsv`: `id, NAME, TYPE, gender, nhóm` của các item cần dò (`SELECT id, NAME, TYPE, gender, 'nhom' FROM item_template WHERE ...`).
   - `opt.tsv`: `SELECT id, NAME FROM item_option_template;`
   - `shop.tsv`: xem câu SELECT trong lịch sử THAY-DOI/kế hoạch: `temp_id, tag_name, tên NPC, tên tab, cost, type_sell, type_shop, tên item trả (theo icon_spec), option id=param;...` (chỉ `is_sell=1`).
   - `gift.tsv`: `SELECT code, detail FROM giftcode;` (bỏ xuống dòng trong detail).
   - `shop_an.tsv`: `temp_id, tag_name, tên NPC, tên tab` của dòng `item_shop` có `is_sell = 0`, cộng thêm dòng `temp_id, DELETED, tab_id, ""` cho dòng có tab hoặc shop đã bị xóa.
2. `perl scan.pl <dir> Teamobi2026/src` → `code.tsv` (id, file, dòng, hàm, kiểu, chỉ số, ghi chú). Bắt `createNewItem`, `new ItemMap`, mảng `{…}`, dải `nextInt(a, b)`; chỉ số đọc ~30 dòng sau, biến dạng `int x = nextInt(a, b)` được đổi ra khoảng.
3. `perl gen.pl <dir> > bang.md` → bảng markdown. Nhãn nguồn (hàm nào là hộp gì, NPC gì) nằm trong `%label` của gen.pl, item mới thì thêm nhãn.

Hạn chế: không bắt được item tạo qua biến id truyền từ nơi khác, quà nhiệm vụ trong DB, client. Kết quả "không có nguồn" nên kiểm tra tay vài món.
