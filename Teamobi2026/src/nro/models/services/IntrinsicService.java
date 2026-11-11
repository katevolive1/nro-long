package nro.models.services;

import nro.models.consts.ConstNpc;
import nro.models.intrinsic.Intrinsic;
import nro.models.player.Player;
import nro.models.server.Manager;
import nro.models.network.Message;
import nro.models.map.service.NpcService;
import nro.models.services.Service;
import nro.models.utils.Util;
import java.util.List;
import nro.models.item.Item;
import nro.models.server.Manager;

/**
 *
 * @author By hnam
 *
 */
public class IntrinsicService {

    private static IntrinsicService I;
    private static final int[] COST_OPEN = {10, 20, 40, 80, 160, 320, 640, 1280};

    // Vé đổi nội tại tự chọn: Rồng băng điều ước 2 cho vé, dùng vé chọn nội tại của hành tinh mình với chỉ số tối đa
    public static final short VE_DOI_NOI_TAI = 1730;
    private static final int VE_NOI_TAI_PAGE_SIZE = 6;

    // Danh sách nội tại chọn được: theo hành tinh, bỏ id 0, bỏ dòng trùng id (bảng intrinsic lặp mỗi id nhiều dòng)
    private List<Intrinsic> getIntrinsicsChoose(byte gender) {
        java.util.TreeMap<Integer, Intrinsic> map = new java.util.TreeMap<>();
        for (Intrinsic in : getIntrinsics(gender)) {
            if (in.id != 0) {
                map.putIfAbsent(in.id, in);
            }
        }
        return new java.util.ArrayList<>(map.values());
    }

    private Intrinsic createMaxIntrinsic(Intrinsic base) {
        Intrinsic in = new Intrinsic(base);
        in.param1 = in.paramTo1;
        in.param2 = in.paramTo2;
        return in;
    }

    private String getShortName(Intrinsic in) {
        String name = createMaxIntrinsic(in).getName();
        int index = name.indexOf(" [");
        return index != -1 ? name.substring(0, index) : name;
    }

    public void showMenuVeNoiTai(Player player, int page) {
        if (InventoryService.gI().findItemBag(player, VE_DOI_NOI_TAI) == null) {
            Service.gI().sendThongBao(player, "Bạn không có vé đổi nội tại");
            return;
        }
        if (player.nPoint.power < 10000000000L) {
            Service.gI().sendThongBao(player, "Yêu cầu sức mạnh tối thiểu 10 tỷ");
            return;
        }
        List<Intrinsic> list = getIntrinsicsChoose(player.gender);
        int pageCount = (list.size() + VE_NOI_TAI_PAGE_SIZE - 1) / VE_NOI_TAI_PAGE_SIZE;
        if (page < 0 || page >= pageCount) {
            page = 0;
        }
        int from = page * VE_NOI_TAI_PAGE_SIZE;
        int to = Math.min(from + VE_NOI_TAI_PAGE_SIZE, list.size());
        List<String> buttons = new java.util.ArrayList<>();
        StringBuilder say = new StringBuilder("Chọn nội tại muốn nhận (chỉ số tối đa)\nTrang " + (page + 1) + "/" + pageCount);
        for (int i = from; i < to; i++) {
            String name = getShortName(list.get(i));
            say.append("\n").append(i - from + 1).append(") ").append(name);
            buttons.add(String.valueOf(i - from + 1));
        }
        if (page < pageCount - 1) {
            buttons.add("Trang\nsau");
        }
        if (page > 0) {
            buttons.add("Trang\ntrước");
        }
        buttons.add("Đóng");
        NpcService.gI().createMenuConMeo(player, ConstNpc.VE_DOI_NOI_TAI, -1, say.toString(), buttons.toArray(new String[0]), page);
    }

