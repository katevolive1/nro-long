#!/usr/bin/perl
# Dựng bảng xuất xứ + chỉ số cho 3 nhóm item từ ids.tsv, opt.tsv, shop.tsv, gift.tsv, code.tsv
use strict; use warnings; use utf8;
binmode STDOUT, ':encoding(UTF-8)';
my ($dir) = @ARGV;
sub rd { my ($f) = @_; open my $h, '<:encoding(UTF-8)', "$dir/$f" or die $f; my @r; while (<$h>) { chomp; s/\r$//; push @r, [split /\t/, $_, -1]; } close $h; return @r; }

my %optName = map { $_->[0] => $_->[1] } rd('opt.tsv');
sub optText {
    my ($s) = @_;
    my @out;
    for my $tok (split /;/, $s) {
        next unless length $tok;
        my ($id, $p) = split /=/, $tok, 2;
        my $n = $optName{$id} // "option $id";
        $p = '' unless defined $p;
        if ($n =~ /#/) { $n =~ s/#/$p/; } elsif ($id == 30 || $id == 231 || $id == 73) { } else { $n .= " ($p)" if $p ne '' && $p ne '0' && $p ne '1'; }
        $n =~ s/^\$\(?|\)$//g if $n =~ /^\$/;
        push @out, $n;
    }
    return @out ? join('; ', @out) : 'không có chỉ số';
}

my %label = (
    'nro/models/map/Map.java|initItem' => 'Rơi sẵn trên map (đồ nhiệm vụ)',
    'nro/models/npc_list/ToriBot.java|VIP1' => 'Tori Bot: mua gói VIP 1',
    'nro/models/npc_list/ToriBot.java|VIP2' => 'Tori Bot: mua gói VIP 2',
    'nro/models/npc_list/ToriBot.java|VIP3' => 'Tori Bot: mua gói VIP 3',
    'nro/models/npc_list/ToriBot.java|VIP4' => 'Tori Bot: mua gói VIP 4',
    'nro/models/services/ItemService.java|vanBay2011' => 'Mở Hộp quà 5 sao (736)',
    'nro/models/services/ItemService.java|phuKien2011' => 'Mở Hộp quà 5 sao (736)',
    'nro/models/services/ItemService.java|vatphamsk' => 'KHÔNG RA ĐƯỢC (hàm OpenItem648 không ai gọi)',
    'nro/models/services/ItemService.java|vanBayChrimas' => 'KHÔNG RA ĐƯỢC (hàm OpenItem648 không ai gọi)',
    'nro/models/services/ItemService.java|phuKienChristmas' => 'KHÔNG RA ĐƯỢC (hàm OpenItem648 không ai gọi)',
    'nro/models/services/RewardService.java|getListItemLuckyRound' => 'Vòng quay may mắn',
    'nro/models/services/RewardService.java|rewardLancon' => 'Quy Lão Kame: quà sau khi hạ Lân con (sự kiện Tết)',
    'nro/models/services/RewardService.java|rewardCapsuleTet' => 'KHÔNG RA ĐƯỢC (hàm rewardCapsuleTet không ai gọi)',
    'nro/models/services/shenron/SummonDragonNamek.java|confirmWish' => 'Ước Rồng thần Namếc',
    'nro/models/services_func/UseItem.java|RadaNgocRong' => 'Dùng Rada ngọc rồng (1822)',
    'nro/models/services_func/UseItem.java|RadaNgocRongVip' => 'Dùng Rada ngọc rồng Vip (1823)',
    'nro/models/services_func/UseItem.java|OpenHopQuaThuong' => 'Mở Hộp quà sự kiện (1776)',
    'nro/models/services_func/UseItem.java|OpenTrungRongNhi' => 'Mở Trứng vàng rồng nhí (1821)',
    'nro/models/services_func/UseItem.java|ChuLunBox' => 'Mở Túi 7 chú lùn (1171)',
);

my %src;   # id -> [ [nguồn, chỉ số] ]
for my $r (rd('code.tsv')) {
    my ($id, $file, $line, $m, $kind, $opts, $note) = @$r;
    next if $kind =~ /nhiều dòng/;
    next if $file =~ /FlagBagService/;
    my $lb = $label{"$file|$m"} // "$file:$line ($m)";
    my $k = $kind eq 'tạo item' || $kind eq 'rơi xuống map' ? '' : " ($kind)";
    my $ct = optText($opts);
    $note = join(', ', grep { !/initChiSoItem/ } split /, /, $note);
    $ct .= "; $note" if $note;
    push @{$src{$id}}, ["$lb$k", $ct];
}
my %tien = (0 => 'vàng', 1 => 'ngọc', 3 => 'hồng ngọc', 4 => 'coupon');
for my $r (rd('shop.tsv')) {
    my ($id, $tag, $npc, $tab, $cost, $ts, $tshop, $payItem, $opts) = @$r;
    my $gia = $tshop == 3 ? "$cost $payItem" : "$cost " . ($tien{$ts} // "tiền loại $ts");
    $gia =~ s/(\d)(?=(\d{3})+(?!\d))/$1./g;
    push @{$src{$id}}, ["Shop $npc ($tag, tab $tab), giá $gia", optText($opts)];
}
for my $r (rd("shop_an.tsv")) {
    my ($id, $tag, $npc, $tab) = @$r;
    push @{$src{$id}}, [($tag eq 'DELETED' ? "KHÔNG RA ĐƯỢC: có trong item_shop nhưng tab $npc đã bị xóa" : "KHÔNG RA ĐƯỢC: có trong Shop $npc ($tag, tab $tab) nhưng đang ẩn (is_sell = 0)"), "–"];
}
for my $r (rd('gift.tsv')) {
    my ($code, $detail) = @$r;
    while ($detail =~ /\{"id":(\d+),"quantity":(\d+),"options":\[(.*?)\]\}/g) {
        my ($id, $q, $o) = ($1, $2, $3);
        my @op; while ($o =~ /"id":(\d+),"param":(-?\d+)/g) { push @op, "$1=$2"; }
        push @{$src{$id}}, ["Giftcode `$code` (x$q)", optText(join ';', @op)];
    }
}

my %hanh = (0 => 'Trái Đất', 1 => 'Namếc', 2 => 'Xayda', 3 => 'Chung');
my %title = (pet => '### Thú cưng (ô 8, loại 27, 69 món theo `Player.sendNewPet`)',
             back => '### Đồ đeo lưng (ô 9, loại 11, có hình, 173 món)',
             mount => '### Thú cưỡi (loại 23/24, 55 món)');
my (%rows, %cnt);
for my $r (rd('ids.tsv')) {
    my ($id, $name, $type, $g, $grp) = @$r;
    $name =~ s/\|/\//g;
    my $s = $src{$id} || [];
    $cnt{$grp}{tong}++;
    $cnt{$grp}{conguon}++ if grep { $_->[0] !~ /KHÔNG RA ĐƯỢC/ } @$s;
    my ($xx, $cs);
    if (@$s) {
        $xx = join('<br>', map { $_->[0] } @$s);
        $cs = join('<br>', map { $_->[1] } @$s);
    } else { $xx = 'không có (không tìm thấy nguồn trong code, shop, giftcode)'; $cs = '–'; }
    push @{$rows{$grp}}, "| $id | $name | $hanh{$g} | $xx | $cs |";
}
print "## Bảng xuất xứ và chỉ số (dò 1/11/2026)\n\n";
print "Nguồn đã quét: code server (mọi chỗ tạo item: `createNewItem`, `new ItemMap`, mảng id, dải `nextInt(a, b)`, kèm chỉ số gán ngay sau), shop (`item_shop`, từng shop riêng), giftcode (`giftcode`). Món có nhiều nguồn thì mỗi nguồn 1 dòng, cột Chỉ số cùng thứ tự với cột Xuất xứ. \"Ngẫu nhiên trong mảng N món\" = hộp/quà chọn ngẫu nhiên 1 trong N món, trong đó có món này. Khoảng \"a–b\" = ngẫu nhiên trong khoảng. Chưa quét: quà nhiệm vụ trong DB, client.\n\n";
printf "Tổng: thú cưng %d/%d món có nguồn, đồ đeo lưng %d/%d, thú cưỡi %d/%d.\n\n",
    $cnt{pet}{conguon} // 0, $cnt{pet}{tong}, $cnt{back}{conguon} // 0, $cnt{back}{tong}, $cnt{mount}{conguon} // 0, $cnt{mount}{tong};
for my $g (qw(pet back mount)) {
    print "$title{$g}\n\n| ID | Tên | Hành tinh | Xuất xứ | Chỉ số |\n|---|---|---|---|---|\n";
    print "$_\n" for @{$rows{$g}};
    print "\n";
}
