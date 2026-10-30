package nro.models.npc_list;

import nro.models.map.service.ChangeMapService;
import nro.models.npc.Npc;
import nro.models.player.Player;
import nro.models.utils.Util;

/**
 *
 * @author By hnam
 *
 */
public class DuongTang extends Npc {
    //Đường tăng
    public DuongTang(int mapId, int status, int cx, int cy, int tempId, int avartar) {
        super(mapId, status, cx, cy, tempId, avartar);
    }

    public static void veLangAru(Player player) {
        ChangeMapService.gI().changeMapNonSpaceship(player, 0, Util.nextInt(750, 850), 432);
    }

    @Override
    public void openBaseMenu(Player player) {
        if (canOpenNpc(player)) {
            this.createOtherMenu(player, 0, "A di đà phật, thí chủ muốn rời Ngũ Hành Sơn?", "Về\nLàng Aru", "Từ chối");
        }
    }

    @Override
    public void confirmMenu(Player player, int select) {
        if (canOpenNpc(player) && select == 0) {
            veLangAru(player);
        }
    }
}
