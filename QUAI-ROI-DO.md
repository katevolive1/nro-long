# Đánh quái rơi đồ theo map (tài liệu nội bộ, không đưa cho người chơi)

Dò 16/11/2026 từ [`Teamobi2026/src/nro/models/mob/Mob.java`](Teamobi2026/src/nro/models/mob/Mob.java) hàm `getItemMobReward` (~dòng 613–1088). Sửa tỉ lệ rơi đồ quái thì cập nhật file này. Boss rơi đồ: [BOSS-ROI-DO.md](BOSS-ROI-DO.md).

## Cách tính chung
- Mỗi con quái chết, server tung **từng dòng dưới đây độc lập** (trừ chỗ ghi "không trúng thì"), nên 1 con có thể rơi nhiều món cùng lúc.
- [`Util.isTrue(a, b)`](Teamobi2026/src/nro/models/utils/Util.java#L209) = a/b. Tỉ lệ tính bằng số nguyên nên **Cỏ bốn lá ×1,15 thường bị làm tròn xuống**: 1 → 1 (không tác dụng), 2 → 2, 10 → 11, 20 → 23.
- Người nhận = ai ra đòn kết liễu ([`Mob.injured`](Teamobi2026/src/nro/models/mob/Mob.java#L117) → `sendMobDieAffterAttacked(plAtt)`). Đệ tử giết thì tính theo đệ: hành tinh của đệ, đồ đệ mặc, Cỏ bốn lá của đệ.
- Không rơi gì: quái `tempId` 0, người giết là boss.
- Không có điều kiện tuổi tài khoản (mốc 35 ngày `isNewMember` không dùng ở đây). `active` chỉ ảnh hưởng ngọc rồng 6–7 sao, mảnh Thiên Sứ, bí kíp.

## Nhóm map trong code ([`MapService`](Teamobi2026/src/nro/models/map/service/MapService.java))
| Nhóm | Map |
|---|---|
| 3 hành tinh (`isMap3Planets`) | 1–6, 8–13, 15–20, 27–38 (≤ 38, trừ làng 0/7/14, nhà 21–23, trạm tàu 24–26) |
| Up SKH (`isMapUpSKH`) | 1 Đồi hoa cúc, 2 Thung lũng tre, 3 Rừng nấm, 8 Đồi nấm tím, 9 Thị trấn Moori, 11 Thung lũng Maima, 15 Đồi hoang, 16 Làng Plant, 17 Rừng nguyên sinh |
| Nappa (`isMapNappa`) | 63–83 |
| Tương lai (`isMapTuongLai(int)`) | 92–94, 96–100, 102, 103 |
| Lạnh (`isMapCold(int)`) | 105–110 (bản `int` không có 152) |
| Doanh trại | 53–62 |
| Phó bản | doanh trại + kho báu 135–138 + rắn độc 141–144 + khí gas 147–149, 151, 152 |
| Ngũ Hành Sơn | 122–124 |
| Ngục tù | 155 |
| Thánh địa (`isMapUpPorata`) | 156–159 |
| Riêng tư | 164 |
| `AllMap` | 0–163 |

## 1. Mọi map (kể cả 164, 165+, 186–188)
| Đồ | Tỉ lệ | Cỏ bốn lá | Ghi chú |
|---|---|---|---|
| Sao pha lê 441–447 (đỏ, lam, hồng, tím, cam, vàng, lục; mỗi màu 1/7) | 10% | 11% | [`Util.spl`](Teamobi2026/src/nro/models/utils/Util.java#L560) gắn sẵn chỉ số |
| Ngọc rồng 4–7 sao (17–20, mỗi loại 1/4) | 1% | 1% | |
| 1 Ngọc (77) | 1/1.000.000 | | |

Thức ăn 663–667 (Pudding … Sushi) đã chuyển sang mục 7 và 8 (chỉ map Tương lai và map lạnh, 16/11/2026).

## 2. Map 0–163 (`AllMap`)
| Đồ | Tỉ lệ |
|---|---|
| Tayaki 1798 | 5% |
| Kẹo táo 1799 | 5% |
| Kem que đôi 1800 | 5% |
| Khúc mía 1612 | 5% |
| Mochi 1801 | 1% |
| Ramen 1802 | 1/130 ≈ 0,77% |
| 2 Ngọc (77) | 1 lần, khi `player.event.luotNhanNgocMienPhi == 1` |

Cỏ bốn lá không ảnh hưởng nhóm này. Mỗi con quái còn cộng `monsterKillCountAutoTrain`.

## 3. Map 3 hành tinh (1–6, 8–13, 15–20, 27–38)
| Đồ | Tỉ lệ |
|---|---|
| Vàng 500–3.000 | 5% |
| Mảnh đá vụn 225 | 10% |
| Ngọc rồng 6 hoặc 7 sao (19/20) | 10/70 ≈ 14,3% (Cỏ 11/70 ≈ 15,7%); tài khoản active không trúng được tung thêm 1% → ≈ 15,1% (active + Cỏ ≈ 16,6%) |

Dòng ngọc rồng 6–7 sao áp dụng cả map Nappa, Tương lai, Lạnh.

## 4. Map up SKH (1, 2, 3, 8, 9, 11, 15, 16, 17)
Ngoài mục 1–3 còn có:

| Đồ | Tỉ lệ | Cỏ bốn lá |
|---|---|---|
| **Đồ kích hoạt** | 0,5% (trước 2/9999, sửa 16/11/2026) | 0,575% |
| Cápsule vỡ 1634 | 1/9999 | không đổi |
| ~~Đồ sao "3 map đầu"~~ (**tạm tắt 16/11/2026**, comment trong code, thay bằng mục 15) | ≈ 1/4.080 nếu sức mạnh < 100k, giảm theo sức mạnh (bảng dưới) | |
| ~~Đồ sao "khác vải thô"~~ (**tạm tắt 16/11/2026**) | 1/8000 × 1/19999 × 50% ≈ 1/320 triệu (coi như không rơi) | |

**Đồ kích hoạt** (`randTempItemKichHoat` + [`randOptionItemKichHoat`](Teamobi2026/src/nro/models/services/ItemService.java#L833)):
- Tỉ lệ = 0,5% × (1 + option 236) × Cỏ 1,15, tính trên 1 triệu nên không bị làm tròn. Option 236 (May mắn): tổng param trên đồ đang mặc (tối đa 100) → cộng (param/100)^1,5 × 20%, tối đa +20% → 0,6% (cùng Cỏ 0,69%). Trước 16/11/2026 tính trên 9999 nên 236 và phần lẻ của Cỏ bị cắt mất, Cỏ khi đó ×1,5.
- Loại: giày 41,1%, găng 20,7%, quần 15,9%, áo 12,3%, rađa 10%. Món theo hành tinh người giết, cấp 1 hoặc cấp 2 (50/50): áo 0/33 TĐ, 1/41 NM, 2/49 XD; quần 6/35, 7/43, 8/51; găng 21/24, 22/46, 23/53; giày 27/30, 28/47, 29/55; rađa 12/57.
- Set: 30% set loại 4 option (TĐ Thần Vũ Trụ Kaio 245–248, NM Nail 237–240, XD Cađic M 241–244), 70% còn lại chia 50/25/12,5/12,5. Tổng:
  - Trái Đất: Kaio 30%, Kirin 35%, Thên Xin Hăng 17,5%, Gohan 8,75%, Sôngôku 8,75%.
  - Namếc: Nail 30%, Picolo 35%, Ốc tiêu 17,5%, Gohan 8,75%, Pikkoro Daimao 8,75%.
  - Xayda: Cađic M 30%, Ca Đíc 35%, Nappa 17,5%, Gohan 8,75%, Kakarot 8,75%.
- Có chỉ số gốc như đồ shop và option 30 (không giao dịch).

**Đồ sao 3 map đầu** (`randDoSao`): tung 50/50000 (0,1%), rồi tỉ lệ theo sức mạnh, rồi 49% có lỗ sao (không có lỗ thì không rơi). Lỗ: 1 sao 60%, 2 sao 30%, 3 sao 10%. Loại: áo 22%, quần 23%, giày 22%, găng 23%, rađa 10%. Không gắn option 30 (giao dịch được).

| Sức mạnh | Tỉ lệ bước 2 (Cỏ) | Tổng mỗi con quái (không Cỏ) |
|---|---|---|
| < 100k | 50% (57%) | ≈ 1/4.080 |
| 100k – < 200k | 30% (37%) | ≈ 1/6.800 |
| 200k – < 300k | 10% (17%) | ≈ 1/20.400 |
| ≥ 300k | 0 | không rơi |

## 5. Map riêng tư 164
| Đồ | Tỉ lệ |
|---|---|
| Đồ kích hoạt (giống mục 4, cùng cách tính option 236 / Cỏ) | 0,5% (Cỏ 0,575%) |
| Cápsule vỡ 1634 | 1/19999 |

Map 164 không thuộc `AllMap` nên không có đồ ăn mục 2.

## 6. Map Nappa 63–83
- Vàng 2.000–6.000: 1%.
- Ngọc rồng 6–7 sao như mục 3.

## 7. Map Tương lai 92–94, 96–100, 102, 103
- Vàng 80.000–150.000: 15%.
- Ngọc rồng 6–7 sao như mục 3.
- Thức ăn 663–667 (mỗi loại 1/5): 5% khi mặc đủ set Thần Linh (`checkSetGod`), Cỏ không tác dụng. Cũng áp dụng map lạnh 105–110.

## 8. Map lạnh 105–110
| Đồ | Tỉ lệ |
|---|---|
| Vàng 150.000–250.000 | 30% |
| Đá nâng cấp 220–224 (lục bảo, saphia, ruby, titan, thạch anh tím; mỗi loại 4%) | 20% |
| Ngọc rồng 6–7 sao | như mục 3 |
| **Đồ Thần Linh** (`randDoTL`) | 1/50.000 (Cỏ không tác dụng) |
| Thức ăn 663–667 (mặc đủ set Thần Linh) | 5% |

Đồ Thần Linh: áo 27,8%, quần 30,4%, găng 22,5%, nhẫn 10%, giày 9,3%; món theo hành tinh ngẫu nhiên (áo 555/557/559, quần 556/558/560, găng 562/564/566, giày 563/565/567, nhẫn 561). Chỉ số = gốc × 100–115% (phần trên 100% ghi ở option 206), 21% có thêm option 86 hoặc 87, luôn có 21:15–17 (yêu cầu 15–17 tỷ sức mạnh). Rơi theo người kết liễu; đệ giết thì đồ tính cho sư phụ.

## 9. Doanh trại 53–62
| Đồ | Tỉ lệ |
|---|---|
| Cuốn chả giò 1778 | 20% (Cỏ 23%) |
| Mảnh đá vụn 225 | 10% |
| Vàng 80.000–200.000 (Cỏ ×1,15 số vàng) | 1% |

## 10. Phó bản khác (kho báu 135–138, rắn độc 141–144, khí gas 147–149, 151, 152)
- Vàng 80.000–200.000: 1% (Cỏ ×1,15 số vàng).

## 11. Ngũ Hành Sơn 122–124
- Quả Hồng Đào 541 hoặc Quả Hồng Đào Chín 542: 10% (mỗi loại 5%).

## 12. Hành tinh ngục tù 155
| Đồ | Tỉ lệ |
|---|---|
| Mảnh Thiên Sứ 1066–1070 (chỉ khi mặc đủ 5 món Hủy Diệt) | 10%, active thêm 2/555 → ≈ 10,3% |
| Bí kíp tuyệt kỹ 1229 | 10%; active và đủ set Hủy Diệt thêm 20% → 28% |

## 13. Thánh địa 156–159
| Đồ | Tỉ lệ (Cỏ) |
|---|---|
| Mảnh vỡ bông tai 933 | 10% (15%) |
| không trúng thì Mảnh hồn bông tai 934 | 20% (23%), tối đa 500/ngày |
| không trúng thì Đá xanh lam 935 | 1/500 (2/500) |
| Mảnh vỡ bông tai cấp 3 1820 (tung riêng) | 30% |

## 14. Rơi theo điều kiện riêng
- Viên Capsule kì bí 380: 20% khi đang dùng Máy dò và quái là Xên con cấp 1–8 (`tempId` 58–65).
- Nhiệm vụ 8 (`TASK_8_1`): quái thằn lằn/quỷ bay/phi long mẹ đúng hành tinh rơi Ngọc rồng 7 sao (20).
- Kilis (option 250) không phải đồ rơi: xem CLAUDE.md mục đệ tử.

## 15. Đồ shop làng theo map (từ 16/11/2026)
Code: [`ItemService.randDoShopRoiTuQuai`](Teamobi2026/src/nro/models/services/ItemService.java#L703) + [`capDoShopTheoMap`](Teamobi2026/src/nro/models/services/ItemService.java#L672), gọi trong [`Mob.getItemMobReward`](Teamobi2026/src/nro/models/mob/Mob.java#L613). Kế hoạch: [KE-HOACH-QUAI-ROI-DO-SHOP.md](KE-HOACH-QUAI-ROI-DO-SHOP.md).

**Tỉ lệ và cấp theo vùng** (tỉ lệ mỗi con quái, Cỏ bốn lá ×1,15)

| Vùng | Map | Tỉ lệ rơi | Cấp đồ sao | Cấp đồ kích hoạt |
|---|---|---|---|---|
| Đầu | 1, 2, 3, 8, 9, 11, 15, 16, 17 | 5% | 1–3 | 1–3 |
| Giữa | 4, 5, 6, 10, 12, 13, 18, 19, 20 | 2% | 3–5 | 1–5 |
| Xa | 27–38 | 1% | 5–7 | 1–7 |
| Fide | 63–83 | 0,5% | 7–9 | 1–9 |
| ~~Tương lai~~ (tắt) | 92–94, 96–100, 102, 103 | 0,3% | 9–11 | 1–11 |
| ~~Lạnh~~ (tắt) | 105–110 | 0,3% | 11–12 | 1–12 |

Đổi 16/11/2026: tỉ lệ từ 2% mọi vùng (Tương lai/lạnh 1%) thành đầu 5%, giữa 2%, xa 1%, Fide 0,5%, Tương lai/lạnh 0,3%; đồ kích hoạt từ cấp 1 (trước cùng cấp với đồ sao), đồ sao / kích hoạt 85% / 15% (trước 70% / 30%). **Tương lai và lạnh đang tắt** (chỉ rơi tới map Fide): 2 khối trong [`capDoShopTheoMap`](Teamobi2026/src/nro/models/services/ItemService.java#L672) bị comment, cần thì bỏ comment là chạy lại với số trong bảng. Dòng Ký gửi bên dưới chỉ có tác dụng khi bật lại.

**Khi rơi**

| | Đồ sao | Đồ kích hoạt |
|---|---|---|
| Tỉ lệ | 85% | 15% |
| Chọn cấp | Thấp nhất vùng 50%, kế 35%, cao 15% (lạnh: 11 và 12 mỗi cấp 50%) | Ngẫu nhiên đều từ cấp 1 tới cấp cao nhất vùng |
| Thêm option | 107 sao pha lê ([`Boss.randSaoDoShop`](Teamobi2026/src/nro/models/boss/Boss.java#L699), bảng dưới) | Set theo [`randOptionItemKichHoat`](Teamobi2026/src/nro/models/services/ItemService.java#L833) (tỉ lệ set như mục 4) |
| Giao dịch | Được | Không (option 30), không có lỗ sao |

**Số sao pha lê của đồ sao**

| Số sao | 1–3 | 4–5 | 6 | 7 | 8 |
|---|---|---|---|---|---|
| Tỉ lệ | 79,49% | 17% | 3% | 0,5% | 0,01% |

**Quy tắc chung**

| Mục | Cách tính |
|---|---|
| Loại đồ | Áo, quần, găng, giày, rađa, mỗi loại 20% |
| Chỉ số | Option shop × 100–115% (mỗi option tung riêng) |
| Hành tinh | Theo người kết liễu (đệ giết thì theo sư phụ, Cỏ cũng tính của sư phụ) |
| Sức mạnh | Không giới hạn (bỏ chặn 16/11/2026) |
| Ký gửi | Tương lai / lạnh: thêm 10% có Ký gửi vàng (86) hoặc Ký gửi ngọc (87), 50/50, cho cả đồ sao và đồ kích hoạt |
