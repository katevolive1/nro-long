# ID trong game (bản long, DB `team10_long`)

Xuất từ DB ngày 29/10/2026. Thêm/sửa dữ liệu trong DB thì xuất lại file này. Boss (không nằm trong DB) xem [BOSS-ROI-DO.md](BOSS-ROI-DO.md).

## Lệnh admin (gõ ở ô chat)
| Lệnh | Tác dụng |
|---|---|
| `i <id> <số lượng> [option:giá trị ...]` | Lấy vật phẩm, ví dụ `i 1835 10`, `i 0 1 47:500 6:1000` |
| `item` / `getitem` | Mở khung nhập để tặng / lấy vật phẩm |
| `m<id>` | Dịch chuyển tới map, ví dụ `m5` |
| `n<id>` | Đặt nhiệm vụ chính, ví dụ `n10` |
| `up <số>` / `upp <số>` | Cộng sức mạnh cho mình / đệ tử |
| `hp <số>`, `ki <số>`, `dm <số>` | Đặt HP / KI / sức đánh gốc |
| `hs` | Hồi chiêu ngay |
| `a` | Menu admin |

## Lệnh chat của client mod (ai cũng dùng được, client tự xử lý)
| Lệnh | Tác dụng |
|---|---|
| `k <số>` | Đổi sang khu đó, ví dụ `k 3` |
| `s <1-10>` | Tốc độ game (1 = bình thường) |
| `ak` | Bật/tắt tự đánh |
| `ts` | Bật/tắt tàn sát (tự đánh quái quanh mình) |
| `tsnguoi` | Tàn sát người (chưa thử, đoán theo tên) |
| `ahs` | Bật/tắt tự hồi sinh |
| `vqmm` | Bật/tắt tự quay vòng quay may mắn |
| `ukhu` | Bật/tắt tự cập nhật danh sách khu |
| `htl` | Bật/tắt hành trang dạng lưới |
| `gtv` | Bật/tắt gõ tiếng Việt |
| `dbx` | Bật/tắt tự dò boss |
| `do <tên boss>` | Đặt tên boss cần dò |
| `atc <nội dung>` / `atctg <nội dung>` | Tự chat nội dung đó ở map / kênh thế giới |
| `loadskill` | Nạp lại thanh kỹ năng |

## Lệnh đệ tử (server)
`di theo`, `bao ve`, `tan cong`, `ve nha`, `bien hinh`, `ten con la <tên>` (đổi tên đệ), `sach tuyet ky` (đệ dùng sách tuyệt kỹ trong hành trang).

