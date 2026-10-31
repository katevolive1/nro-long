# Version server

Mỗi version = 1 git tag `vN` (code) + `version/vN.sql` (dữ liệu game trong DB lúc chốt). Dữ liệu người chơi (account, player, bang hội, ký gửi, xếp hạng, web, nạp tiền) **không** đi theo version.

Bảng dữ liệu game đi theo version (danh sách trong `version.ps1`): `achievement_template`, `array_head_2_frames`, `bg_item_template`, `clan_task_template`, `data_badges`, `flag_bag`, `giftcode`, `head_avatar`, `img_by_name`, `intrinsic`, `item_option_template`, `item_shop`, `item_shop_option`, `item_template`, `map_template`, `mob_template`, `npc_template`, `part`, `radar`, `shop`, `tab_shop`, `side_task_template`, `skill_template`, `task_badges_template`, `task_main_template`, `task_sub_template`.

## Cách dùng

- **Chốt bản mới:** `version\chot-version.bat <N>`. Script xuất dữ liệu game ra `version\vN.sql`. Sau đó ghi mô tả vào file này, commit, `git tag vN`, `git push origin main vN`.
- **Chạy bản cũ:** tắt server, rồi `version\doi-version.bat <N>`. Script checkout tag `vN`, nạp `vN.sql` vào DB, đưa nhân vật đang đứng ở map không có trong bản đó về nhà, rồi build. Lần đầu rời bản mới nhất, script lưu dữ liệu game hiện tại vào `version\_dang-dung.sql` (gitignore).
- **Về bản mới nhất:** `version\doi-version.bat moi`. Script checkout `main` và nạp lại `_dang-dung.sql`.
- Đang ở bản cũ thì không sửa code, không commit. Repo phải sạch (đã commit hết) mới đổi được. Máy kia lấy tag: `git fetch --tags`.
- Client không đi theo version. Bản cũ dùng client mới nhất vẫn được, trừ khi bản đó cần client cũ (xem cột Client).

## Danh sách

| Bản | Tên | Ngày | Nội dung | Client |
|---|---|---|---|---|
| v1 | Trước Hủy diệt | – | Trước commit `bd9bc6f3`. **Không có `v1.sql`**, chưa chốt lúc đó nên không chuyển về được. | – |
| v2 | Boss Hủy diệt | 31/10/2026 | Commit `bd9bc6f3`: Thiên Sứ + Hủy Diệt ở map 186–188. **Không có `v2.sql`**, không chuyển về được. | – |
| v3 | Cân bằng boss | 1/11/2026 | THAY-DOI mục 41–48: bỏ sự kiện mía; Hủy diệt rơi đồ mới, HP 3 tỷ, hồi sinh 20 phút; HP boss lớn (Cooler, Black Goku, Cumber), bỏ giảm sát thương, tỉ lệ Thần Linh và ngọc rồng mới, Mabư 12h 0,15% Thần Linh; đổi 3 Hủy Diệt ra kích hoạt theo hành tinh người chơi; đệ Uub/Kid Beer/Jiren mặc đồ 3 hành tinh, ô thú cưng và đeo lưng; Liên hoàn Namếc 5–35%; đổi tên 3 hộp (chưa mở được); gói VIP Tori Bot mùa 1/11/2026–30/4/2027, bỏ x3 kinh nghiệm. | Cần `patch-ty-10.ps1`, `patch-so-sat-thuong.ps1` |
