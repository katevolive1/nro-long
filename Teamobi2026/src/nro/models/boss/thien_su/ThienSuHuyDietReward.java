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

// Đồ rơi chung của boss Thiên sứ và Hủy diệt (mỗi con rơi riêng):
// 40% 1 món Hủy Diệt theo hành tinh người giết (như mua ở shop Bill: chỉ số gốc cộng 0-15%, 21:60, 30),
// 20% Ngọc rồng 2 hoặc 3 sao, 20% Cuồng nộ 2 / Bổ khí 2 / Bổ huyết 2 / Giáp Xên 2 (1-5 cái), 20% không rơi gì
public class ThienSuHuyDietReward {

    public static void drop(Boss boss, Player plKill) {
        int rd = Util.nextInt(1, 100);
        ItemMap it;
        if (rd <= 40) {
            it = createHuyDiet(boss, plKill);
        } else if (rd <= 60) {
            it = new ItemMap(boss.zone, Util.nextInt(15, 16), 1, boss.location.x, y(boss), plKill.id);
        } else if (rd <= 80) {
            it = new ItemMap(boss.zone, Util.nextInt(1150, 1153), Util.nextInt(1, 5), boss.location.x, y(boss), plKill.id);
        } else {
            return;
        }
        Service.gI().dropItemMap(boss.zone, it);
    }

    private static int y(Boss boss) {
        return boss.zone.map.yPhysicInTop(boss.location.x, boss.location.y - 24);
    }

    // 650-662: áo 650+2g, quần 651+2g, găng 657+2g, giày 658+2g, nhẫn 656 (g = hành tinh 0-2)
    private static ItemMap createHuyDiet(Boss boss, Player plKill) {
        int g = Math.max(0, Math.min(2, plKill.gender));
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
        options.add(new ItemOption(21, 60)); // yêu cầu 60 tỷ sức mạnh
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