Mục lục: [Vật phẩm](#vật-phẩm) · [Option](#option-chỉ-số-vật-phẩm) · [Map](#map) · [Nhiệm vụ](#nhiệm-vụ-chính) · [Quái](#quái) · [NPC](#npc) · [Kỹ năng](#kỹ-năng)

## Vật phẩm
Loại: 0 áo, 1 quần, 2 găng, 3 giày, 4 rada, 5 cải trang; số khác là loại riêng của game. Hành tinh: 0 Trái Đất, 1 Namếc, 2 Xayda, 3 dùng chung.

| ID | Tên | Loại | Hành tinh |
|---|---|---|---|
| 0 | Áo vải 3 lỗ | 0 | 0 |
| 1 | Áo sợi len | 0 | 1 |
| 2 | Áo vải thô | 0 | 2 |
| 3 | Áo vải dày | 0 | 0 |
| 4 | Áo len Pico | 0 | 1 |
| 5 | Áo giáp sắt | 0 | 2 |
| 6 | Quần vải đen | 1 | 0 |
| 7 | Quần sợi len | 1 | 1 |
| 8 | Quần vải thô | 1 | 2 |
| 9 | Quần vải dày | 1 | 0 |
| 10 | Quần vải thô Pico | 1 | 1 |
| 11 | Quần giáp sắt | 1 | 2 |
| 12 | Rada cấp 1 | 4 | 3 |
| 13 | Đậu thần cấp 1 | 6 | 3 |
| 14 | Ngọc Rồng 1 sao | 12 | 3 |
| 15 | Ngọc Rồng 2 sao | 12 | 3 |
| 16 | Ngọc Rồng 3 sao | 12 | 3 |
| 17 | Ngọc Rồng 4 sao | 12 | 3 |
| 18 | Ngọc Rồng 5 sao | 12 | 3 |
| 19 | Ngọc Rồng 6 sao | 12 | 3 |
| 20 | Ngọc Rồng 7 sao | 12 | 3 |
| 21 | Găng vải đen | 2 | 0 |
| 22 | Găng sợi len | 2 | 1 |
| 23 | Găng vải thô | 2 | 2 |
| 24 | Găng thun đen | 2 | 0 |
| 25 | Găng len Pico | 2 | 1 |
| 26 | Găng sắt | 2 | 2 |
| 27 | Giầy nhựa | 3 | 0 |
| 28 | Giầy sợi len | 3 | 1 |
| 29 | Giầy vải thô | 3 | 2 |
| 30 | Giầy cao su | 3 | 0 |
| 31 | Giầy nhựa Pico | 3 | 1 |
| 32 | Giầy sắt | 3 | 2 |
| 33 | Áo thun 3 lỗ | 0 | 0 |
| 34 | Áo thun dày | 0 | 0 |
| 35 | Quần thun đen | 1 | 0 |
| 36 | Quần thun dày | 1 | 0 |
| 37 | Găng vải dày | 2 | 0 |
| 38 | Găng thun dày | 2 | 0 |
| 39 | Giày nhựa đế dày | 3 | 0 |
| 40 | Giày cao su đế dày | 3 | 0 |
| 41 | Áo sợi gai | 0 | 1 |
| 42 | Áo thun Pico | 0 | 1 |
| 43 | Quần sợi gai | 1 | 1 |
| 44 | Quần thun Pico | 1 | 1 |
| 45 | Găng thun Pico | 2 | 1 |
| 46 | Găng sợi gai | 2 | 1 |
| 47 | Giầy sợi gai | 3 | 1 |
| 48 | Giầy cao su Pico | 3 | 1 |
| 49 | Áo thun thô | 0 | 2 |
| 50 | Áo giáp đồng | 0 | 2 |
| 51 | Quần thun thô | 1 | 2 |
| 52 | Quần giáp đồng | 1 | 2 |
| 53 | Găng thun thô | 2 | 2 |
| 54 | Găng đồng | 2 | 2 |
| 55 | Giầy cao su thô | 3 | 2 |
| 56 | Giầy đồng | 3 | 2 |
| 57 | Rada cấp 2 | 4 | 3 |
| 58 | Rada cấp 3 | 4 | 3 |
| 59 | Rada cấp 4 | 4 | 3 |
| 60 | Đậu thần cấp 2 | 6 | 3 |
| 61 | Đậu thần cấp 3 | 6 | 3 |
| 62 | Đậu thần cấp 4 | 6 | 3 |
| 63 | Đậu thần cấp 5 | 6 | 3 |
| 64 | Đậu thần cấp 6 | 6 | 3 |
| 65 | Đậu thần cấp 7 | 6 | 3 |
| 66 | Sách đấm Dragon lv1 | 7 | 0 |
| 67 | Sách đấm Dragon lv2 | 7 | 0 |
| 68 | Sách đấm Dragon lv3 | 7 | 0 |
| 69 | Sách đấm Dragon lv4 | 7 | 0 |
| 70 | Sách đấm Dragon lv5 | 7 | 0 |
| 71 | Sách đấm Dragon lv6 | 7 | 0 |
| 72 | Sách đấm Dragon lv7 | 7 | 0 |
| 73 | Đùi gà | 8 | 3 |
| 74 | Đùi gà nướng | 27 | 3 |
| 75 | Đùi heo Xayda | 8 | 3 |
| 76 | Vàng | 9 | 3 |
| 77 | Ngọc | 10 | 3 |
| 78 | Đứa bé | 11 | 3 |
| 79 | Sách đấm Demon lv1 | 7 | 1 |
| 80 | Sách đấm Demon lv2 | 7 | 1 |
| 81 | Sách đấm Demon lv3 | 7 | 1 |
| 82 | Sách đấm Demon lv4 | 7 | 1 |
| 83 | Sách đấm Demon lv5 | 7 | 1 |
| 84 | Sách đấm Demon lv6 | 7 | 1 |
| 85 | Truyện tranh | 8 | 3 |
| 86 | Sách đấm Demon lv7 | 7 | 1 |
| 87 | Sách đấm Galick lv1 | 7 | 2 |
| 88 | Sách đấm Galick lv2 | 7 | 2 |
| 89 | Sách đấm Galick lv3 | 7 | 2 |
| 90 | Sách đấm Galick lv4 | 7 | 2 |
| 91 | Sách đấm Galick lv5 | 7 | 2 |
| 92 | Sách đấm Galick lv6 | 7 | 2 |
| 93 | Sách đấm Galick lv7 | 7 | 2 |
| 94 | Sách Kamejoko lv1 | 7 | 0 |
| 95 | Sách Kamejoko lv2 | 7 | 0 |
| 96 | Sách Kamejoko lv3 | 7 | 0 |
| 97 | Sách Kamejoko lv4 | 7 | 0 |
| 98 | Sách Kamejoko lv5 | 7 | 0 |
| 99 | Sách Kamejoko lv6 | 7 | 0 |
| 100 | Sách Kamejoko lv7 | 7 | 0 |
| 101 | Sách Masenko lv1 | 7 | 1 |
| 102 | Sách Masenko lv2 | 7 | 1 |
| 103 | Sách Masenko lv3 | 7 | 1 |
| 104 | Sách Masenko lv4 | 7 | 1 |
| 105 | Sách Masenko lv5 | 7 | 1 |
| 106 | Sách Masenko lv6 | 7 | 1 |
| 107 | Sách Masenko lv7 | 7 | 1 |
| 108 | Sách Antomic lv1 | 7 | 2 |
| 109 | Sách Antomic lv2 | 7 | 2 |
| 110 | Sách Antomic lv3 | 7 | 2 |
| 111 | Sách Antomic lv4 | 7 | 2 |
| 112 | Sách Antomic lv5 | 7 | 2 |
| 113 | Sách Antomic lv6 | 7 | 2 |
| 114 | Sách Antomic lv7 | 7 | 2 |
| 115 | Thái Dương Hạ San lv1 | 7 | 0 |
| 116 | Thái Dương Hạ San lv2 | 7 | 0 |
| 117 | Thái Dương Hạ San lv3 | 7 | 0 |
| 118 | Thái Dương Hạ San lv4 | 7 | 0 |
| 119 | Thái Dương Hạ San lv5 | 7 | 0 |
| 120 | Thái Dương Hạ San lv6 | 7 | 0 |
| 121 | Thái Dương Hạ San lv7 | 7 | 0 |
| 122 | Sách học Trị thương lv1 | 7 | 1 |
| 123 | Sách học Trị thương lv2 | 7 | 1 |
| 124 | Sách học Trị thương lv3 | 7 | 1 |
| 125 | Sách học Trị thương lv4 | 7 | 1 |
| 126 | Sách học Trị thương lv5 | 7 | 1 |
| 127 | Sách học Trị thương lv6 | 7 | 1 |
| 128 | Sách học Trị thương lv7 | 7 | 1 |
| 129 | Tái tạo năng lượng lv1 | 7 | 2 |
| 130 | Tái tạo năng lượng lv2 | 7 | 2 |
| 131 | Tái tạo năng lượng lv3 | 7 | 2 |
| 132 | Tái tạo năng lượng lv4 | 7 | 2 |
| 133 | Tái tạo năng lượng lv5 | 7 | 2 |
| 134 | Tái tạo năng lượng lv6 | 7 | 2 |
| 135 | Tái tạo năng lượng lv7 | 7 | 2 |
| 136 | Áo vải Kame | 0 | 0 |
| 137 | Áo thun Kame | 0 | 0 |
| 138 | Áo võ Kame | 0 | 0 |
| 139 | Áo võ Goku | 0 | 0 |
| 140 | Quần vải Kame | 1 | 0 |
| 141 | Quần thun Kame | 1 | 0 |
| 142 | Quần võ Kame | 1 | 0 |
| 143 | Quần võ goku | 1 | 0 |
| 144 | Găng vải Kame | 2 | 0 |
| 145 | Găng thun Kame | 2 | 0 |
| 146 | Găng võ Kame | 2 | 0 |
| 147 | Găng võ goku | 2 | 0 |
| 148 | Giày nhựa Kame | 3 | 0 |
| 149 | Giày cao su Kame | 3 | 0 |
| 150 | Giày võ kame | 3 | 0 |
| 151 | Giày võ goku | 3 | 0 |
| 152 | Áo choàng len | 0 | 1 |
| 153 | Áo choàng thun | 0 | 1 |
| 154 | Áo vải Pico | 0 | 1 |
| 155 | Áo da Pico | 0 | 1 |
| 156 | Quần len cứng | 1 | 1 |
| 157 | Quần thun cứng | 1 | 1 |
| 158 | Quần vải cứng Pico | 1 | 1 |
| 159 | Quần vải mềm Pico | 1 | 1 |
| 160 | Găng len cứng | 2 | 1 |
| 161 | Găng thun cứng | 2 | 1 |
| 162 | Găng vải Pico | 2 | 1 |
| 163 | Găng da Pico | 2 | 1 |
| 164 | Giày nhựa cứng | 3 | 1 |
| 165 | Giày cao su cứng | 3 | 1 |
| 166 | Giày da Pico | 3 | 1 |
| 167 | Giày sắt Pico | 3 | 1 |
| 168 | Áo giáp bạc | 0 | 2 |
| 169 | Áo giáp vàng | 0 | 2 |
| 170 | Áo lông Xayda | 0 | 2 |
| 171 | Áo khoác Xayda | 0 | 2 |
| 172 | Quần giáp bạc | 1 | 2 |
| 173 | Quần giáp vàng | 1 | 2 |
| 174 | Quần lông Xayda | 1 | 2 |
| 175 | Quần da Xayda | 1 | 2 |
| 176 | Găng bạc | 2 | 2 |
| 177 | Găng vàng | 2 | 2 |
| 178 | Găng lông Xayda | 2 | 2 |
| 179 | Găng da Xayda | 2 | 2 |
| 180 | Giày bạc | 3 | 2 |
| 181 | Giày vàng | 3 | 2 |
| 182 | Giày lông Xayda | 3 | 2 |
| 183 | Giày da Xayda | 3 | 2 |
| 184 | Rada cấp 5 | 4 | 3 |
| 185 | Rada cấp 6 | 4 | 3 |
| 186 | Rada cấp 7 | 4 | 3 |
| 187 | Rada cấp 8 | 4 | 3 |
| 188 | Vàng | 9 | 3 |
| 189 | Vàng | 9 | 3 |
| 190 | Vàng | 9 | 3 |
| 191 | Cà chua | 27 | 3 |
| 192 | Cà rốt | 27 | 3 |
| 193 | Gói 10 viên Capsule | 27 | 3 |
| 194 | Viên Capsule đặc biệt | 27 | 3 |
| 195 | Siêu thánh thủy | 27 | 3 |
| 196 | Avatar | 5 | 2 |
| 197 | Avatar | 5 | 2 |
| 198 | Avatar | 5 | 2 |
| 199 | Avatar | 5 | 2 |
| 200 | Avatar | 5 | 2 |
| 201 | Avatar | 5 | 0 |
| 202 | Avatar | 5 | 2 |
| 203 | Avatar | 5 | 0 |
| 204 | Avatar | 5 | 0 |
| 205 | Avatar | 5 | 0 |
| 206 | Avatar | 5 | 1 |
| 207 | Avatar | 5 | 1 |
| 208 | Avatar | 5 | 1 |
| 209 | Avatar | 5 | 2 |
| 210 | Avatar | 5 | 0 |
| 211 | Nho tím | 27 | 3 |
| 212 | Nho xanh | 27 | 3 |
| 213 | Bùa Trí Tuệ | 13 | 3 |
| 214 | Bùa Mạnh Mẽ | 13 | 3 |
| 215 | Bùa Da Trâu | 13 | 3 |
| 216 | Bùa Oai Hùng | 13 | 3 |
| 217 | Bùa Bất Tử | 13 | 3 |
| 218 | Bùa Dẻo Dai | 13 | 3 |
| 219 | Bùa Thu Hút | 13 | 3 |
| 220 | Đá lục bảo | 14 | 3 |
| 221 | Đá Saphia | 14 | 3 |
| 222 | Đá Ruby | 14 | 3 |
| 223 | Đá Titan | 14 | 3 |
| 224 | Đá thạch anh tím | 14 | 3 |
| 225 | Mảnh đá vụn | 15 | 3 |
| 226 | Bình nước phép | 16 | 3 |
| 227 | Avatar VIP | 5 | 0 |
| 228 | Avatar VIP | 5 | 1 |
| 229 | Avatar VIP | 5 | 2 |
| 230 | Áo bạc Goku | 0 | 0 |
| 231 | Áo vàng Goku | 0 | 0 |
| 232 | Áo da Calic | 0 | 0 |
| 233 | Áo jean Calic | 0 | 0 |
| 234 | Áo sắt Tron | 0 | 1 |
| 235 | Áo đồng Tron | 0 | 1 |
| 236 | Áo bạc Zealot | 0 | 1 |
| 237 | Áo vàng Zealot | 0 | 1 |
| 238 | Áo lông đỏ | 0 | 2 |
| 239 | Áo siêu xayda | 0 | 2 |
| 240 | Áo Kaio | 0 | 2 |
| 241 | Áo lưỡng long | 0 | 2 |
| 242 | Quần bạc Goku | 1 | 0 |
| 243 | Quần vàng Goku | 1 | 0 |
| 244 | Quần da Calic | 1 | 0 |
| 245 | Quần jean Calic | 1 | 0 |
| 246 | Quần sắt Tron | 1 | 1 |
| 247 | Quần đồng Tron | 1 | 1 |
| 248 | Quần bạc Zealot | 1 | 1 |
| 249 | Quần vàng Zealot | 1 | 1 |
| 250 | Quần lông đỏ | 1 | 2 |
| 251 | Quần siêu Xayda | 1 | 2 |
| 252 | Quần Kaio | 1 | 2 |
| 253 | Quần lưỡng long | 1 | 2 |
| 254 | Găng bạc Goku | 2 | 0 |
| 255 | Găng vàng Goku | 2 | 0 |
| 256 | Găng da Calic | 2 | 0 |
| 257 | Găng jean Calic | 2 | 0 |
| 258 | Găng sắt Tron | 2 | 1 |
| 259 | Găng đồng Tron | 2 | 1 |
| 260 | Găng bạc Zealot | 2 | 1 |
| 261 | Găng vàng Zealot | 2 | 1 |
| 262 | Găng lông đỏ | 2 | 2 |
| 263 | Găng siêu Xayda | 2 | 2 |
| 264 | Găng Kaio | 2 | 2 |
| 265 | Găng lưỡng long | 2 | 2 |
| 266 | Giày bạc Goku | 3 | 0 |
| 267 | Giày vàng Goku | 3 | 0 |
| 268 | Giày da Calic | 3 | 0 |
| 269 | Giày jean Calic | 3 | 0 |
| 270 | Giày sắt Tron | 3 | 1 |
| 271 | Giày đồng Tron | 3 | 1 |
| 272 | Giày bạc Zealot | 3 | 1 |
| 273 | Giày vàng Zealot | 3 | 1 |
| 274 | Giày lông đỏ | 3 | 2 |
| 275 | Giày siêu Xayda | 3 | 2 |
| 276 | Giày Kaio | 3 | 2 |
| 277 | Giày lưỡng long | 3 | 2 |
| 278 | Rada cấp 9 | 4 | 3 |
| 279 | Rada cấp 10 | 4 | 3 |
| 280 | Rada cấp 11 | 4 | 3 |
| 281 | Rada cấp 12 | 4 | 3 |
| 282 | Cải trang | 5 | 3 |
| 283 | Cải trang | 5 | 0 |
| 284 | Cải trang | 5 | 3 |
| 285 | Cải trang | 5 | 0 |
| 286 | Cải trang | 5 | 1 |
| 287 | Cải trang | 5 | 1 |
| 288 | Cải trang | 5 | 2 |
| 289 | Cải trang | 5 | 2 |
| 290 | Cải trang | 5 | 3 |
| 291 | Cải trang | 5 | 0 |
| 292 | Cải trang | 5 | 3 |
| 293 | Gói 30 đậu thần cấp 1 | 27 | 3 |
| 294 | Gói 30 đậu thần cấp 2 | 27 | 3 |
| 295 | Gói 30 đậu thần cấp 3 | 27 | 3 |
| 296 | Gói 30 đậu thần cấp 4 | 27 | 3 |
| 297 | Gói 30 đậu thần cấp 5 | 27 | 3 |
| 298 | Gói 30 đậu thần cấp 6 | 27 | 3 |
| 299 | Gói 30 đậu thần cấp 7 | 27 | 3 |
| 300 | Kaioken lv1 | 7 | 0 |
| 301 | Kaioken lv2 | 7 | 0 |
| 302 | Kaioken lv3 | 7 | 0 |
| 303 | Kaioken lv4 | 7 | 0 |
| 304 | Kaioken lv5 | 7 | 0 |
| 305 | Kaioken lv6 | 7 | 0 |
| 306 | Kaioken lv7 | 7 | 0 |
| 307 | Quả cầu Kênh Khi lv1 | 7 | 0 |
| 308 | Quả cầu Kênh Khi lv2 | 7 | 0 |
| 309 | Quả cầu Kênh Khi lv3 | 7 | 0 |
| 310 | Quả cầu Kênh Khi lv4 | 7 | 0 |
| 311 | Quả cầu Kênh Khi lv5 | 7 | 0 |
| 312 | Quả cầu Kênh Khi lv6 | 7 | 0 |
| 313 | Quả cầu Kênh Khi lv7 | 7 | 0 |
| 314 | Hóa khỉ khổng lồ lv1 | 7 | 2 |
| 315 | Hóa khỉ khổng lồ lv2 | 7 | 2 |
| 316 | Hóa khỉ khổng lồ lv3 | 7 | 2 |
| 317 | Hóa khỉ khổng lồ lv4 | 7 | 2 |
| 318 | Hóa khỉ khổng lồ lv5 | 7 | 2 |
| 319 | Hóa khỉ khổng lồ lv6 | 7 | 2 |
| 320 | Hóa khỉ khổng lồ lv7 | 7 | 2 |
| 321 | Bom hi sinh lv1 | 7 | 2 |
| 322 | Bom hi sinh lv2 | 7 | 2 |
| 323 | Bom hi sinh lv3 | 7 | 2 |
| 324 | Bom hi sinh lv4 | 7 | 2 |
| 325 | Bom hi sinh lv5 | 7 | 2 |
| 326 | Bom hi sinh lv6 | 7 | 2 |
| 327 | Bom hi sinh lv7 | 7 | 2 |
| 328 | Makankosappo lv1 | 7 | 1 |
| 329 | Makankosappo lv2 | 7 | 1 |
| 330 | Makankosappo lv3 | 7 | 1 |
| 331 | Makankosappo lv4 | 7 | 1 |
| 332 | Makankosappo lv5 | 7 | 1 |
| 333 | Makankosappo lv6 | 7 | 1 |
| 334 | Makankosappo lv7 | 7 | 1 |
| 335 | Đẻ trứng lv1 | 7 | 1 |
| 336 | Đẻ trứng lv2 | 7 | 1 |
| 337 | Đẻ trứng lv3 | 7 | 1 |
| 338 | Đẻ trứng lv4 | 7 | 1 |
| 339 | Đẻ trứng lv5 | 7 | 1 |
| 340 | Đẻ trứng lv6 | 7 | 1 |
| 341 | Đẻ trứng lv7 | 7 | 1 |
| 342 | Vệ tinh trí lực | 22 | 3 |
| 343 | Vệ tinh trí tuệ | 22 | 3 |
| 344 | Vệ tinh phòng thủ | 22 | 3 |
| 345 | Vệ tinh sinh lực | 22 | 3 |
| 346 | Cân đẩu vân | 23 | 0 |
| 347 | Phi Long | 23 | 1 |
| 348 | Ván bay | 23 | 2 |
| 349 | Cân đẩu vân VIP | 24 | 0 |
| 350 | Phi Long VIP | 24 | 1 |
| 351 | Ván bay VIP | 24 | 2 |
| 352 | Đậu thần cấp 8 | 6 | 3 |
| 353 | Ngọc Rồng Namek 1 Sao | 11 | 3 |
| 354 | Ngọc Rồng Namek 2 Sao | 11 | 3 |
| 355 | Ngọc Rồng Namek 3 Sao | 11 | 3 |
| 356 | Ngọc Rồng Namek 4 Sao | 11 | 3 |
| 357 | Ngọc Rồng Namek 5 Sao | 11 | 3 |
| 358 | Ngọc Rồng Namek 6 Sao | 11 | 3 |
| 359 | Ngọc Rồng Namek 7 Sao | 11 | 3 |
| 360 | Ngọc Rồng Namek | 11 | 3 |
| 361 | Gói 10 Rađa dò ngọc | 25 | 3 |
| 362 | Hóa thạch Ngọc Rồng | 11 | 3 |
| 363 | Tháo cờ | 28 | 3 |
| 364 | Cờ xanh | 28 | 3 |
| 365 | Cờ đỏ | 28 | 3 |
| 366 | Cờ tím | 28 | 3 |
| 367 | Cờ vàng | 28 | 3 |
| 368 | Cờ lục | 28 | 3 |
| 369 | Cờ hồng | 28 | 3 |
| 370 | Cờ cam | 28 | 3 |
| 371 | Cờ xám | 28 | 3 |
| 372 | Ngọc rồng 1 sao đen | 11 | 3 |
| 373 | Ngọc rồng 2 sao đen | 11 | 3 |
| 374 | Ngọc rồng 3 sao đen | 11 | 3 |
| 375 | Ngọc rồng 4 sao đen | 11 | 3 |
| 376 | Ngọc rồng 5 sao đen | 11 | 3 |
| 377 | Ngọc rồng 6 sao đen | 11 | 3 |
| 378 | Ngọc rồng 7 sao đen | 11 | 3 |
| 379 | Máy dò Capsule kì bí | 29 | 3 |
| 380 | Viên Capsule kì bí | 27 | 3 |
| 381 | Cuồng nộ | 29 | 3 |
| 382 | Bổ huyết | 29 | 3 |
| 383 | Bổ khí | 29 | 3 |
| 384 | Giáp Xên bọ hung | 29 | 3 |
| 385 | Ẩn danh | 29 | 3 |
| 386 | Nón Noel Xám | 5 | 0 |
| 387 | Nón Noel Đỏ | 5 | 0 |
| 388 | Nón Noel Xanh | 5 | 0 |
| 389 | Nón Noel Xám | 5 | 1 |
| 390 | Nón Noel Đỏ | 5 | 1 |
| 391 | Nón Noel Xanh | 5 | 1 |
| 392 | Nón Noel Xám | 5 | 2 |
| 393 | Nón Noel Đỏ | 5 | 2 |
| 394 | Nón Noel Xanh | 5 | 2 |
| 395 | Nhân vật bí ẩn | 27 | 3 |
| 396 | Thú cưỡi cực VIP | 24 | 3 |
| 397 | Hộp quà tết | 27 | 3 |
| 398 | Hộp quà tết | 27 | 3 |
| 399 | Thiệp chúc tết | 27 | 3 |
| 400 | Đặt tên đệ tử | 27 | 3 |
| 401 | Đổi đệ tử | 27 | 3 |
| 402 | Nâng kỹ năng 1 đệ tử | 27 | 3 |
| 403 | Nâng kỹ năng 2 đệ tử | 27 | 3 |
| 404 | Nâng kỹ năng 3 đệ tử | 27 | 3 |
| 405 | Cải trang | 5 | 3 |
| 406 | Cải trang | 5 | 3 |
| 407 | Cải trang | 5 | 3 |
| 408 | Cải trang | 5 | 3 |
| 409 | Cải trang | 5 | 3 |
| 410 | Cải trang | 5 | 3 |
| 411 | Cải trang | 5 | 3 |
| 412 | Avatar | 5 | 0 |
| 413 | Avatar | 5 | 0 |
| 414 | Avatar | 5 | 0 |
| 415 | Avatar | 5 | 1 |
| 416 | Avatar | 5 | 1 |
| 417 | Avatar | 5 | 1 |
| 418 | Avatar | 5 | 2 |
| 419 | Avatar | 5 | 2 |
| 420 | Avatar | 5 | 2 |
| 421 | Cải trang | 5 | 3 |
| 422 | Cải trang | 5 | 3 |
| 423 | Cải trang | 5 | 3 |
| 424 | Cải trang | 5 | 3 |
| 425 | Cải trang | 5 | 3 |
| 426 | Cải trang | 5 | 3 |
| 427 | Cải trang | 5 | 3 |
| 428 | Cải trang | 5 | 3 |
| 429 | Cải trang | 5 | 3 |
| 430 | Cải trang | 5 | 3 |
| 431 | Cải trang | 5 | 3 |
| 432 | Cải trang | 5 | 3 |
| 433 | Cải trang | 5 | 3 |
| 434 | Khiên năng lượng lv1 | 7 | 3 |
| 435 | Khiên năng lượng lv2 | 7 | 3 |
| 436 | Khiên năng lượng lv3 | 7 | 3 |
| 437 | Khiên năng lượng lv4 | 7 | 3 |
| 438 | Khiên năng lượng lv5 | 7 | 3 |
| 439 | Khiên năng lượng lv6 | 7 | 3 |
| 440 | Khiên năng lượng lv7 | 7 | 3 |
| 441 | Sao pha lê đỏ | 30 | 3 |
| 442 | Sao pha lê lam | 30 | 3 |
| 443 | Sao pha lê hồng | 30 | 3 |
| 444 | Sao pha lê tím | 30 | 3 |
| 445 | Sao pha lê cam | 30 | 3 |
| 446 | Sao pha lê vàng | 30 | 3 |
| 447 | Sao pha lê lục | 30 | 3 |
| 448 | Cải trang | 5 | 3 |
| 449 | Cải trang | 5 | 3 |
| 450 | Cải trang | 5 | 3 |
| 451 | Cải trang | 5 | 3 |
| 452 | Cải trang | 5 | 3 |
| 453 | Chiến thuyền Tennis | 27 | 3 |
| 454 | Bông tai Porata | 27 | 3 |
| 455 | Cải trang | 5 | 3 |
| 456 | Bình nước | 27 | 3 |
| 457 | Thỏi vàng | 27 | 3 |
| 458 | Cải trang | 5 | 3 |
| 459 | Phiếu giảm giá | 27 | 3 |
| 460 | Cục xương | 27 | 3 |
| 461 | Cải trang | 5 | 3 |
| 462 | Củ cà rốt | 27 | 3 |
| 463 | Cải trang | 5 | 3 |
| 464 | Cải trang | 5 | 3 |
| 465 | Bánh Trung Thu 1 trứng | 31 | 3 |
| 466 | Bánh Trung Thu 2 trứng | 31 | 3 |
| 467 | Lồng đèn Ông Sao | 11 | 3 |
| 468 | Lồng đèn Cá chép | 11 | 3 |
| 469 | Lồng đèn Kéo Quân | 11 | 3 |
| 470 | Lồng đèn Ông trăng | 11 | 3 |
| 471 | Lồng đèn Hội An | 11 | 3 |
| 472 | Bánh Trung Thu Đặc Biệt | 31 | 3 |
| 473 | Hộp bánh Trung Thu | 31 | 3 |
| 474 | Sách Biến Sôcôla lv1 | 7 | 1 |
| 475 | Sách Biến Sôcôla lv2 | 7 | 1 |
| 476 | Sách Biến Sôcôla lv3 | 7 | 1 |
| 477 | Sách Biến Sôcôla lv4 | 7 | 1 |
| 478 | Sách Biến Sôcôla lv5 | 7 | 1 |
| 479 | Sách Biến Sôcôla lv6 | 7 | 1 |
| 480 | Sách Biến Sôcôla lv7 | 7 | 1 |
| 481 | Sách Liên hoàn lv1 | 7 | 1 |
| 482 | Sách Liên hoàn lv2 | 7 | 1 |
| 483 | Sách Liên hoàn lv3 | 7 | 1 |
| 484 | Sách Liên hoàn lv4 | 7 | 1 |
| 485 | Sách Liên hoàn lv5 | 7 | 1 |
| 486 | Sách Liên hoàn lv6 | 7 | 1 |
| 487 | Sách Liên hoàn lv7 | 7 | 1 |
| 488 | Sách Dịch Chuyển lv1 | 7 | 0 |
| 489 | Sách Dịch Chuyển lv2 | 7 | 0 |
| 490 | Sách Dịch Chuyển lv3 | 7 | 0 |
| 491 | Sách Dịch Chuyển lv4 | 7 | 0 |
| 492 | Sách Dịch Chuyển lv5 | 7 | 0 |
| 493 | Sách Dịch Chuyển lv6 | 7 | 0 |
| 494 | Sách Dịch Chuyển lv7 | 7 | 0 |
| 495 | Sách Thôi Miên lv1 | 7 | 0 |
| 496 | Sách Thôi Miên lv2 | 7 | 0 |
| 497 | Sách Thôi Miên lv3 | 7 | 0 |
| 498 | Sách Thôi Miên lv4 | 7 | 0 |
| 499 | Sách Thôi Miên lv5 | 7 | 0 |
| 500 | Sách Thôi Miên lv6 | 7 | 0 |
| 501 | Sách Thôi Miên lv7 | 7 | 0 |
| 502 | Sách Trói lv1 | 7 | 2 |
| 503 | Sách Trói lv2 | 7 | 2 |
| 504 | Sách Trói lv3 | 7 | 2 |
| 505 | Sách Trói lv4 | 7 | 2 |
| 506 | Sách Trói lv5 | 7 | 2 |
| 507 | Sách Trói lv6 | 7 | 2 |
| 508 | Sách Trói lv7 | 7 | 2 |
| 509 | Sách Huýt Sáo lv1 | 7 | 2 |
| 510 | Sách Huýt Sáo lv2 | 7 | 2 |
| 511 | Sách Huýt Sáo lv3 | 7 | 2 |
| 512 | Sách Huýt Sáo lv4 | 7 | 2 |
| 513 | Sách Huýt Sáo lv5 | 7 | 2 |
| 514 | Sách Huýt Sáo lv6 | 7 | 2 |
| 515 | Sách Huýt Sáo lv7 | 7 | 2 |
| 516 | Sôcôla | 27 | 3 |
| 517 | Mở rộng hành trang | 27 | 3 |
| 518 | Mở rộng rương đồ | 27 | 3 |
| 519 | Cờ Kaiô | 28 | 3 |
| 520 | Cờ Mabư | 28 | 3 |
| 521 | Tự động luyện tập | 27 | 3 |
| 522 | Bùa Đệ Tử | 13 | 3 |
| 523 | Đậu thần cấp 9 | 6 | 3 |
| 524 | Cải trang | 5 | 3 |
| 525 | Cải trang | 5 | 3 |
| 526 | Cải trang | 5 | 3 |
| 527 | Cải trang | 5 | 3 |
| 528 | Cải trang | 5 | 3 |
| 529 | Giáp tập luyện cấp 1 | 32 | 3 |
| 530 | Giáp tập luyện cấp 2 | 32 | 3 |
| 531 | Giáp tập luyện cấp 3 | 32 | 3 |
| 532 | Quỷ Chim | 24 | 3 |
| 533 | Kẹo giáng sinh | 27 | 3 |
| 534 | Giáp tập luyện cấp 1 | 32 | 3 |
| 535 | Giáp tập luyện cấp 2 | 32 | 3 |
| 536 | Giáp tập luyện cấp 3 | 32 | 3 |
| 537 | Chữ giải | 27 | 3 |
| 538 | Chữ khai | 27 | 3 |
| 539 | Chữ phong | 27 | 3 |
| 540 | Chữ ấn | 27 | 3 |
| 541 | Quả Hồng Đào | 27 | 3 |
| 542 | Quả Hồng Đào Chín | 27 | 3 |
| 543 | Vòng Kim Cô | 27 | 3 |
| 544 | Cải trang | 5 | 0 |
| 545 | Cải trang | 5 | 1 |
| 546 | Cải trang | 5 | 2 |
| 547 | Cải trang | 5 | 3 |
| 548 | Cải trang | 5 | 3 |
| 549 | Cải trang | 5 | 3 |
| 550 | Cải trang | 5 | 3 |
| 551 | Cải trang | 5 | 3 |
| 552 | Cải trang | 5 | 3 |
| 553 | Pháo bông | 27 | 3 |
| 554 | Siêu Pháo bông x100 | 27 | 3 |
| 555 | Áo Thần Linh | 0 | 0 |
| 556 | Quần Thần Linh | 1 | 0 |
| 557 | Áo Thần Namếc | 0 | 1 |
| 558 | Quần Thần namếc | 1 | 1 |
| 559 | Áo Thần Xayda | 0 | 2 |
| 560 | Quần Thần Xayda | 1 | 2 |
| 561 | Nhẫn Thần Linh | 4 | 3 |
| 562 | Găng Thần Linh | 2 | 0 |
| 563 | Giầy Thần Linh | 3 | 0 |
| 564 | Găng Thần Namếc | 2 | 1 |
| 565 | Giầy Thần Namếc | 3 | 1 |
| 566 | Găng Thần Xayda | 2 | 2 |
| 567 | Giầy Thần Xayda | 3 | 2 |
| 568 | Quả Trứng | 27 | 3 |
| 569 | Dưa Hấu | 27 | 3 |
| 570 | Rương Gỗ | 27 | 3 |
| 571 | Rương Bạc | 27 | 3 |
| 572 | Rương Vàng | 27 | 3 |
| 573 | Capsule Bạc | 27 | 3 |
| 574 | Capsule Vàng | 27 | 3 |
| 575 | Cải trang | 5 | 3 |
| 576 | Cải trang | 5 | 3 |
| 577 | Cải trang | 5 | 3 |
| 578 | Cải trang | 5 | 3 |
| 579 | Đuôi khỉ | 29 | 3 |
| 580 | Cải trang | 5 | 3 |
| 581 | Cải trang | 5 | 3 |
| 582 | Cải trang | 5 | 3 |
| 583 | Cải trang Póc | 5 | 3 |
| 584 | Cải trang | 5 | 3 |
| 585 | Bí ngô | 27 | 3 |
| 586 | Cải trang | 5 | 3 |
| 587 | Cải trang | 5 | 3 |
| 588 | Cải trang | 5 | 3 |
| 589 | Bông hoa | 27 | 3 |
| 590 | Bí kiếp | 27 | 3 |
| 591 | Cải trang Siêu Thần | 5 | 3 |
| 592 | Cải trang Yardrat | 5 | 0 |
| 593 | Cải trang Yardrat | 5 | 1 |
| 594 | Cải trang Yardrat | 5 | 2 |
| 595 | Đậu thần cấp 10 | 6 | 3 |
| 596 | Gói 30 đậu thần cấp 8 | 27 | 3 |
| 597 | Gói 30 đậu thần cấp 9 | 27 | 3 |
| 598 | Avatar | 5 | 0 |
| 599 | Avatar | 5 | 1 |
| 600 | Avatar | 5 | 2 |
| 601 | Cải trang Hợp Thể | 5 | 0 |
| 602 | Cải trang Hợp Thể | 5 | 1 |
| 603 | Cải trang Hợp Thể | 5 | 2 |
| 604 | Cải trang VIP | 5 | 0 |
| 605 | Cải trang VIP | 5 | 1 |
| 606 | Cải trang VIP | 5 | 2 |
| 607 | Cải trang Chan Xư | 5 | 0 |
| 608 | Cải trang Lão Cận | 5 | 1 |
| 609 | Cải trang Xayda | 5 | 2 |
| 610 | Bông hoa | 27 | 3 |
| 611 | Bản đồ kho báu | 27 | 3 |
| 612 | Cải trang Arale | 5 | 3 |
| 613 | Cải trang Gatchan | 5 | 3 |
| 614 | Cải trang Obotchaman | 5 | 3 |
| 615 | Cải trang | 5 | 3 |
| 616 | Cải trang | 5 | 3 |
| 617 | Cải trang | 5 | 3 |
| 618 | Cải trang Luffy | 5 | 3 |
| 619 | Cải trang Zoro | 5 | 3 |
| 620 | Cải trang Sanji | 5 | 3 |
| 621 | Cải trang Brook | 5 | 3 |
| 622 | Cải trang Chopper | 5 | 3 |
| 623 | Cải trang Nami | 5 | 3 |
| 624 | Cải trang Franky | 5 | 3 |
| 625 | Cải trang Usopp | 5 | 3 |
| 626 | Cải trang Robin | 5 | 3 |
| 627 | Capsule quà tặng | 27 | 3 |
| 628 | Cải trang Hải Tặc | 5 | 3 |
| 629 | Cải trang Fide vàng | 5 | 3 |
| 630 | Cải trang Frost 1 | 5 | 3 |
| 631 | Cải trang Frost 2 | 5 | 3 |
| 632 | Cải trang Frost 3 | 5 | 3 |
| 633 | Cải trang Píc | 5 | 3 |
| 634 | Cải trang King kong | 5 | 3 |
| 635 | Cải trang Pi láp | 5 | 3 |
| 636 | Cải trang Mai | 5 | 3 |
| 637 | Cải trang Su | 5 | 3 |
| 638 | Bình chứa Commeson | 27 | 3 |
| 639 | Cải trang Hợp Thể | 5 | 2 |
| 640 | Cải trang Hợp Thể | 5 | 0 |
| 641 | Cải trang Hợp Thể | 5 | 1 |
| 642 | Cải trang ma trơi | 5 | 3 |
| 643 | Cải trang dơi nhí | 5 | 3 |
| 644 | Cải trang bộ xương | 5 | 0 |
| 645 | Cải trang bộ xương | 5 | 1 |
| 646 | Cải trang bộ xương | 5 | 2 |
| 647 | Cải trang Saibamen | 5 | 3 |
| 648 | Hộp quà giáng sinh | 27 | 3 |
| 649 | Tất,vớ giáng sinh | 27 | 3 |
| 650 | Áo Hủy Diệt | 0 | 0 |
| 651 | Quần Hủy Diệt | 1 | 0 |
| 652 | Áo Hủy Diệt | 0 | 1 |
| 653 | Quần Hủy Diệt | 1 | 1 |
| 654 | Áo Hủy Diệt | 0 | 2 |
| 655 | Quần Hủy Diệt | 1 | 2 |
| 656 | Nhẫn Hủy Diệt | 4 | 3 |
| 657 | Găng Hủy Diệt | 2 | 0 |
| 658 | Giầy Hủy Diệt | 3 | 0 |
| 659 | Găng Hủy Diệt | 2 | 1 |
| 660 | Giầy Hủy Diệt | 3 | 1 |
| 661 | Găng Hủy Diệt | 2 | 2 |
| 662 | Giầy Hủy Diệt | 3 | 2 |
| 663 | Bánh Pudding | 29 | 3 |
| 664 | Xúc xích | 29 | 3 |
| 665 | Kem dâu | 29 | 3 |
| 666 | Mì ly | 29 | 3 |
| 667 | Sushi | 29 | 3 |
| 668 | Hộp quà Tết 2019 | 27 | 3 |
| 669 | Dưa Hấu | 29 | 3 |
| 670 | Cà rốt | 29 | 3 |
| 671 | Bùa Trí Tuệ x3 | 13 | 3 |
| 672 | Bùa Trí Tuệ x4 | 13 | 3 |
| 673 | abcd | 27 | 3 |
| 674 | Đá ngũ sắc | 27 | 3 |
| 675 | Cải trang | 5 | 3 |
| 676 | Cải trang | 5 | 3 |
| 677 | Cải trang | 5 | 3 |
| 678 | Cải trang | 5 | 3 |
| 679 | Cải trang | 5 | 3 |
| 680 | Cải trang | 5 | 3 |
| 681 | Cải trang | 5 | 3 |
| 682 | Avatar | 5 | 1 |
| 683 | Avatar | 5 | 1 |
| 684 | Avatar | 5 | 1 |
| 685 | Avatar | 5 | 2 |
| 686 | Avatar | 5 | 2 |
| 687 | Avatar | 5 | 2 |
| 688 | Avatar | 5 | 0 |
| 689 | Avatar | 5 | 0 |
| 690 | Avatar | 5 | 0 |
| 691 | Quần đi biển | 1 | 0 |
| 692 | Quần đi biển | 1 | 1 |
| 693 | Quần đi biển | 1 | 2 |
| 694 | Trái dừa | 29 | 3 |
| 695 | Vỏ ốc | 27 | 3 |
| 696 | Vỏ sò | 27 | 3 |
| 697 | Con cua | 27 | 3 |
| 698 | Sao biển | 27 | 3 |
| 699 | HP +400K | 27 | 3 |
| 700 | Sức đánh +20K | 27 | 3 |
| 701 | KI +400K | 27 | 3 |
| 702 | Bí ngô 1 sao | 12 | 3 |
| 703 | Bí ngô 2 sao | 12 | 3 |
| 704 | Bí ngô 3 sao | 12 | 3 |
| 705 | Bí ngô 4 sao | 12 | 3 |
| 706 | Bí ngô 5 sao | 12 | 3 |
| 707 | Bí ngô 6 sao | 12 | 3 |
| 708 | Bí ngô 7 sao | 12 | 3 |
| 709 | Bông hoa | 27 | 3 |
| 710 | Cải trang | 5 | 3 |
| 711 | Cải trang | 5 | 3 |
| 712 | Truy | 27 | 3 |
| 713 | Bắt | 27 | 3 |
| 714 | Đại | 27 | 3 |
| 715 | Vương | 27 | 3 |
| 716 | Urôn | 27 | 3 |
| 717 | Bao Lì Xì | 27 | 3 |
| 718 | Vé tặng ngọc | 27 | 3 |
| 719 | Cải trang | 5 | 3 |
| 720 | Mảnh cải trang | 27 | 3 |
| 721 | Phiếu giảm giá VIP | 27 | 3 |
| 722 | Capsule hồng | 27 | 3 |
| 723 | Bông hồng | 27 | 3 |
| 724 | Cải trang | 5 | 3 |
| 725 | Siêu thần thủy | 27 | 3 |
| 726 | Mảnh giấy có chữ MA | 27 | 3 |
| 727 | Siêu thần thủy | 27 | 3 |
| 728 | Siêu thần thủy | 27 | 3 |
| 729 | Cải trang Hatchiyack | 5 | 3 |
| 730 | Cải trang Sói Basil | 5 | 3 |
| 731 | Cải trang Sói Lavender | 5 | 3 |
| 732 | Cải trang Sói Bergamo | 5 | 3 |
| 733 | Cân đẩu vân ngũ sắc | 23 | 3 |
| 734 | Ngọc Thố | 23 | 3 |
| 735 | Lồng đèn cá chép | 23 | 3 |
| 736 | Hộp quà 5 sao | 27 | 3 |
| 737 | Capsule Trung Thu | 27 | 3 |
| 738 | Cải trang Dr Lychee | 5 | 3 |
| 739 | Cải trang Bill Bí Ngô | 5 | 3 |
| 740 | Lưỡi hái Thần Chết | 11 | 3 |
| 741 | Cánh dơi Dracula | 11 | 3 |
| 742 | Cải trang Caufila Dơi | 5 | 3 |
| 743 | Chổi bay Phù Thủy | 23 | 3 |
| 744 | Cột nhà | 23 | 3 |
| 745 | Bông tuyết | 11 | 3 |
| 746 | Xe tuần lộc | 23 | 3 |
| 747 | Cờ xanh dương | 28 | 3 |
| 748 | Thịt heo | 27 | 3 |
| 749 | Thúng nếp | 27 | 3 |
| 750 | Thúng đậu xanh | 27 | 3 |
| 751 | Lá dong | 27 | 3 |
| 752 | Bánh tét | 31 | 3 |
| 753 | Bánh chưng | 31 | 3 |
| 754 | Nón Chuột may mắn | 5 | 0 |
| 755 | Nón Chuột may mắn | 5 | 1 |
| 756 | Nón Chuột may mắn | 5 | 2 |
| 757 | Túi Canh Tý 2020 | 27 | 3 |
| 758 | Capsule Tết 2024 | 27 | 3 |
| 759 | Nâng kỹ năng 4 đệ tử | 27 | 3 |
| 760 | Cải trang VIP | 5 | 3 |
| 761 | Avatar đeo khẩu trang | 5 | 0 |
| 762 | Avatar đeo khẩu trang | 5 | 1 |
| 763 | Avatar đeo khẩu trang | 5 | 2 |
| 764 | Khẩu trang | 29 | 3 |
| 765 | Cải trang Gohan Bư | 5 | 3 |
| 766 | Cờ xám | 11 | 3 |
| 767 | Cờ đen | 11 | 3 |
| 768 | Cờ xanh lá | 11 | 3 |
| 769 | Cờ xanh biển | 11 | 3 |
| 770 | Cờ hồng | 11 | 3 |
| 771 | Cờ cam | 11 | 3 |
| 772 | Cờ vàng | 11 | 3 |
| 773 | Cờ tím | 11 | 3 |
| 774 | Cờ xanh dạ | 11 | 3 |
| 775 | Cờ đỏ | 11 | 3 |
| 776 | Khăn xanh lá | 11 | 3 |
| 777 | Khăn xanh dương | 11 | 3 |
| 778 | Khăn vàng | 11 | 3 |
| 779 | Khăn tím | 11 | 3 |
| 780 | Khăn nâu | 11 | 3 |
| 781 | Khăn xám | 11 | 3 |
| 782 | Khăn đỏ | 11 | 3 |
| 783 | Khăn hồng | 11 | 3 |
| 784 | Khăn xanh dạ | 11 | 3 |
| 785 | Ba lô | 11 | 3 |
| 786 | Đao | 11 | 3 |
| 787 | Gậy | 11 | 3 |
| 788 | Mai rùa | 11 | 3 |
| 789 | Giỏ bơ | 11 | 3 |
| 790 | Giỏ dưa hấu | 11 | 3 |
| 791 | Giỏ củ cải trắng | 11 | 3 |
| 792 | Giỏ cà rốt | 11 | 3 |
| 793 | Giỏ chuối | 11 | 3 |
| 794 | Gậy phép | 11 | 3 |
| 795 | Ghế bay | 23 | 3 |
| 796 | Hộp Capsule | 27 | 3 |
| 797 | Bùa Trí Tuệ | 13 | 3 |
| 798 | Bùa Mạnh Mẽ | 13 | 3 |
| 799 | Bùa Da Trâu | 13 | 3 |
| 800 | Lồng đèn Cô Vy | 11 | 3 |
| 801 | Lồng đèn Con tàu | 11 | 3 |
| 802 | Lồng đèn Con gà | 11 | 3 |
| 803 | Lồng đèn Con bướm | 11 | 3 |
| 804 | Lồng đèn Đôrêmon | 11 | 3 |
| 805 | Vòng sáng thiên thần | 11 | 3 |
| 806 | Cải trang Đôrêmon | 5 | 3 |
| 807 | Ngọc đen 1 sao | 12 | 3 |
| 808 | Ngọc đen 2 sao | 12 | 3 |
| 809 | Ngọc đen 3 sao | 12 | 3 |
| 810 | Ngọc đen 4 sao | 12 | 3 |
| 811 | Ngọc đen 5 sao | 12 | 3 |
| 812 | Ngọc đen 6 sao | 12 | 3 |
| 813 | Ngọc đen 7 sao | 12 | 3 |
| 814 | Ma trơi | 11 | 3 |
| 815 | Hồn ma Goku | 11 | 3 |
| 816 | Hồn ma Ca đíc | 11 | 3 |
| 817 | Hồn ma Pôcôlô | 11 | 3 |
| 818 | Capsule Halloween | 27 | 3 |
| 819 | Cải trang Xuka | 5 | 3 |
| 820 | Vé quay ngọc đen | 27 | 3 |
| 821 | Vé quay ngọc vàng | 27 | 3 |
| 822 | Cây thông | 11 | 3 |
| 823 | Túi quà | 11 | 3 |
| 824 | Cải trang Noel | 5 | 0 |
| 825 | Cải trang Noel | 5 | 1 |
| 826 | Cải trang Noel | 5 | 2 |
| 827 | Cải trang Noel | 5 | 3 |
| 828 | Mảnh Khủng long | 33 | 3 |
| 829 | Mảnh Lợn lòi | 33 | 3 |
| 830 | Mảnh Quỷ đất | 33 | 3 |
| 831 | Mảnh Khủng long mẹ | 33 | 3 |
| 832 | Mảnh Lợn lòi mẹ | 33 | 3 |
| 833 | Mảnh Quỷ đất mẹ | 33 | 3 |
| 834 | Mảnh Thằn lằn bay | 33 | 3 |
| 835 | Mảnh Phi long | 33 | 3 |
| 836 | Mảnh Quỷ bay | 33 | 3 |
| 837 | Mảnh Lính độc nhãn | 33 | 3 |
| 838 | Mảnh Lính độc nhãn | 33 | 3 |
| 839 | Mảnh Sói xám | 33 | 3 |
| 840 | Mảnh Trung úy Trắng | 33 | 3 |
| 841 | Mảnh Ninja Áo Tím | 33 | 3 |
| 842 | Mảnh Trung úy Xanh Lơ | 33 | 3 |
| 843 | Cải trang Trâu vàng | 5 | 0 |
| 844 | Cải trang Trâu đen | 5 | 1 |
| 845 | Cải trang Trâu trắng | 5 | 2 |
| 846 | Nón Trâu may mắn | 5 | 0 |
| 847 | Nón Trâu may mắn | 5 | 1 |
| 848 | Nón Trâu may mắn | 5 | 2 |
| 849 | Pháo Thăng Thiên | 23 | 3 |
| 850 | Cỏ tươi | 27 | 3 |
| 851 | Cỏ tươi | 27 | 3 |
| 852 | Cây trúc | 11 | 3 |
| 853 | Cải trang Trâu Nâu | 5 | 0 |
| 854 | Cải trang Trâu Nâu | 5 | 1 |
| 855 | Cải trang Trâu Nâu | 5 | 2 |
| 856 | Cải trang Trâu Đốm | 5 | 0 |
| 857 | Cải trang Trâu Đốm | 5 | 1 |
| 858 | Cải trang Trâu Đốm | 5 | 2 |
| 859 | Mảnh Độc Nhãn | 33 | 3 |
| 860 | Cải trang Mị Nương | 5 | 3 |
| 861 | Hồng ngọc | 34 | 3 |
| 862 | Cải trang Nobita | 5 | 3 |
| 863 | Cải trang Xekô | 5 | 3 |
| 864 | Cải trang Chaien | 5 | 3 |
| 865 | Kiếm Z | 11 | 3 |
| 866 | Avatar | 5 | 0 |
| 867 | Avatar | 5 | 1 |
| 868 | Avatar | 5 | 2 |
| 869 | Capsule 1 sao | 27 | 3 |
| 870 | Capsule 2 sao | 27 | 3 |
| 871 | Capsule 3 sao | 27 | 3 |
| 872 | Avatar Gohan 1 | 5 | 0 |
| 873 | Avatar Gohan 2 | 5 | 0 |
| 874 | Rùa con | 27 | 3 |
| 875 | Cải trang Cadic | 5 | 2 |
| 876 | Cải trang Gohan | 5 | 0 |
| 877 | Cải trang Pocolo | 5 | 1 |
| 878 | Cải trang Cooler vàng | 5 | 3 |
| 879 | Cải trang Thống Chế Kilo | 5 | 3 |
| 880 | Cua rang me | 29 | 3 |
| 881 | Bạch tuộc nướng | 29 | 3 |
| 882 | Tôm tẩm bột chiên xù | 29 | 3 |
| 883 | Cải trang Black Gohan Rose | 5 | 3 |
| 884 | Cải trang Hit | 5 | 3 |
| 885 | CT Lích Tên béo | 5 | 3 |
| 886 | Trứng vịt muối | 27 | 3 |
| 887 | Gà quay nguyên con | 27 | 3 |
| 888 | Bột mì | 27 | 3 |
| 889 | Đậu xanh | 27 | 3 |
| 890 | Bánh trung thu Gà quay | 27 | 3 |
| 891 | Bánh trung thu thập cẩm | 27 | 3 |
| 892 | Thỏ xám | 27 | 3 |
| 893 | Thỏ trắng | 27 | 3 |
| 894 | Avatar | 5 | 0 |
| 895 | Avatar | 5 | 1 |
| 896 | Avatar | 5 | 2 |
| 897 | Rùa bay | 23 | 3 |
| 898 | Cải trang Zamasu | 5 | 3 |
| 899 | Kẹo một mắt | 29 | 3 |
| 900 | Súp bí hắc ám | 29 | 3 |
| 901 | Kẹo bàn tay | 27 | 3 |
| 902 | Bánh gato nhện | 29 | 3 |
| 903 | Hamburger sâu | 29 | 3 |
| 904 | Cải trang Black Goku SSJ White | 5 | 3 |
| 905 | Cải trang Siêu Thần Trái Đất | 5 | 0 |
| 906 | Cải trang Mighty Mask | 5 | 3 |
| 907 | Cải trang Siêu thần Namếc | 5 | 1 |
| 908 | Ma phong ba | 27 | 3 |
| 909 | Thần chết cute | 27 | 3 |
| 910 | Bí ngô nhí nhảnh | 27 | 3 |
| 911 | Cải trang Siêu Thần Xayda | 5 | 2 |
| 912 | Cải trang Gohan áo xanh | 5 | 3 |
| 913 | Cải trang Póc áo đỏ | 5 | 3 |
| 914 | Cải trang Búp bê Arale | 5 | 3 |
| 915 | Capsule Squid Game | 27 | 3 |
| 916 | Lính bảo vệ tam giác | 27 | 3 |
| 917 | Lính bảo vệ vuông | 27 | 3 |
| 918 | Lính bảo vệ tròn | 27 | 3 |
| 919 | Búp bê | 27 | 3 |
| 920 | Gậy như ý | 23 | 3 |
| 921 | Bông tai Porata | 27 | 3 |
| 922 | Cải trang Goku Noel | 5 | 0 |
| 923 | Cải trang Pico Noel | 5 | 1 |
| 924 | Cải trang Ca đíc Noel | 5 | 2 |
| 925 | Ngọc rồng băng 1 sao | 12 | 3 |
| 926 | Ngọc rồng băng 2 sao | 12 | 3 |
| 927 | Ngọc rồng băng 3 sao | 12 | 3 |
| 928 | Ngọc rồng băng 4 sao | 12 | 3 |
| 929 | Ngọc rồng băng 5 sao | 12 | 3 |
| 930 | Ngọc rồng băng 6 sao | 12 | 3 |
| 931 | Ngọc rồng băng 7 sao | 12 | 3 |
| 932 | Cải trang Uub | 5 | 3 |
| 933 | Mảnh vỡ bông tai | 27 | 3 |
| 934 | Mảnh hồn bông tai | 27 | 3 |
| 935 | Đá xanh lam | 27 | 3 |
| 936 | Tuần lộc nhí | 27 | 3 |
| 937 | Cải trang Mabư Noel | 5 | 3 |
| 938 | Cải trang Goku thời trang | 5 | 0 |
| 939 | Cải trang Pôcôlô thời trang | 5 | 1 |
| 940 | Cải trang Ca Đíc thời trang | 5 | 2 |
| 941 | Nón Hổ vàng | 5 | 3 |
| 942 | Hổ mặp vàng | 27 | 3 |
| 943 | Hổ mặp trắng | 27 | 3 |
| 944 | Hổ mặp xanh | 27 | 3 |
| 945 | Cải trang Goku Tarzan | 5 | 3 |
| 946 | Nón Hổ trắng | 5 | 3 |
| 947 | Nón Hổ xanh | 5 | 3 |
| 948 | Cải trang Hổ vàng | 5 | 3 |
| 949 | Thịt tươi | 27 | 3 |
| 950 | Thịt tươi | 27 | 3 |
| 951 | Cải trang Siêu Goku Tarzan | 5 | 3 |
| 952 | Cải trang Hổ trắng | 5 | 3 |
| 953 | Cải trang Hổ xanh | 5 | 3 |
| 954 | Bó Hoa Hồng | 11 | 3 |
| 955 | Bó Hoa Vàng | 11 | 3 |
| 956 | Mảnh Đội trưởng Vàng | 33 | 3 |
| 957 | Cải trang Goku võ sĩ | 5 | 0 |
| 958 | Cải trang Pôcôlô võ sĩ | 5 | 1 |
| 959 | Cải trang Cađíc võ sĩ | 5 | 2 |
| 960 | Cờ trắng | 28 | 3 |
| 961 | Cờ đen | 28 | 3 |
| 962 | Cap thời trang 5 ngày | 27 | 3 |
| 963 | Cap thời trang 7 ngày | 27 | 3 |
| 964 | Sao pha lê đen cấp 2 | 30 | 3 |
| 965 | Sao pha lê trắng cấp 2 | 30 | 3 |
| 966 | Trái bóng | 11 | 3 |
| 967 | Sao la | 27 | 3 |
| 968 | Số 7 Goku | 5 | 3 |
| 969 | Số 11 Gohan | 5 | 3 |
| 970 | Số 6 Cađíc | 5 | 3 |
| 971 | Số 2 Krilin | 5 | 3 |
| 972 | Số 4 Thên Xin Hăng | 5 | 3 |
| 973 | Số 10 Pôcôlô | 5 | 3 |
| 974 | Số 1 Mabư | 5 | 3 |
| 975 | Số 8 Biden | 5 | 3 |
| 976 | Số 9 Quy lão Kamê | 5 | 3 |
| 977 | Số 3 Poc | 5 | 3 |
| 978 | Số 5 Pic | 5 | 3 |
| 979 | Huy chương đồng | 27 | 3 |
| 980 | Huy chương bạc | 27 | 3 |
| 981 | Huy chương vàng | 27 | 3 |
| 982 | Cúp vàng | 11 | 3 |
| 983 | Cờ cổ động | 11 | 3 |
| 984 | Capsule SEA games | 27 | 3 |
| 985 | Cải trang Chill | 5 | 3 |
| 986 | Cải trang Chill cấp 2 | 5 | 3 |
| 987 | Đá bảo vệ | 27 | 3 |
| 988 | Mở rộng túi vàng | 27 | 3 |
| 989 | Cải trang Gohan Siêu Nhân | 5 | 3 |
| 990 | Cải trang Biđen Siêu Nhân | 5 | 3 |
| 991 | Cải trang Bản Cô Nương Siêu Nhân | 5 | 3 |
| 992 | Nhẫn thời không sai lệch | 27 | 3 |
| 993 | Giỏ thức ăn | 27 | 3 |
| 994 | Vỏ ốc | 11 | 3 |
| 995 | Cây kem | 11 | 3 |
| 996 | Cá heo | 11 | 3 |
| 997 | Con diều | 11 | 3 |
| 998 | Diều rồng | 11 | 3 |
| 999 | Mèo mun | 11 | 3 |
| 1000 | Xiên cá | 11 | 3 |
| 1001 | Phóng lợn | 11 | 3 |
| 1002 | Cá nóc | 27 | 3 |
| 1003 | Cá bảy màu | 27 | 3 |
| 1004 | Cá diêu hồng | 27 | 3 |
| 1005 | Xô cá xanh | 27 | 3 |
| 1006 | Xô cá vàng | 27 | 3 |
| 1007 | Ván lướt sóng | 11 | 3 |
| 1008 | Cua đỏ | 27 | 3 |
| 1009 | Rương Tranh ngọc Namếc | 27 | 3 |
| 1010 | Cải trang Áo vịt cam | 5 | 0 |
| 1011 | Cải trang Áo trắng hoa | 5 | 2 |
| 1012 | Cải trang Nón rơm mùa hè | 5 | 1 |
| 1013 | Kiếm ánh sáng | 11 | 3 |
| 1014 | Rađa dò ngọc Namếc | 27 | 3 |
| 1015 | Ngọc rồng Siêu Cấp | 27 | 3 |
| 1016 | Thuốc mỡ Ipana | 29 | 3 |
| 1017 | Thuốc mỡ Ipana đặc biệt | 29 | 3 |
| 1018 | Cải trang Broly | 5 | 0 |
| 1019 | Cải trang Broly | 5 | 1 |
| 1020 | Cải trang Broly | 5 | 2 |
| 1021 | Búa Mjolnir | 11 | 3 |
| 1022 | Búa Stormbreaker | 11 | 3 |
| 1023 | Quạt ba tiêu | 11 | 3 |
| 1024 | Như Ý Kim Cô Bổng | 11 | 3 |
| 1025 | Cửu Xỉ Đinh Ba | 11 | 3 |
| 1026 | Nguyệt Nha Sản | 11 | 3 |
| 1027 | Cửu Hoàn Thiên Tích Trượng | 11 | 3 |
| 1028 | Dao răng cưa | 11 | 3 |
| 1029 | Lọ nước phép | 27 | 3 |
| 1030 | Cờ Hoa đăng | 11 | 3 |
| 1031 | Cờ Hoa sen | 11 | 3 |
| 1032 | Giấy màu | 27 | 3 |
| 1033 | Lời chúc | 27 | 3 |
| 1034 | Nến | 27 | 3 |
| 1035 | Khung tre | 27 | 3 |
| 1036 | Pháo hoa | 27 | 3 |
| 1037 | Hoa đăng | 27 | 3 |
| 1038 | Hoa đăng có lời chúc | 27 | 3 |
| 1039 | Pet Thỏ ốm | 27 | 3 |
| 1040 | Pet Thỏ mập | 27 | 3 |
| 1041 | Thỏ hồng Bun ma | 5 | 3 |
| 1042 | Thỏ đỏ Chi Chi | 5 | 3 |
| 1043 | Thỏ đen Android 18 | 5 | 3 |
| 1044 | Sách tuyệt kỹ 1 | 25 | 0 |
| 1045 | Đuôi khỉ | 27 | 3 |
| 1046 | Pet Khỉ Bong Bóng | 27 | 3 |
| 1047 | Lồng đèn lon | 11 | 3 |
| 1048 | Áo Thiên Sứ | 0 | 0 |
| 1049 | Áo Thiên Sứ | 0 | 1 |
| 1050 | Áo Thiên Sứ | 0 | 2 |
| 1051 | Quần Thiên Sứ | 1 | 0 |
| 1052 | Quần Thiên Sứ | 1 | 1 |
| 1053 | Quần Thiên Sứ | 1 | 2 |
| 1054 | Găng Thiên Sứ | 2 | 0 |
| 1055 | Găng Thiên Sứ | 2 | 1 |
| 1056 | Găng Thiên Sứ | 2 | 2 |
| 1057 | Giầy Thiên Sứ | 3 | 0 |
| 1058 | Giầy Thiên Sứ | 3 | 1 |
| 1059 | Giầy Thiên Sứ | 3 | 2 |
| 1060 | Nhẫn Thiên Sứ | 4 | 0 |
| 1061 | Nhẫn Thiên Sứ | 4 | 1 |
| 1062 | Nhẫn Thiên Sứ | 4 | 2 |
| 1063 | Avatar Thiên Sứ | 5 | 0 |
| 1064 | Avatar Thiên Sứ | 5 | 1 |
| 1065 | Avatar Thiên Sứ | 5 | 2 |
| 1066 | Mảnh áo | 27 | 3 |
| 1067 | Mảnh quần | 27 | 3 |
| 1068 | Mảnh giầy | 27 | 3 |
| 1069 | Mảnh nhẫn | 27 | 3 |
| 1070 | Mảnh găng tay | 27 | 3 |
| 1071 | Công thức | 27 | 0 |
| 1072 | Công thức | 27 | 1 |
| 1073 | Công thức | 27 | 2 |
| 1074 | Đá nâng cấp cấp 1 | 27 | 3 |
| 1075 | Đá nâng cấp cấp 2 | 27 | 3 |
| 1076 | Đá nâng cấp cấp 3 | 27 | 3 |
| 1077 | Đá nâng cấp cấp 4 | 27 | 3 |
| 1078 | Đá nâng cấp cấp 5 | 27 | 3 |
| 1079 | Đá may mắn cấp 1 | 27 | 3 |
| 1080 | Đá may mắn cấp 2 | 27 | 3 |
| 1081 | Đá may mắn cấp 3 | 27 | 3 |
| 1082 | Đá may mắn cấp 4 | 27 | 3 |
| 1083 | Đá may mắn cấp 5 | 27 | 3 |
| 1084 | Công thức VIP | 27 | 0 |
| 1085 | Công thức VIP | 27 | 1 |
| 1086 | Công thức VIP | 27 | 2 |
| 1087 | Tanjiro | 5 | 3 |
| 1088 | Inosuke Hashibira | 5 | 3 |
| 1089 | Inosuke | 5 | 3 |
| 1090 | Zenitsu | 5 | 3 |
| 1091 | Nezuko | 5 | 3 |
| 1092 | Gậy Quy Lão | 23 | 3 |
| 1093 | Đất trồng cây | 27 | 3 |
| 1094 | Phân bón | 27 | 3 |
| 1095 | Hạt mầm | 27 | 3 |
| 1096 | Thuốc tăng trưởng | 27 | 3 |
| 1097 | Chậu sứ | 27 | 3 |
| 1098 | Hoa hồng xanh | 27 | 3 |
| 1099 | Chậu hoa hồng xanh | 27 | 3 |
| 1100 | Chậu hoa ăn thịt | 11 | 3 |
| 1101 | Lời chúc | 27 | 3 |
| 1102 | Lời chúc VIP | 27 | 3 |
| 1103 | Marron | 5 | 3 |
| 1104 | Poc satan | 5 | 3 |
| 1105 | Bun ma phù thủy | 5 | 3 |
| 1106 | Biden dracula | 5 | 3 |
| 1107 | Pet Bí Ma Vương | 27 | 3 |
| 1108 | Đinh ba Satan | 11 | 3 |
| 1109 | Chổi phù thủy | 11 | 3 |
| 1110 | Cánh thiên thần | 11 | 3 |
| 1111 | Cánh thiên thần 2 | 11 | 3 |
| 1112 | Cây nắp ấm | 11 | 3 |
| 1113 | Cá Chà Bá | 11 | 3 |
| 1114 | Pet Ma vàng phù thủy | 27 | 3 |
| 1115 | Máy dò Ngọc rồng sự kiện | 29 | 3 |
| 1116 | Hòm Halloween | 27 | 3 |
| 1117 | Thiệp Halloween | 27 | 3 |
| 1118 | W | 27 | 3 |
| 1119 | O | 27 | 3 |
| 1120 | R | 27 | 3 |
| 1121 | L | 27 | 3 |
| 1122 | D | 27 | 3 |
| 1123 | C | 27 | 3 |
| 1124 | U | 27 | 3 |
| 1125 | P | 27 | 3 |
| 1126 | 20 | 27 | 3 |
| 1127 | 22 | 27 | 3 |
| 1128 | Cờ logo Quatar 1 | 11 | 3 |
| 1129 | Cờ logo Quatar 2 | 11 | 3 |
| 1130 | Cờ giày vàng | 11 | 3 |
| 1131 | Quả bóng siêu việt | 23 | 3 |
| 1132 | Fan cuồng bóng đá | 27 | 3 |
| 1133 | Fan gà nửa mùa | 27 | 3 |
| 1134 | Thiệp World Cup | 27 | 3 |
| 1135 | Capsule World Cup | 27 | 3 |
| 1136 | Capsule World Cup VIP | 27 | 3 |
| 1137 | Cờ GOAL | 11 | 3 |
| 1138 | Cờ FIFA | 11 | 3 |
| 1139 | Quả Bóng Vàng | 11 | 3 |
| 1140 | Mèo mun đột biến | 11 | 3 |
| 1141 | Phiếu giảm giá Black Friday | 27 | 3 |
| 1142 | Bong bóng heo | 11 | 3 |
| 1143 | Đá bảo vệ (Khóa) | 27 | 3 |
| 1144 | Phượng hoàng lửa | 23 | 3 |
| 1145 | Cải trang Black goku ssj 3 White | 5 | 3 |
| 1146 | Avatar Gohan White | 5 | 0 |
| 1147 | Avatar Gohan White | 5 | 2 |
| 1148 | Avatar Gohan White | 5 | 1 |
| 1149 | Cánh thiên sứ hắc ám | 11 | 3 |
| 1150 | Cuồng nộ 2 | 29 | 3 |
| 1151 | Bổ khí 2 | 29 | 3 |
| 1152 | Bổ huyết 2 | 29 | 3 |
| 1153 | Giáp Xên bọ hung 2 | 29 | 3 |
| 1154 | Ẩn danh 2 | 29 | 3 |
| 1155 | Noel 2022 Goku | 5 | 0 |
| 1156 | Noel 2022 Cađíc | 5 | 2 |
| 1157 | Noel 2022 Pôcôlô | 5 | 1 |
| 1158 | Chú lùn | 11 | 3 |
| 1159 | Chú lùn | 11 | 3 |
| 1160 | Chú lùn | 11 | 3 |
| 1161 | Chú lùn | 11 | 3 |
| 1162 | Chú lùn | 11 | 3 |
| 1163 | Chú lùn | 11 | 3 |
| 1164 | Chú lùn | 11 | 3 |
| 1165 | Chuông đồng | 27 | 3 |
| 1166 | Cá tuyết | 27 | 3 |
| 1167 | Bánh quy | 27 | 3 |
| 1168 | Kẹo đường | 27 | 3 |
| 1169 | Kẹo người tuyết | 27 | 3 |
| 1170 | Gói quà | 27 | 3 |
| 1171 | Túi 7 chú lùn | 27 | 3 |
| 1172 | Xe heo tuần lộc | 23 | 3 |
| 1173 | Rương Mảnh Thiên Sứ | 27 | 3 |
| 1174 | Kimono | 5 | 0 |
| 1175 | Kimono | 5 | 1 |
| 1176 | Kimono | 5 | 2 |
| 1177 | Mãng cầu | 27 | 3 |
| 1178 | Quả dừa | 27 | 3 |
| 1179 | Đu đủ | 27 | 3 |
| 1180 | Quả xoài | 27 | 3 |
| 1181 | Trái sung | 27 | 3 |
| 1182 | Mâm ngũ quả | 27 | 3 |
| 1183 | Bao lì xì rồng | 27 | 3 |
| 1184 | Gói quà đặc biệt | 27 | 3 |
| 1185 | Cành mai | 11 | 3 |
| 1186 | Cành đào | 11 | 3 |
| 1187 | Hộp quà Tết 2024 | 27 | 3 |
| 1188 | Pet mèo đen đuôi vàng | 27 | 3 |
| 1189 | Xúc xích xông khói | 29 | 3 |
| 1190 | Dĩa thức ăn cho mèo | 29 | 3 |
| 1191 | Thiệp chúc tết | 27 | 3 |
| 1192 | Thiệp chúc tết | 27 | 3 |
| 1193 | Thiệp chúc tết | 27 | 3 |
| 1194 | Phiếu bé ngoan | 27 | 3 |
| 1195 | Xí muội Hoa đào | 29 | 3 |
| 1196 | Xí muội Hoa mai | 29 | 3 |
| 1197 | Bóng Vịt Vàng | 11 | 3 |
| 1198 | Nón mèo | 5 | 0 |
| 1199 | Nón mèo | 5 | 1 |
| 1200 | Nón mèo | 5 | 2 |
| 1201 | Karin Kid Lân | 5 | 3 |
| 1202 | Pet mèo trắng đuôi vàng | 27 | 3 |
| 1203 | Pet mèo trắng đuôi vàng | 27 | 3 |
| 1204 | Mảnh Rồng thần Namếc | 33 | 3 |
| 1205 | Drabura Frost | 5 | 3 |
| 1206 | Trái tim Valentine | 11 | 3 |
| 1207 | Pet Minion | 27 | 3 |
| 1208 | Bunma tóc xanh neon | 5 | 3 |
| 1209 | Bunma tóc nâu băng đô | 5 | 3 |
| 1210 | Bunma tóc tím thắt bím | 5 | 3 |
| 1211 | Sách tuyệt kỹ 1 | 25 | 1 |
| 1212 | Sách tuyệt kỹ 1 | 25 | 2 |
| 1213 | Cờ mèo Hoàng Thượng | 11 | 3 |
| 1214 | Cơm nếp | 27 | 3 |
| 1215 | Ván cơm nếp | 27 | 3 |
| 1216 | Tệp cơm nếp | 27 | 3 |
| 1217 | Lá dong | 27 | 3 |
| 1218 | Sợi Cói | 27 | 3 |
| 1219 | Tệp bánh chưng | 27 | 3 |
| 1220 | Ngà voi | 27 | 3 |
| 1221 | Cựa gà | 27 | 3 |
| 1222 | Hồng mao | 27 | 3 |
| 1223 | Bóng khí Gas | 11 | 3 |
| 1224 | Pet Voi Chín Ngà | 27 | 3 |
| 1225 | Pet Gà Chín Cựa | 27 | 3 |
| 1226 | Pet Ngựa Chín Hồng mao | 27 | 3 |
| 1227 | Hộp quà thường | 27 | 3 |
| 1228 | Hộp quà cao cấp | 27 | 3 |
| 1229 | Bí kíp tuyệt kỹ | 27 | 3 |
| 1230 | Hào Quang Rực Rỡ | 11 | 3 |
| 1231 | Gậy thượng đế | 11 | 3 |
| 1232 | Bình chứa nhỏ | 29 | 1 |
| 1233 | Nồi cơm điện | 29 | 1 |
| 1234 | Cải trang Pic Thợ Lặn | 5 | 3 |
| 1235 | Cải trang Poc Bikini | 5 | 3 |
| 1236 | Cải trang King Kong Sành Điệu | 5 | 3 |
| 1237 | Cành khô | 27 | 3 |
| 1238 | Nước Suối Tinh Khiết | 27 | 3 |
| 1239 | Gỗ Lớn | 27 | 3 |
| 1240 | Que đốt | 27 | 3 |
| 1241 | Bồn tắm gỗ | 27 | 3 |
| 1242 | Bồn tắm vàng | 27 | 3 |
| 1243 | Pet bọ cánh cứng | 27 | 3 |
| 1244 | Pet ngài đêm | 27 | 3 |
| 1245 | Bọ Kiến Vương Hai Sừng | 27 | 3 |
| 1246 | Bọ Hung Tê Giác | 27 | 3 |
| 1247 | Bọ Kẹp Kìm | 27 | 3 |
| 1248 | Bọ Cánh Cứng | 27 | 3 |
| 1249 | Ngài Đêm | 27 | 3 |
| 1250 | Hũ Mật Ong | 27 | 3 |
| 1251 | Vợt Bắt Bọ | 27 | 3 |
| 1252 | Ve Sầu Xên | 23 | 3 |
| 1253 | Ve Sầu Xên Tiến Hóa | 23 | 3 |
| 1254 | Búa hắc hường | 11 | 3 |
| 1255 | Cải trang Mabư Còm | 5 | 3 |
| 1256 | Pet heo bướm | 27 | 3 |
| 1257 | Xe triều đình | 5 | 3 |
| 1258 | Hồn ma | 27 | 3 |
| 1259 | Bình phép | 27 | 3 |
| 1260 | Lọ nước hồi sinh | 27 | 3 |
| 1261 | Bùa hồi sinh | 27 | 3 |
| 1262 | Lích Tên | 27 | 3 |
| 1263 | Siêu Lích Tên | 27 | 3 |
| 1264 | Máy dò linh hồn | 29 | 3 |
| 1265 | Yajirobe Zoro | 5 | 3 |
| 1266 | Avatar Gohan sẹo | 5 | 0 |
| 1267 | Avatar Gohan sẹo | 5 | 1 |
| 1268 | Avatar Gohan sẹo | 5 | 2 |
| 1269 | Avatar Gohan Blue sẹo | 5 | 0 |
| 1270 | Avatar Gohan Blue sẹo | 5 | 1 |
| 1271 | Avatar Gohan Blue sẹo | 5 | 2 |
| 1272 | Đài sen hồng | 23 | 3 |
| 1273 | Đài sen vàng | 23 | 3 |
| 1274 | Cải trang Cumber | 5 | 3 |
| 1275 | Cải trang Cumber SSJ | 5 | 3 |
| 1276 | Cải trang Nguyệt thần | 5 | 3 |
| 1277 | Cải trang Nhật thần | 5 | 3 |
| 1278 | Sách tuyệt kỹ 2 | 25 | 0 |
| 1279 | Sách tuyệt kỹ 2 | 25 | 1 |
| 1280 | Sách tuyệt kỹ 2 | 25 | 2 |
| 1281 | Trang sách cũ | 27 | 3 |
| 1282 | Bìa sách | 27 | 3 |
| 1283 | Cuốn sách cũ | 27 | 3 |
| 1284 | Bùa giám định | 27 | 3 |
| 1285 | Kìm bấm giấy | 27 | 3 |
| 1286 | Kẻ thao túng sói | 36 | 3 |
| 1287 | Nước anh bao | 36 | 3 |
| 1288 | Chiến thần khóa nick | 36 | 3 |
| 1289 | Đại gia mới nhú | 36 | 3 |
| 1290 | Trùm ước rồng | 36 | 3 |
| 1291 | Trùm săn Boss | 36 | 3 |
| 1292 | Thánh đập đồ +7 | 36 | 3 |
| 1293 | Cao thủ siêu hạng | 36 | 3 |
| 1294 | Nông dân chăm chỉ | 36 | 3 |
| 1295 | Ông thần ve chai | 36 | 3 |
| 1296 | Bị móc sạch túi | 36 | 3 |
| 1297 | KOL | 36 | 3 |
| 1298 | Chuyên gia lượm nhặt | 36 | 3 |
| 1299 | Fan cứng | 36 | 3 |
| 1300 | Thánh ở dơ | 36 | 3 |
| 1301 | Cờ khỉ hoàng đế | 11 | 3 |
| 1302 | Cải trang | 5 | 3 |
| 1303 | Lồng đèn thỏ trắng | 11 | 3 |
| 1304 | Kiếm gỗ | 27 | 3 |
| 1305 | Ánh trăng tròn | 27 | 3 |
| 1306 | Bánh dẻo thỏ trắng | 31 | 3 |
| 1307 | Bánh dẻo thỏ xanh | 31 | 3 |
| 1308 | Bánh dẻo thỏ hồng | 31 | 3 |
| 1309 | Bunma Ả rập Xê út | 5 | 3 |
| 1310 | Thỏ ngọc | 27 | 3 |
| 1311 | Lồng đèn treo | 27 | 3 |
| 1312 | Hạt sen | 27 | 3 |
| 1313 | Bánh trung thu Hạt sen | 27 | 3 |
| 1314 | Hộp giấy | 27 | 3 |
| 1315 | Túi giấy | 27 | 3 |
| 1316 | Giỏ bánh trung thu | 27 | 3 |
| 1317 | Giỏ bánh trung thu độc đáo | 27 | 3 |
| 1318 | Pet Mông Quỷ | 27 | 3 |
| 1319 | Sách đấm Dragon | 37 | 0 |
| 1320 | Sách Kamejoko | 37 | 0 |
| 1321 | Thái Dương Hạ San | 37 | 0 |
| 1322 | Kaioken | 37 | 0 |
| 1323 | Quả cầu Kênh Khi | 37 | 0 |
| 1324 | Sách Dịch Chuyển | 37 | 0 |
| 1325 | Sách Thôi Miên | 37 | 0 |
| 1326 | Sách đấm Demon | 37 | 1 |
| 1327 | Sách Masenko | 37 | 1 |
| 1328 | Sách học Trị thương | 37 | 1 |
| 1329 | Makankosappo | 37 | 1 |
| 1330 | Đẻ trứng | 37 | 1 |
| 1331 | Sách Biến Sôcôla | 37 | 1 |
| 1332 | Sách Liên hoàn | 37 | 1 |
| 1333 | Sách đấm Galick | 37 | 2 |
| 1334 | Sách Antomic | 37 | 2 |
| 1335 | Tái tạo năng lượng | 37 | 2 |
| 1336 | Hóa khỉ khổng lồ | 37 | 2 |
| 1337 | Bom hi sinh | 37 | 2 |
| 1338 | Sách Trói | 37 | 2 |
| 1339 | Sách Huýt Sáo | 37 | 2 |
| 1340 | Khiên năng lượng | 37 | 3 |
| 1341 | Sách Super Kamejoko | 37 | 0 |
| 1342 | Sách Ma phong ba | 37 | 1 |
| 1343 | Sách Cađíc liên hoàn chưởng | 37 | 2 |
| 1344 | Con Cat hường | 11 | 3 |
| 1345 | Thú cưỡi mèo kéo xương | 23 | 3 |
| 1346 | Thú cưỡi Xe bí ngô | 23 | 3 |
| 1347 | Pet Mèo Phù Thủy | 27 | 3 |
| 1348 | Giỏ đựng ngọc bí | 27 | 3 |
| 1349 | Giỏ đựng | 27 | 3 |
| 1350 | Kẹo não người | 27 | 3 |
| 1351 | Dây buộc | 27 | 3 |
| 1352 | Bó kẹo kinh dị | 27 | 3 |
| 1353 | Giỏ kẹo kinh dị | 27 | 3 |
| 1354 | Giấy trang trí Halloween | 27 | 3 |
| 1355 | Giỏ đựng kẹo trái bí | 27 | 3 |
| 1356 | Hộp Kẹo Ma Quỷ | 27 | 3 |
| 1357 | Kẹo bí ngô | 27 | 3 |
| 1358 | Cờ hồn Mabư | 11 | 3 |
| 1359 | Cờ hồn Xên Bọ Hung | 11 | 3 |
| 1360 | Cờ Ma đèn nhảy múa | 11 | 3 |
| 1361 | Cờ Ma đèn hút hồn | 11 | 3 |
| 1362 | Cải trang Thầy giáo Ca Lích | 5 | 0 |
| 1363 | Thú cưỡi con Cat hường | 23 | 3 |
| 1364 | Lá trà tươi | 27 | 3 |
| 1365 | Nia tre | 27 | 3 |
| 1366 | Que tre | 27 | 3 |
| 1367 | Hoa cúc | 27 | 3 |
| 1368 | Túi trà khô | 27 | 3 |
| 1369 | Hộp trà | 27 | 3 |
| 1370 | Hộp trà hoa cúc | 27 | 3 |
| 1371 | Cải trang đệ tử Tí | 5 | 3 |
| 1372 | Bao bì thiệp | 27 | 3 |
| 1373 | Mảnh giấy | 27 | 3 |
| 1374 | Keo dán | 27 | 3 |
| 1375 | Lời chúc | 27 | 3 |
| 1376 | Thiệp chúc thường | 27 | 3 |
| 1377 | Thiệp chúc đặc biệt | 27 | 3 |
| 1378 | Cải trang Thầy giáo Cađíc | 5 | 2 |
| 1379 | Cải trang Thầy giáo Pô cô lô | 5 | 1 |
| 1380 | Cải trang đệ tử Sửu | 5 | 3 |
| 1381 | Cải trang đệ tử Dần | 5 | 3 |
| 1382 | Kéo tỉa hoa đặc biệt | 27 | 3 |
| 1383 | Cải trang Thầy giáo Raddit | 5 | 3 |
| 1384 | Cải trang Thầy giáo Goku | 5 | 3 |
| 1385 | Cải trang Thầy giáo Quy Lão | 5 | 3 |
| 1386 | Bút chì hồng | 11 | 3 |
| 1387 | Kéo tỉa hoa | 27 | 3 |
| 1388 | Bó hoa hồng | 27 | 3 |
| 1389 | Avatar Cử nhân | 5 | 0 |
| 1390 | Avatar Cử nhân | 5 | 1 |
| 1391 | Avatar Cử nhân | 5 | 2 |
| 1392 | Gõ đầu trẻ | 36 | 3 |
| 1393 | Gõ đầu trẻ | 36 | 3 |
| 1394 | Gõ đầu trẻ | 36 | 3 |
| 1395 | Đóa hoa hồng | 27 | 3 |
| 1396 | Cải trang Super Píc | 5 | 3 |
| 1397 | Rương radar | 29 | 3 |
| 1398 | Rương giày | 29 | 3 |
| 1399 | Rương nhẫn | 29 | 3 |
| 1400 | Rương găng tay | 29 | 3 |
| 1401 | Rương áo | 29 | 3 |
| 1402 | Rương quần | 29 | 3 |
| 1403 | Rương bí kíp tuyệt kỹ | 29 | 3 |
| 1404 | Chí mạng 2 | 29 | 3 |
| 1405 | Chí mạng 3 | 29 | 3 |
| 1406 | Né đòn | 29 | 3 |
| 1407 | Né đòn 2 | 29 | 3 |
| 1408 | Hồi skill | 29 | 3 |
| 1409 | Phản sát thương | 29 | 3 |
| 1410 | Phản sát thương 2 | 29 | 3 |
| 1411 | Phản sát thương 3 | 29 | 3 |
| 1412 | Kamejoko | 29 | 3 |
| 1413 | Kamejoko 2 | 29 | 3 |
| 1414 | Pet Shiba | 27 | 3 |
| 1415 | Cải trang Dr Myuu | 5 | 3 |
| 1416 | Sao pha lê đỏ cấp 2 | 30 | 3 |
| 1417 | Sao pha lê lam cấp 2 | 30 | 3 |
| 1418 | Sao pha lê hồng cấp 2 | 30 | 3 |
| 1419 | Sao pha lê tím cấp 2 | 30 | 3 |
| 1420 | Sao pha lê cam cấp 2 | 30 | 3 |
| 1421 | Sao pha lê vàng cấp 2 | 30 | 3 |
| 1422 | Sao pha lê lục cấp 2 | 30 | 3 |
| 1423 | Hematite | 27 | 3 |
| 1424 | Cải trang Goku Santa | 5 | 3 |
| 1425 | Anti phong ấn | 29 | 3 |
| 1426 | Sao pha lê đỏ lấp lánh | 30 | 3 |
| 1427 | Sao pha lê lam lấp lánh | 30 | 3 |
| 1428 | Sao pha lê hồng lấp lánh | 30 | 3 |
| 1429 | Sao pha lê tím lấp lánh | 30 | 3 |
| 1430 | Sao pha lê cam lấp lánh | 30 | 3 |
| 1431 | Sao pha lê vàng lấp lánh | 30 | 3 |
| 1432 | Sao pha lê lục lấp lánh | 30 | 3 |
| 1433 | Sao pha lê đen lấp lánh | 30 | 3 |
| 1434 | Sao pha lê trắng lấp lánh | 30 | 3 |
| 1435 | Pet chim cánh cụt | 27 | 3 |
| 1436 | Cải trang Chi Chi tuần lộc | 5 | 3 |
| 1437 | Cải trang Bông Băng Vàng | 5 | 3 |
| 1438 | Dùi đục | 27 | 3 |
| 1439 | Đá mài | 27 | 3 |
| 1440 | Rương sao pha lê | 27 | 3 |
| 1441 | Hematite (khóa) | 27 | 3 |
| 1442 | Cải trang Super Xayda God | 5 | 3 |
| 1443 | Phượng hoàng băng | 23 | 3 |
| 1444 | Mũi cà rốt | 27 | 3 |
| 1445 | Tảng tuyết | 27 | 3 |
| 1446 | Tay gỗ | 27 | 3 |
| 1447 | Khăn choàng | 27 | 3 |
| 1448 | Người tuyết | 27 | 3 |
| 1449 | Người tuyết băng giá | 27 | 3 |
| 1450 | Cải trang Broly Base | 5 | 3 |
| 1451 | Nón Noel | 27 | 3 |
| 1452 | Pet Ông già Noel | 27 | 3 |
| 1453 | Rương sao pha lê VIP | 27 | 3 |
| 1454 | Cải trang Super Black Goku Rose | 5 | 3 |
| 1455 | Quả bóng tuyết | 23 | 3 |
| 1456 | Kiếm Kitetsu | 11 | 3 |
| 1457 | Danh hiệu X-mas | 36 | 3 |
| 1458 | Pet Shiba đeo nơ | 27 | 3 |
| 1459 | Chuông | 27 | 3 |
| 1460 | Quả châu | 27 | 3 |
| 1461 | Ngôi sao | 27 | 3 |
| 1462 | Dây kim tuyến | 27 | 3 |
| 1463 | Móc treo Noel | 27 | 3 |
| 1464 | Kẹo giáng sinh | 27 | 3 |
| 1465 | Máy bay trực thăng Noel | 23 | 3 |
| 1466 | Tuần lộc Machine | 23 | 3 |
| 1467 | Gấu bắc cực | 11 | 3 |
| 1468 | Thú cưỡi Rồng PiLong | 23 | 3 |
| 1469 | Avatar mũ rồng | 5 | 0 |
| 1470 | Avatar mũ rồng | 5 | 1 |
| 1471 | Avatar mũ rồng | 5 | 2 |
| 1472 | Dây pháo | 27 | 3 |
| 1473 | Câu đối | 27 | 3 |
| 1474 | Dây treo bánh | 27 | 3 |
| 1475 | Đèn lồng treo cây | 27 | 3 |
| 1476 | Cải trang Bunma rực rỡ | 5 | 3 |
| 1477 | Thỏi vàng bay | 23 | 3 |
| 1478 | Cờ bao lì xì | 11 | 3 |
| 1479 | Cờ dây pháo | 11 | 3 |
| 1480 | Mì thanh long | 29 | 3 |
| 1481 | Cơm gà quay | 29 | 3 |
| 1482 | Pet rồng Pikachu thanh long | 27 | 3 |
| 1483 | Cải trang Bunma thanh lịch | 5 | 3 |
| 1484 | Cải trang Thần tài | 5 | 0 |
| 1485 | Cải trang Thần tài | 5 | 1 |
| 1486 | Cải trang Thần tài | 5 | 2 |
| 1487 | Cá chép rồng | 23 | 3 |
| 1488 | Vạn | 27 | 3 |
| 1489 | Sự | 27 | 3 |
| 1490 | Như | 27 | 3 |
| 1491 | Ý | 27 | 3 |
| 1492 | 2024 | 27 | 3 |
| 1493 | Phong bì Tết 2024 | 27 | 3 |
| 1494 | Thiệp đỏ | 27 | 3 |
| 1495 | Thiệp đỏ VIP | 27 | 3 |
| 1496 | Thiệp chúc mừng | 27 | 3 |
| 1497 | Pet rồng con thần tài | 27 | 3 |
| 1498 | Cải trang Goku Dragon | 5 | 0 |
| 1499 | Cải trang Pôcôlô Dragon | 5 | 1 |
| 1500 | Cải trang Cađíc Dragon | 5 | 2 |
| 1501 | Hộp quà Lucky 2024 | 27 | 3 |
| 1502 | Thanh Long Yển Nguyệt đao | 11 | 3 |
| 1503 | CT Lý Tiểu Nương hầu gái xanh | 5 | 3 |
| 1504 | CT Lý Tiểu Nương hầu gái hồng | 5 | 3 |
| 1505 | Giấy màu | 27 | 3 |
| 1506 | Hộp đựng quà | 27 | 3 |
| 1507 | Sôcôla Trái Tim | 27 | 3 |
| 1508 | Hoa hồng giấy | 27 | 3 |
| 1509 | Nơ trang trí | 27 | 3 |
| 1510 | Hộp quà nhẹ nhàng | 27 | 3 |
| 1511 | Hộp quà chỉn chu | 27 | 3 |
| 1512 | CT Lý Tiểu Nương Bikini | 5 | 3 |
| 1513 | Song mã hoàng gia | 23 | 3 |
| 1514 | Em xinh, em đẹp | 36 | 3 |
| 1515 | Chậu hoa hồng | 11 | 3 |
| 1516 | Hộp Mù Tình Yêu | 27 | 3 |
| 1517 | Sát thương chuẩn | 29 | 3 |
| 1518 | Sát thương chuẩn 2 | 29 | 3 |
| 1519 | Bong bóng thiên thần | 11 | 3 |
| 1520 | Bong bóng hoa hồng | 11 | 3 |
| 1521 | Thiệp mừng 8-3 | 27 | 3 |
| 1522 | Bùa Trí tuệ Đệ Tử | 13 | 3 |
| 1523 | Tự động luyện tập 2 | 27 | 3 |
| 1524 | Tự động luyện tập 3 | 27 | 3 |
| 1525 | Túi hạt giống Hoa Hồng | 27 | 3 |
| 1526 | Đất trồng cây | 27 | 3 |
| 1527 | Ống tre nước | 27 | 3 |
| 1528 | Chậu đất | 27 | 3 |
| 1529 | Thuốc tăng trưởng | 27 | 3 |
| 1530 | Bông hoa hồng | 27 | 3 |
| 1531 | Cánh thiên thần 3 | 11 | 3 |
| 1532 | Rađa kho báu | 29 | 3 |
| 1533 | Chuột mặp | 27 | 3 |
| 1534 | Thuyền Âu Lạc | 23 | 3 |
| 1535 | Thỏi vàng | 27 | 3 |
| 1536 | Đệ Black Goku | 29 | 3 |
| 1537 | Hộp thần linh | 29 | 3 |
| 1538 | Hộp quà Set kích hoạt 5 sao | 27 | 3 |
| 1539 | Bụi tre | 11 | 3 |
| 1540 | Rađa phóng xạ | 27 | 3 |
| 1541 | Môtô Bun ma | 23 | 3 |
| 1542 | Bánh dầy | 27 | 3 |
| 1543 | Bánh dầy | 27 | 3 |
| 1544 | Chả lụa | 27 | 3 |
| 1545 | Muối tiêu | 27 | 3 |
| 1546 | Cơm nếp | 27 | 3 |
| 1547 | Bột gạo | 27 | 3 |
| 1548 | Đậu xanh | 27 | 3 |
| 1549 | Thịt tươi | 27 | 3 |
| 1550 | Pet Godzilla | 27 | 3 |
| 1551 | Pet Kong | 27 | 3 |
| 1552 | Xiên nướng | 29 | 3 |
| 1553 | CT Goku SSJ4 | 5 | 3 |
| 1554 | Tàu ngầm 19 Cam | 23 | 3 |
| 1555 | Tàu ngầm 19 Vàng | 23 | 3 |
| 1556 | Bánh chưng Lang Liêu | 27 | 3 |
| 1557 | Hắc Mị Nương | 5 | 3 |
| 1558 | Tem chứng nhận Mai An Tiêm | 27 | 3 |
| 1559 | Capsule 1 món kích hoạt | 27 | 3 |
| 1560 | Rương ngọc rồng | 27 | 3 |
| 1561 | Chìa khóa vàng | 27 | 3 |
| 1562 | Mặt trời tí hon | 11 | 3 |
| 1563 | Ván bay té nước | 23 | 3 |
| 1564 | Pet Po | 27 | 3 |
| 1565 | Bản đồ truyền thuyết | 27 | 3 |
| 1566 | CT Lích Tên béo | 5 | 3 |
| 1567 | CT Frieren | 5 | 3 |
| 1568 | Pet Shimo | 27 | 3 |
| 1569 | Kho báu hải tặc | 27 | 3 |
| 1570 | Chìa khóa bạc | 27 | 3 |
| 1571 | Gậy phép của Frieren | 11 | 3 |
| 1572 | Goku bay | 11 | 3 |
| 1573 | Xe tăng Santa | 27 | 3 |
| 1574 | Cánh sấm sét | 11 | 3 |
| 1575 | Pháo bông | 27 | 3 |
| 1576 | Pháo bông VIP | 27 | 3 |
| 1577 | Cánh sấm sét hoàng kim | 11 | 3 |
| 1578 | Mây mưa | 23 | 3 |
| 1579 | 1 sao | 11 | 3 |
| 1580 | 2 sao | 11 | 3 |
| 1581 | 3 sao | 11 | 3 |
| 1582 | 4 sao | 11 | 3 |
| 1583 | 5 sao | 11 | 3 |
| 1584 | 6 sao | 11 | 3 |
| 1585 | 7 sao | 11 | 3 |
| 1586 | Super 1 sao | 11 | 3 |
| 1587 | CT Goku SSJ3 | 5 | 3 |
| 1588 | CT Goku | 5 | 3 |
| 1589 | CT Goku SSJ | 5 | 3 |
| 1590 | CT Goku SSJ Blue | 5 | 3 |
| 1591 | Hộp quà Goku Day | 27 | 3 |
| 1592 | Hộp quà Goku Day VIP | 27 | 3 |
| 1593 | CT Goku SSJ God | 5 | 3 |
| 1594 | Hộp quà Goku Day | 27 | 3 |
| 1595 | CT Goku SSJ2 | 5 | 3 |
| 1596 | Pet Albart | 27 | 3 |
| 1597 | Pet Albart Cup | 27 | 3 |
| 1598 | Trực thăng thỏ đế | 23 | 3 |
| 1599 | CT Fide nhí | 5 | 3 |
| 1600 | CT Xên nhí | 5 | 3 |
| 1601 | CT Mabư nhí | 5 | 3 |
| 1602 | CT Android 21 kid | 5 | 3 |
| 1603 | Tên lửa cá mập | 23 | 3 |
| 1604 | CT Sư | 5 | 3 |
| 1605 | Hộp quà thiếu nhi | 27 | 3 |
| 1606 | Hộp quà thiếu nhi | 27 | 3 |
| 1607 | Hộp quà thiếu nhi | 27 | 3 |
| 1608 | Hộp quà thiếu nhi | 27 | 3 |
| 1609 | Kem trái cây | 27 | 3 |
| 1610 | Que kem | 27 | 3 |
| 1611 | Pet Minion Otto | 27 | 3 |
| 1612 | Khúc mía | 27 | 3 |
| 1613 | Nước đá | 27 | 3 |
| 1614 | Ly mía khổng lồ | 29 | 3 |
| 1615 | Ly mía thơm | 29 | 3 |
| 1616 | Ly mía sầu riêng | 29 | 3 |
| 1617 | Cá nóc nâu | 11 | 3 |
| 1618 | Cá nóc vàng | 11 | 3 |
| 1619 | Túi nước mía | 11 | 3 |
| 1620 | Pet Baby Shark | 27 | 3 |
| 1621 | Pet Baby Shark | 27 | 3 |
| 1622 | Pet Baby Shark | 27 | 3 |
| 1623 | Trái bóng Euro | 11 | 3 |
| 1624 | Cup Euro | 11 | 3 |
| 1625 | Tivi bay | 23 | 3 |
| 1626 | Thẻ trọng tài | 11 | 3 |
| 1627 | TT | 27 | 3 |
| 1628 | Bùa x2 tn,sm đệ tử | 29 | 3 |
| 1629 | Pet Capybara đeo ba lô | 27 | 3 |
| 1630 | Pet Capybara xì mũi | 27 | 3 |
| 1631 | Pet Zịt vàng bối rối | 27 | 3 |
| 1632 | CT Himmel | 5 | 3 |
| 1633 | Pet Mini Desutoron Gas | 27 | 3 |
| 1634 | Cápsule Vỡ | 27 | 3 |
| 1635 | Cỏ bốn lá | 29 | 3 |
| 1636 | Spain | 27 | 3 |
| 1637 | Georgia | 27 | 3 |
| 1638 | Germany | 27 | 3 |
| 1639 | Denmark | 27 | 3 |
| 1640 | Portugal | 27 | 3 |
| 1641 | Slovenia | 27 | 3 |
| 1642 | France | 27 | 3 |
| 1643 | Belgium | 27 | 3 |
| 1644 | Romania | 27 | 3 |
| 1645 | Netherlands | 27 | 3 |
| 1646 | Austria | 27 | 3 |
| 1647 | Turkey | 27 | 3 |
| 1648 | England | 27 | 3 |
| 1649 | Slovakia | 27 | 3 |
| 1650 | Switzerland | 27 | 3 |
| 1651 | Italy | 27 | 3 |
| 1652 | Loa to thế giới | 27 | 3 |
| 1653 | Loa to liên vũ trụ | 27 | 3 |
| 1654 | Pet Cerberus | 27 | 3 |
| 1655 | Cápsule Kích hoạt 1 món tự chọn | 27 | 3 |
| 1656 | Khoáng tái chế | 27 | 3 |
| 1657 | CT Gohan đi biển | 5 | 3 |
| 1658 | Đầu trâu | 5 | 0 |
| 1659 | Đầu trâu | 5 | 1 |
| 1660 | Đầu trâu | 5 | 2 |
| 1661 | Mặt ngựa | 5 | 0 |
| 1662 | Mặt ngựa | 5 | 1 |
| 1663 | Mặt ngựa | 5 | 2 |
| 1664 | Vỏ Xên bọ hung | 27 | 3 |
| 1665 | Túi đựng vỏ Xên bọ hung | 27 | 3 |
| 1666 | Rađa dò vỏ Xên | 27 | 3 |
| 1667 | CT Gohan kính mát | 5 | 3 |
| 1668 | Pet Capybara hồng | 27 | 3 |
| 1669 | Balo Capybara | 11 | 3 |
| 1670 | Balo Capybara hồng | 11 | 3 |
| 1671 | Rương mùa hè | 27 | 3 |
| 1672 | Sầu riêng 6 múi | 29 | 3 |
| 1673 | Tay nhanh hơn não | 36 | 3 |
| 1674 | CT Pikkon | 5 | 3 |
| 1675 | Lồng đèn kéo quân NRO | 11 | 3 |
| 1676 | Phong hỏa luân | 23 | 3 |
| 1677 | Xe xanh Chi Chi | 23 | 3 |
| 1678 | Xe đỏ Bun ma | 23 | 3 |
| 1679 | Cờ Olympic | 11 | 3 |
| 1680 | Hỏa tiêm thương | 11 | 3 |
| 1681 | Cờ Hải Ly xe máy | 11 | 3 |
| 1682 | Pet Hải Ly | 27 | 3 |
| 1683 | Pet Hải Ly Ong Vàng | 27 | 3 |
| 1684 | CT lân | 5 | 3 |
| 1685 | CT rồng | 5 | 3 |
| 1686 | Pet Thỏ Ú | 27 | 3 |
| 1687 | Cờ Goku bay | 11 | 3 |
| 1688 | Cờ Hắc Vô Thường | 11 | 3 |
| 1689 | Cờ Bạch Vô Thường | 11 | 3 |
| 1690 | Phiếu đổi Cápsule | 27 | 3 |
| 1691 | Bùa bình an | 27 | 3 |
| 1692 | Bùa may mắn | 27 | 3 |
| 1693 | CT Cađíc SSJ4 | 5 | 3 |
| 1694 | Labubu | 11 | 3 |
| 1695 | Hộp quà tháng 9 | 27 | 3 |
| 1696 | Hộp quà tháng 9 VIP | 27 | 3 |
| 1697 | CT Gogeta | 5 | 3 |
| 1698 | CT Urôn Trư Bát Giới | 5 | 3 |
| 1699 | Bồ cào 9 răng | 11 | 3 |
| 1700 | CT Hằng Nga | 5 | 3 |
| 1701 | Hộp bánh Trung Thu đặc biệt | 27 | 3 |
| 1702 | Lưỡi hái hồng | 11 | 3 |
| 1703 | Gia hạn mầm | 27 | 3 |
| 1704 | Bí Ngô Cánh Dơi | 23 | 3 |
| 1705 | Cải Trang Chi Chi Võ Đài | 5 | 3 |
| 1706 | Lưỡi hái | 11 | 3 |
| 1707 | <Cập nhật phiên bản mới để xem> | 27 | 3 |
| 1708 | CT Android 21 Thân Thiện | 5 | 3 |
| 1709 | CT Android 21 Evil | 5 | 3 |
| 1710 | CT Android 21 Tiến Sĩ | 5 | 3 |
| 1711 | Cân Đẩu Vân Thơ Mộng | 23 | 3 |
| 1712 | Pet Rồng xương | 27 | 3 |
| 1713 | Khủng Long Thơ Mộng | 11 | 3 |
| 1714 | Pet Giru | 27 | 3 |
| 1715 | Đậu thần cấp 11 | 6 | 3 |
| 1716 | Giáp tập luyện cấp 4 | 32 | 3 |
| 1717 | Gia hạn mầm | 27 | 3 |
| 1718 | Thiệp chúc VIP | 27 | 3 |
| 1719 | Hộp quà 20/10 | 27 | 3 |
| 1720 | Hộp quà 20/10 | 27 | 3 |
| 1721 | Cá Koi zombie | 11 | 3 |
| 1722 | Cánh Thiên thần - Ác quỷ | 11 | 3 |
| 1723 | Cải trang Chan Xư | 5 | 3 |
| 1724 | Ván bay Sọ Dừa | 23 | 3 |
| 1725 | Gói quà Halloween | 27 | 3 |
| 1726 | Kẹo mù Halloween | 27 | 3 |
| 1727 | Pet Ma cầu mưa | 27 | 3 |
| 1728 | Túi mù Halloween | 27 | 3 |
| 1729 | Pet Rồng Xanh | 27 | 3 |
| 1730 | Vé ước miễn phí | 27 | 3 |
| 1731 | CT Black Goku Rose | 5 | 3 |
| 1732 | CT Black Goku | 5 | 3 |
| 1733 | Thú cưỡi Thích Kim Quy | 23 | 3 |
| 1734 | Thú cưỡi Phong Xích Lan | 23 | 3 |
| 1735 | Đeo lưng dụng cụ học tập | 11 | 3 |
| 1736 | Hộp quà FA | 27 | 3 |
| 1737 | Rađa dò Zombie | 27 | 3 |
| 1738 | Hộp quà FA | 27 | 3 |
| 1739 | Hộp quà 20-11 | 27 | 3 |
| 1740 | Sách giáo khoa | 27 | 3 |
| 1741 | CT Cađíc | 5 | 3 |
| 1742 | CT Cađíc SSJ | 5 | 3 |
| 1743 | CT Cađíc SSJ2 | 5 | 3 |
| 1744 | CT Cađíc SSJ2 M | 5 | 3 |
| 1745 | CT Cađíc SSJ3 | 5 | 3 |
| 1746 | CT Cađíc SSJ Blue | 5 | 3 |
| 1747 | Hộp quà Black Friday | 27 | 3 |
| 1748 | Pet tuần lộc | 27 | 3 |
| 1749 | Thú cưỡi Cây thông | 23 | 3 |
| 1750 | Pet Khủng Long ngok | 27 | 3 |
| 1751 | Diều rồng băng | 11 | 3 |
| 1752 | Đai lưng | 17 | 3 |
| 1753 | Đai lưng | 17 | 3 |
| 1754 | Đai lưng | 17 | 3 |
| 1755 | Hộp quà Cađíc | 27 | 3 |
| 1756 | Hộp quà Cađíc | 27 | 3 |
| 1757 | Hộp quà Cađíc VIP | 27 | 3 |
| 1758 | Phở Linh Lang | 29 | 3 |
| 1759 | Phở Giải Phóng | 29 | 3 |
| 1760 | Phở Công viên Hòa Bình | 29 | 3 |
| 1761 | Mị Hoàng Kim | 5 | 3 |
| 1762 | hùng vương  | 5 | 3 |
| 1763 | Sơn tinh  | 5 | 3 |
| 1764 | Thủy Tinh  | 5 | 3 |
| 1765 | Bé Rồng Cute | 27 | 3 |
| 1766 | Bé Rồng Cute | 27 | 3 |
| 1767 | Bé Rồng Cute | 27 | 3 |
| 1768 | Bé Rồng Cute | 27 | 3 |
| 1769 | Bé Rồng Cute | 27 | 3 |
| 1770 | Bé Rồng Cute | 27 | 3 |
| 1771 | Bé Rồng Cute | 27 | 3 |
| 1772 | búa sơn tinh | 11 | 3 |
| 1773 | bút thủy tinh | 11 | 3 |
| 1774 | Đệ Black Goku | 29 | 3 |
| 1775 | Hộp thần linh | 29 | 3 |
| 1776 | Hộp quà sự kiện | 29 | 3 |
| 1777 | Hộp quà sự kiện VIP | 29 | 3 |
| 1778 | Cuốn chả giò | 27 | 3 |
| 1779 | Cải trang buma | 5 | 3 |
| 1780 | Cải trang goku | 5 | 3 |
| 1781 | Cải trang gohan | 5 | 3 |
| 1782 | Cải trang chichi | 5 | 3 |
| 1783 | Cải trang broly | 5 | 3 |
| 1784 | Cải trang broly red | 5 | 3 |
| 1785 | Cải trang baby | 5 | 3 |
| 1786 | Cải trang vegeta baby | 5 | 3 |
| 1787 | Vé riêng tư | 75 | 3 |
| 1788 | Cải trang baby khỉ | 5 | 3 |
| 1789 | Thỏ may mắn | 27 | 3 |
| 1790 | Mẹ Rồng | 75 | 3 |
| 1791 | Mảnh khỉ Oorazu | 33 | 3 |
| 1792 | Mảnh khỉ Oorazu 1 | 33 | 3 |
| 1793 | Mảnh khỉ Oorazu 2 | 33 | 3 |
| 1794 | Con dấu | 75 | 3 |
| 1795 | Bình hút năng lượng | 75 | 3 |
| 1796 | Đệ tử vegeta | 5 | 3 |
| 1797 | Cải trang Picolo | 5 | 3 |
| 1798 | Tayaki | 75 | 3 |
| 1799 | Kẹo táo | 75 | 3 |
| 1800 | Kem que đôi | 75 | 3 |
| 1801 | Mochi | 75 | 3 |
| 1802 | Ramen | 75 | 3 |
| 1803 | Cadic đi biển | 5 | 3 |
| 1804 | Buma đi biển | 5 | 3 |
| 1805 | Phiếu thức ăn | 75 | 3 |
| 1806 | Kem que | 11 | 3 |
| 1807 | Goku ssj 4 kid | 5 | 3 |
| 1808 | Kid jiren | 5 | 3 |
| 1809 | Super 2 sao | 11 | 3 |
| 1810 | Super 3 sao | 11 | 3 |
| 1811 | Super 4 sao | 11 | 3 |
| 1812 | Guardian Angel | 11 | 3 |
| 1813 | Fallen Angel | 11 | 3 |
| 1814 | Eternal Hope | 11 | 3 |
| 1815 | ct dep vcl | 5 | 3 |
| 1816 | td | 5 | 3 |
| 1817 | nm | 5 | 3 |
| 1818 | xd | 5 | 3 |
| 1819 | Bông tai Porata | 27 | 3 |
| 1820 | Mảnh vỡ bông tai cấp 3 | 27 | 3 |
| 1821 | Trứng vàng rồng nhí | 75 | 3 |
| 1822 | Rada ngọc rồng | 75 | 3 |
| 1823 | Rada ngọc rồng Vip | 75 | 3 |
| 1824 | Cậu Vàng | 75 | 3 |
| 1825 | Vé Nhệm Vụ KOL Vip | 75 | 3 |
| 1826 |  | 75 | 3 |
| 1827 |  | 75 | 3 |
| 1828 |  | 75 | 3 |
| 1829 |  | 75 | 3 |
| 1830 |  | 75 | 3 |
| 1831 |  | 75 | 3 |
| 1832 |  | 75 | 3 |
| 1833 |  | 75 | 3 |
| 1834 |  | 75 | 3 |
| 1835 | Vé hoàn thành nhiệm vụ | 75 | 3 |
| 1836 |  | 75 | 3 |
| 1837 |  | 75 | 3 |
| 1838 |  | 75 | 3 |
| 1839 |  | 75 | 3 |
| 1840 | Hộp quà Goku Day VIP | 75 | 3 |
| 1841 | Cải trang Gốc | 5 | 3 |
| 1842 | Cải trang Gốc | 5 | 3 |
| 1843 | Cải trang Gốc | 5 | 3 |
| 1844 | Cải trang Gốc | 5 | 3 |
| 1845 | Cải trang Gốc | 5 | 3 |
| 1846 | Cải trang Gốc | 5 | 3 |
| 1847 | Cải trang Gốc | 5 | 3 |
| 1848 | Cải trang Gốc | 5 | 3 |
| 1849 | Cải trang Gốc | 5 | 3 |
| 1850 | Cải trang Gốc | 5 | 3 |
| 1851 | Broly Nes | 5 | 3 |
| 1852 | Cải trang Gốc | 5 | 3 |
| 1853 | Cải trang Gốc | 5 | 3 |
| 1854 | Cải trang Gốc | 5 | 3 |
| 1855 | Cải trang Gốc | 5 | 3 |
| 1856 | Cải trang Gốc | 5 | 3 |
| 1857 | Cải trang Gốc | 5 | 3 |
| 1858 | Cải trang Gốc | 5 | 3 |
| 1859 | Cải trang Gốc | 5 | 3 |
| 1860 | Cải trang Gốc 1 | 5 | 3 |
| 1861 | Cải trang Gốc 2 | 5 | 3 |
| 1862 | Cải trang Gốc 3 | 5 | 3 |
| 1863 | Cải trang Gốc 4 | 5 | 3 |
| 1864 | Cải trang Gốc 5 | 5 | 3 |
| 1865 | Cải trang Gốc 6 | 5 | 3 |
| 1866 | Cải trang Gốc 7 | 5 | 3 |
| 1867 | Cải trang Gốc 8 | 5 | 3 |
| 1868 | Cải trang Gốc 9 | 5 | 3 |
| 1869 | Giáp tập luyện cấp 5 | 32 | 3 |
| 1870 | Cải trang Gốc 10 | 5 | 3 |
| 1871 |  | 75 | 3 |
| 1872 |  | 75 | 3 |
| 1873 |  | 75 | 3 |
| 1874 |  | 75 | 3 |
| 1875 |  | 75 | 3 |
| 1876 |  | 75 | 3 |
| 1877 |  | 75 | 3 |
| 1878 |  | 75 | 3 |
| 1879 |  | 75 | 3 |
| 1880 |  | 75 | 3 |
| 1881 |  | 75 | 3 |
| 1882 |  | 75 | 3 |
| 1883 |  | 75 | 3 |
| 1884 |  | 75 | 3 |
| 1885 |  | 75 | 3 |
| 1886 |  | 75 | 3 |
| 1887 |  | 75 | 3 |
| 1888 |  | 75 | 3 |
| 1889 |  | 75 | 3 |
| 1890 |  | 75 | 3 |
| 1891 |  | 75 | 3 |
| 1892 |  | 75 | 3 |
| 1893 |  | 75 | 3 |
| 1894 |  | 75 | 3 |
| 1895 |  | 75 | 3 |
| 1896 |  | 75 | 3 |
| 1897 |  | 75 | 3 |
| 1898 |  | 75 | 3 |
| 1899 |  | 75 | 3 |
| 1900 | Ghost Rider | 27 | 3 |
| 1901 |  | 75 | 3 |
| 1902 |  | 75 | 3 |
| 1903 |  | 75 | 3 |
| 1904 |  | 75 | 3 |
| 1905 |  | 75 | 3 |
| 1906 |  | 75 | 3 |
| 1907 |  | 75 | 3 |
| 1908 |  | 75 | 3 |
| 1909 |  | 75 | 3 |
| 1910 |  | 75 | 3 |
| 1911 |  | 75 | 3 |
| 1912 |  | 75 | 3 |
| 1913 |  | 75 | 3 |
| 1914 |  | 75 | 3 |
| 1915 |  | 75 | 3 |
| 1916 |  | 75 | 3 |
| 1917 |  | 75 | 3 |
| 1918 |  | 75 | 3 |
| 1919 |  | 75 | 3 |
| 1920 |  | 75 | 3 |
| 1921 |  | 75 | 3 |
| 1922 |  | 75 | 3 |
| 1923 |  | 75 | 3 |
| 1924 |  | 75 | 3 |
| 1925 |  | 75 | 3 |
| 1926 |  | 75 | 3 |
| 1927 |  | 75 | 3 |
| 1928 |  | 75 | 3 |
| 1929 |  | 75 | 3 |
| 1930 |  | 75 | 3 |
| 1931 |  | 75 | 3 |
| 1932 |  | 75 | 3 |
| 1933 |  | 75 | 3 |
| 1934 |  | 75 | 3 |
| 1935 |  | 75 | 3 |
| 1936 |  | 75 | 3 |
| 1937 |  | 75 | 3 |
| 1938 |  | 75 | 3 |
| 1939 |  | 75 | 3 |
| 1940 |  | 75 | 3 |
| 1941 |  | 75 | 3 |
| 1942 |  | 75 | 3 |
| 1943 |  | 75 | 3 |
| 1944 |  | 75 | 3 |
| 1945 |  | 75 | 3 |
| 1946 |  | 75 | 3 |
| 1947 |  | 75 | 3 |
| 1948 |  | 75 | 3 |
| 1949 |  | 75 | 3 |
| 1950 |  | 75 | 3 |
| 1951 |  | 75 | 3 |
| 1952 |  | 75 | 3 |
| 1953 |  | 75 | 3 |
| 1954 |  | 75 | 3 |
| 1955 |  | 75 | 3 |
| 1956 |  | 75 | 3 |
| 1957 |  | 75 | 3 |
| 1958 |  | 75 | 3 |
| 1959 |  | 75 | 3 |
| 1960 |  | 75 | 3 |
| 1961 |  | 75 | 3 |
| 1962 |  | 75 | 3 |
| 1963 |  | 75 | 3 |
| 1964 |  | 75 | 3 |
| 1965 |  | 75 | 3 |
| 1966 |  | 75 | 3 |
| 1967 |  | 75 | 3 |
| 1968 |  | 75 | 3 |
| 1969 |  | 75 | 3 |
| 1970 |  | 75 | 3 |
| 1971 |  | 75 | 3 |
| 1972 |  | 75 | 3 |
| 1973 |  | 75 | 3 |
| 1974 |  | 75 | 3 |
| 1975 |  | 75 | 3 |
| 1976 |  | 75 | 3 |
| 1977 |  | 75 | 3 |
| 1978 |  | 75 | 3 |
| 1979 |  | 75 | 3 |
| 1980 |  | 75 | 3 |
| 1981 |  | 75 | 3 |
| 1982 |  | 75 | 3 |
| 1983 |  | 75 | 3 |
| 1984 |  | 75 | 3 |
| 1985 |  | 75 | 3 |
| 1986 |  | 75 | 3 |
| 1987 |  | 75 | 3 |
| 1988 |  | 75 | 3 |
| 1989 |  | 75 | 3 |
| 1990 |  | 75 | 3 |
| 1991 |  | 75 | 3 |
| 1992 |  | 75 | 3 |
| 1993 |  | 75 | 3 |
| 1994 |  | 75 | 3 |
| 1995 |  | 75 | 3 |
| 1996 |  | 75 | 3 |
| 1997 |  | 75 | 3 |
| 1998 | SKH Beerus Hủy Diệt | 29 | 3 |
| 1999 | Beerus Hủy Diệt | 5 | 3 |

## Option (chỉ số vật phẩm)
Dấu `#` trong tên là chỗ thay bằng giá trị. Dùng trong lệnh `i` dạng `id:giá trị`.

| ID | Tên |
|---|---|
| 0 | Tấn công+# |
| 1 | Thời gian sử dụng # phút |
| 2 | HP, KI+#000 |
| 3 | Vô hiệu và biến #% sát thương chưởng thành KI |
| 4 | Hồi phục #% KI khi bị đánh |
| 5 | +#% sức đánh chí mạng |
| 6 | HP+# |
| 7 | KI+# |
| 8 | Hút #% HP, KI xung quanh mỗi 5 giây |
| 9 | Hiệu lực trong # phút |
| 10 | Sát thương chuẩn #% |
| 11 | Công đức +# |
| 12 | Số lần sử dụng còn lại +# |
| 13 | Số yêu quái đã hạ +# |
| 14 | Chí mạng+#% |
| 15 | Phản đòn cận chiến+# |
| 16 | Tốc độ di chuyển+#% |
| 17 | Né đòn: +# |
| 18 | Chính xác: +#% |
| 19 | Tấn công+#% khi đánh quái |
| 20 | PIN # |
| 21 | Yêu cầu sức mạnh # tỉ |
| 22 | HP+#K |
| 23 | KI+#K |
| 24 | Làm tăng trọng lực, gây chậm mọi người xung quanh |
| 25 | Tàng hình mỗi 5 giây |
| 26 | Hóa đá mọi người xung quanh mỗi 30 giây |
| 27 | +# HP/30s |
| 28 | +# KI/30s |
| 29 | Biến Sôcôla mọi người xung quanh mỗi 30 giây |
| 30 | Không thể giao dịch |
| 31 | Số lượng # |
| 32 | Không bị hóa Xương |
| 33 | Dịch chuyển tức thời |
| 34 | Tinh ấn |
| 35 | Nguyệt ấn |
| 36 | Nhật ấn |
| 37 | Số lần đã ký gửi # |
| 38 | Chỉ có tác dụng khi hợp thể |
| 39 | <Cập nhật bản mới để xem> |
| 40 | Siêu cải trang # đá ngũ sắc |
| 41 | Chỉ số thưởng +#: |
| 42 | Tấn công+#% lên quái bay |
| 43 | Tấn công+#% lên quái khỉ |
| 44 | Tấn công+#% lên quái mặt đất |
| 45 | Tấn công+#% lên tộc Namếc |
| 46 | Tấn công+#% lên tộc Trái đất |
| 47 | Giáp+# |
| 48 | HP, KI+# |
| 49 | Tấn công+#% |
| 50 | Sức đánh+#% |
| 51 | Sôn Gô Ku ss# |
| 52 | Ca Đic siêu ss# |
| 53 | Broly |
| 54 | Mr. Santa |
| 55 | Broly ss# |
| 56 | Ca Lích |
| 57 | Thên Xin Hăng |
| 58 | Pic |
| 59 | Siêu na mếc # |
| 60 | Sôn Gô Tên |
| 61 | Sôn Gô Ku |
| 62 | Phục hồi thể lực #% |
| 63 | Còn lại # ngày |
| 64 | Còn lại # giờ |
| 65 | Còn lại # phút |
| 66 | Chưa có |
| 67 | Dùng nâng cấp găng tay |
| 68 | Dùng để nâng cấp áo |
| 69 | Dùng để nâng cấp quần |
| 70 | Dùng để nâng cấp giày |
| 71 | Dùng để nâng cấp rađa |
| 72 | Cấp # |
| 73 |  |
| 74 | Dùng để ép thành đá |
| 75 | Dùng để làm phép |
| 76 | Vip |
| 77 | HP+#% |
| 78 | Sức hủy diệt+#% |
| 79 | Đệ tử #% sức đánh |
| 80 | HP+#%/30s |
| 81 | KI+#%/30s |
| 82 | Không bị quái chủ động đánh và giảm 20% sát thương khi bị đánh |
| 83 | Tăng 20% sức mạnh và tiềm năng nhận được khi đánh quái |
| 84 | Dùng để bay không tốn KI |
| 85 | Dùng để bay và phục hồi KI |
| 86 | Ký gửi vàng |
| 87 | Ký gửi ngọc |
| 88 | Cộng #% Tiềm năng và sức mạnh nhận được khi đánh quái |
| 89 | Dùng để bay và phục hồi HP, KI |
| 90 | Tặng cho người khác (bỏ ra đất) sẽ được nhận may mắn |
| 91 | Mở ra để nhận may mắn |
| 92 | Chúc tết bang hội và mọi người kèm theo pháo hoa |
| 93 | Hạn sử dụng # ngày |
| 94 | Giảm #% sát thương |
| 95 | Biến #% tấn công thành HP |
| 96 | Biến #% tấn công thành KI |
| 97 | Phản #% sát thương |
| 98 | Xuyên giáp #% chưởng |
| 99 | Xuyên giáp #% cận chiến |
| 100 | +#% vàng từ quái |
| 101 | +#% tiềm năng, sức mạnh |
| 102 | # Sao Pha Lê |
| 103 | KI +#% |
| 104 | Biến #% tấn công quái thành HP |
| 105 | Vô hình khi không đánh quái và boss |
| 106 | Không ảnh hưởng bởi cái lạnh |
| 107 | # Sao Pha Lê |
| 108 | #% Né đòn |
| 109 | Hôi, giảm #% HP |
| 110 | Dò pha lê |
| 111 | Phân tâm |
| 112 | Giảm #% khi mua Avatar hoặc Cải trang |
| 113 | Ném cho Sói Hẹc Quyn |
| 114 | +#% TĐ chạy |
| 115 | Biến cà rốt |
| 116 | Kháng TDHS |
| 117 | Đẹp +#% SĐ cho mình và người xung quanh |
| 118 | Tới ngay mục tiêu và gây choáng trong # mili giây |
| 119 | Gây mù xung quanh trong # giây |
| 120 | Ra đòn sau # giây |
| 121 | Ru ngủ trong # giây |
| 122 | Bảo vệ trong # giây |
| 123 | Trói gô mục tiêu trong # giây |
| 124 | Tỉnh giấc bị yếu đi -#% sức đánh trong 10 giây |
| 125 | Tăng và hồi phục #% HP tạm thời cho mình và xung quanh trong 30 giây |
| 126 | Biến sôcôla làm yếu đi -#% sức đánh trong 30 giây |
| 127 | Set Thên Xin Hăng |
| 128 | Set Kirin |
| 129 | Set Sôngôku |
| 130 | Set Picolo |
| 131 | Set Ốc tiêu |
| 132 | Set Pikkoro Daimao |
| 133 | Set Kakarot |
| 134 | Set Ca Đíc |
| 135 | Set Nappa |
| 136 | $(5 món +100% sát thương đấm Galick) |
| 137 | $(5 món x5 thời gian hóa khỉ) |
| 138 | $(5 món +80% HP) |
| 139 | $(5 món x2 thời gian chói mắt) |
| 140 | $(5 món +100% sát thương Quả Cầu Kênh Khi) |
| 141 | $(5 món +100% sát thương Kamejoko) |
| 142 | $(5 món +100% sát thương Masenkosappo) |
| 143 | $(5 món +100% sát thương Liên Hoàn) |
| 144 | $(5 món +100% sát thương và bất tử đệ từ Đẻ Trứng) |
| 145 | $(Ở gần 1 CT Dr Slum khác loại +20% sức đánh +66% tốc độ chạy) |
| 146 | $(Ở gần 2 CT Dr Slum khác loại +30% sức đánh +100% tốc độ chạy) |
| 147 | +#% sức đánh |
| 148 | +#% tốc độ chạy |
| 149 | (Chỉ số tăng khi ở gần CT Hải Tặc khác loại) |
| 150 | (Chỉ số tăng khi ở gần Android Sát Thủ khác loại) |
| 151 | $(Ở gần 1 CT nhóm Piláp khác loại +20% sức đánh +66% tốc độ chạy) |
| 152 | $(Ở gần 2 CT nhóm Piláp khác loại +30% sức đánh +100% tốc độ chạy) |
| 153 | #% tỉ lệ phát nổ sau khi chết |
| 154 | Không thể bán lại |
| 155 | Giảm 50% sức đánh, HP, KI và +#% SM, TN, vàng từ quái |
| 156 | Cộng dồn 1% sức đánh khi chỉ dùng chiêu đấm, tối đa #% |
| 157 | Giảm #% mọi sát thương khi KI dưới 20% |
| 158 | Khi ở trần và không đeo cải trang sẽ có cơ hội tìm thấy vật phẩm sự kiện |
| 159 | x# sức đánh đòn chưởng cơ bản mỗi phút |
| 160 | +#% TN, SM cho đệ tử khi sư phụ mặc |
| 161 | Thêm # ngọc mỗi ngày khi đánh quái. |
| 162 | Cute hồi #% KI/s bản thân và xung quanh |
| 163 | Biến người xung quanh thành Bí Ngô |
| 164 | Đổi bằng # điểm sự kiện |
| 165 | Cơ hội ra đòn +#% sát thương lửa khi cận chiến quái |
| 166 | Ngầu +#% sức đánh lên quái khi bay với Cải Trang Tàu Pảy Pảy |
| 167 | Tạo không khí lạnh |
| 168 | Hấp thụ sức mạnh rồi bộc phá |
| 169 | Cơ hội hạ độc đối thủ |
| 170 | Ngầu +#% sức đánh lên quái khi bay với Cải Trang nhà Fide |
| 171 | Số lượng #K |
| 172 | # |
| 173 | Phục hồi #% HP và KI cho đồng đội |
| 174 | Sự kiện năm # |
| 175 | Giảm #% thời gian bị mù |
| 176 | $(Ở gần đủ 5 loại +20% sức đánh +50% tốc độ chạy) |
| 177 | $(Tối đa +2% tất cả khi ở gần Mabư mập) |
| 178 | KI+#%/10s |
| 179 | +2% sức đánh, tối đa 10% khi ở gần Cải Trang tộc Demons Frost |
| 180 | +#% sức đánh khi ở gần Cải Trang Black Gohan Rose |
| 181 | Dịch chuyển tức thời +#% sát thương |
| 182 | +#% sát thương đệ từ trứng |
| 183 | Giảm #% thời gian hồi Khiên |
| 184 | +#% sức đánh, tối đa 10% khi ở gần Gohan xanh, Poc đỏ, Arale búp bê |
| 185 | +# giờ sử dụng |
| 186 | Biến kẹo 30 giây |
| 187 | Giảm # giây thời gian bị mù |
| 188 | Đệ tử chưởng kamejoko +#% sát thương |
| 189 | Đệ tử chưởng antomic +#% sát thương |
| 190 | Đệ tử chưởng masenko +#% sát thương |
| 191 | Né chí mạng+#% |
| 192 | +#% Chí mạng |
| 193 | +#% sức đánh, tối đa 11% khi ở gần Cải trang cầu thủ khác |
| 194 | +#% sức đánh, tối đa 10% khi ở gần Cải trang hè khác |
| 195 | +#% sức đánh, tối đa 10% khi ở gần Cải trang siêu nhân khác |
| 196 | Xinh +#% sức đánh, tối đa 18% khi ở gần Cải trang Thỏ khác |
| 197 | Tấn công+#% lên tộc Xayda |
| 198 | Giảm #% sát thương từ tộc Trái Đất |
| 199 | Giảm #% sát thương từ tộc Namếc |
| 200 | Set Hủy Diệt Beerus |
| 201 | $[2] Tăng nhẹ SĐ và STCM |
| 202 | $[4] Tăng mạnh SĐ và STCM |
| 203 | $[5] Tăng cực mạnh SĐ và STCM |
| 204 | Tấn công+#% lên Boss |
| 205 | Đi cùng CT Diệt Quỷ +#% SĐ, tối đa 18% |
| 206 | Vật phẩm hiếm rơi từ quái (+#%) |
| 207 | Vật phẩm hiếm rơi từ boss (+#%) |
| 208 | Trang bị đã chuyển hóa |
| 209 | Bị rớt cấp # lần |
| 210 | # Dòng chỉ số ẩn |
| 211 | Giám định #/5 |
| 212 | Độ bền #/1000 |
| 213 | Giá bán: # triệu vàng |
| 214 | Phạm vi tuyệt kỹ +#% |
| 215 | Số lượng mục tiêu +# |
| 216 | Tuyệt kỹ +#% sát thương |
| 217 | - Chưa giám định |
| 218 |  --------- |
| 219 | Số lần tẩy # |
| 220 | Hoàn thành #% |
| 221 | Phục hồi #% HP và  KI mỗi 30 giây cho bản thân và đồng bang |
| 222 | 120 giây kích nộ sức đánh #% trong 30 giây |
| 223 | 120 giây kích hồi #% HP trong vòng 30 giây |
| 224 | Giảm thời gian cooldown của tất cả kỹ năng về 0,1 giây |
| 225 | Giảm # giây bị phong ấn của Ma Phong Ba |
| 226 | Cute +#% SĐ cho mình và người xung quanh |
| 227 | Giảm #% tác dụng của các đòn khống chế khi dùng khiên năng lượng |
| 228 | Cường hóa tới ô sao pha lê # |
| 229 | Lạnh gây giảm #% HP , KI mỗi 30s cho những người xung quanh |
| 230 | +# triệu tiềm năng, sức mạnh |
| 231 | Hạn sử dụng hoặc vĩnh viễn |
| 232 | Số lần giao dịch còn lại: # |
| 233 | Set Gohan |
| 234 | $(5 món +150% may mắn +30% vàng rơi từ quái) |
| 235 | Số lần ký gửi còn lại: # |
| 236 | +#% May mắn |
| 237 | Set Nail chiến binh Namếc |
| 238 | $[2] Tăng nhẹ sát thương chí mạng |
| 239 | $[4] Giảm nhẹ hồi chiêu Masenko |
| 240 | $[5] Tăng sát thương Masenko, giảm mạnh hồi chiêu Masenko |
| 241 | Set Cađic M |
| 242 | $[2] Tăng nhẹ HP và phạm vi ảnh hưởng chiêu phát nổ |
| 243 | $[4] Tăng nhẹ sát thương chiêu phát nổ |
| 244 | $[5] Tăng mạnh sát thương chiêu phát nổ |
| 245 | Set Thần Vũ Trụ Kaio |
| 246 | $[2] Tăng mạnh chí mạng |
| 247 | $[4] Giảm nhẹ hao HP,KI chiêu Kaioken |
| 248 | $[5] Tăng mạnh sát thương và giảm mạnh hao HP,KI chiêu Kaioken |
| 249 | Hắc hóa: +#% HP cho người chơi xung quanh |
| 250 | # Kilis |

## Map
| ID | Tên | Hành tinh |
|---|---|---|
| 0 | Làng Aru | 0 |
| 1 | Đồi hoa cúc | 0 |
| 2 | Thung lũng tre | 0 |
| 3 | Rừng nấm | 0 |
| 4 | Rừng xương | 0 |
| 5 | Đảo Kamê | 0 |
| 6 | Đông Karin | 0 |
| 7 | Làng Mori | 1 |
| 8 | Đồi nấm tím | 1 |
| 9 | Thị trấn Moori | 1 |
| 10 | Thung lũng Namếc | 1 |
| 11 | Thung lũng Maima | 1 |
| 12 | Vực maima | 1 |
| 13 | Đảo Guru | 1 |
| 14 | Làng Kakarot | 2 |
| 15 | Đồi hoang | 2 |
| 16 | Làng Plant | 2 |
| 17 | Rừng nguyên sinh | 2 |
| 18 | Rừng thông Xayda | 2 |
| 19 | Thành phố Vegeta | 2 |
| 20 | Vách núi đen | 2 |
| 21 | Nhà Gôhan | 0 |
| 22 | Nhà Moori | 1 |
| 23 | Nhà Broly | 2 |
| 24 | Trạm tàu vũ trụ | 0 |
| 25 | Trạm tàu vũ trụ | 1 |
| 26 | Trạm tàu vũ trụ | 2 |
| 27 | Rừng Bamboo | 0 |
| 28 | Rừng dương xỉ | 0 |
| 29 | Nam Kamê | 0 |
| 30 | Đảo Bulông | 0 |
| 31 | Núi hoa vàng | 1 |
| 32 | Núi hoa tím | 1 |
| 33 | Nam Guru | 1 |
| 34 | Đông Nam Guru | 1 |
| 35 | Rừng cọ | 2 |
| 36 | Rừng đá | 2 |
| 37 | Thung lũng đen | 2 |
| 38 | Bờ vực đen | 2 |
| 39 | Vách núi Aru | 0 |
| 40 | Vách núi Moori | 1 |
| 41 | Vực Plant | 2 |
| 42 | Vách núi Aru | 0 |
| 43 | Vách núi Moori | 1 |
| 44 | Vách núi Kakarot | 2 |
| 45 | Thần điện | 0 |
| 46 | Tháp Karin | 0 |
| 47 | Rừng Karin | 0 |
| 48 | Hành tinh Kaio | 0 |
| 49 | Phòng tập thời gian | 0 |
| 50 | Thánh địa Kaio | 0 |
| 51 | Đấu trường | 2 |
| 52 | Đại hội võ thuật | 2 |
| 53 | Tường thành 1 | 2 |
| 54 | Tầng 3 | 0 |
| 55 | Tầng 1 | 0 |
| 56 | Tầng 2 | 0 |
| 57 | Tầng 4 | 0 |
| 58 | Tường thành 2 | 0 |
| 59 | Tường thành 3 | 0 |
| 60 | Trại độc nhãn 1 | 0 |
| 61 | Trại độc nhãn 2 | 0 |
| 62 | Trại độc nhãn 3 | 0 |
| 63 | Trại lính Fide | 2 |
| 64 | Núi dây leo | 2 |
| 65 | Núi cây quỷ | 2 |
| 66 | Trại qủy già | 2 |
| 67 | Vực chết | 2 |
| 68 | Thung lũng Nappa | 2 |
| 69 | Vực cấm | 2 |
| 70 | Núi Appule | 2 |
| 71 | Căn cứ Raspberry | 2 |
| 72 | Thung lũng Raspberry | 2 |
| 73 | Thung lũng chết | 2 |
| 74 | Đồi cây Fide | 2 |
| 75 | Khe núi tử thần | 2 |
| 76 | Núi đá | 2 |
| 77 | Rừng đá | 2 |
| 78 | Lãnh địa Fize | 0 |
| 79 | Núi khỉ đỏ | 2 |
| 80 | Núi khỉ vàng | 2 |
| 81 | Hang quỷ chim | 2 |
| 82 | Núi khỉ đen | 2 |
| 83 | Hang khỉ đen | 2 |
| 84 | Siêu Thị | 0 |
| 85 | Hành tinh M-2 | 2 |
| 86 | Hành tinh Polaris | 2 |
| 87 | Hành tinh Cretaceous | 2 |
| 88 | Hành tinh Monmaasu | 2 |
| 89 | Hành tinh Rudeeze | 2 |
| 90 | Hành tinh Gelbo | 2 |
| 91 | Hành tinh Tigere | 2 |
| 92 | Thành phố phía đông | 2 |
| 93 | Thành phố phía nam | 2 |
| 94 | Đảo Balê | 2 |
| 95 | 95 | 1 |
| 96 | Cao nguyên | 2 |
| 97 | Thành phố phía bắc | 2 |
| 98 | Ngọn núi phía bắc | 2 |
| 99 | Thung lũng phía bắc | 2 |
| 100 | Thị trấn Ginder | 2 |
| 101 | 101 | 1 |
| 102 | Nhà Bunma | 2 |
| 103 | Võ đài Xên bọ hung | 2 |
| 104 | Sân sau siêu thị | 0 |
| 105 | Cánh đồng tuyết | 2 |
| 106 | Rừng tuyết | 2 |
| 107 | Núi tuyết | 2 |
| 108 | Dòng sông băng | 2 |
| 109 | Rừng băng | 2 |
| 110 | Hang băng | 2 |
| 111 | Đông Nam Karin | 2 |
| 112 | Võ đài Hạt Mít | 2 |
| 113 | Đại hội võ thuật | 2 |
| 114 | Cổng phi thuyền | 2 |
| 115 | Phòng chờ | 2 |
| 116 | Thánh địa Kaio | 0 |
| 117 | Cửa Ải 1 | 2 |
| 118 | Cửa Ải 2 | 2 |
| 119 | Cửa Ải 3 | 2 |
| 120 | Phòng chỉ huy | 2 |
| 121 | 121 | 1 |
| 122 | Ngũ Hành Sơn | 2 |
| 123 | Ngũ Hành Sơn | 2 |
| 124 | Ngũ Hành Sơn | 2 |
| 125 | 125 | 1 |
| 126 | Thành phố Santa | 2 |
| 127 | Cổng phi thuyền | 2 |
| 128 | Bụng Mabư | 0 |
| 129 | Đại hội võ thuật | 2 |
| 130 | 130 | 1 |
| 131 | Hành Tinh Yardart | 2 |
| 132 | Hành Tinh Yardart 2 | 2 |
| 133 | Hành Tinh Yardart 3 | 2 |
| 134 | 134 | 1 |
| 135 | Động hải tặc | 0 |
| 136 | Hang Bạch Tuộc | 0 |
| 137 | Động kho báu | 0 |
| 138 | Cảng hải tặc | 0 |
| 139 | Hành tinh Potaufeu | 2 |
| 140 | Hang động Potaufeu | 2 |
| 141 | Con đường rắn độc | 0 |
| 142 | Con đường rắn độc | 0 |
| 143 | Con đường rắn độc | 0 |
| 144 | Hoang mạc | 2 |
| 145 | Võ Đài Siêu Cấp | 2 |
| 146 | Tây Karin | 0 |
| 147 | Sa mạc | 0 |
| 148 | Lâu đài Lychee | 2 |
| 149 | Thành phố Santa | 2 |
| 151 | Hành tinh bóng tối | 2 |
| 152 | Vùng đất băng giá | 2 |
| 153 | Lãnh địa Bang Hội | 0 |
| 154 | Hành tinh Bill | 0 |
| 155 | Hành tinh ngục tù | 0 |
| 156 | Tây thánh địa | 2 |
| 157 | Đông thánh Địa | 2 |
| 158 | Bắc thánh địa | 2 |
| 159 | Nam thánh Địa | 2 |
| 160 | Khu hang động | 2 |
| 161 | Bìa rừng nguyên thủy | 2 |
| 162 | Rừng nguyên thủy | 2 |
| 163 | Làng Plant nguyên thủy | 2 |
| 164 | Map riêng tư | 0 |
| 165 | Sa mạc hoang vu | 2 |
| 166 | Phòng thí nghiệm Myuu | 2 |
| 183 | Thành cổ 1 | 0 |
| 184 | Thành cổ 2 | 0 |
| 185 | Đấu trường thành cổ | 0 |

## Nhiệm vụ chính
| ID | Tên |
|---|---|
| 0 | Nhiệm vụ đầu tiên |
| 1 | Nhiệm vụ tập luyện |
| 2 | Nhiệm vụ tìm thức ăn |
| 3 | Nhiệm vụ sao băng |
| 4 | Nhiệm vụ thử thách |
| 5 | Nhiệm vụ thử thách |
| 6 | Nhiệm vụ thử thách |
| 7 | Nhiệm vụ giải cứu |
| 8 | Nhiệm vụ tìm ngọc |
| 9 | Nhiệm vụ bái sư |
| 10 | Nhiệm vụ thử sức |
| 11 | Nhiệm vụ gia tăng sức mạnh |
| 12 | Nhiệm vụ xin phép |
| 13 | Nhiệm vụ gia nhập bang hội |
| 14 | Nhiệm vụ bang hội đầu tiên |
| 15 | Nhiệm vụ bang hội thứ 2 |
| 16 | Tiêu diệt quái vật |
| 17 | Nhiệm vụ giúp đỡ Cui |
| 18 | Nhiệm vụ bất khả thi |
| 19 | Nhiệm vụ tìm diệt đệ tử |
| 20 | Nhiệm vụ Tiểu đội sát thủ |
| 21 | Nhiệm vụ chạm trán Fide đại ca |
| 22 | Chú bé đến từ tương lai |
| 23 | Chạm chán Robot sát thủ lần 1 |
| 24 | Chạm trán Robot sát thủ lần 2 |
| 25 | Chạm trán Robot sát thủ lần 3 |
| 26 | Chạm trán Xên bọ hung |
| 27 | Cuộc dạo chơi của xên |
| 28 | Cuộc đối đầu không cân sức |
| 29 | .. |

## Quái
| ID | Tên | HP |
|---|---|---|
| 0 | Mộc nhân | 20 |
| 1 | Khủng long | 200 |
| 2 | Lợn lòi | 200 |
| 3 | Quỷ đất | 200 |
| 4 | Khủng long mẹ | 500 |
| 5 | Lợn lòi mẹ | 500 |
| 6 | Quỷ đất mẹ | 500 |
| 7 | Thằn lằn bay | 600 |
| 8 | Phi long | 600 |
| 9 | Quỷ bay | 600 |
| 10 | Thằn lằn mẹ | 1000 |
| 11 | Phi long mẹ | 1000 |
| 12 | Quỷ bay mẹ | 1000 |
| 13 | Ốc mượn hồn | 3000 |
| 14 | Ốc sên | 3000 |
| 15 | Heo Xayda mẹ | 3000 |
| 16 | Heo rừng | 1500 |
| 17 | Heo da xanh | 1500 |
| 18 | Heo Xayda | 1500 |
| 19 | Heo rừng mẹ | 12000 |
| 20 | Heo xanh mẹ | 12000 |
| 21 | Alien | 12000 |
| 22 | Bulon | 6000 |
| 23 | Ukulele | 6000 |
| 24 | Quỷ mập | 6000 |
| 25 | Tambourine | 20000 |
| 26 | Drum | 20000 |
| 27 | Akkuman | 20000 |
| 28 | Thằn lằn bay 2 | 1500 |
| 29 | Phi long 2 | 1500 |
| 30 | Quỷ bay 2 | 1500 |
| 31 | Không tặc | 3000 |
| 32 | Quỷ đầu to | 3000 |
| 33 | Quỷ địa ngục | 3000 |
| 34 | Lính độc nhãn | 30000 |
| 35 | Lính độc nhãn | 30000 |
| 36 | Sói xám | 30000 |
| 37 | Robot bay | 30000 |
| 38 | Robot thép | 30000 |
| 39 | Nappa | 40000 |
| 40 | Soldier | 50000 |
| 41 | Appule | 60000 |
| 42 | Raspberry | 70000 |
| 43 | Thằn lằn xanh | 80000 |
| 44 | Quỷ đầu nhọn | 90000 |
| 45 | Quỷ đầu vàng | 100000 |
| 46 | Quỷ da tím | 110000 |
| 47 | Quỷ già | 120000 |
| 48 | Cá sấu | 130000 |
| 49 | Dơi da xanh | 140000 |
| 50 | Quỷ chim | 180000 |
| 51 | Lính đầu trọc | 150000 |
| 52 | Lính tai dài | 160000 |
| 53 | Lính vũ trụ | 170000 |
| 54 | Khỉ lông đen | 300000 |
| 55 | Khỉ giáp sắt | 350000 |
| 56 | Khỉ lông đỏ | 400000 |
| 57 | Khỉ lông vàng | 450000 |
| 58 | Xên con cấp 1 | 200000 |
| 59 | Xên con cấp 2 | 250000 |
| 60 | Xên con cấp 3 | 300000 |
| 61 | Xên con cấp  4 | 350000 |
| 62 | Xên con cấp  5 | 400000 |
| 63 | Xên con cấp  6 | 450000 |
| 64 | Xên con cấp  7 | 500000 |
| 65 | Xên con cấp  8 | 550000 |
| 66 | Tai tím | 350000 |
| 67 | Abo | 400000 |
| 68 | Kado | 450000 |
| 69 | Da xanh | 500000 |
| 70 | Hirudegarn | 40000000 |
| 71 | Vua Bạch Tuộc | 1500000 |
| 72 | Rôbốt bảo vệ | 1000000 |
| 73 | Kawazu | 50000 |
| 74 | Kinkarn | 55000 |
| 75 | Arbee | 60000 |
| 76 | Cỗ máy hủy diệt | 80000000 |
| 77 | Gấu tướng cướp | 2000000000 |
| 78 | Khỉ lông xanh | 2000000 |
| 79 | Taburine Đỏ | 3000000 |
| 80 | Cabira | 4000000 |
| 81 | Tobi | 5000000 |
| 82 | Voi Chín Ngà | 20000000 |
| 83 | Gà Chín Cựa | 12000000 |
| 84 | Ngựa Chín Lmao | 15000000 |
| 85 | Piano | 2000000000 |
| 86 | Ếch mặt đỏ | 4000000 |
| 87 | Jinai | 6000000 |
| 88 | Quỷ đỏ | 1000000 |
| 89 | Quỷ xanh | 1500000 |
| 90 | Quỷ xanh lá | 1000000 |
| 91 | Quỷ vàng | 1500000 |
| 92 | Godzila | 100000000 |
| 93 |  | 1 |
| 94 | Toppo | 4000000 |
| 95 | Cadic M | 6000000 |
| 96 | Janemba | 4000000 |
| 97 | MEZ | 4000000 |
| 98 | GOZ | 4000000 |
| 99 | Đá đỏ | 4000000 |
| 100 | Đá vàng | 4000000 |
| 101 | Đá xanh | 4000000 |
| 102 | Thây ma | 4000000 |
| 103 | Bù nhìn ma quái | 20 |
| 104 | Phù thủy | 4000000 |
| 105 | Frostbite | 500 |
| 106 | Snowy Tangerine | 550 |
| 107 | Deinonychus | 550 |
| 108 | Snake | 550 |
| 109 | Blizzard bird | 550 |
| 110 | Snowman | 55 |
| 111 | Yeti | 11 |
| 112 | Grim Reaper | 11 |
| 113 | Demon 3 | 11 |
| 114 | Golem | 11 |
| 115 | Dazing Stone | 11 |
| 116 | Demon 2 | 11 |
| 117 | Máy đo sức mạnh | 2000000000 |
| 118 | Cadic M | 6000000 |

## NPC
| ID | Tên |
|---|---|
| 0 | Ông Gôhan |
| 1 | Ông Paragus |
| 2 | Ông Moori |
| 3 | Rương đồ |
| 4 | Đậu thần |
| 5 | Con mèo |
| 6 | Khu vực |
| 7 | Bunma |
| 8 | Dende |
| 9 | Appule |
| 10 | Dr. Brief |
| 11 | Cargo |
| 12 | Cui |
| 13 | Quy Lão Kame |
| 14 | Trưởng lão Guru |
| 15 | Vua Vegeta |
| 16 | Uron |
| 17 | Bò Mộng |
| 18 | Thần mèo Karin |
| 19 | Thượng Đế |
| 20 | Thần Vũ Trụ |
| 21 | Bà Hạt Mít |
| 22 | Trọng tài |
| 23 | Ghi danh |
| 24 | Rồng Thiêng |
| 25 | Lính canh |
| 26 | Độc Nhãn |
| 27 | Rồng Thần Namec |
| 28 | Cửa hàng ký gửi |
| 29 | Rồng Omega |
| 30 | Rồng 2 sao |
| 31 | Rồng 3 sao |
| 32 | Rồng 4 sao |
| 33 | Rồng 5 sao |
| 34 | Rồng 6 sao |
| 35 | Rồng 7 sao |
| 36 | Rồng 1 sao |
| 37 | Bunma |
| 38 | Ca Lích |
| 39 | Santa |
| 40 | Mabư mập |
| 41 | Trung thu |
| 42 | Quốc Vương |
| 43 | Tổ Sư Kaio |
| 44 | Ôsin |
| 45 | Kibit |
| 46 | Babiđây |
| 47 | Giu-ma Đầu Bò |
| 48 | Ngộ Không |
| 49 | Đường Tăng |
| 50 | Quả trứng |
| 51 | Dưa hấu |
| 52 | Hùng Vương |
| 53 | Tapion |
| 54 | Lý Tiểu Nương |
| 55 | Bill |
| 56 | Whis |
| 57 | Champa |
| 58 | Vados |
| 59 | Trọng tài |
| 60 | Goku SSJ |
| 61 | Goku SSJ |
| 62 | Potage |
| 63 | Jaco |
| 64 | Thiên Sứ Whis |
| 65 | Yarirobe |
| 66 | Nồi bánh |
| 67 | Mr Popo |
| 68 | Panchy |
| 69 | Thỏ Đại Ca |
| 70 | Bardock |
| 71 | Berry |
| 72 | Đặc Cầu |
| 73 | Fide |
| 74 | Tori-Bot |
| 75 | Thỏ Đỏ ChiChi |
| 76 | Granola |
| 77 | Quả trứng linh thú |
| 78 | Ông già Noel |
| 79 | Cây thông Noel |
| 80 | Npc |
| 81 | Chi Chi |
| 82 | Rương Sưu Tầm |
| 83 | Dr. Myuu |
| 84 | Xe nước mía |
| 103 | Chú Bé Đần |
| 104 | Khá BảnH |
| 105 | Tiến Bry |
| 106 | Bulma Tết Nguyên Đán |
| 107 | Bill Bí Ngô |
| 108 | Heart |
| 109 | Bulma Bunny |
| 110 | Bunma Rực Rỡ |

## Kỹ năng
Hành tinh: 0 Trái Đất, 1 Namếc, 2 Xayda.

| Hành tinh | ID | Tên |
|---|---|---|
| 0 | 0 | Chiêu đấm Dragon |
| 0 | 1 | Chiêu Kamejoko |
| 0 | 6 | Thái Dương Hạ San |
| 0 | 9 | Kaioken |
| 0 | 10 | Quả cầu kênh khi |
| 0 | 19 | Khiên năng lượng |
| 0 | 20 | Dịch chuyển tức thời |
| 0 | 22 | Thôi miên |
| 0 | 24 | Super Kamejoko |
| 1 | 2 | Chiêu đấm Demon |
| 1 | 3 | Chiêu Masenko |
| 1 | 7 | Trị thương |
| 1 | 11 | Makankosappo |
| 1 | 12 | Đẻ trứng |
| 1 | 17 | Liên hoàn |
| 1 | 18 | Biến Sôcôla |
| 1 | 19 | Khiên năng lượng |
| 1 | 26 | Ma phong ba |
| 2 | 4 | Chiêu đấm Galick |
| 2 | 5 | Chiêu Antomic |
| 2 | 8 | Tái tạo năng lượng |
| 2 | 13 | Biến hình |
| 2 | 14 | Tự phát nổ |
| 2 | 19 | Khiên năng lượng |
| 2 | 21 | Huýt sáo |
| 2 | 23 | Trói |
| 2 | 25 | Cađíc liên hoàn chưởng |
