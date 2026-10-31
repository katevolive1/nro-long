package nro.models.combine;

import java.util.ArrayList;
import java.util.List;
import nro.models.consts.ConstNpc;
import nro.models.item.Item;
import nro.models.item.Item.ItemOption;
import nro.models.player.Player;
import nro.models.services.InventoryService;
import nro.models.services.ItemService;
import nro.models.services.Service;
import nro.models.utils.Util;

/**
 * Bà Hạt Mít (map 5 Đảo Kame) có 2 chức năng đổi đồ:
 * 1. Thần Linh -> Hủy Diệt: đặt 1 món Thần Linh (555-567) + 10 thỏi vàng trong hành trang ->
 *    món Hủy Diệt cùng loại, cùng hành tinh (id + 95). Chỉ số gốc như bán ở Bill (item_shop), mỗi chỉ số
 *    nâng được (InventoryService.optionCanUpgrade) cộng thêm ngẫu nhiên 5-15% (cùng một mức cho cả món),
 *    thêm 21:60 (yêu cầu 60 tỷ sức mạnh) và 30 (không giao dịch) giống ShopService.buyItemHD.
 * 2. Hủy Diệt -> Kích hoạt: đặt 3 món Hủy Diệt (650-662) + 20 thỏi vàng trong hành trang ->
 *    1 món kích hoạt ngẫu nhiên như capsule kích hoạt (ItemService.randomItemSKH), loại và hành tinh
 *    theo món đặt đầu tiên (rada/nhẫn thì theo hành tinh người chơi). Cả hai đều thành công 100%.
 */
public class DoiDoBaHatMit {

    private static final int THOI_VANG = 457;
    private static final int THOI_VANG_HUY_DIET = 10;
    private static final int THOI_VANG_KICH_HOAT = 20;
    private static final int SO_MON_HUY_DIET = 3;
    private static final int CONG_ID_HUY_DIET = 95;
    private static final int TI_LE_MIN = 5;
    private static final int TI_LE_MAX = 15;

    private static List<Item> getItems(Player player) {
        List<Item> items = new ArrayList<>();
        for (Item it : player.combineNew.itemsCombine) {
            if (it != null && it.isNotNullItem() && !items.contains(it)) {
                items.add(it);
            }
        }
        return items;
    }

    private static int countThoiVang(Player player) {
        int count = 0;
        for (Item it : player.inventory.itemsBag) {
            if (it.isNotNullItem() && it.template.id == THOI_VANG) {
                count += it.quantity;
            }
        }
        return count;
    }

    private static void subThoiVang(Player player, int quantity) {
        for (Item it : new ArrayList<>(player.inventory.itemsBag)) {
            if (quantity <= 0) {
                break;
            }
            if (it.isNotNullItem() && it.template.id == THOI_VANG) {
                int sub = Math.min(it.quantity, quantity);
                InventoryService.gI().subQuantityItemsBag(player, it, sub);
                quantity -= sub;
            }
        }
    }

    private static void showError(Player player, String text) {
        CombineService.gI().baHatMit.createOtherMenu(player, ConstNpc.IGNORE_MENU, text, "Đóng");
    }

    /**
     * Trả câu báo lỗi hoặc null nếu đặt đúng 1 món Thần Linh.
     */
    private static String checkThanLinh(Player player) {
        List<Item> items = getItems(player);
        if (items.isEmpty()) {
            return "Hãy đặt 1 món đồ Thần Linh";
        }
        if (items.size() > 1) {
            return "Chỉ đặt 1 món đồ Thần Linh";
        }
        if (!items.get(0).isThanLinh()) {
            return "Chỉ đổi được đồ Thần Linh";
        }
        return null;
    }

    public static void showInfoThanLinh(Player player) {
        String error = checkThanLinh(player);
        if (error != null) {
            showError(player, error);
            return;
        }
        Item than = getItems(player).get(0);
        String name = ItemService.gI().getTemplate(than.template.id + CONG_ID_HUY_DIET).name;
        String npcSay = "|2|Đổi " + than.template.name + " thành " + name + "\n"
                + "|2|Cùng loại, chỉ số ngẫu nhiên\n"
                + "|2|Cần: " + THOI_VANG_HUY_DIET + " thỏi vàng\n";
        int have = countThoiVang(player);
        if (have < THOI_VANG_HUY_DIET) {
            showError(player, npcSay + "|7|Còn thiếu " + (THOI_VANG_HUY_DIET - have) + " thỏi vàng");
            return;
        }
        CombineService.gI().baHatMit.createOtherMenu(player, ConstNpc.MENU_START_COMBINE, npcSay,
                "Đổi\n" + THOI_VANG_HUY_DIET + " thỏi vàng", "Từ chối");
    }

