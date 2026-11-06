# Kho ảnh

Đọc file này trước khi đụng vào ảnh. **Không mở ảnh lẻ để dò**, mỗi ảnh đều tốn token:

- Hỏi icon của item, hoặc icon này của item nào: tra [ICON.md](ICON.md) (bằng Grep, file dài).
- Cần nhìn nhiều icon: ghép bằng `tools/kho-anh/sheet.ps1`, xem 1 ảnh thay vì 200 ảnh.

## Thư mục

| Thư mục | Nội dung | Tên file | Git |
|---|---|---|---|
| `Teamobi2026/data/icon/x2`, `x3`, `x4` | Icon server gửi cho client | số ID | có |
| `web/icon` | Bản sao đúng 100% của `data/icon/x2`, chỉ trang admin dùng | số ID | có |
| `Teamobi2026/data/res/x1..x4` | Tài nguyên tải lần đầu (1.413 file) | tên | có |
| `Teamobi2026/data/mob`, `effect`, `item_bg_temp`, `map` | Quái, hiệu ứng, nền map | số ID | có |
| `web/images`, `web/img` | Ảnh web (logo, banner, gif, ảnh chụp game) | tên tay | có |
| `kho-anh/hop-nhat/` | Kho icon gộp x4, 1 file mỗi ID (23.647 file, 321 MB) | số ID | **không** |
| `kho-anh/ban-khac/<bộ>/` | Ảnh độc nhất nhưng trùng số ID với game (3.618 file, 84 MB) | số ID | **không** |
| `kho-anh/sheets/` | Ảnh ghép do `sheet.ps1` tạo | | **không** |

`x2`/`x3`/`x4` là mức zoom của client (`session.zoomLevel`), cùng ID thì ảnh x4 to gấp đôi x2. Thêm icon mới phải có đủ 3 mức và chép bản x2 sang `web/icon`.

## Kho gộp (`kho-anh/`, dựng 6/11/2026)

Nguồn: `F:\AILinhTinh\` gồm `icon_teamovi2026\x4`, `icons_x4`, `icon_tumlum\Icons\Icons`, `icon_teamobi2026_v2`, cộng `data/icon/x4`. Đều là x4.

**Quan trọng: các bộ ngoài game đánh số khác game.** Cùng ID có thể là hình khác hẳn (11880 ở game là mũ, ở `tumlum` là khẩu súng). Vì vậy:

- Chỉ `data/icon` là đúng số của game, luôn ưu tiên trước. `icon_teamovi2026` gần giống nhất (trùng 95%).
- Ảnh trong `ban-khac/` và ID mới từ `tumlum`, `icons_x4` chỉ là nguồn ảnh. **Đừng chép thẳng vào `data/icon` theo số**, phải chọn ảnh rồi đặt số mới.
- Thứ tự ưu tiên: `data/icon` > `icon_teamovi2026` > `icons_x4` > `icon_tumlum` > `icon_teamobi2026_v2`.

Kết quả: 50.852 file nguồn còn 26.705 ảnh khác nhau, không mất ảnh nào. Bỏ 37.724 file trùng cùng ID, 1.359 file trùng ảnh khác số (`kho-anh/lap-noi-dung.tsv`). 4.547 ID xung đột, trong đó 336 ID có item dùng (`kho-anh/xung-dot-dang-dung.txt`, chi tiết `kho-anh/BAO-CAO-XUNG-DOT.md`). `hop-nhat/` có vài ảnh trùng nội dung là cố ý: toàn bộ ID của game và ID item đang trỏ tới đều giữ, vì game gọi icon theo số.

Dựng lại ở máy khác (cần 4 bộ nguồn và MySQL):

```bash
mysql -uroot -N team10_long -e "SELECT DISTINCT icon_id FROM item_template;" > kho-anh/icon-item-dung.txt
rm -rf kho-anh/hop-nhat kho-anh/ban-khac
php tools/kho-anh/hop-nhat.php <repo>/kho-anh --giu=<repo>/kho-anh/icon-item-dung.txt \
  cur=<repo>/Teamobi2026/data/icon/x4 teamovi=<nguồn>/icon_teamovi2026/x4 icons_x4=<nguồn>/icons_x4 \
  tumlum=<nguồn>/icon_tumlum/Icons/Icons teamobi_v2=<nguồn>/icon_teamobi2026_v2
php tools/kho-anh/xuat-icon.php
```

## Công cụ (`tools/kho-anh/`)

- `hop-nhat.php`: gộp các bộ, bỏ lặp, giữ ảnh độc nhất. Không sửa file nguồn.
- `xuat-icon.php`: xuất `ICON.md` từ `item_template`. Đổi item trong DB thì chạy lại.
- `sheet.ps1`: ghép ảnh có nhãn ID (PHP XAMPP không có GD nên dùng PowerShell).
- `lam-du-zoom.ps1`: thêm icon mới chỉ có 1 mức zoom thì bù các mức còn lại và chép sang `web/icon`. Không ghi đè file có sẵn, có `-Preview`.

```powershell
.\sheet.ps1 -From 21500 -To 21599 -Cell 56                # dải ID trong kho gộp
.\sheet.ps1 -Ids 100,1000,14514 -Out thu.png              # vài ID
.\sheet.ps1 -Dir ..\..\kho-anh\ban-khac\tumlum -Ids 11880 # xem ban-khac
.\sheet.ps1 -Compare -Ids 11880 -Order cur,tumlum -Sets @{cur='...\data\icon\x4'; tumlum='...'}  # so bộ
```

## Lỗi đã thấy trong dữ liệu (6/11/2026, chưa sửa)

Đã xem ảnh ghép và đo kích thước, **đừng dò lại**:

- **12 cải trang thiếu trọn bộ ảnh** (item 1796 Đệ tử vegeta, 1841–1850 Cải trang Gốc, 1851 Broly Nes): `data/icon` không có icon item, và ảnh đầu/thân/chân trong `part` cũng thiếu. Mặc vào có thể không hiện đúng hình.
  - Toàn bảng `part`: 91/2.099 dòng trỏ tới ảnh không có, tổng 605 ID ảnh thiếu. 13 item có part thiếu ảnh.
  - **Không lấy được từ các bộ ngoài**: số lệch so với `part`. Vd part 1939 (đầu của item 1841) trỏ tới 21488, nhưng 21488 trong kho là cái quần, đầu thật nằm ở 21495–21496; item 1851 Broly Nes trỏ 20097 thì ra cái tay. Muốn sửa cần bộ ảnh gốc khớp `part`, hoặc sửa lại số trong `part` (có SQL, tăng `vsData`/`vsItem`, phải kiểm tra từng cải trang).
- **4 item ảnh trống**: 1752, 1753, 1754 Đai lưng (icon 14524, 14523, 14525) và 673 "abcd" (icon 15313). Ở mọi nơi chỉ có ảnh giữ chỗ 1x1, tức icon chưa từng được vẽ.
- **187 ID thiếu mức zoom không cần sửa**: 151 ID có x4 thiếu x2/x3 (15917–16036, 16672–16673, 16901–16935), 36 ID có x2 thiếu x4 (14523–14566). Tất cả là ảnh giữ chỗ 1x1 hoặc 2x2, không có ảnh thật. Đã thử bù rồi gỡ vì chỉ thêm file rác. `lam-du-zoom.ps1` nay tự bỏ qua ảnh giữ chỗ.

Icon mới chỉ cần chép vào `data/icon/x2..x4` (và x2 sang `web/icon`): `DataGame.sendIcon` đọc file mỗi lần client xin, không cần build lại server.
