# Tỉ lệ đập đồ (Bà Hạt Mít) – ghi lại để rollback

Sửa ngày 30/10/2026. Code ở `Teamobi2026/src/nro/models/combine/`.

## 1. Pha lê hóa (`PhaLeHoaTrangBi.java`, hàm `getRatio`)
Trước đây NPC báo tỉ lệ `getFakeRatio` nhưng kết quả tính bằng bảng `getRatio` thấp hơn. Nay `getRatio` trả về đúng `getFakeRatio`.

| Lên sao | Mới (= NPC báo) | Cũ (thật trước khi sửa) |
|---|---|---|
| 0 → 1 | 80% | 50% |
| 1 → 2 | 40% | 20% |
| 2 → 3 | 30% | 10% |
| 3 → 4 | 20% | 5% |
| 4 → 5 | 10% | 1% |
| 5 → 6 | 5% | 0,7% |
| 6 → 7 | 3% | 0,5% |
| 7 → 8 | 2% | 0,1% |
| 8 → 9 | 1% | 0,1% |

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
(`CombineSystem.getRatioPhaLeHoa` là bảng trùng không ai gọi, không đổi.)

## 2. Nâng cấp đồ +1..+8 (`NangCapVatPham.java`)
Không đổi. NPC báo đúng tỉ lệ thật (`CombineSystem.getTileNangCapDo`).

## 3. Cường hóa lỗ sao pha lê thứ 9 (`CuongHoaLoSaoPhaLe.java`)
- Mới: `Util.isTrue(50, 100)` = 50%, đúng như NPC báo.
- Cũ: `Util.isTrue(50, 200)` = 25%. Rollback: đổi lại `100` thành `200`.
- Lỗ thứ 8 vẫn luôn thành công (không có xác suất).
