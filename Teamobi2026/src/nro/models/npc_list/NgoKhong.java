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
public class NgoKhong extends Npc {
    //Ngộ không
    public NgoKhong(int mapId, int status, int cx, int cy, int tempId, int avartar) {
        super(mapId, status, cx, cy, tempId, avartar);
    }

    @Override
    public void openBaseMenu(Player player) {
        if (canOpenNpc(player)) {
            if (mapId == 0) {
                this.createOtherMenu(player, 0, "Ngũ Hành Sơn có nhiều yêu quái, luyện tập ở đó mau lên sức mạnh lắm", "Đến\nNgũ Hành Sơn", "Từ chối");
            } else {
                this.createOtherMenu(player, 0, "Ngươi muốn về Làng Aru sao?", "Về\nLàng Aru", "Từ chối");
            }
        }
    }

    @Override
    public void confirmMenu(Player player, int select) {
        if (canOpenNpc(player) && select == 0) {
            if (mapId == 0) {
                ChangeMapService.gI().changeMapNonSpaceship(player, 122, Util.nextInt(900, 1000), 408);
            } else {
                DuongTang.veLangAru(player);
            }
        }
    }
}
