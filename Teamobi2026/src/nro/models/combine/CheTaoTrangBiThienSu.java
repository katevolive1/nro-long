
package nro.models.combine;

import nro.models.item.Item;
import nro.models.item.Item.ItemOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.function.Predicate;
import nro.models.player.Player;
import nro.models.services.ItemService;
import nro.models.services.Service;
import nro.models.services.InventoryService;
import nro.models.utils.Util;

/**
 * Chế tạo trang bị thiên sứ (NPC Whis). Đặt đúng 4 món: 1 công thức (thường 1071-1073 hoặc VIP 1084-1086),
 * >= 999 mảnh thiên sứ cùng loại (1066-1070), 1 đá nâng cấp (1074-1078), 1 đá may mắn (1079-1083).
 * Bấm "Nâng cấp" ở khung -> showInfoCombine hiện xác nhận (menu CHE_TAO_TRANG_BI_THIEN_SU của Whis)
 * -> chọn "Nâng cấp" -> CheTaoTS chế tạo.
 *
 * @author By hnam
 */
public class CheTaoTrangBiThienSu {

    private static final int GOLD = 10_000_000;
    private static final int MANH = 999;
    // thứ tự theo Item.typeIdManh: áo, quần, găng, giày, nhẫn; hàng: Trái Đất, Namếc, Xayda
    private static final short[][] ITEM_IDS = {{1048, 1051, 1054, 1057, 1060}, {1049, 1052, 1055, 1058, 1061}, {1050, 1053, 1056, 1059, 1062}};

    private static boolean isCongThucVip(Item it) {
        return it.template.id >= 1084 && it.template.id <= 1086;
    }

    private static long count(Player player, Predicate<Item> p) {
        return player.combineNew.itemsCombine.stream().filter(it -> it != null && it.isNotNullItem() && p.test(it)).count();
    }

    private static Item find(Player player, Predicate<Item> p) {
        return player.combineNew.itemsCombine.stream().filter(it -> it != null && it.isNotNullItem() && p.test(it)).findFirst().orElse(null);
    }

    /**
     * Kiểm tra 4 món trong ô, trả câu báo lỗi hoặc null nếu đủ.
     */
    private static String checkItems(Player player) {
        if (player.combineNew.itemsCombine.size() > 4) {
            return "Chỉ đặt 4 món: 1 công thức (thường hoặc VIP), 999 mảnh thiên sứ, 1 đá nâng cấp, 1 đá may mắn";
        }
        long ct = count(player, Item::isCongThucVip); // Item.isCongThucVip nhận cả công thức thường và VIP
        if (ct == 0) {
            return "Thiếu Công thức hoặc Công thức VIP";
        }
        if (ct > 1) {
            return "Chỉ đặt 1 công thức (thường hoặc VIP)";
        }
        if (count(player, it -> it.isManhTS() && it.quantity >= MANH) != 1) {
            return "Cần " + MANH + " mảnh thiên sứ cùng loại";
        }
        if (count(player, Item::isDaNangCap1) != 1) {
            return "Thiếu Đá nâng cấp";
        }
        if (count(player, Item::isDaMayMan) != 1) {
            return "Thiếu Đá may mắn";
        }
        return null;
    }

    private static int getGender(Player player, Item ct) {
        return ct.template.gender > 2 ? player.gender : ct.template.gender;
    }

    public static void showInfoCombine(Player player) {
        String error = checkItems(player);
        if (error != null) {
            CombineService.gI().whis.createOtherMenu(player, nro.models.consts.ConstNpc.IGNORE_MENU, error, "Đóng");
            return;
        }
        Item ct = find(player, Item::isCongThucVip);
        Item mts = find(player, it -> it.isManhTS() && it.quantity >= MANH);
        short idTS = ITEM_IDS[getGender(player, ct)][mts.typeIdManh()];
        String npcSay = "Chế tạo " + ItemService.gI().getTemplate(idTS).name + "\n"
                + "Dùng " + ct.template.name + "\n"
                + "Thất bại vẫn mất nguyên liệu";
        if (player.inventory.gold < GOLD) {
            CombineService.gI().whis.createOtherMenu(player, nro.models.consts.ConstNpc.IGNORE_MENU,
                    npcSay + "\nCòn thiếu " + Util.numberToMoney(GOLD - player.inventory.gold) + " vàng", "Đóng");
            return;
        }
        CombineService.gI().whis.createOtherMenu(player, CombineService.CHE_TAO_TRANG_BI_THIEN_SU, npcSay,
                "Nâng cấp\n" + Util.numberToMoney(GOLD) + " vàng", "Từ chối");
    }

