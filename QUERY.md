# Câu SQL hay dùng

Chạy trong phpMyAdmin hoặc từ file `.sql` UTF-8 (gõ trong Git Bash thì chữ có dấu thành `?`). Sửa đồ/đệ của nhân vật thì cho nhân vật offline trước.

## Đổi loại đệ

Kid Beer → Mabư (số đầu: 0 thường, 1 Mabư, 2 Uub, 3 Kid Beer, 4 Jiren):

```sql
UPDATE player
SET pet = REPLACE(REPLACE(pet, '["[3,', '["[1,'), '$Kid Beer', '$Mabư')
WHERE name = 'hoang';
```
