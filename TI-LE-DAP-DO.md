# Tỉ lệ đập đồ (Bà Hạt Mít) – ghi lại để rollback

Sửa ngày 30/10/2026. Code ở `Teamobi2026/src/nro/models/combine/`.

## 1. Pha lê hóa = đập/đục lỗ sao pha lê ([`PhaLeHoaTrangBi.java`](Teamobi2026/src/nro/models/combine/PhaLeHoaTrangBi.java), hàm `getRatio`)
Trước đây NPC báo tỉ lệ `getFakeRatio` nhưng kết quả tính bằng bảng `getRatio` thấp hơn. Nay `getRatio` trả về đúng `getFakeRatio`.
**Đổi lại 17/11/2026** (user chỉnh; `getFakeRatio` đổi `int` → `float` để có 0,5% / 0,3%). NPC vẫn báo đúng tỉ lệ thật.

| Lên sao (đục lỗ thứ) | Hiện tại (17/11/2026) | 30/10/2026 | Gốc (trước 30/10/2026) |
|---|---|---|---|
| 0 → 1 | 60% | 80% | 50% |
| 1 → 2 | 30% | 40% | 20% |
| 2 → 3 | 20% | 30% | 10% |
| 3 → 4 | 15% | 20% | 5% |
| 4 → 5 | 10% | 10% | 1% |
| 5 → 6 | 5% | 5% | 0,7% |
| 6 → 7 | 1% | 3% | 0,5% |
| 7 → 8 | 0,5% | 2% | 0,1% |
| 8 → 9 | 0,2% | 1% | 0,1% |

Rollback: thay thân hàm `getRatio(int star)` bằng switch cũ:
```java
switch (star) {
    case 0: return 50f;
    case 1: return 20f;
    case 2: return 10f;
    case 3: return 5f;
    case 4: return 1f;
    case 5: return 0.7f;
    case 6: return 0.5f;
    case 7: return 0.1f;
    case 8: return 0.1f;
}
return 0;
```
([`CombineSystem.getRatioPhaLeHoa`](Teamobi2026/src/nro/models/combine/CombineSystem.java#L162) là bảng trùng không ai gọi, không đổi.)

## 2. Nâng cấp đồ +1..+8 ([`NangCapVatPham.java`](Teamobi2026/src/nro/models/combine/NangCapVatPham.java))
Không đổi. NPC báo đúng tỉ lệ thật ([`CombineSystem.getTileNangCapDo`](Teamobi2026/src/nro/models/combine/CombineSystem.java#L293)): +0→1 80%, 1→2 50%, 2→3 20%, 3→4 10%, 4→5 7%, 5→6 5%, 6→7 1%, 7→8 0,3%. `case 8`–`12` đã comment (17/11/2026) vì đồ tối đa +8 (`MAX_LEVEL_ITEM`), không bao giờ chạy.

## 3. Cường hóa lỗ sao pha lê thứ 9 ([`CuongHoaLoSaoPhaLe.java`](Teamobi2026/src/nro/models/combine/CuongHoaLoSaoPhaLe.java))
- **Hiện tại (17/11/2026)**: `Util.isTrue(25, 100)` = **25%** (dòng 137), nhưng NPC vẫn báo **50%** (dòng 55). User cố ý giữ chữ NPC, không sửa.
- 30/10/2026: `Util.isTrue(50, 100)` = 50%, đúng như NPC báo.
- Gốc: `Util.isTrue(50, 200)` = 25%, NPC báo 50%.
- Lỗ thứ 8 vẫn luôn thành công (không có xác suất).
