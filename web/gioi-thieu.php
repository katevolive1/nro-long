<?php
require_once __DIR__ . '/view/layout.php';

function guide_shots(array $names): void
{
    echo '<div class="shots" tabindex="0" role="group" aria-label="Ảnh trong game">';
    foreach ($names as $name) {
        echo '<img src="/images/screen/' . site_e($name) . '.png" alt="Ảnh trong game" loading="lazy">';
    }
    echo '</div>';
}

$sections = [
    's0' => 'Sơ lược',
    's1' => 'Nhân vật',
    's2' => 'Hệ thống nhà',
    's3' => 'Map và NPC',
    's4' => 'Chiêu thức',
    's5' => 'Nhiệm vụ',
    's6' => 'Vật phẩm',
    's7' => 'Vật phẩm bay',
    's8' => 'Đệ tử',
    's9' => 'Các võ đài',
    's10' => 'Lưỡng Long Nhất Thể',
    's11' => 'Trang bị Pha Lê',
    's12' => 'Phó bản hàng ngày',
    's13' => 'Boss',
];

site_head('Giới thiệu', 'intro', 'Giới thiệu các hệ thống trong ' . SITE_NAME . ': nhân vật, chiêu thức, đệ tử, võ đài, trang bị và boss.');
?>
<div class="wrap">
    <div class="page-head">
        <h1>Giới thiệu game</h1>
        <p>Toàn bộ hệ thống trong thế giới Ngọc Rồng.</p>
    </div>
    <div class="guide">
        <nav class="card guide-toc" aria-label="Mục lục">
            <h2>Mục lục</h2>
            <ol>
                <?php foreach ($sections as $id => $label): ?>
                    <li><a href="#<?= $id ?>"><?= site_e($label) ?></a></li>
                <?php endforeach; ?>
            </ol>
        </nav>
        <article class="card guide-body">
            <h2 id="s0">Sơ lược về <?= SITE_NAME ?></h2>
            <p><?= SITE_NAME ?> là game nhập vai trực tuyến với cốt truyện và nhân vật dựa trên bộ truyện tranh nổi tiếng Nhật Bản Dragon Ball đã từng làm say lòng bao nhiêu thế hệ độc giả Việt Nam. Bạn sẽ chọn theo hành tinh nào, Trái Đất, Namếc hay Xayda? Cuộc hành trình tìm kiếm ngọc rồng và chống kẻ hung ác sẽ bắt đầu nằm trong tay bạn.</p>
            <p>Cùng với sự hướng dẫn của các bậc tiền bối và sự nỗ lực của bản thân, bạn có thể đạt đến sức mạnh kinh hoàng, trở thành những chiến binh siêu hạng. Ngoài ra bạn sẽ không phải chiến đấu đơn độc khi xung quanh bạn là những chiến binh cùng chí hướng, cùng hỗ trợ lẫn nhau đối đầu với các thế lực hắc ám.</p>
            <p>Hiện game có bản cho máy tính Windows. Khi chơi trên PC bạn chỉ cần dùng chuột để điều khiển nhân vật.</p>

            <h2 id="s1">Nhân vật</h2>
            <p>Khi tham gia vào thế giới <?= SITE_NAME ?>, bạn có thể chọn 1 trong 3 hành tinh với hình dạng và những khả năng riêng biệt.</p>
            <ul>
                <li><strong>Trái Đất:</strong> những kỹ năng đặc biệt khó chịu, và rất mạnh khi đi theo nhóm. Đại diện Gohan, Krillin, Yamcha.</li>
                <li><strong>Namếc:</strong> khả năng tái tạo và hỗ trợ đồng đội đáng kinh ngạc, với đại diện Ốc tiêu, Pocollo và Kami.</li>
                <li><strong>Xayda:</strong> sức mạnh kinh hoàng khi chiến đấu đơn độc, với đại diện Cađic, Rađic và Kakalot.</li>
            </ul>

            <h2 id="s2">Hệ thống nhà</h2>
            <?php guide_shots(['2-10']); ?>
            <ul>
                <li>Nguồn hồi phục KI và HP của các chiến binh chính là đậu thần. Đậu thần có thể nâng cấp, mỗi lần nâng cấp tốn một lượng vàng nhất định. Đậu cấp càng cao thì khả năng hồi phục càng nhiều.</li>
                <li>Rương đồ dùng để chứa tài sản quý giá không tiện mang theo người.</li>
            </ul>

            <h2 id="s3">Hệ thống map và NPC đa dạng</h2>
            <p>Những NPC nổi tiếng và gắn liền với cốt truyện của Dragon Ball. Thông qua các NPC đặc biệt như Thượng Đế, Thần Mèo, Thần Vũ Trụ, bạn có khả năng tăng sức mạnh và tiềm năng của nhân vật.</p>
            <?php guide_shots(['2-1', '2-2', '2-3', '2-4', '2-5', '2-6', '2-7', '2-8']); ?>

            <h2 id="s4">Chiêu thức, chiến đấu và khả năng nhân vật</h2>
            <p>Mỗi hành tinh có những hệ thống chiêu thức khác nhau. Tùy vào sở thích và khả năng bản thân, bạn có thể nâng cấp chiêu thức cũng như tiềm năng để đạt sức mạnh cao nhất. Cân bằng hài hòa giữa chỉ số bản thân và chiêu thức có thể giúp bạn rất nhiều trong con đường trở thành chiến binh huyền thoại.</p>
            <h3>Xayda</h3>
            <p>Chiêu thức điển hình: Biến hình, Tự phát nổ.</p>
            <?php guide_shots(['4-1']); ?>
            <h3>Trái Đất</h3>
            <p>Chiêu thức điển hình: Quả cầu kênh khi, Kaioken, Trái dương hạ san, Kamejoko.</p>
            <?php guide_shots(['4-2']); ?>
            <h3>Namếc</h3>
            <p>Chiêu thức điển hình: Makankosappo, Đẻ trứng, Trị thương.</p>
            <?php guide_shots(['4-3']); ?>

            <h2 id="s5">Nhiệm vụ chính tuyến và nhiệm vụ thành tích</h2>
            <ul>
                <li>Nhiệm vụ chính tuyến tiêu diệt quái, đạt sức mạnh, hạ boss, đa dạng phong phú đi theo cốt truyện.</li>
                <li>Nhiệm vụ hàng ngày từ dễ đến khó, hoàn thành có thể nhận thêm sức mạnh, tiềm năng.</li>
                <li>Hoạt động thành tựu giúp kiếm ngọc hồng qua các hoạt động hàng ngày như đạt sức mạnh, đánh quái, online chăm chỉ.</li>
            </ul>
            <?php guide_shots(['5-1', '5-2', '5-3']); ?>

            <h2 id="s6">Vật phẩm</h2>
            <ul>
                <li>Kiếm vật phẩm trang bị bằng cách tích lũy vàng trong game, hoặc đánh quái, hạ Boss rớt ra.</li>
                <li>Mua sách kỹ năng để nâng cấp chiêu thức, cải trang để biến hóa hình dạng, tạo sự độc nhất cho nhân vật.</li>
            </ul>
            <?php guide_shots(['6-1', '6-2', '6-3']); ?>

            <h2 id="s7">Vật phẩm bay</h2>
            <p>Với thú cưỡi, bạn được phục hồi KI trong khi bay. Các vật phẩm bay đặc biệt có thêm chỉ số hỗ trợ tăng KI, HP. Hãy tìm mua vật phẩm yêu thích trong cửa hàng, hoặc kiếm tại vòng quay thượng đế khi sự kiện diễn ra.</p>
            <?php guide_shots(['7-1']); ?>

            <h2 id="s8">Đệ tử</h2>
            <ul>
                <li>Boss Broly ban đầu mới xuất hiện sẽ rất yếu. Khi đánh hắn, hắn sẽ mạnh dần lên đến khi biến hình thành siêu xayda tóc vàng (Super Broly) và dắt theo 1 đệ tử. Đánh thắng Super Broly bạn sẽ nhận được đệ tử ấy.</li>
                <li>Đệ tử Mabư: vào lúc 22h tối hàng ngày, tại Thành phố Vegeta, các nhân vật đi theo Tapion và tiêu diệt Boss Hirudegarn, hạ gục Boss sẽ có cơ hội nhận được Quả trứng.</li>
                <li>Quả trứng xuất hiện trong nhà và có thời gian nở. Có thể làm các nhiệm vụ khó, siêu khó tại bồ mộng để giảm thời gian nở trứng. Hết thời gian, mở trứng để nhận Đệ tử Mabư.</li>
            </ul>
            <?php guide_shots(['8-2', '8-3', '8-4']); ?>

            <h2 id="s9">Các võ đài</h2>
            <h3>Đại Hội Võ Thuật</h3>
            <p>Diễn ra mỗi giờ trong ngày tại vách núi Kakarot. Khi tham gia bạn phải đóng phí, thắng sẽ nhận lại tương đương phí cược. Hãy đến sớm hơn thời gian lên sàn đấu, nếu offline sẽ bị xử thua. Vô địch có thể nhận được đá nâng cấp.</p>
            <ul>
                <li>Giải Nhi Đồng: 8, 14, 18h</li>
                <li>Giải Siêu cấp 1: 9, 13, 19h</li>
                <li>Giải Siêu cấp 2: 10, 15, 20h</li>
                <li>Giải Siêu cấp 3: 11, 16, 21h</li>
                <li>Giải Siêu cấp 4: 12, 17, 22, 23h</li>
            </ul>
            <?php guide_shots(['9-1', '9-2']); ?>
            <h3>Võ đài bà Hạt Mít</h3>
            <ul>
                <li>Nhân vật dưới 150 triệu sức mạnh có thể tham gia Võ đài sinh tử tại Bà Hạt Mít ở Đảo Kame, lần đầu không tốn phí.</li>
                <li>Đối thủ: Dracula, Người vô hình, Bông băng, Vua quỷ, Thỏ đầu bạc. Thắng có thể nhận bùa 1h hoặc x1 vệ tinh bất kì.</li>
                <li>Khi trận đấu diễn ra, khán giả có cơ hội bình chọn cho bên mình thấy có khả năng chiến thắng.</li>
            </ul>
            <?php guide_shots(['9-3']); ?>
            <h3>Võ đài lần thứ 23</h3>
            <ul>
                <li>Đánh bại các Boss theo thứ tự: Sói héc quyn, Ở dơ, Xinbato, Tàu pảy pảy để nhận rương gỗ tương đương cấp độ Boss.</li>
                <li>Ví dụ đánh thắng Sói héc quyn, bạn sẽ nhận được Rương gỗ cấp 1.</li>
            </ul>
            <?php guide_shots(['9-4']); ?>
            <h3>Giải siêu hạng</h3>
            <ul>
                <li>Nơi chứng minh sức mạnh với những đối thủ mạnh không kém.</li>
                <li>Mỗi ngày từ 19h-23h, đạt top 100 sẽ được trao phần thưởng hồng ngọc theo từng top.</li>
            </ul>
            <?php guide_shots(['9-5']); ?>
            <h3>Võ đài liên server</h3>
            <ul>
                <li>Diễn ra 12h trưa và 20h tối hàng ngày (trận đấu 48 phút), các server chiến đấu giành sống sót cuối cùng.</li>
                <li>Mỗi thành viên sống sót có thể mang về phần thưởng cá nhân và cho vũ trụ của mình.</li>
            </ul>

            <h2 id="s10">Chiêu thức Lưỡng Long Nhất Thể</h2>
            <?php guide_shots(['10-1']); ?>
            <ul>
                <li><strong>Lưỡng long nhất thể:</strong> giữ trạng thái biến hình 10 phút, sau khi tách ra phải chờ 10 phút mới dùng lại được (Trái Đất và Xayda).</li>
                <li><strong>Bông tai Porata:</strong> có bán tại NPC Urôn, hợp thể bất cứ lúc nào và tách ra khi dùng lại bông tai, dùng vĩnh viễn (Trái Đất và Xayda).</li>
                <li><strong>Hợp thể của người Namek</strong> (Namek).</li>
                <li><strong>Hợp thể vĩnh viễn của người Namek:</strong> đệ tử mãi mãi mất đi, toàn bộ sức mạnh của đệ tử biến thành tiềm năng của sư phụ (Namek).</li>
            </ul>

            <h2 id="s11">Trang bị Pha Lê</h2>
            <h3>Nâng cấp</h3>
            <p>Tìm các viên đá nâng cấp từ đánh quái, thắng đại hội võ thuật. Có 5 loại đá: Đá lục bảo (rada), Đá Saphia (giày), Đá Ruby (quần), Đá Titan (áo), Đá thạch anh tím (găng tay). Đá bảo vệ giúp tránh bị rớt cấp.</p>
            <?php guide_shots(['11-2']); ?>
            <h3>Pha lê hóa trang bị</h3>
            <p>Đem những món đồ thích hợp (vải thô, lưỡng long, jean, zealot...) tới đảo Kame gặp NPC bà Hạt Mít để phù phép pha lê hóa. Phù phép thành công, món đồ có thêm sao xám và mạnh hơn.</p>
            <ul>
                <li>Đánh quái có cơ hội nhận trang bị pha lê có thể ép pha lê vào.</li>
                <li>Có 9 loại pha lê, 9 màu sắc và tác dụng khác nhau, có thể dùng thêm ngọc rồng để sao pha lê hóa.</li>
                <li>Trước khi ép, NPC bà Hạt Mít sẽ cho biết trước thông tin.</li>
            </ul>
            <?php guide_shots(['11-3']); ?>
            <h3>Chuyển hóa trang bị</h3>
            <p>Chuyển hóa bằng vàng hoặc ngọc. Khi đã có các món đồ cấp 12: lưỡng long, vàng zealot, jean calic [+4], bạn có thể chuyển hóa cùng với trang bị thần linh.</p>
            <?php guide_shots(['11-4']); ?>

            <h2 id="s12">Hoạt động phó bản hàng ngày</h2>
            <p>Gặp Lính canh rừng Bambo ở Trái Đất để tham gia. Có 10 cửa ải: từ tường thành đến Trại độc nhãn và cuối cùng là Tầng 1, 2, 3, 4.</p>
            <?php guide_shots(['12-1', '12-2', '12-3', '12-4', '12-5', '12-6', '12-7']); ?>

            <h2 id="s13">Hệ thống Boss đa dạng</h2>
            <p>Đi theo lối truyện từ các nhân vật phe phản diện: Xên, Fide, Tiểu đội sát thủ, Bộ đôi Android 19, 20. Săn boss đa dạng và rớt nhiều trang bị vật phẩm hiếm.</p>
            <?php guide_shots(['14-1', '14-2', '14-3', '14-4', '14-5', '14-6', '14-7', '14-8']); ?>
        </article>
    </div>
</div>
<?php site_foot(); ?>
