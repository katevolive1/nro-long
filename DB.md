# Cấu trúc DB `team10_long`

Lập ngày 30/10/2026 từ `information_schema` và code đọc DB (`database/MrBlue.java` khi đăng nhập, `database/PlayerDAO.java` khi lưu). Số dòng là lúc lập file. Đổi cấu trúc bảng thì cập nhật file này. Tra ID vật phẩm/option/map… xem [ID-GAME.md](ID-GAME.md).

**Sửa tay DB phải tắt server trước**: server giữ người chơi, bang, ký gửi… trong bộ nhớ và lúc lưu sẽ ghi đè. Riêng gift code và shop có bảng `*_reload_request` để server đang chạy nạp lại.

## Tài khoản, nhân vật

### `account` (tài khoản đăng nhập)
`id`, `username`, `password` (chữ thường, không mã hóa), `email`, `create_time`, `update_time`, `ban`, `is_admin`, `admin`, `last_time_login`, `last_time_logout`, `ip_address`, `active` (mặc định 1 = đã "mở thành viên"; tự về 0 nếu `vnd` âm lúc đăng nhập), `vnd` (số dư, mặc định 1.000.000 để test: `ALTER TABLE account ALTER vnd SET DEFAULT 1000000`, gốc là 0), `tongnap`, `thoi_vang`, `vang`, `luotquay`, `event_point`, `vip`, `tichdiem`, `server_login`, `bd_player`, `is_gift_box`, `gift_time`, `reward`, `token`, `xsrf_token`, `newpass`, cột web (`point_post`, `last_post`, `gioithieu`, `xacnhan_gioitheu`, `baiviet`, `xacminh`).

### `player` (nhân vật, 1 tài khoản 1 dòng)
Cột thường: `id`, `account_id` → `account.id`, `name`, `head`, `gender` (0 Trái Đất, 1 Namek, 2 Xayda), `clan_id`, `have_tennis_space_ship`, `create_time`, `firstTimeLogin`, `rank`, `event_point`, `point_sukien`, `point_sukien1`, `point_sukien2`, `point_maydam`, `total_damage_maydam`, `thachdauwhis`, `doanhtrai`, `rongxuong`, `lasttimepkcommeson`.

Cột JSON chính:
| Cột | Nội dung |
|---|---|
| `data_inventory` | `[vàng, ngọc, hồng ngọc, coupon, event]` |
| `data_location` | `[mapId, x, y]` |
| `data_point` | `[limitPower, sức mạnh, tiềm năng, thể lực, thể lực max, hpGốc, kiGốc, sđGốc, giápGốc, chí mạng gốc, critdragon, năng động (bỏ qua), hp hiện tại, ki hiện tại]` |
| `data_magic_tree` | đậu thần `[level, số đậu, đang nâng cấp 0/1, lần thu hoạch, lần nâng cấp]` |
| `data_task` | nhiệm vụ chính `[id nhiệm vụ, index bước, count, lastTime]` |
| `data_item_time` | thời gian còn lại bổ huyết, bổ khí, giáp xên… (số giây theo thứ tự cố định trong code) |
| `items_body` | đồ đang mặc |
| `items_bag` | hành trang |
| `items_box` | rương đồ |
| `items_box_lucky_round` | rương vòng quay may mắn |
| `items_daban` | đồ đã bán (mua lại) |
| `pet` | đệ tử `[info, chỉ số, items_body, skills]`; info = `[typePet, gender, tên, typeFusion, thời gian hợp thể, status]`; chỉ số giống `data_point` |
| `skills`, `skills_shortcut` | kỹ năng `[id, level, lastTimeUse, …]`, ô phím tắt |
| `friends`, `enemies` | bạn bè, kẻ thù |
| `data_intrinsic` | nội tại |
| `data_charm` | bùa |
| `data_black_ball` | ngọc rồng sao đen |
| `data_side_task`, `data_clan_task`, `nhiem_vu_kol` | nhiệm vụ phụ, bang, KOL (Quy Lão) |
| `data_card` | thẻ rada |
| `data_mabu_egg`, `data_duahau_egg` | trứng Mabư, trứng dưa hấu |
| `dataBadges`, `dataTaskBadges` | huy hiệu |
| `data_vip`, `data_achievement`, `dailyGift`, `giftcode` (code đã nhập), `data_event`, `data_item_event`, `data_luyentap`, `BoughtSkill`, `LearnSkill` | các dữ liệu tính năng khác |
| `bandokhobau`, `conduongrandoc`, `sieuthanthuy`, `vodaisinhtu`, `ruonggo`, `nhanthoivang`, `checkNhanQua`, `thanhTichBang`, `thanhTichKhiGas`, `thanhTichCDRD` | lượt/thời gian phó bản, thành tích |
| `baovetaikhoan`, `captcha`, `notify`, `masterDoesNotAttack` | mã bảo vệ, captcha, thông báo |

