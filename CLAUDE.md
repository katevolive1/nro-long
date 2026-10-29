# Quy tắc riêng cho NRO

## Bản long (nro-long)

- Chạy song song với bản int: server long dùng DB `team10_long`, port `14446`. Web long ở `web\` trong repo này, port `8081` (VirtualHost trong `apache\conf\extra\httpd-vhosts.conf`, mẫu ở `deploy\httpd-vhosts-long.conf`; `/download` dùng chung `C:\xampp\htdocs\download`, session tên `NROLONGSESSID`). Web long chỉ hiện nút tải PC (nút APK/iOS ẩn bằng `display:none` vì chưa có bản long). Bản int: DB `team10`, port 14445, web 8080.
- Repo git: `github.com/katevolive1/nro-long` (private, tác giả commit Manhnt). `db/*.sql` bị gitignore vì có mật khẩu tài khoản; DB phải chép tay. Bản clone để test: `D:\nro-long-clone` dùng DB `team10_long_clone`, không commit từ bản clone.
- **Vé hoàn thành nhiệm vụ** = item `1835` (dùng lại item bỏ không), icon `17742` (`data/icon/x2..x4/17742.png`, ảnh gốc `quest-skip.png`). Code: `TaskService.skipTaskMain`, `UseItem` case 1835. DB không theo git, máy khác phải chạy lại: `UPDATE item_template SET NAME='Vé hoàn thành nhiệm vụ', description='Dùng để hoàn thành ngay nhiệm vụ chính hiện tại và nhận thưởng', icon_id=17742 WHERE id=1835;`
- **Ghi chú dự án ghi vào file trong repo này (CLAUDE.md, `client-patch/CLIENT-UNITY.md`…), không ghi vào memory** vì user làm ở nhiều máy, memory không theo git.
- Đây là bản sao của `nro` với HP/KI kiểu `long`. Client đi kèm: `D:\nr-long` (đã đổi `ModFunc.isReadInt` = false trong `GameAssembly.dll`, offset `0x3E6298` và `0x59D538`). Client int cũ (`D:\nr`) không dùng được với server này.
- **Client Unity**: trước khi dò hay sửa client, đọc `client-patch/CLIENT-UNITY.md` (offset, hàm đã dò, công cụ `tools/xref.cs`). Dò được gì mới thì ghi thêm vào file đó.
- `NPoint.hp/hpMax/hpg/mp/mpMax/mpg`, `MobPoint.hp/maxHp`, `BossData.hp` là long. Trần HP/KI: `NPoint.MAX_HP_MP` (100 nghìn tỷ). `dame`/`def` vẫn là int.
- Client đọc bằng long (`readIntToLongDQT`) ở các gói sau. Khi thêm/sửa gói này phải dùng `writeLong` đúng vị trí:
  - `-30` sub 4 (hp, mp), sub 5 (hp), sub 6 (mp), sub 7 / `readCharInfo` (hp, hpMax sau tên), sub 9 (hp, hpMax), sub 14 (hp, hpMax), sub 15 (hp, mp).
  - `-42` (hpg, mpg, dameg, hpMax, mpMax, hp, mp, dame; `def` vẫn int).
  - `-107` đệ tử (hp, hpMax, mp, mpMax, dame; `def` vẫn short).
  - `-95` MobMe: type 0 (hp), 2 (dame, hp), 3 (hp, dame), 5 (damage, hp).
  - `-9` (hp, dame), `-10` (hp), `-11` (dame), `-12` (dame), `-13` (hp), `56` (hp, dame), `-60` (dame).
  - Template quái trong `DataGame` (hp) và danh sách quái khi vào map trong `Zone` (hp, hpFull).
- Các gói còn lại vẫn đọc int: boss to `101`/`102`/`51`, `87`… Nếu giá trị long thì dùng `Util.toInt()`.
- Build: biên dịch bằng javac (`-cp "lib/*"`) rồi `jar uf Teamobi2026.jar` các thư mục `nro`, `models`. Jar int cũ: `Teamobi2026-int-backup.jar`.

## Bảng rơi đồ boss

- Bảng boss rơi đồ và tỉ lệ nằm ở [BOSS-ROI-DO.md](BOSS-ROI-DO.md). Khi hỏi về đồ rơi từ boss, đọc file này trước, không quét lại code.
- Khi sửa code làm thay đổi đồ rơi hoặc tỉ lệ rơi của boss (hàm `reward()`, `afk()`, `dropCt()` trong `Teamobi2026/src/nro/models/boss/**`, `ItemService.randDoTLBoss`, `rewardRatio`…), phải cập nhật luôn phần tương ứng trong `BOSS-ROI-DO.md` ngay trong cùng lượt sửa.
- Thêm boss mới có rơi đồ thì thêm boss đó vào bảng. Xóa boss hoặc bỏ phần rơi đồ thì xóa hoặc chuyển boss đó sang mục "Không rơi đồ".
- Chỉ sửa đúng dòng hoặc mục liên quan, không viết lại cả file. Cập nhật ngày ở đầu file.
