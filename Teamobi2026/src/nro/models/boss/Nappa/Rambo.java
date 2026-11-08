package nro.models.boss.Nappa;


import nro.models.boss.Boss;
import nro.models.boss.BossID;
import nro.models.consts.BossStatus;
import nro.models.boss.BossesData;
import java.util.Random;
import nro.models.map.ItemMap;
import nro.models.player.Player;
import nro.models.services.Service;
import nro.models.services.TaskService;
import nro.models.utils.Util;

public class Rambo extends Boss {

    private long st;

    public Rambo() throws Exception {
        super(BossID.RAMBO, true, true, BossesData.RAMBO);
    }

    @Override
    public void joinMap() {
        super.joinMap();
        st = System.currentTimeMillis();
    }

    @Override
    public void reward(Player plKill) {
        int diem = 5;
        plKill.event.addEventPoint(diem);
        Service.gI().sendThongBao(plKill, "+5 Point");
        TaskService.gI().checkDoneTaskKillBoss(plKill, this);
        Service.gI().dropItemMap(this.zone, new ItemMap(this.zone, 190, Util.nextInt(20000, 30001),
          this.location.x, this.zone.map.yPhysicInTop(this.location.x, this.location.y - 24), plKill.id));
        if (Util.isTrue(90, 100)) {
            int r = Util.nextInt(1, 100);
            int ngoc = r <= 70 ? 18 : r <= 90 ? 19 : 20;
            Service.gI().dropItemMap(this.zone, new ItemMap(this.zone, ngoc, 1,
          this.location.x, this.zone.map.yPhysicInTop(this.location.x, this.location.y - 24), plKill.id));
        } else {
            Service.gI().dropItemMap(this.zone, new ItemMap(this.zone, 457, Util.nextInt(2, 5),
          this.location.x, this.zone.map.yPhysicInTop(this.location.x, this.location.y - 24), plKill.id));
        }
    }    
    @Override
    public void autoLeaveMap() {
        // Không tự rời map, chỉ biến mất khi bị giết
//        if (this.zone != null && this.zone.getNumOfPlayers() > 0) {
//            st = System.currentTimeMillis();
//        }
    }
}
