using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace NroManager
{
    // Gửi phím vào cửa sổ game. Client nhận phím ở Main.checkInput (Game1 0x3BE830): cần Input.anyKeyDown + Event KeyDown.
    // Cách 0 (nền): PostMessage WM_KEYDOWN/WM_CHAR/WM_KEYUP, không giành chuột/bàn phím. Client gốc bỏ qua vì đòi
    // Input.anyKeyDown (chỉ bật với phím thật); slot đã vá bỏ điều kiện này (SlotBuilder.PatchKeyInput).
    // Cách 1: đưa từng cửa sổ lên trước rồi SendInput (phím thật, chắc nhận nhưng cửa sổ chớp lên).
    static class KeySender
    {
        public class Stroke { public ushort Vk; public bool Shift; public char Ch; }

        [StructLayout(LayoutKind.Sequential)] struct MOUSEINPUT { public int dx, dy; public uint mouseData, dwFlags, time; public IntPtr extra; }
        [StructLayout(LayoutKind.Sequential)] struct KEYBDINPUT { public ushort wVk, wScan; public uint dwFlags, time; public IntPtr extra; }
        [StructLayout(LayoutKind.Explicit)] struct InputUnion { [FieldOffset(0)] public MOUSEINPUT mi; [FieldOffset(0)] public KEYBDINPUT ki; }
        [StructLayout(LayoutKind.Sequential)] struct INPUT { public uint type; public InputUnion u; }

        [DllImport("user32.dll")] static extern uint SendInput(uint n, INPUT[] inputs, int size);
        [DllImport("user32.dll")] static extern bool PostMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
        [DllImport("user32.dll")] static extern short VkKeyScan(char c);
        [DllImport("user32.dll")] static extern uint MapVirtualKey(uint code, uint type);

        const uint WM_KEYDOWN = 0x100, WM_KEYUP = 0x101, WM_CHAR = 0x102, KEYUP = 2;
        const ushort VK_SHIFT = 0x10, VK_MENU = 0x12, VK_RETURN = 0x0D;

        static readonly Dictionary<string, ushort> Named = new Dictionary<string, ushort>(StringComparer.OrdinalIgnoreCase)
        {
            { "Enter", 0x0D }, { "Space", 0x20 }, { "Esc", 0x1B }, { "Tab", 0x09 }, { "Backspace", 0x08 },
            { "Up", 0x26 }, { "Down", 0x28 }, { "Left", 0x25 }, { "Right", 0x27 },
            { "F1", 0x70 }, { "F2", 0x71 }, { "F3", 0x72 }, { "F4", 0x73 }, { "F5", 0x74 }, { "F6", 0x75 },
            { "F7", 0x76 }, { "F8", 0x77 }, { "F9", 0x78 }, { "F10", 0x79 }, { "F11", 0x7A }, { "F12", 0x7B },
        };

        static Stroke Char(char c)
        {
            short r = VkKeyScan(c);
            Stroke s = new Stroke(); s.Vk = (ushort)(r & 0xFF); s.Shift = ((r >> 8) & 1) != 0; s.Ch = c;
            return s;
        }

        static Stroke Key(ushort vk, char ch) { Stroke s = new Stroke(); s.Vk = vk; s.Ch = ch; return s; }

        public static bool IsChat(string spec) { spec = spec.Trim(); return spec.Length > 1 && !Named.ContainsKey(spec); }

        // 1 ký tự = 1 phím; tên phím (Enter, Esc, F1..) = phím đặc biệt; còn lại = gõ chat: Enter, chữ, Enter.
        public static List<Stroke> Parse(string spec)
        {
            List<Stroke> r = new List<Stroke>();
            spec = spec.Trim();
            if (spec.Length == 0) return r;
            ushort vk;
            if (spec.Length == 1) r.Add(Char(char.ToLower(spec[0])));
            else if (Named.TryGetValue(spec, out vk)) r.Add(Key(vk, vk == VK_RETURN ? '\r' : vk == 0x20 ? ' ' : '\0'));
            else
            {
                r.Add(Key(VK_RETURN, '\r'));
                foreach (char c in spec) r.Add(Char(c));
                r.Add(Key(VK_RETURN, '\r'));
            }
            return r;
        }

        static IntPtr KeyLParam(ushort vk, bool up)
        {
            long sc = MapVirtualKey(vk, 0);
            long l = 1 | (sc << 16);
            if (up) l |= 0xC0000000L;
            return new IntPtr(l);
        }

        static void Input(ushort vk, bool up)
        {
            INPUT[] i = new INPUT[1];
            i[0].type = 1;
            i[0].u.ki.wVk = vk; i[0].u.ki.wScan = (ushort)MapVirtualKey(vk, 0); i[0].u.ki.dwFlags = up ? KEYUP : 0;
            SendInput(1, i, Marshal.SizeOf(typeof(INPUT)));
        }

        public static async Task Press(IntPtr h, Stroke s, bool foreground)
        {
            if (foreground)
            {
                if (s.Shift) Input(VK_SHIFT, false);
                Input(s.Vk, false);
                await Task.Delay(50);
                Input(s.Vk, true);
                if (s.Shift) Input(VK_SHIFT, true);
            }
            else
            {
                if (s.Shift) PostMessage(h, WM_KEYDOWN, new IntPtr(VK_SHIFT), KeyLParam(VK_SHIFT, false));
                PostMessage(h, WM_KEYDOWN, new IntPtr(s.Vk), KeyLParam(s.Vk, false));
                if (s.Ch != '\0') PostMessage(h, WM_CHAR, new IntPtr(s.Ch), KeyLParam(s.Vk, false));
                await Task.Delay(50);
                PostMessage(h, WM_KEYUP, new IntPtr(s.Vk), KeyLParam(s.Vk, true));
                if (s.Shift) PostMessage(h, WM_KEYUP, new IntPtr(VK_SHIFT), KeyLParam(VK_SHIFT, true));
            }
        }

        [DllImport("user32.dll")] static extern IntPtr GetForegroundWindow();
        [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr h, IntPtr pid);
        [DllImport("kernel32.dll")] static extern uint GetCurrentThreadId();
        [DllImport("user32.dll")] static extern bool AttachThreadInput(uint a, uint b, bool attach);
        [DllImport("user32.dll")] static extern bool BringWindowToTop(IntPtr h);

        // Windows hay chặn đổi cửa sổ trước: gắn tạm luồng nhập với cửa sổ đang ở trước + bấm nhả Alt rồi mới đổi.
        // Trả true nếu cửa sổ h đã thật sự ở trước.
        public static bool Focus(IntPtr h)
        {
            if (Win32.IsIconic(h)) Win32.ShowWindow(h, Win32.SW_RESTORE);
            IntPtr fg = GetForegroundWindow();
            if (fg == h) return true;
            uint me = GetCurrentThreadId(), other = GetWindowThreadProcessId(fg, IntPtr.Zero);
            bool attached = other != 0 && other != me && AttachThreadInput(me, other, true);
            Input(VK_MENU, false); Input(VK_MENU, true);
            BringWindowToTop(h);
            Win32.SetForegroundWindow(h);
            if (attached) AttachThreadInput(me, other, false);
            return GetForegroundWindow() == h;
        }
    }

    partial class MainForm
    {
        CheckedListBox clbWin = new CheckedListBox();
        ComboBox cbMode = new ComboBox();
        FlowLayoutPanel pnCustom;
        TextBox tCustom = new TextBox();
        ToolTip ctlTip = new ToolTip();
        bool sending;

        // ================= tab 2: Control =================

        void BuildControlTab(TabPage tp)
        {
            SplitContainer sp = new SplitContainer();
            sp.Dock = DockStyle.Fill; sp.FixedPanel = FixedPanel.Panel1;
            tp.Controls.Add(sp);
            Load += delegate { try { sp.SplitterDistance = 220; sp.Panel1MinSize = 160; } catch { } };

            // --- trái: cửa sổ nhận lệnh ---
            GroupBox gWin = new GroupBox(); gWin.Text = "Cửa sổ nhận lệnh"; gWin.Dock = DockStyle.Fill; gWin.Padding = new Padding(6);
            clbWin.Dock = DockStyle.Fill; clbWin.CheckOnClick = true; clbWin.IntegralHeight = false;
            gWin.Controls.Add(clbWin);
            TableLayoutPanel wb = new TableLayoutPanel(); wb.Dock = DockStyle.Bottom; wb.AutoSize = true; wb.ColumnCount = 2;
            wb.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50)); wb.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            Button all = new Button(); all.Text = "Chọn hết"; all.Dock = DockStyle.Fill; all.Click += delegate { CheckAll(true); };
            Button none = new Button(); none.Text = "Bỏ hết"; none.Dock = DockStyle.Fill; none.Click += delegate { CheckAll(false); };
            wb.Controls.Add(all, 0, 0); wb.Controls.Add(none, 1, 0);
            Label lm = new Label(); lm.Text = "Cách gửi phím:"; lm.AutoSize = true; lm.Margin = new Padding(3, 8, 3, 0);
            wb.Controls.Add(lm, 0, 1); wb.SetColumnSpan(lm, 2);
            cbMode.DropDownStyle = ComboBoxStyle.DropDownList; cbMode.Dock = DockStyle.Fill;
            cbMode.Items.AddRange(new object[] { "Nền (không giành chuột)", "Bật cửa sổ lên rồi gõ" });
            cbMode.SelectedIndex = cfg.GuiPhim == 1 ? 1 : 0;
            cbMode.SelectedIndexChanged += delegate { cfg.GuiPhim = cbMode.SelectedIndex; cfg.Save(); };
            ctlTip.SetToolTip(cbMode, "Nền: gửi thẳng vào cửa sổ, không đổi cửa sổ đang dùng (chưa chắc game nhận).\nBật lên: đưa từng cửa sổ đã tích lên trước rồi bấm phím thật (chắc nhận, cửa sổ sẽ chớp).");
            wb.Controls.Add(cbMode, 0, 2); wb.SetColumnSpan(cbMode, 2);
            gWin.Controls.Add(wb);
            sp.Panel1.Controls.Add(gWin);

            // --- phải: các nhóm nút ---
            FlowLayoutPanel root = new FlowLayoutPanel();
            root.Dock = DockStyle.Fill; root.AutoScroll = true; root.WrapContents = true; root.Padding = new Padding(4);
            sp.Panel2.Controls.Add(root);

            GroupBox gSkill = CtlGroup(root, "Kỹ năng");
            FlowLayoutPanel s = FlowN();
            for (int i = 1; i <= 10; i++) { string k = (i % 10).ToString(); SendBtn(s, i.ToString(), k, "Phím " + k, 34); }
            Put(gSkill, s);

            GroupBox gZone = CtlGroup(root, "Khu vực (lệnh mod k <số>)");
            FlowLayoutPanel z = FlowN(); z.FlowDirection = FlowDirection.TopDown; z.WrapContents = false;
            FlowLayoutPanel z1 = FlowN(); z1.MaximumSize = new Size(470, 0);
            for (int i = 0; i <= 10; i++) SendBtn(z1, i.ToString(), "k " + i, "Gõ chat \"k " + i + "\"", 34);
            z.Controls.Add(z1);
            FlowLayoutPanel z2 = FlowN();
            NumericUpDown nZone = new NumericUpDown(); Num(z2, nZone, 0, 99, 0, 50);
            Btn(z2, "Vào khu", delegate { Send("k " + (int)nZone.Value); });
            SendBtn(z2, "Bảng khu (M)", "m", "Phím M: mở bảng đổi khu");
            z.Controls.Add(z2);
            Put(gZone, z);

            GroupBox gMod = CtlGroup(root, "Phím tắt của mod");
            FlowLayoutPanel m = FlowN(); m.MaximumSize = new Size(470, 0);
            SendBtn(m, "Bông tai (F)", "f", "F: dùng bông tai Porata");
            SendBtn(m, "Capsule (C)", "c", "C: dùng capsule");
            SendBtn(m, "Bay tới boss (Q)", "q", "Q: bay tới boss gần nhất trong map");
            SendBtn(m, "Tàn sát (T)", "t", "T: bật/tắt tàn sát");
            SendBtn(m, "Tự hồi sinh (E)", "e", "E: bật/tắt tự hồi sinh");
            SendBtn(m, "Tự nhặt (N)", "n", "N: bật/tắt tự nhặt");
            SendBtn(m, "Map trái (J)", "j", "J: qua map bên trái");
            SendBtn(m, "Map giữa (K)", "k", "K: qua map giữa");
            SendBtn(m, "Map phải (L)", "l", "L: qua map bên phải");
            SendBtn(m, "Menu mod (X)", "x", "X: mở menu mod");
            Put(gMod, m);

            GroupBox gChat = CtlGroup(root, "Lệnh chat");
            FlowLayoutPanel c = FlowN(); c.FlowDirection = FlowDirection.TopDown; c.WrapContents = false;
            FlowLayoutPanel c1 = FlowN(); c1.MaximumSize = new Size(470, 0);
            SendBtn(c1, "Tự đánh (ak)", "ak", "Gõ chat ak: bật/tắt tự đánh");
            SendBtn(c1, "Dò boss (dbx)", "dbx", "Gõ chat dbx: bật/tắt tự dò boss");
            SendBtn(c1, "Cập nhật khu (ukhu)", "ukhu", "Gõ chat ukhu");
            SendBtn(c1, "Hồi skill (hs, admin)", "hs", "Lệnh admin hs: chỉ tài khoản admin dùng được");
            c.Controls.Add(c1);
            FlowLayoutPanel c2 = FlowN();
            Lbl(c2, "Map ID (admin):"); NumericUpDown nMap = new NumericUpDown(); Num(c2, nMap, 0, 999, 0, 60);
            Btn(c2, "Đi", delegate { Send("m" + (int)nMap.Value); });
            c.Controls.Add(c2);
            FlowLayoutPanel c3 = FlowN();
            Lbl(c3, "Nhập chat/lệnh:"); TextBox tChat = new TextBox(); tChat.Width = 200; c3.Controls.Add(tChat);
            Btn(c3, "Gửi", delegate { if (tChat.Text.Trim().Length > 0) Send("\u0001" + tChat.Text.Trim()); });
            c.Controls.Add(c3);
            Put(gChat, c);

            // --- phím tùy chỉnh (như ảnh AutoMax): nhập rồi Thêm nút, mỗi nút gửi đúng nội dung đó ---
            GroupBox gCus = CtlGroup(root, "Phím tùy chỉnh");
            FlowLayoutPanel cu = FlowN(); cu.FlowDirection = FlowDirection.TopDown; cu.WrapContents = false;
            FlowLayoutPanel cu1 = FlowN();
            Lbl(cu1, "Nhập:"); tCustom.Width = 140; cu1.Controls.Add(tCustom);
            ctlTip.SetToolTip(tCustom, "1 ký tự = bấm phím đó; Enter, Esc, Space, Tab, F1..F12, Up/Down/Left/Right = phím đặc biệt;\ncòn lại = gõ chat (Enter, nội dung, Enter). Chuột phải vào nút để xóa.");
            Btn(cu1, "Gửi", delegate { if (tCustom.Text.Trim().Length > 0) Send(tCustom.Text.Trim()); });
            Btn(cu1, "Thêm nút", delegate { AddCustom(tCustom.Text.Trim()); });
            cu.Controls.Add(cu1);
            pnCustom = FlowN(); pnCustom.MaximumSize = new Size(470, 0); pnCustom.MinimumSize = new Size(300, 30);
            cu.Controls.Add(pnCustom);
            Put(gCus, cu);
            foreach (string k in cfg.NutPhim) AddCustomButton(k);

            GroupBox gWnd = CtlGroup(root, "Cửa sổ đã tích");
            FlowLayoutPanel w = FlowN();
            Btn(w, "Hiện", delegate { ShowWin(Targets(), false); });
            Btn(w, "Thu nhỏ", delegate { ShowWin(Targets(), true); });
            Btn(w, "Đóng", delegate { CloseMany(Targets()); });
            Put(gWnd, w);
        }

        void SendBtn(FlowLayoutPanel p, string text, string spec, string tip, int width = 0)
        {
            Button b = Btn(p, text, delegate { Send(spec); }, width);
            ctlTip.SetToolTip(b, tip);
        }

        void AddCustom(string spec)
        {
            if (spec.Length == 0) { Log("Nhập phím hoặc lệnh trước khi Thêm nút."); return; }
            if (spec.Contains("|")) { Log("Nội dung nút không được có dấu |."); return; }
            if (cfg.NutPhim.Contains(spec)) { Log("Đã có nút \"" + spec + "\"."); return; }
            cfg.NutPhim.Add(spec); cfg.Save();
            AddCustomButton(spec);
            tCustom.Text = "";
        }

        void AddCustomButton(string spec)
        {
            Button b = Btn(pnCustom, spec.Length == 1 ? spec.ToUpper() : spec, delegate { Send(spec); }, spec.Length == 1 ? 60 : 0);
            ctlTip.SetToolTip(b, (KeySender.IsChat(spec) ? "Gõ chat \"" + spec + "\"" : "Phím " + spec) + " (chuột phải để xóa)");
            ContextMenuStrip cm = new ContextMenuStrip();
            cm.Items.Add("Xóa nút", null, delegate { pnCustom.Controls.Remove(b); cfg.NutPhim.Remove(spec); cfg.Save(); });
            b.ContextMenuStrip = cm;
        }

        static void Put(GroupBox g, Control c) { c.Location = new Point(g.Padding.Left, g.Padding.Top); g.Controls.Add(c); }

        GroupBox CtlGroup(FlowLayoutPanel root, string text)
        {
            GroupBox g = Group(text);
            g.Dock = DockStyle.None; g.Margin = new Padding(4); g.Padding = new Padding(6, 18, 6, 6);
            root.Controls.Add(g);
            return g;
        }

        // ================= danh sách cửa sổ nhận lệnh =================

        // cửa sổ mới bật lên thì tự tích; cửa sổ đã tắt thì bỏ khỏi danh sách; giữ nguyên ô người dùng đã bỏ tích
        void SyncWinList()
        {
            List<Acc> run = accs.Where(a => a.Running).OrderBy(a => a.Id).ToList();
            clbWin.BeginUpdate();
            for (int i = clbWin.Items.Count - 1; i >= 0; i--)
                if (!run.Contains((Acc)clbWin.Items[i])) clbWin.Items.RemoveAt(i);
            foreach (Acc a in run)
                if (!clbWin.Items.Contains(a)) clbWin.Items.Add(a, true);
            clbWin.EndUpdate();
        }

        void CheckAll(bool v) { for (int i = 0; i < clbWin.Items.Count; i++) clbWin.SetItemChecked(i, v); }

        List<Acc> Targets() { return clbWin.CheckedItems.Cast<Acc>().Where(a => a.Running).ToList(); }

        // spec bắt đầu bằng \u0001 = luôn gõ chat (kể cả 1 ký tự)
        async void Send(string spec)
        {
            if (sending) { Log("Đang gửi lệnh trước, chờ chút."); return; }
            List<Acc> targets = Targets();
            if (targets.Count == 0) { Log("Chưa tích cửa sổ nào (tab Control, danh sách bên trái)."); return; }
            bool chat = spec.StartsWith("\u0001");
            if (chat) spec = spec.Substring(1);
            List<KeySender.Stroke> keys = chat && spec.Length == 1 ? ChatOf(spec) : KeySender.Parse(spec);
            bool fg = cbMode.SelectedIndex == 1;
            sending = true;
            try
            {
                foreach (Acc a in targets)
                {
                    IntPtr h = WinOf(a);
                    if (h == IntPtr.Zero) continue;
                    if (fg)
                    {
                        if (!KeySender.Focus(h)) { Log("Không đưa được cửa sổ " + a + " lên trước, bỏ qua."); continue; }
                        await Task.Delay(150);
                    }
                    foreach (KeySender.Stroke k in keys) { await KeySender.Press(h, k, fg); await Task.Delay(40); }
                }
                if (fg) KeySender.Focus(Handle);
                Log("Đã gửi \"" + spec + "\" tới " + targets.Count + " cửa sổ" + (fg ? "" : " (gửi nền)") + ".");
            }
            catch (Exception ex) { Log("Lỗi gửi phím: " + ex.Message); }
            finally { sending = false; }
        }

        // gõ chat cho nội dung 1 ký tự (Parse coi 1 ký tự là phím)
        static List<KeySender.Stroke> ChatOf(string text)
        {
            List<KeySender.Stroke> r = KeySender.Parse("Enter");
            foreach (char ch in text) r.AddRange(KeySender.Parse(ch.ToString()));
            r.AddRange(KeySender.Parse("Enter"));
            return r;
        }
    }
}