    public static void doiThanLinh(Player player) {
        String error = checkThanLinh(player);
        if (error != null) {
            Service.gI().sendThongBao(player, error);
            return;
        }
        if (countThoiVang(player) < THOI_VANG_HUY_DIET) {
            Service.gI().sendThongBao(player, "Không đủ thỏi vàng");
            return;
        }
        Item than = getItems(player).get(0);
        short idHuyDiet = (short) (than.template.id + CONG_ID_HUY_DIET);
        List<ItemOption> base = ItemService.gI().getListOptionItemShop(idHuyDiet);
        if (base.isEmpty()) {
            Service.gI().sendThongBao(player, "Không thể thực hiện");
            return;
        }

        int tiLe = Util.nextInt(TI_LE_MIN, TI_LE_MAX);
        Item huyDiet = ItemService.gI().createNewItem(idHuyDiet);
        for (ItemOption io : base) {
            int id = io.optionTemplate.id;
            if (id == 164) {
                continue;
            }
            int param = io.param;
            if (InventoryService.gI().optionCanUpgrade(id)) {
                param += Math.max(1, param * tiLe / 100);
            }
            huyDiet.itemOptions.add(new ItemOption(id, param));
        }
        huyDiet.itemOptions.add(new ItemOption(21, 60)); // yêu cầu 60 tỷ sức mạnh
        huyDiet.itemOptions.add(new ItemOption(30, 0)); // không giao dịch

        subThoiVang(player, THOI_VANG_HUY_DIET);
        InventoryService.gI().subQuantityItemsBag(player, than, 1);
        InventoryService.gI().addItemBag(player, huyDiet);
        InventoryService.gI().sendItemBags(player);
        Service.gI().sendThongBao(player, "Bạn nhận được " + huyDiet.template.name);
        CombineService.gI().sendEffectSuccessCombine(player);
        player.combineNew.clearItemCombine();
        CombineService.gI().reOpenItemCombine(player);
    }

    /**
     * Trả câu báo lỗi hoặc null nếu đặt đúng 3 món Hủy Diệt.
     */
    private static String checkHuyDiet(Player player) {
        List<Item> items = getItems(player);
        if (items.size() != SO_MON_HUY_DIET) {
            return "Hãy đặt đúng " + SO_MON_HUY_DIET + " món đồ Hủy Diệt";
        }
        for (Item it : items) {
            if (!it.isHuyDiet()) {
                return "Chỉ đổi được đồ Hủy Diệt";
            }
        }
        return null;
    }

    public static void showInfoHuyDiet(Player player) {
        String error = checkHuyDiet(player);
        if (error != null) {
            showError(player, error);
            return;
        }
        Item dau = getItems(player).get(0);
        String npcSay = "|2|Đổi " + SO_MON_HUY_DIET + " món Hủy Diệt thành 1 món kích hoạt ngẫu nhiên\n"
                + "|2|Loại đồ theo món đặt đầu tiên (" + dau.template.name + ")\n"
                + "|2|Cần: " + THOI_VANG_KICH_HOAT + " thỏi vàng\n";
        int have = countThoiVang(player);
        if (have < THOI_VANG_KICH_HOAT) {
            showError(player, npcSay + "|7|Còn thiếu " + (THOI_VANG_KICH_HOAT - have) + " thỏi vàng");
            return;
        }
        CombineService.gI().baHatMit.createOtherMenu(player, ConstNpc.MENU_START_COMBINE, npcSay,
                "Đổi\n" + THOI_VANG_KICH_HOAT + " thỏi vàng", "Từ chối");
    }

    public static void doiHuyDiet(Player player) {
        String error = checkHuyDiet(player);
        if (error != null) {
            Service.gI().sendThongBao(player, error);
            return;
        }
        if (countThoiVang(player) < THOI_VANG_KICH_HOAT) {
            Service.gI().sendThongBao(player, "Không đủ thỏi vàng");
            return;
        }
        List<Item> items = getItems(player);
        Item dau = items.get(0);
        // loại đồ theo món đầu tiên: type 0 áo, 1 quần, 2 găng, 3 giày, 4 nhẫn (rada); nhẫn gender 3 thì theo người chơi
        int select = dau.template.type;
        int gender = dau.template.gender <= 2 ? dau.template.gender : player.gender;
        Item kichHoat = ItemService.gI().randomItemSKH(gender, select);
        if (kichHoat == null) {
            Service.gI().sendThongBao(player, "Không thể thực hiện");
            return;
        }

        subThoiVang(player, THOI_VANG_KICH_HOAT);
        for (Item it : items) {
            InventoryService.gI().subQuantityItemsBag(player, it, 1);
        }
        InventoryService.gI().addItemBag(player, kichHoat);
        InventoryService.gI().sendItemBags(player);
        Service.gI().sendThongBao(player, "Bạn nhận được " + kichHoat.template.name);
        CombineService.gI().sendEffectSuccessCombine(player);
        player.combineNew.clearItemCombine();
        CombineService.gI().reOpenItemCombine(player);
    }
}
