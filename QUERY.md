# Câu SQL hay dùng

## Đổi loại đệ

```sql
UPDATE player
SET pet = REPLACE(REPLACE(pet, '["[3,', '["[1,'), '$Kid Beer', '$Mabư')
WHERE name = 'hoang';
```

## Cho buff Ngọc rồng sao đen (bù khi quên 20h)

### Một nhân vật

```sql
SET @t = UNIX_TIMESTAMP() * 1000 + 79200000;
UPDATE player
SET data_black_ball = CONCAT('[', REPEAT(CONCAT('"[', @t, ',0,0]",'), 6), '"[', @t, ',0,0]"]')
WHERE name = 'Tên nhân vật';
```

### Cả bang

```sql
SET @t = UNIX_TIMESTAMP() * 1000 + 79200000;
UPDATE player
SET data_black_ball = CONCAT('[', REPEAT(CONCAT('"[', @t, ',0,0]",'), 6), '"[', @t, ',0,0]"]')
WHERE clan_id = 123;
```

### Kiểm tra

```sql
SELECT name, data_black_ball FROM player WHERE name = 'Tên nhân vật';
```