    public void selectVeNoiTai(Player player, int page, int select) {
        List<Intrinsic> list = getIntrinsicsChoose(player.gender);
        int pageCount = (list.size() + VE_NOI_TAI_PAGE_SIZE - 1) / VE_NOI_TAI_PAGE_SIZE;
        if (page < 0 || page >= pageCount) {
            return;
        }
        int from = page * VE_NOI_TAI_PAGE_SIZE;
        int count = Math.min(from + VE_NOI_TAI_PAGE_SIZE, list.size()) - from;
        if (select < count) {
            Item ve = InventoryService.gI().findItemBag(player, VE_DOI_NOI_TAI);
            if (ve == null) {
                Service.gI().sendThongBao(player, "Bạn không có vé đổi nội tại");
                return;
            }
            if (player.nPoint.power < 10000000000L) {
                Service.gI().sendThongBao(player, "Yêu cầu sức mạnh tối thiểu 10 tỷ");
                return;
            }
            player.playerIntrinsic.intrinsic = createMaxIntrinsic(list.get(from + select));
            InventoryService.gI().subQuantityItemsBag(player, ve, 1);
            InventoryService.gI().sendItemBags(player);
            Service.gI().sendThongBao(player, "Bạn nhận được Nội tại:\n" + getShortName(list.get(from + select)));
            sendInfoIntrinsic(player);
            return;
        }
        int button = select - count;
        boolean hasNext = page < pageCount - 1;
        if (hasNext && button == 0) {
            showMenuVeNoiTai(player, page + 1);
        } else if (page > 0 && button == (hasNext ? 1 : 0)) {
            showMenuVeNoiTai(player, page - 1);
        }
    }

    public static IntrinsicService gI() {
        if (IntrinsicService.I == null) {
            IntrinsicService.I = new IntrinsicService();
        }
        return IntrinsicService.I;
    }

    public List<Intrinsic> getIntrinsics(byte playerGender) {
        switch (playerGender) {
            case 0:
                return Manager.INTRINSIC_TD;
            case 1:
                return Manager.INTRINSIC_NM;
            default:
                return Manager.INTRINSIC_XD;
        }
    }

    public Intrinsic getIntrinsicById(int id) {
        for (Intrinsic intrinsic : Manager.INTRINSICS) {
            if (intrinsic.id == id) {
                return new Intrinsic(intrinsic);
            }
        }
        return null;
    }

    public void sendInfoIntrinsic(Player player) {
        Message msg;
        try {
            msg = new Message(112);
            msg.writer().writeByte(0);
            msg.writer().writeShort(player.playerIntrinsic.intrinsic.icon);
            msg.writer().writeUTF(player.playerIntrinsic.intrinsic.getName());
            player.sendMessage(msg);
            msg.cleanup();
        } catch (Exception e) {
        }
    }

    public void showAllIntrinsic(Player player) {
        List<Intrinsic> listIntrinsic = getIntrinsics(player.gender);
        Message msg;
        try {
            msg = new Message(112);
            msg.writer().writeByte(1);
            msg.writer().writeByte(1); //count tab
            msg.writer().writeUTF("Nội tại");
            msg.writer().writeByte(listIntrinsic.size() - 1);
            for (int i = 1; i < listIntrinsic.size(); i++) {
                msg.writer().writeShort(listIntrinsic.get(i).icon);
                msg.writer().writeUTF(listIntrinsic.get(i).getDescription());
            }
            player.sendMessage(msg);
            msg.cleanup();
        } catch (Exception e) {
        }
    }

    public void showMenu(Player player) {
        NpcService.gI().createMenuConMeo(player, ConstNpc.INTRINSIC, -1,
                "Nội tại là một kỹ năng bị động hỗ trợ đặc biệt\nBạn có muốn mở hoặc thay đổi nội tại không?",
                "Xem\ntất cả\nNội Tại", "Mở\nNội Tại", "Mở VIP", "Từ chối");
    }

    public void showConfirmOpen(Player player) {
        NpcService.gI().createMenuConMeo(player, ConstNpc.CONFIRM_OPEN_INTRINSIC, -1, "Bạn muốn đổi Nội Tại khác\nvới giá là "
                + COST_OPEN[player.playerIntrinsic.countOpen] + " Tr vàng ?", "Mở\nNội Tại", "Từ chối");
    }

