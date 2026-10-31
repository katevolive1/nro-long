# Giá trị gốc trước khi chỉnh thử nghiệm

Danh sách những chỗ đang chỉnh để test. Khi mở bản chính thức, trả về cột "Gốc" rồi build lại. Đường dẫn tính từ `Teamobi2026/src/nro/models/`.

| Chỗ | Đang | Gốc |
|---|---|---|
| `map/phoban/RedRibbonHQ.java` `N_PLAYER_CLAN` (số thành viên bang để vào Doanh trại) | 1 | 5 |
| `map/phoban/RedRibbonHQ.java` `N_PLAYER_MAP` (đồng đội đứng gần Lính canh) | 0 | 1 |
| `map/phoban/RedRibbonHQ.java` `MIN_DAYS_IN_CLAN` (ngày vào bang) | 0 | 1 |
| `map/phoban/BanDoKhoBau.java` `POWER_CAN_GO_TO_DBKB` | 200000000 (200 triệu) | 2000000000 (2 tỷ) |
| `player/NPoint.java` TNSM Ngũ Hành Sơn 122–124 (`tiemNang *= 2`) | ×2 | ×1 (không có dòng nhân) |
| `player/NPoint.java` TNSM Bản đồ kho báu 135–138 (`tiemNang *= 3`) | ×3 | ×1,5 |
| `mob_bigboss/Hirudegarn.java` `DISABLED` | true | false |
| DB `account.vnd` mặc định | 1000000 | 0 (`ALTER TABLE account ALTER vnd SET DEFAULT 0`) |
| `map/phoban/DestronGas.java` `GIAM` (Khí Gas: chia máu + sát thương quái và Dr Lychee/Hatchiyack) | 20 | 1 |
| `services/shenron/SummonDragon.java` `timeResummonShenron` (chờ gọi rồng lần sau, chung cả server) | 180000 (3 phút) | 600000 (10 phút) |
| `boss/Boss_Manager/BossManager.loadBoss` Mặt Trời (`createBoss(BossID.MAT_TROI, 5)`) | comment (tắt) | 5 con |

## Khí Gas Hủy Diệt – công thức gốc (trước khi chia `GIAM`)
Đặt `GIAM = 1` là về đúng như dưới. Lv = cấp độ 1–110.
- Quái mạnh (`DestronGas.init()`, quái đầu ở 147/151/152, thứ 8 ở 149, thứ 34 ở 152): sát thương `Lv*31*5*tempId*10`, máu `Lv*3*6700*tempId*10`.
- Quái thường: sát thương `Lv*31*5*tempId`, máu `Lv*5*45*tempId`.
- Dr Lychee (`DestronGas.update()` + constructor `DrLychee`): sát thương `10000 + min(1000*Lv, 200000000)`, máu `1000000 + min(15000000*Lv, 2000000000)`.
- Hatchiyack (`DrLychee.leaveMap()`): ×1,5 sát thương (tối đa 200 triệu) và ×1,5 máu (tối đa 2 tỷ) của Dr Lychee — tự giảm theo Dr Lychee, không sửa riêng.
- Bảng số theo cấp 1/10/50/100/110: mục 7a [BOSS-ROI-DO.md](BOSS-ROI-DO.md) (là số gốc).