**Định dạng một ô đồ** (`items_*`, phần đồ của `pet`): mảng JSON, mỗi phần tử là chuỗi
```
[id item, số lượng, "[[id option, chỉ số], ...]", thời gian tạo (ms)]
```
Ô trống có id `-1`. Đồ không cộng dồn (cải trang, trang bị) mỗi cái 1 ô. Trong DB dấu `"` bên trong bị escape nhiều lớp (`\"`, `\\\"`). Option hay gặp: `93` hạn sử dụng (ngày), `154` không bán lại, `107` số sao pha lê, `102` sao pha lê đã ép, `30` không giao dịch. Tên option ở `item_option_template`.

## Bang hội
- `clan`: `id`, `NAME`, `NAME_2` (tên viết tắt 4 ký tự), `slogan`, `img_id`, `power_point`, `max_member`, `clan_point`, `LEVEL`, `members` (JSON thành viên: `id`, `name`, `head`, `body`, `leg`, `role`, `donate`, `receive_donate`, `member_point`, `clan_point`, `join_time` giây Unix, `ask_pea_time`, `power`), `tops`, `create_time`, `thanhTichBDKB`, `thongTinLeader`.
- `clan_task_template` (59): nhiệm vụ bang `NAME`, `max_count_lv1..5`.

## Dữ liệu game (template, ít khi sửa)
| Bảng | Dòng | Nội dung |
|---|---|---|
| `item_template` | 2000 | vật phẩm: `id`, `TYPE`, `gender` (3 = mọi hành tinh), `NAME`, `description` (tối đa 75 ký tự), `level`, `icon_id`, `part`, `is_up_to_up` (cộng dồn), `power_require`, `gold`, `gem`, `head`, `body`, `leg` |
| `item_option_template` | 251 | tên option (`#` là chỗ điền chỉ số) |
| `map_template` | 169 | map: `NAME`, `zones` (số khu), `max_player`, `type`, `planet_id`, `bg_*`, `tile_id`, `waypoints`, `mobs` (quái: temp, level, hp, x, y), `npcs`, `is_map_double` |
| `mob_template` | 119 | quái: `TYPE`, `NAME`, `hp`, `range_move`, `speed`, `dart_Type`, `percent_dame`, `percent_tiem_nang` |
| `npc_template` | 93 | NPC: `NAME`, `head`, `body`, `leg`, `avatar` |
| `skill_template` | 27 | kỹ năng theo `nclass_id` (hành tinh): `NAME`, `max_point`, `icon_id`, `dam_info`, `skills` (JSON từng cấp) |
| `intrinsic` | 208 | nội tại: `NAME`, `param_from/to_1/2`, `icon`, `gender` |
| `task_main_template` / `task_sub_template` | 30 / 125 | nhiệm vụ chính và các bước (`max_count`, `npc_id`, `map`) |
| `side_task_template` | 59 | nhiệm vụ phụ |
| `achievement_template` | 20 | thành tựu: `info1`, `info2`, `money`, `max_count` |
| `data_badges`, `task_badges_template` | 16, 18 | huy hiệu và nhiệm vụ nhận huy hiệu |
| `radar` | 21 | thẻ rada (quái, chỉ số, aura) |
| `flag_bag` | 156 | cờ/ba lô (`gold`, `gem`, `icon_id`) |
| `part`, `head_avatar`, `bg_item_template`, `img_by_name`, `array_head_2_frames` | | dữ liệu hình (đầu, thân, nền, ảnh) |

## Shop
- `shop` (32): cửa hàng theo `npc_id`, `tag_name`, `type_shop`.
- `tab_shop` (58): tab của shop (`shop_id`, `NAME`).
- `item_shop` (826): món bán: `tab_id`, `temp_id` (id item), `is_new`, `is_sell`, `type_sell` (loại tiền), `cost`, `icon_spec`, `sort_order`.
- `item_shop_option` (1420): option của món bán (`item_shop_id`, `option_id`, `param`).
- `shop_reload_request`: thêm dòng để server đang chạy nạp lại shop.
- `shop_ky_gui`: ký gửi (`player_id`, `tab`, `item_id`, `gold`/`gem` giá, `quantity`, `itemOption`, `isUpTop`, `isBuy`).

## Gift code, sự kiện, xếp hạng
- `giftcode`: `code`, `count_left`, `detail` (JSON đồ phát), `datecreate`, `expired`. Code tân thủ xem CLAUDE.md.
- `giftcode_reload_request`: thêm dòng để server đang chạy nạp lại gift code.
- `super_rank` (2): Siêu hạng (`player_id`, `rank`, `ticket`, `win`, `lose`, `history`).
- `history_transaction`: lịch sử giao dịch giữa 2 người (đồ trước/sau).
- `notify`: thông báo server.

## Nạp tiền, web (hiện trống)
`napthe`, `payments`, `bank_transfers` (nạp thẻ/ngân hàng), `adminpanel`, `settings` (cấu hình web), `posts` (8 bài), `comments`, `phongchat` (diễn đàn, chat web).
