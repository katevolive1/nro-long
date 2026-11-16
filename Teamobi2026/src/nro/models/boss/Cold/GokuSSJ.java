package nro.models.boss.Cold;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import nro.models.boss.Boss;
import nro.models.boss.BossData;
import nro.models.boss.BossID;
import nro.models.boss.BossesData;
import nro.models.item.Item;
import nro.models.map.ItemMap;
import nro.models.map.Zone;
import nro.models.map.service.MapService;
import nro.models.player.Player;
import nro.models.services.ItemService;
import nro.models.services.RewardService;
import nro.models.services.Service;
import nro.models.utils.Util;

// Goku SSJ 1/2/3 ở map Cold 105-110 (KE-HOACH-BOSS-GOKU-SSJ.md): mỗi con 1 mạng, HP 3 tỷ, dame 250k,
// 3 con luôn ở 3 map khác nhau (khu có thể trùng), chết 30 phút hồi sinh.
// Rơi đúng 1 món cho người giết, bảng tỉ lệ ở BOSS-ROI-DO.md
public class GokuSSJ extends Boss {

    private static final int[] MAP_COLD = {105, 106, 107, 108, 109, 110};
    private static final List<GokuSSJ> ALL = new CopyOnWriteArrayList<>();

    private final int caiTrangId;

    public GokuSSJ(int bossId) throws Exception {
        super(bossId, dataOf(bossId));
        this.caiTrangId = bossId == BossID.GOKU_SSJ2 ? 1595 : bossId == BossID.GOKU_SSJ3 ? 1587 : 1589;
        ALL.add(this);
    }

    private static BossData dataOf(int bossId) {
        if (bossId == BossID.GOKU_SSJ2) {
            return BossesData.GOKU_SSJ2;
        }
        if (bossId == BossID.GOKU_SSJ3) {
            return BossesData.GOKU_SSJ3;
        }
        return BossesData.GOKU_SSJ;
    }

    // Chọn map Cold chưa có con Goku SSJ khác còn sống
    @Override
    public Zone getMapJoin() {
        List<Integer> maps = new ArrayList<>();
        for (int mapId : MAP_COLD) {
            boolean used = false;
            for (GokuSSJ other : ALL) {
                Zone z = other.zone;
                if (other != this && z != null && !other.isDie() && z.map.mapId == mapId) {
                    used = true;
                    break;
                }
            }
            if (!used) {
                maps.add(mapId);
            }
        }
        int mapId = maps.isEmpty()
                ? MAP_COLD[Util.nextInt(0, MAP_COLD.length - 1)]
                : maps.get(Util.nextInt(0, maps.size() - 1));
        return MapService.gI().getMapWithRandZone(mapId);
    }

    @Override
    public void reward(Player plKill) {
        super.reward(plKill);
        int x = this.location.x;
        int y = this.zone.map.yPhysicInTop(x, this.location.y - 24);
        int r = Util.nextInt(1, 100);
        if (r <= 2) { // 2% đồ Thần Linh
            ItemMap it = ItemService.gI().randDoTLBoss(this.zone, 1, x, y, plKill.id);
            if (it != null) {
                Service.gI().dropItemMap(this.zone, it);
            }
        } else if (r <= 27) { // 25% Hộp quà giáng sinh
            drop(648, 1, x, y, plKill);
        } else if (r <= 47) { // 20% Ngọc rồng 2 sao
            drop(15, 1, x, y, plKill);
        } else if (r <= 57) { // 10% Ngọc rồng 3 sao
            drop(16, 1, x, y, plKill);
        } else if (r <= 85) { // 28% 2-10 Thỏi vàng
            drop(457, Util.nextInt(2, 10), x, y, plKill);
        } else { // 15% cải trang cùng tên boss
            Item ct = RewardService.gI().createCaiTrangGokuSSJ(caiTrangId);
            ItemMap im = new ItemMap(this.zone, caiTrangId, 1, x, y, plKill.id);
            im.options.addAll(ct.itemOptions);
            Service.gI().dropItemMap(this.zone, im);
        }
    }

    private void drop(int itemId, int quantity, int x, int y, Player plKill) {
        Service.gI().dropItemMap(this.zone, new ItemMap(this.zone, itemId, quantity, x, y, plKill.id));
    }

    @Override
    public void autoLeaveMap() {
        // Không tự rời map, chỉ biến mất khi bị giết
    }
}
