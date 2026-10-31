#!/usr/bin/perl
# Quét code Java tìm chỗ tạo ra các item trong ids.tsv, kèm chỉ số gán ngay sau đó.
# Kết quả: code.tsv = id \t file \t dòng \t hàm \t kiểu \t chỉ số (id=param, cách nhau ;) \t ghi chú
use strict; use warnings; use utf8;
use File::Find;
binmode STDOUT, ':encoding(UTF-8)';
my ($dir, $src) = @ARGV;
my %want;
open my $fi, '<:encoding(UTF-8)', "$dir/ids.tsv" or die;
while (<$fi>) { chomp; s/\r$//; my @c = split /\t/; $want{$c[0]} = 1; }
close $fi;

# chỗ quét nhầm (mảng số không phải id item)
my %skip = map { $_ => 1 } ('nro/models/Bot/Bot.java', 'nro/models/npc/MagicTree.java');
my %skipLine = map { $_ => 1 } ('nro/models/services/RewardService.java:19', 'nro/models/services/RewardService.java:20',
    'nro/models/services/RewardService.java:21', 'nro/models/services/RewardService.java:22');

my @files;
find(sub { push @files, $File::Find::name if /\.java$/ }, $src);
open my $out, '>:encoding(UTF-8)', "$dir/code.tsv" or die;

sub rangeOf {
    my ($e) = @_;
    $e =~ s/\s+//g;
    return "$1–$2" if $e =~ /^(?:Util\.)?(?:nextInt|randomInRange)\((-?\d+),(-?\d+)\)$/;
    return "0–" . ($1 - 1) if $e =~ /^(?:Util\.)?nextInt\((\d+)\)$/;
    return "$2–" . ($2 + $1 - 1) if $e =~ /^newRandom\(\)\.nextInt\((\d+)\)\+(\d+)$/;
    return "$1 hoặc $2" if $e =~ /\?(-?\d+):(-?\d+)$/;
    return $e;
}

for my $f (sort @files) {
    (my $rel = $f) =~ s{^.*/src/}{};
    next if $skip{$rel};
    open my $h, '<:encoding(UTF-8)', $f or next;
    my @L = <$h>; close $h;
    s/\r?\n$// for @L;
    my $method = '';
    my @mstart;
    for (my $i = 0; $i < @L; $i++) {
        my $l = $L[$i];
        if ($l =~ /^\s*(?:public|private|protected|static)[^=;(]*?\b(\w+)\s*\([^;]*$/ && $l !~ /\bnew\b/) { $method = $1; }
        next if $l =~ /^\s*\/\//;
        next if $skipLine{"$rel:" . ($i + 1)};
        my @hits;   # [id, kiểu, có phải chọn ngẫu nhiên]
        while ($l =~ /(?:createNewItem|createItemSetKichHoat|createItemSKH)\(\s*(?:\(short\)\s*)?(\d+)/g) { push @hits, [$1, 'tạo item', 0]; }
        while ($l =~ /new ItemMap\([^,]+,\s*(?:\(short\)\s*)?(\d+)\s*,/g) { push @hits, [$1, 'rơi xuống map', 0]; }
        while ($l =~ /nextInt\(\s*(\d+)\s*,\s*(\d+)\s*\)/g) {
            my ($a, $b) = ($1, $2);
            if ($want{$a} && $want{$b} && $b > $a && $b - $a < 60) { push @hits, [$_, "ngẫu nhiên trong $a–$b", 1] for $a .. $b; }
        }
        while ($l =~ /\{([\d\s,]+)\}/g) {
            my @n = grep { length } map { s/\s//gr } split /,/, $1;
            my @w = grep { $want{$_} } @n;
            next unless @w;
            next if @n < 2 && $l !~ /item|Item|drop|reward|qua/i;
            push @hits, [$_, 'ngẫu nhiên trong mảng ' . scalar(@n) . ' món', 1] for @w;
        }
        # dòng chỉ có số (mảng viết trên nhiều dòng)
        if (!@hits) {
            (my $nums = $l) =~ s{//.*}{};
            if ($nums =~ /^\s*[\d\s,]+[\s,};]*$/ && $nums =~ /\d/) {
                $nums =~ s/[};]//g;
                my @n = grep { length } map { s/\s//gr } split /,/, $nums;
                push @hits, [$_, 'ngẫu nhiên trong mảng nhiều dòng', 1] for grep { $want{$_} } @n;
            }
        }
        next unless @hits;
        # điểm bắt đầu đọc chỉ số: dòng hiện tại, hoặc dòng tạo item gần nhất phía sau nếu id nằm trong mảng/dải
        my $start = $i;
        if (grep { $_->[2] } @hits) {
            for (my $j = $i + 1; $j < @L && $j <= $i + 10; $j++) {
                if ($L[$j] =~ /createNewItem|new ItemMap/) { $start = $j; last; }
            }
        }
        my (@opts, @notes);
        for (my $j = $start; $j < @L && $j <= $start + 30; $j++) {
            last if $j > $start && ($L[$j] =~ /createNewItem|new ItemMap|^\s*(?:public|private|protected)\s/);
            push @notes, 'cộng thêm chỉ số theo initChiSoItem' if $L[$j] =~ /initChiSoItem/;
            push @notes, 'chỉ số shop ×100–115%' if $L[$j] =~ /getListOptionItemShop/;
            while ($L[$j] =~ /ItemOption\(\s*(\d+)\s*,\s*(.*?)\)\s*\)\s*;/g) {
                my ($oid, $p) = ($1, $2);
                $p =~ s/^\s+|\s+$//g;
                if ($p =~ /^[A-Za-z_]\w*$/) {
                    for (my $k = $j; $k >= 0 && $k >= $j - 40; $k--) {
                        if ($L[$k] =~ /\b(?:int|long|short|byte|double)\s+\Q$p\E\s*=\s*(.+?);/) { $p = $1; last; }
                    }
                }
                push @opts, "$oid=" . rangeOf($p);
            }
            last if $L[$j] =~ /addItemBag\(|dropItemMap\(|return\s/ && @opts;
        }
        my %seen; my %sn;
        @notes = grep { !$sn{$_}++ } @notes;
        for my $hh (@hits) {
            my ($id, $kind) = @$hh;
            next unless $want{$id};
            next if $seen{"$id|$kind"}++;
            print $out join("\t", $id, $rel, $i + 1, $method, $kind, join(';', @opts), join(', ', @notes)), "\n";
        }
    }
}
close $out;
print "xong\n";
