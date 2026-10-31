package nro.models.boss.thien_su;

import nro.models.boss.Boss;
import nro.models.boss.BossData;
import nro.models.boss.BossID;
import nro.models.consts.ConstPlayer;
import nro.models.map.service.MapService;
import nro.models.player.Player;
import nro.models.skill.Skill;

// Boss Hủy diệt (Beerus / Champa) ở Trạm hủy diệt 186-188, dẫn cặp với Thiên sứ (Whis / Vados) đi kèm.
// HP 2 tỷ, không giới hạn sát thương mỗi đòn. Vào khu ngẫu nhiên (2 cặp có thể chung khu).
// Hồi sinh: chỉ đếm 10 phút khi cả 2 con trong cặp đã chết, rồi cả cặp xuất hiện lại.
public class HuyDiet extends Boss {

    public static final int DAME = 100_000;
    public static final long HP = 2_000_000_000L;
    public static final int REST_SECONDS = 600;

    static final int[][] SKILLS = {
        {Skill.DRAGON, 7, 1000}, {Skill.DEMON, 7, 1000}, {Skill.GALICK, 7, 1000},
        {Skill.KAMEJOKO, 7, 1000}, {Skill.MASENKO, 7, 1000}, {Skill.ANTOMIC, 7, 1000}};

    private final int mapId;

    public HuyDiet(int bossId, int mapId) throws Exception {
        super(bossId, false, false, data(bossId, mapId));
        this.mapId = mapId;
    }

    private static BossData data(int bossId, int mapId) {
        boolean beerus = bossId == BossID.HUY_DIET_BEERUS;
        return new BossData(
                beerus ? "Beerus" : "Champa", //name
                ConstPlayer.XAYDA, //gender
                beerus ? new short[]{1983, 1986, 1987, -1, -1, -1} : new short[]{511, 512, 513, -1, -1, -1}, //outfit {head, body, leg, bag, aura, eff}
                DAME, //dame
                new long[]{HP}, //hp
                new int[]{mapId}, //map join
                SKILLS, //skill
                new String[]{beerus ? "|-1|Ta là Thần Hủy Diệt Beerus" : "|-1|Ta là Thần Hủy Diệt Champa"}, //text chat 1
                new String[]{"|-1|Hủy diệt!", "|-1|Các ngươi chỉ có thế thôi sao?"}, //text chat 2
                new String[]{"|-1|Ta sẽ quay lại..."}, //text chat 3
                REST_SECONDS, //giây nghỉ trước khi hồi sinh
                new int[]{beerus ? BossID.THIEN_SU_WHIS : BossID.THIEN_SU_VADOS} //thiên sứ đi kèm
        );
    }

    private Boss getThienSu() {
        if (this.bossAppearTogether != null && this.bossAppearTogether[0] != null && this.bossAppearTogether[0].length > 0) {
            return this.bossAppearTogether[0][0];
        }
        return null;
    }

    @Override
    public void rest() {
        // Thiên sứ còn sống trong map thì chưa đếm thời gian hồi sinh
        Boss thienSu = getThienSu();
        if (thienSu != null && thienSu.zone != null && !thienSu.isDie()) {
            this.lastTimeRest = System.currentTimeMillis();
            return;
        }
        super.rest();
    }

    @Override
    public void joinMap() {
        this.zoneFinal = MapService.gI().getMapWithRandZone(this.mapId);
        super.joinMap();
    }

    @Override
    public void reward(Player plKill) {
        super.reward(plKill);
        ThienSuHuyDietReward.drop(this, plKill);
    }
}
