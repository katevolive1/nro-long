package nro.models.services.shenron;

import models.ShenronEvent;
import nro.models.consts.ConstNpc;
import nro.models.item.Item;
import nro.models.managers.ShenronEventManager;
import nro.models.map.service.NpcService;
import nro.models.player.Player;
import nro.models.services.InventoryService;
import nro.models.services.ItemService;
import nro.models.services.Service;
import nro.models.utils.Util;

/**
 * Gọi rồng bằng đủ 7 viên Bí ngô (702 = 1 sao … 708 = 7 sao), điều ước ở models.ShenronEvent.
 */
public class Shenron_BiNgo {

    public static final short BI_NGO_1_SAO = 702;
    public static final short BI_NGO_7_SAO = 708;

    public static void openMenuSummonShenron(Player pl) {
        NpcService.gI().createMenuConMeo(pl, ConstNpc.SUMMON_SHENRON_BI_NGO, -1,
                "Bạn có muốn gọi Rồng thần bằng 7 viên Bí ngô không ?", "Đồng ý", "Từ chối");
    }

    public static void summonShenron(Player player) {
        int mapId = player.zone.map.mapId;
        if (mapId == 0 || mapId == 7 || mapId == 14 || mapId == 21 || mapId == 22 || mapId == 23) {
            Service.gI().sendThongBao(player, "Không thể gọi rồng ở đây");
            return;
        }
        if (!checkBall(player)) {
            return;
        }
        if (player.isShenronAppear || player.shenronEvent != null || player.shenronBiNgo != null) {
            Service.gI().sendThongBao(player, "Không thể thực hiện");
            return;
        }
        if (!Util.canDoWithTime(player.lastTimeShenronAppeared, ShenronEvent.timeResummonShenron)) {
            int timeLeft = (int) ((ShenronEvent.timeResummonShenron - (System.currentTimeMillis() - player.lastTimeShenronAppeared)) / 1000);
            Service.gI().sendThongBao(player, "Vui lòng đợi " + (timeLeft < 7200 ? timeLeft + " giây" : timeLeft / 60 + " phút") + " nữa");
            return;
        }
        for (int i = BI_NGO_1_SAO; i <= BI_NGO_7_SAO; i++) {
            InventoryService.gI().subQuantityItemsBag(player, InventoryService.gI().findItemBag(player, i), 1);
        }
        InventoryService.gI().sendItemBags(player);
        player.idMark.setShenronType(0);
        ShenronEvent shenron = new ShenronEvent();
        shenron.setPlayer(player);
        shenron.setZone(player.zone);
        player.shenronBiNgo = shenron;
        ShenronEventManager.gI().add(shenron);
        shenron.activeShenron(true, ShenronEvent.DRAGON_EVENT);
        shenron.sendWhishesShenron();
    }

    private static boolean checkBall(Player pl) {
        for (int i = BI_NGO_1_SAO; i <= BI_NGO_7_SAO; i++) {
            if (!InventoryService.gI().isExistItemBag(pl, i)) {
                Item it = ItemService.gI().createNewItem((short) i);
                Service.gI().sendThongBao(pl, "Bạn còn thiếu 1 viên " + it.template.name);
                return false;
            }
        }
        return true;
    }
}