    public void showConfirmOpenVip(Player player) {
        NpcService.gI().createMenuConMeo(player, ConstNpc.CONFIRM_OPEN_INTRINSIC_VIP, -1,
                "Bạn có muốn mở Nội Tại\nvới giá là 100 ngọc và\ntái lập giá vàng quay lại ban đầu không?", "Mở\nNội VIP", "Từ chối");
    }

    private void changeIntrinsic(Player player) {
        List<Intrinsic> listIntrinsic = getIntrinsics(player.gender);
        player.playerIntrinsic.intrinsic = new Intrinsic(listIntrinsic.get(Util.nextInt(1, listIntrinsic.size() - 1)));
        player.playerIntrinsic.intrinsic.param1 = (short) Util.nextInt(player.playerIntrinsic.intrinsic.paramFrom1, player.playerIntrinsic.intrinsic.paramTo1);
        player.playerIntrinsic.intrinsic.param2 = (short) Util.nextInt(player.playerIntrinsic.intrinsic.paramFrom2, player.playerIntrinsic.intrinsic.paramTo2);
        String name = player.playerIntrinsic.intrinsic.getName();
        int index = name.indexOf(" [");

        if (index != -1) {
            Service.gI().sendThongBao(player, "Bạn nhận được Nội tại:\n" + name.substring(0, index));
        } else {
            Service.gI().sendThongBao(player, "Bạn nhận được Nội tại:\n" + name);
        }

        sendInfoIntrinsic(player);
    }

    public void doinoitai(Player player) {
        List<Intrinsic> listIntrinsic = getIntrinsics(player.gender);
        player.playerIntrinsic.intrinsic = new Intrinsic(listIntrinsic.get(Util.nextInt(1, listIntrinsic.size() - 1)));
        player.playerIntrinsic.intrinsic.param1 = (short) Util.nextInt(player.playerIntrinsic.intrinsic.paramFrom1, player.playerIntrinsic.intrinsic.paramTo1);
        player.playerIntrinsic.intrinsic.param2 = (short) Util.nextInt(player.playerIntrinsic.intrinsic.paramFrom2, player.playerIntrinsic.intrinsic.paramTo2);
        Service.gI().sendThongBao(player, "Bạn nhận được Nội tại:\n" + player.playerIntrinsic.intrinsic.getName().substring(0, player.playerIntrinsic.intrinsic.getName().indexOf(" [")));
        sendInfoIntrinsic(player);
    }

    public void open(Player player) {
        if (player.nPoint.power >= 10000000000L) {
            int goldRequire = COST_OPEN[player.playerIntrinsic.countOpen] * 1000000;
            if (player.inventory.gold >= goldRequire) {
                player.inventory.gold -= goldRequire;
                PlayerService.gI().sendInfoHpMpMoney(player);
                changeIntrinsic(player);
                if (player.playerIntrinsic.countOpen < COST_OPEN.length - 1) {
                    player.playerIntrinsic.countOpen++;
                }
            } else {
                Service.gI().sendThongBao(player, "Bạn không đủ vàng, còn thiếu "
                        + Util.numberToMoney(goldRequire - player.inventory.gold) + " vàng nữa");
            }
        } else {
            Service.gI().sendThongBao(player, "Yêu cầu sức mạnh tối thiểu 10 tỷ");
        }
    }

    public void openVip(Player player) {
        if (player.nPoint.power >= 10000000000L) {
            int gemRequire = 100;
            if (player.inventory.gem >= 100) {
                player.inventory.gem -= gemRequire;
                PlayerService.gI().sendInfoHpMpMoney(player);
                changeIntrinsic(player);
                player.playerIntrinsic.countOpen = 0;
            } else {
                Service.gI().sendThongBao(player, "Bạn không có đủ ngọc, còn thiếu "
                        + (gemRequire - player.inventory.gem) + " ngọc nữa");
            }
        } else {
            Service.gI().sendThongBao(player, "Yêu cầu sức mạnh tối thiểu 10 tỷ");
        }
    }

}