    public static void CheTaoTS(Player player) {
        String error = checkItems(player);
        if (error != null) {
            Service.gI().sendThongBao(player, error);
            return;
        }
        if (InventoryService.gI().getCountEmptyBag(player) < 1) {
            Service.gI().sendThongBao(player, "Bạn phải có ít nhất 1 ô trống hành trang");
            return;
        }
        if (player.inventory.gold < GOLD) {
            Service.gI().sendThongBao(player, "Không đủ vàng để thực hiện");
            return;
        }
        Item ct = find(player, Item::isCongThucVip);
        Item mts = find(player, it -> it.isManhTS() && it.quantity >= MANH);
        Item daNC = find(player, Item::isDaNangCap1);
        Item daMM = find(player, Item::isDaMayMan);

        player.inventory.gold -= GOLD;
        // Tỉ lệ thành công: công thức VIP 90%, thường 50% (sửa 31/10/2026), cộng cấp đá nâng cấp (1-5)
        int tiLe = (isCongThucVip(ct) ? 90 : 50) + (daNC.template.id - 1073);
        if (Util.nextInt(0, 99) < tiLe) {
            int gender = getGender(player, ct);
            Item itemTS = ItemService.gI().DoThienSu(ITEM_IDS[gender][mts.typeIdManh()], gender);
            // Thành công: mọi chỉ số x2 (kể cả sức đánh), trừ 20, 21 (yêu cầu sức mạnh), 30 (không giao dịch)
            for (ItemOption io : itemTS.itemOptions) {
                int id = io.optionTemplate.id;
                if (id != 20 && id != 21 && id != 30) {
                    io.param += io.param;
                }
            }
            // Đá may mắn cấp n: nextInt(0, 50) <= 5 + 5n thì thêm option 15 và 1-3 dòng phụ
            int tileLucky = 5 + 5 * (daMM.template.id - 1078);
            int roll = Util.nextInt(0, 50);
            if (roll <= tileLucky) {
                int soDong;
                if (roll >= tileLucky - 3) {
                    soDong = 3;
                } else if (roll >= tileLucky - 10) {
                    soDong = 2;
                } else {
                    soDong = 1;
                }
                itemTS.itemOptions.add(new ItemOption(15, soDong));
                ArrayList<Integer> listOptionBonus = new ArrayList<>(Arrays.asList(50, 77, 103, 94, 5));
                for (int j = 0; j < soDong; j++) {
                    int k = Util.nextInt(0, listOptionBonus.size() - 1);
                    itemTS.itemOptions.add(new ItemOption(listOptionBonus.get(k), Util.nextInt(1, 3)));
                    listOptionBonus.remove(k);
                }
            }
            InventoryService.gI().addItemBag(player, itemTS);
            CombineService.gI().sendEffectSuccessCombine(player);
        } else {
            CombineService.gI().sendEffectFailCombine(player);
        }
        InventoryService.gI().subQuantityItemsBag(player, ct, 1);
        InventoryService.gI().subQuantityItemsBag(player, daNC, 1);
        InventoryService.gI().subQuantityItemsBag(player, daMM, 1);
        InventoryService.gI().subQuantityItemsBag(player, mts, MANH);
        InventoryService.gI().sendItemBags(player);
        Service.gI().sendMoney(player);
        CombineService.gI().reOpenItemCombine(player);
    }
}
