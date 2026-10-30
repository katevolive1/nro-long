package nro.models.services_dungeon;

import nro.models.map.phoban.RedRibbonHQ;
import nro.models.map.Zone;
import nro.models.player.Player;
import nro.models.services.Service;
import nro.models.map.service.ChangeMapService;
import java.util.ArrayList;
import java.util.List;
import nro.models.utils.Util;

/**
 *
 * @author By hnam
 * 
 */

public class RedRibbonHQService {

    private static RedRibbonHQService instance;

    public static RedRibbonHQService gI() {
        if (RedRibbonHQService.instance == null) {
            RedRibbonHQService.instance = new RedRibbonHQService();
        }
        return RedRibbonHQService.instance;
    }

    public List<RedRibbonHQ> doanhTrais;

    private RedRibbonHQService() {
        this.doanhTrais = new ArrayList<>();
        for (int i = 0; i < RedRibbonHQ.AVAILABLE; i++) {
            this.doanhTrais.add(new RedRibbonHQ(i));
        }
    }

    // Mỗi người 1 lượt doanh trại/ngày (lastTimeJoinDT, cột player.doanhtrai), kể cả đổi hoặc tạo bang mới.
    // Được vào lại trại đang mở của bang nếu đã vào chính trại đó (bị văng, chết...).
    public static boolean daVaoHomNay(Player pl) {
        if (pl.lastTimeJoinDT <= 0 || Util.isAfterMidnight(pl.lastTimeJoinDT)) {
            return false;
        }
        RedRibbonHQ dt = pl.clan != null ? pl.clan.doanhTrai : null;
        return dt == null || pl.lastTimeJoinDT < dt.getLastTimeOpen();
    }

    public void addMapDoanhTrai(int id, Zone zone) {
        this.doanhTrais.get(id).getZones().add(zone);
    }

    public void joinDoanhTrai(Player pl) {
        if (pl.clan == null) {
            Service.gI().sendThongBao(pl, "Không thể thực hiện");
            return;
        }
        if (pl.clan.haveGoneDoanhTrai && !Util.isAfterMidnight(pl.clan.lastTimeOpenDoanhTrai)) {
            Service.gI().sendThongBao(pl, "Vui lòng chờ đến ngày mai");
            return;
        }
        if (pl.clanMember.getNumDateFromJoinTimeToToday() < RedRibbonHQ.MIN_DAYS_IN_CLAN) {
            return;
        }
        if (daVaoHomNay(pl)) {
            Service.gI().sendThongBao(pl, "Hôm nay bạn đã tham gia doanh trại rồi, hẹn gặp bạn vào ngày mai");
            return;
        }
        if (pl.clan.doanhTrai != null) {
            pl.lastTimeJoinDT = System.currentTimeMillis();
            pl.clan.doanhTrai.updateHPDame();
            ChangeMapService.gI().changeMapInYard(pl, 53, -1, 60);
            return;
        }
        RedRibbonHQ doanhTrai = null;
        for (RedRibbonHQ dt : this.doanhTrais) {
            if (dt.getClan() == null) {
                doanhTrai = dt;
                break;
            }
        }
        if (doanhTrai == null) {
            Service.gI().sendThongBao(pl, "Doanh trại đã đầy, hãy quay lại vào lúc khác!");
            return;
        }
        doanhTrai.openDoanhTrai(pl);
    }
}
