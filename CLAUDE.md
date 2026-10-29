# Quy tắc riêng cho NRO

## Bản long (nro-long)

- Chỉ còn bản long (bản int `nro`, DB `team10`, client `D:\nr` đã xóa ngày 29/10/2026). Server long dùng DB `team10_long`, port `14446`. Web long ở `web\` trong repo này, port `8081` (VirtualHost trong `apache\conf\extra\httpd-vhosts.conf`, mẫu ở `deploy\httpd-vhosts-long.conf`; `/download` dùng chung `C:\xampp\htdocs\download`, session tên `NROLONGSESSID`). Web long chỉ hiện nút tải PC (nút APK/iOS ẩn bằng `display:none` vì chưa có bản long).
- Repo git: `github.com/katevolive1/nro-long` (private, tác giả commit Manhnt). `db/*.sql` bị gitignore vì có mật khẩu tài khoản; DB phải chép tay. Bản clone để test: `D:\nro-long-clone` dùng DB `team10_long_clone`, không commit từ bản clone.
- **Vé hoàn thành nhiệm vụ** = item `1835` (dùng lại item bỏ không), icon `17742` (`data/icon/x2..x4/17742.png`, ảnh gốc `quest-skip.png`). Code: `TaskService.skipTaskMain`, `UseItem` case 1835. DB không theo git, máy khác phải chạy lại: `UPDATE item_template SET NAME='Vé hoàn thành nhiệm vụ', description='Dùng để hoàn thành ngay nhiệm vụ chính hiện tại và nhận thưởng', icon_id=17742 WHERE id=1835;`
- Gift code `tanthutd`/`tanthunm`/`tanthuxd` (bảng `giftcode`, id 1262–1264, chỉ có trong DB): áo/quần/găng/giày cấp 1 của hành tinh + Rada cấp 1, mỗi món giữ chỉ số gốc như shop và thêm `107:5, 102:5, 101:25` (5 sao pha lê lục ép sẵn), `30:0`; kèm Ngọc rồng 1–7 sao. Gift code phát đồ đúng option ghi trong JSON, không tự thêm chỉ số gốc. Thêm dòng vào `giftcode_reload_request` để server đang chạy nạp lại code.
- Bảng ID (vật phẩm, option, map, nhiệm vụ, quái, NPC, kỹ năng) + lệnh admin: [ID-GAME.md](ID-GAME.md), xuất từ DB. Hỏi ID thì đọc file này; đổi dữ liệu DB thì xuất lại.
- **Ghi chú dự án ghi vào file trong repo này (CLAUDE.md, `client-patch/CLIENT-UNITY.md`…), không ghi vào memory** vì user làm ở nhiều máy, memory không theo git.
- Bản sao của server int `nro` (đã xóa) với HP/KI kiểu `long`. Client duy nhất: `D:\nr-long` (đã đổi `ModFunc.isReadInt` = false trong `GameAssembly.dll`, offset `0x3E6298` và `0x59D538`). Cập nhật client: `client-patch\cap-nhat-client.bat`.
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
- Build: biên dịch bằng javac (`-cp "lib/*"`) ra `build/classes-cli`, chép `Teamobi2026.jar` thành `build/Teamobi2026.next.jar` rồi `jar uf` các thư mục `nro`, `models` vào bản đó (`build.bat` làm vậy, build được khi server đang chạy). `run.bat` thấy `build/Teamobi2026.next.jar` thì thay vào `Teamobi2026.jar` trước khi chạy. Tắt server trước khi bật lại; trước khi tự tắt server kiểm tra không ai đang kết nối port 14446. Jar int cũ: `Teamobi2026-int-backup.jar`.

## Bảng rơi đồ boss

- Bảng boss rơi đồ và tỉ lệ nằm ở [BOSS-ROI-DO.md](BOSS-ROI-DO.md). Khi hỏi về đồ rơi từ boss, đọc file này trước, không quét lại code.
- Khi sửa code làm thay đổi đồ rơi hoặc tỉ lệ rơi của boss (hàm `reward()`, `afk()`, `dropCt()` trong `Teamobi2026/src/nro/models/boss/**`, `ItemService.randDoTLBoss`, `rewardRatio`…), phải cập nhật luôn phần tương ứng trong `BOSS-ROI-DO.md` ngay trong cùng lượt sửa.
- Boss thường không tự rời map (đã bỏ đồng hồ 15 phút trong `autoLeaveMap`/`active`, có comment "Không tự rời map"), chỉ biến mất khi bị giết. Còn giữ hẹn giờ: Mặt Trời, An Trộm, Ô Đỏ, Virut (15 phút, trong `active()`), Golden Frieza (21h), boss Mabư 12h, Pocolo, Nhân Bản, DeathBeam. `Boss.remindNotify` thông báo lại 5 phút/lần khi boss còn sống. Thông báo boss (gói 93) phải giữ đúng câu `BOSS <tên> vừa xuất hiện tại <tên map>`: mod client chỉ nhận câu này vào tab Thông báo và khung góc phải, câu khác chỉ chạy dưới màn hình. Lúc đăng nhập, `BossManager.sendBossAlive` gửi riêng các boss đang sống với `\t` ở đầu câu (client đã chạy `patch-thong-bao-boss.ps1` thì không chạy chữ dưới màn hình).
- Thêm boss mới có rơi đồ thì thêm boss đó vào bảng. Xóa boss hoặc bỏ phần rơi đồ thì xóa hoặc chuyển boss đó sang mục "Không rơi đồ".
- Chỉ sửa đúng dòng hoặc mục liên quan, không viết lại cả file. Cập nhật ngày ở đầu file.
