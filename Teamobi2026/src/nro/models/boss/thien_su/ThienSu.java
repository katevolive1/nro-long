package nro.models.boss.thien_su;

import nro.models.boss.Boss;
import nro.models.boss.BossData;
import nro.models.boss.BossID;
import nro.models.consts.AppearType;
import nro.models.consts.ConstPlayer;
import nro.models.player.Player;
import nro.models.services.PlayerService;
import nro.models.utils.Util;

// Boss Thiên sứ (Whis / Vados) đi kèm Hủy diệt cùng cặp (parentBoss), xuất hiện cùng khu.
// Mỗi 10 giây hồi cho Hủy diệt 10% HP tối đa nếu Hủy diệt còn sống và cùng khu; còn lại đánh như boss thường.
public class ThienSu extends Boss {

    private static final int HEAL_PERCENT = 10;
    private static final int HEAL_MS = 10_000;

    private long lastTimeHeal;

    public ThienSu(int bossId) throws Exception {
        super(bossId, false, false, data(bossId));
    }

    private static BossData data(int bossId) {
        boolean whis = bossId == BossID.THIEN_SU_WHIS;
        return new BossData(
                whis ? "Whis" : "Vados", //name
                ConstPlayer.XAYDA, //gender
                whis ? new short[]{505, 506, 507, -1, -1, -1} : new short[]{530, 531, 532, -1, -1, -1}, //outfit {head, body, leg, bag, aura, eff}
                HuyDiet.DAME, //dame
                new long[]{HuyDiet.HP}, //hp
                new int[]{186}, //map join (không dùng: đi theo Hủy diệt)
                HuyDiet.SKILLS, //skill
                new String[]{whis ? "|-1|Ngài Beerus, để tôi lo" : "|-1|Ngài Champa, để tôi lo"}, //text chat 1
                new String[]{"|-1|Ồ, thú vị đấy", "|-1|Hohoho"}, //text chat 2
                new String[]{"|-1|Hẹn gặp lại"}, //text chat 3
                0, //nghỉ (xuất hiện theo Hủy diệt)
                AppearType.APPEAR_WITH_ANOTHER
        );
    }

    @Override
    public void active() {
        super.active();
        healHuyDiet();
    }

    private void healHuyDiet() {
        Boss huyDiet = this.parentBoss;
        if (huyDiet == null || huyDiet.isDie() || huyDiet.zone == null || huyDiet.zone != this.zone) {
            return;
        }
        if (!Util.canDoWithTime(this.lastTimeHeal, HEAL_MS)) {
            return;
        }
        this.lastTimeHeal = System.currentTimeMillis();
        if (huyDiet.nPoint.hp < huyDiet.nPoint.hpMax) {
            PlayerService.gI().hoiPhuc(huyDiet, huyDiet.nPoint.hpMax * HEAL_PERCENT / 100, 0);
            this.chat("Hồi phục!");
        }
    }

    @Override
    public void reward(Player plKill) {
        super.reward(plKill);
        ThienSuHuyDietReward.drop(this, plKill);
    }
}
