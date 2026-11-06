package nro.models.boss.thien_su;

import java.util.ArrayList;
import java.util.List;
import nro.models.boss.Boss;
import nro.models.item.Item.ItemOption;
import nro.models.map.ItemMap;
import nro.models.player.Player;
import nro.models.services.InventoryService;
import nro.models.services.ItemService;
import nro.models.services.Service;
import nro.models.utils.Util;

// Đồ rơi của boss Thiên sứ và Hủy diệt (mỗi con rơi riêng). Món Hủy Diệt như mua ở shop Bill: chỉ số gốc cộng 0-15%, 21:60, 30.
public class ThienSuHuyDietReward {

    private static final int THOI_VANG = 457;

    // Thiên sứ: 40% 1 món Hủy Diệt theo hành tinh người giết, 20% Ngọc rồng 2 hoặc 3 sao,
    // 20% Cuồng nộ 2 / Bổ khí 2 / Bổ huyết 2 / Giáp Xên 2 (1-5 cái), 20% không rơi gì
    public static void drop(Boss boss, Player plKill) {
        int rd = Util.nextInt(1, 100);
        ItemMap it;
        if (rd <= 40) {
            it = createHuyDiet(boss, plKill, Math.max(0, Math.min(2, plKill.gender)));
        } else if (rd <= 60) {
            it = new ItemMap(boss.zone, Util.nextInt(15, 16), 1, boss.location.x, y(boss), plKill.id);
        } else if (rd <= 80) {
            it = new ItemMap(boss.zone, Util.nextInt(1150, 1153), Util.nextInt(1, 5), boss.location.x, y(boss), plKill.id);
        } else {
            return;
        }
        Service.gI().dropItemMap(boss.zone, it);
    }

    // Hủy diệt (tổng 100%): 2% đồ Thần Linh (randDoTLBoss), 30% 1 món Hủy Diệt hành tinh ngẫu nhiên,
    // 20% Ngọc rồng 2 sao, 10% Ngọc rồng 3 sao, 38% 5-20 thỏi vàng (457)
    public static void dropHuyDiet(Boss boss, Player plKill) {
        int rd = Util.nextInt(100);
        ItemMap it;
        if (rd < 2) {
            it = ItemService.gI().randDoTLBoss(boss.zone, 1, boss.location.x, y(boss), plKill.id);
        } else if (rd < 32) {
            it = createHuyDiet(boss, plKill, Util.nextInt(3));
        } else if (rd < 52) {
            it = new ItemMap(boss.zone, 15, 1, boss.location.x, y(boss), plKill.id);
        } else if (rd < 62) {
            it = new ItemMap(boss.zone, 16, 1, boss.location.x, y(boss), plKill.id);
        } else {
            it = new ItemMap(boss.zone, THOI_VANG, Util.nextInt(5, 20), boss.location.x, y(boss), plKill.id); // 5-20 thỏi vàng (trước 1)
        }
        Service.gI().dropItemMap(boss.zone, it);
    }

    private static int y(Boss boss) {
        return boss.zone.map.yPhysicInTop(boss.location.x, boss.location.y - 24);
    }

    // 650-662: áo 650+2g, quần 651+2g, găng 657+2g, giày 658+2g, nhẫn 656 (g = hành tinh 0-2)
    private static ItemMap createHuyDiet(Boss boss, Player plKill, int g) {
        int[] ids = {650 + 2 * g, 651 + 2 * g, 657 + 2 * g, 658 + 2 * g, 656};
        int tempId = ids[Util.nextInt(0, ids.length - 1)];
        ItemMap it = new ItemMap(boss.zone, tempId, 1, boss.location.x, y(boss), plKill.id);
        int tiLe = randTiLe();
        List<ItemOption> options = new ArrayList<>();
        for (ItemOption io : ItemService.gI().getListOptionItemShop((short) tempId)) {
            int id = io.optionTemplate.id;
            if (id == 164) {
                continue;
            }
            int param = io.param;
            if (tiLe > 0 && InventoryService.gI().optionCanUpgrade(id)) {
                param += param * tiLe / 100;
            }
            options.add(new ItemOption(id, param));
        }
        options.add(new ItemOption(21, 70)); // yêu cầu 70 tỷ sức mạnh
        options.add(new ItemOption(30, 0)); // không giao dịch
        it.options = options;
        return it;
    }

    // Cùng bảng với ShopService.buyItemHD: 1% +15%, 14% +11-14%, 20% +7-10%, 25% +4-6%, 40% +0-3%
    private static int randTiLe() {
        int random = Util.nextInt(1, 100);
        if (random <= 1) {
            return 15;
        } else if (random <= 15) {
            return Util.nextInt(11, 14);
        } else if (random <= 35) {
            return Util.nextInt(7, 10);
        } else if (random <= 60) {
            return Util.nextInt(4, 6);
        }
        return Util.nextInt(0, 3);
    }
}
