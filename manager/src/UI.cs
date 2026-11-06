using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace NroManager
{
    partial class MainForm : Form
    {
        Config cfg = Config.Load();
        List<Acc> accs = new List<Acc>();
        List<string> servers = new List<string>();
        ListView lv = new ListView();
        TextBox log = new TextBox();
        Timer timer = new Timer();
        int tick;
        bool loadingForm;

        // tab Quản lý tài khoản: ô Cài đặt
        TextBox tUser = new TextBox(), tPass = new TextBox(), tNote = new TextBox();
        ComboBox cbServer = new ComboBox(), cbGroupEdit = new ComboBox();
        // ô Chức năng
        NumericUpDown nFrom = new NumericUpDown(), nTo = new NumericUpDown();
        ComboBox cbCauHinh = new ComboBox(), cbFps = new ComboBox(), cbGroup = new ComboBox();

        public MainForm() : this(0) { }

        public MainForm(int startTab)
        {
            loadingForm = true;
            Text = "NRO Long Manager";
            try { Icon = Icon.ExtractAssociatedIcon(Application.ExecutablePath); } catch { }
            Font = new Font("Segoe UI", 9f);
            Size = new Size(1060, 720); MinimumSize = new Size(760, 480);
            StartPosition = FormStartPosition.CenterScreen;

            SplitContainer outer = new SplitContainer();
            outer.Dock = DockStyle.Fill; outer.Orientation = Orientation.Horizontal; outer.FixedPanel = FixedPanel.Panel2;
            Controls.Add(outer);

            TabControl tabs = new TabControl(); tabs.Dock = DockStyle.Fill;
            TabPage tpAcc = new TabPage("Quản lý tài khoản"), tpCtl = new TabPage("Control");
            tabs.TabPages.Add(tpAcc); tabs.TabPages.Add(tpCtl);
            outer.Panel1.Controls.Add(tabs);

            log.Dock = DockStyle.Fill; log.Multiline = true; log.ReadOnly = true; log.ScrollBars = ScrollBars.Vertical; log.BackColor = Color.White;
            outer.Panel2.Controls.Add(log);

            BuildAccountTab(tpAcc);
            BuildControlTab(tpCtl);
            if (startTab > 0 && startTab <= tabs.TabCount) tabs.SelectedIndex = startTab - 1;

            Load += delegate { outer.SplitterDistance = Math.Max(200, outer.Height - 95); };

            accs = Store.Load();
            Store.LoadState(accs);
            try { SlotBuilder.DonRac(Path.GetFullPath(cfg.EffectiveSlotsDir)); } catch { }
            ReloadServers();
            RefreshGroups();
            RefreshList();
            Log("Đã nạp " + accs.Count + " tài khoản. Client gốc: " + (cfg.GocDir.Length > 0 ? cfg.GocDir : "(chưa đặt, bấm Cài đặt)"));

            timer.Interval = 2000; timer.Tick += delegate { OnTick(); }; timer.Start();
            FormClosing += delegate { Store.SaveState(accs); };
            loadingForm = false;
        }

        // ================= tab 1: Quản lý tài khoản =================

        void BuildAccountTab(TabPage tp)
        {
            SplitContainer sp = new SplitContainer();
            sp.Dock = DockStyle.Fill; sp.FixedPanel = FixedPanel.Panel2;
            tp.Controls.Add(sp);
            // Panel2MinSize/SplitterDistance chỉ đặt được khi khung đã đủ rộng (đặt sớm WinForms ném lỗi)
            Load += delegate { try { sp.SplitterDistance = Math.Max(200, sp.Width - 440); sp.Panel2MinSize = 360; } catch { } };

            lv.Dock = DockStyle.Fill; lv.View = View.Details; lv.FullRowSelect = true; lv.GridLines = true; lv.HideSelection = false;
            lv.Columns.Add("STT", 44); lv.Columns.Add("Tài khoản", 140); lv.Columns.Add("Máy chủ", 70); lv.Columns.Add("Nhóm", 80);
            lv.Columns.Add("Ghi chú", 160); lv.Columns.Add("Trạng thái", 130); lv.Columns.Add("PID", 60);
            lv.Resize += delegate { StretchNoteColumn(); };
            lv.SelectedIndexChanged += delegate { FillFields(); };
            lv.DoubleClick += delegate { DoubleClickRow(); };
            ContextMenuStrip cm = new ContextMenuStrip();
            cm.Items.Add("Đăng nhập", null, delegate { OpenMany(Selected()); });
            cm.Items.Add("Đóng", null, delegate { CloseMany(Selected()); });
            cm.Items.Add("Hiện cửa sổ", null, delegate { ShowWin(Selected(), false); });
            cm.Items.Add("Xóa", null, delegate { DoDelete(); });
            cm.Items.Add("Xóa dữ liệu slot (dựng lại từ đầu)", null, delegate { DoResetSlot(); });
            lv.ContextMenuStrip = cm;
            sp.Panel1.Controls.Add(lv);

            TableLayoutPanel right = new TableLayoutPanel();
            right.Dock = DockStyle.Fill; right.ColumnCount = 1; right.AutoScroll = true; right.Padding = new Padding(4, 0, 4, 0);
            right.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
            sp.Panel2.Controls.Add(right);

            // --- Cài đặt ---
            GroupBox gEdit = Group("Cài Đặt");
            TableLayoutPanel f = Grid();
            tPass.UseSystemPasswordChar = true;
            cbServer.DropDownStyle = ComboBoxStyle.DropDownList;
            cbGroupEdit.DropDownStyle = ComboBoxStyle.DropDown;
            CheckBox showPw = new CheckBox(); showPw.Text = "Hiện"; showPw.AutoSize = true; showPw.Anchor = AnchorStyles.Left;
            showPw.CheckedChanged += delegate { tPass.UseSystemPasswordChar = !showPw.Checked; };
            Row(f, "Tài khoản:", tUser, null);
            Row(f, "Mật khẩu:", tPass, showPw);
            Row(f, "Máy chủ:", cbServer, null);
            Row(f, "Nhóm:", cbGroupEdit, null);
            Row(f, "Ghi chú:", tNote, null);
            FlowLayoutPanel b1 = Flow(); b1.Dock = DockStyle.None; b1.Anchor = AnchorStyles.Left;
            Btn(b1, "Thêm", delegate { DoAdd(); }); Btn(b1, "Lưu", delegate { DoSave(); }); Btn(b1, "Xóa", delegate { DoDelete(); });
            Btn(b1, "Làm mới", delegate { lv.SelectedItems.Clear(); ClearFields(); });
            f.Controls.Add(b1, 0, f.RowCount); f.SetColumnSpan(b1, 3); f.RowCount++;
            gEdit.Controls.Add(f);
            right.Controls.Add(gEdit);

            // --- Chức năng: bảng 2 cột (nhãn | các nút trên 1 dòng) ---
            GroupBox gFn = Group("Chức Năng");
            TableLayoutPanel fn = Grid();
            ToolTip tip = new ToolTip();

            FlowLayoutPanel r2 = Line(fn, "Cấu hình:");
            Combo(r2, cbCauHinh, new string[] { "Mặc định", "Giảm dung lượng" }, cfg.CauHinh == 1 ? 1 : 0, 112);
            Lbl(r2, "FPS:"); Combo(r2, cbFps, new string[] { "Thường", "Cao" }, cfg.Fps == 1 ? 1 : 0, 66);
            tip.SetToolTip(cbCauHinh, "Ô \"Giảm Dung Lượng\" trong menu mod, ghi cho slot trước khi mở");
            tip.SetToolTip(cbFps, "Ô \"FPS Cao\" trong menu mod, ghi cho slot trước khi mở");
            EventHandler saveFn = delegate { SaveFnSettings(); };
            cbCauHinh.SelectedIndexChanged += saveFn; cbFps.SelectedIndexChanged += saveFn;

            FlowLayoutPanel r3 = Line(fn, "Đăng nhập:");
            Btn(r3, "Đăng Nhập", delegate { OpenMany(Selected()); });
            Btn(r3, "Đăng Nhập Tất Cả", delegate { OpenMany(Ordered()); });

            FlowLayoutPanel r4 = Line(fn, "STT:");
            Num(r4, nFrom, 1, 9999, 1, 50); Lbl(r4, "->"); Num(r4, nTo, 1, 9999, 8, 50);
            Btn(r4, "Đăng Nhập Danh Sách", delegate { OpenRange(); });

            FlowLayoutPanel r5 = Line(fn, "Nhóm:");
            cbGroup.DropDownStyle = ComboBoxStyle.DropDownList; cbGroup.Width = 110; cbGroup.Margin = new Padding(3, 4, 3, 3); r5.Controls.Add(cbGroup);
            Btn(r5, "Đăng Nhập Nhóm", delegate { OpenMany(Ordered().Where(a => GroupOf(a) == cbGroup.Text).ToList()); });

            FlowLayoutPanel r6 = Line(fn, "Đóng:");
            Btn(r6, "Đóng", delegate { CloseMany(Selected()); });
            Btn(r6, "Đóng Tất Cả", delegate { CloseMany(accs.ToList()); });

            FlowLayoutPanel r7 = Line(fn, "Cửa sổ:");
            Btn(r7, "Hiện", delegate { ShowWin(Selected(), false); });
            Btn(r7, "Thu Nhỏ", delegate { ShowWin(Selected().Count > 0 ? Selected() : accs.ToList(), true); });

            FlowLayoutPanel r8 = Line(fn, "Khác:");
            Btn(r8, "Nhập File", delegate { DoImportFile(); });
            Btn(r8, "Nhập Từ Client", delegate { DoImportClient(); });
            Btn(r8, "Cài Đặt", delegate { DoSettings(); });

            gFn.Controls.Add(fn);
            right.Controls.Add(gFn);
        }

        // thêm 1 dòng "nhãn | khung chứa nút" vào bảng, trả khung để thêm nút
        static FlowLayoutPanel Line(TableLayoutPanel t, string label)
        {
            FlowLayoutPanel p = Flow(); p.Dock = DockStyle.Fill;
            Row(t, label, p, null);
            p.Anchor = AnchorStyles.Left | AnchorStyles.Right;
            return p;
        }

        // ================= tiện ích dựng giao diện =================

        static GroupBox Group(string text)
        {
            GroupBox g = new GroupBox(); g.Text = text; g.Dock = DockStyle.Top; g.AutoSize = true; g.AutoSizeMode = AutoSizeMode.GrowAndShrink;
            g.Padding = new Padding(6, 4, 6, 6);
            return g;
        }

        static TableLayoutPanel Grid()
        {
            TableLayoutPanel t = new TableLayoutPanel(); t.Dock = DockStyle.Top; t.AutoSize = true; t.ColumnCount = 3;
            t.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
            t.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
            t.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
            return t;
        }

        static void Row(TableLayoutPanel t, string label, Control c, Control extra)
        {
            Label l = new Label(); l.Text = label; l.AutoSize = true; l.Anchor = AnchorStyles.Left; l.Margin = new Padding(3, 6, 3, 3);
            c.Anchor = AnchorStyles.Left | AnchorStyles.Right;
            int r = t.RowCount;
            t.Controls.Add(l, 0, r); t.Controls.Add(c, 1, r);
            if (extra != null) t.Controls.Add(extra, 2, r);
            t.RowCount++;
        }

        // khung tự co, không Dock (dùng trong GroupBox AutoSize)
        static FlowLayoutPanel FlowN() { FlowLayoutPanel p = Flow(); p.Dock = DockStyle.None; return p; }

        static FlowLayoutPanel Flow()
        {
            FlowLayoutPanel p = new FlowLayoutPanel(); p.AutoSize = true; p.AutoSizeMode = AutoSizeMode.GrowAndShrink; p.WrapContents = true;
            p.Dock = DockStyle.Top; p.Margin = new Padding(0);
            return p;
        }

        static Button Btn(FlowLayoutPanel p, string text, EventHandler h, int width = 0)
        {
            Button b = new Button(); b.Text = text;
            if (width > 0) { b.Width = width; } else { b.AutoSize = true; b.AutoSizeMode = AutoSizeMode.GrowAndShrink; b.Padding = new Padding(6, 0, 6, 0); }
            b.Height = 26;
            if (h != null) b.Click += h;
            p.Controls.Add(b);
            return b;
        }

        static void Lbl(FlowLayoutPanel p, string text)
        {
            Label l = new Label(); l.Text = text; l.AutoSize = true; l.Margin = new Padding(3, 7, 3, 3); p.Controls.Add(l);
        }

        static void Num(FlowLayoutPanel p, NumericUpDown n, int min, int max, int val, int width)
        {
            n.Minimum = min; n.Maximum = max; n.Value = Math.Max(min, Math.Min(max, val)); n.Width = width; n.Margin = new Padding(3, 4, 3, 3);
            p.Controls.Add(n);
        }

        static void Combo(FlowLayoutPanel p, ComboBox c, string[] items, int sel, int width)
        {
            c.DropDownStyle = ComboBoxStyle.DropDownList; c.Items.AddRange(items); c.SelectedIndex = sel; c.Width = width; c.Margin = new Padding(3, 4, 3, 3);
            p.Controls.Add(c);
        }

        void StretchNoteColumn()
        {
            int other = 0;
            for (int i = 0; i < lv.Columns.Count; i++) if (i != 4) other += lv.Columns[i].Width;
            int w = lv.ClientSize.Width - other - 4;
            if (w > 80) lv.Columns[4].Width = w;
        }

        public void Log(string s)
        {
            if (InvokeRequired) { BeginInvoke(new Action<string>(Log), s); return; }
            log.AppendText(DateTime.Now.ToString("HH:mm:ss") + "  " + s + "\r\n");
        }

        // ================= danh sách =================

        static string GroupOf(Acc a) { return a.Group.Length > 0 ? a.Group : "(không nhóm)"; }

        List<Acc> Ordered() { return accs.OrderBy(x => x.Id).ToList(); }

        string ServerText(int sv)
        {
            if (sv < 0) return "";
            return (sv + 1).ToString();
        }

        void ReloadServers()
        {
            servers = SlotBuilder.ServerList(cfg);
            cbServer.Items.Clear();
            cbServer.Items.Add("(như client gốc)");
            for (int i = 0; i < servers.Count; i++) cbServer.Items.Add((i + 1) + ". " + servers[i]);
            cbServer.SelectedIndex = 0;
        }

        void RefreshGroups()
        {
            string cur = cbGroup.Text;
            List<string> groups = accs.Select(a => GroupOf(a)).Distinct().OrderBy(x => x).ToList();
            cbGroup.Items.Clear(); cbGroup.Items.AddRange(groups.ToArray());
            if (cbGroup.Items.Count > 0) cbGroup.SelectedIndex = Math.Max(0, cbGroup.Items.IndexOf(cur));
            string ed = cbGroupEdit.Text;
            cbGroupEdit.Items.Clear(); cbGroupEdit.Items.AddRange(accs.Where(a => a.Group.Length > 0).Select(a => a.Group).Distinct().OrderBy(x => x).ToArray());
            cbGroupEdit.Text = ed;
        }

        List<Acc> Selected()
        {
            List<Acc> r = new List<Acc>();
            foreach (ListViewItem it in lv.SelectedItems) r.Add((Acc)it.Tag);
            return r;
        }

        void RefreshList()
        {
            HashSet<int> sel = new HashSet<int>(Selected().Select(a => a.Id));
            lv.BeginUpdate();
            lv.Items.Clear();
            int stt = 0;
            foreach (Acc a in Ordered())
            {
                ListViewItem it = new ListViewItem((++stt).ToString());
                it.SubItems.Add(a.User); it.SubItems.Add(ServerText(a.Server)); it.SubItems.Add(a.Group); it.SubItems.Add(a.Note);
                it.SubItems.Add(a.Status); it.SubItems.Add(a.Running ? a.Proc.Id.ToString() : "");
                it.Tag = a; it.Selected = sel.Contains(a.Id);
                Colorize(it, a);
                lv.Items.Add(it);
            }
            lv.EndUpdate();
            StretchNoteColumn();
        }

        void Colorize(ListViewItem it, Acc a)
        {
            it.ForeColor = a.Running ? Color.FromArgb(0, 120, 0) : a.Status.StartsWith("Lỗi") ? Color.Firebrick : Color.DimGray;
        }

        void UpdateRow(Acc a)
        {
            if (InvokeRequired) { BeginInvoke(new Action<Acc>(UpdateRow), a); return; }
            foreach (ListViewItem it in lv.Items)
                if (it.Tag == a)
                {
                    it.SubItems[1].Text = a.User; it.SubItems[2].Text = ServerText(a.Server); it.SubItems[3].Text = a.Group; it.SubItems[4].Text = a.Note;
                    it.SubItems[5].Text = a.Status; it.SubItems[6].Text = a.Running ? a.Proc.Id.ToString() : "";
                    Colorize(it, a);
                }
        }

        void FillFields()
        {
            List<Acc> s = Selected();
            if (s.Count != 1) return;
            Acc a = s[0];
            tUser.Text = a.User; tPass.Text = a.Pass; tNote.Text = a.Note; cbGroupEdit.Text = a.Group;
            cbServer.SelectedIndex = a.Server >= 0 && a.Server + 1 < cbServer.Items.Count ? a.Server + 1 : 0;
            if (a.Server >= 0 && a.Server + 1 >= cbServer.Items.Count) Log("Máy chủ " + (a.Server + 1) + " của " + a.User + " không có trong danh sách server hiện tại.");
        }

        void ClearFields() { tUser.Text = ""; tPass.Text = ""; tNote.Text = ""; cbGroupEdit.Text = ""; cbServer.SelectedIndex = 0; }

        bool ReadFields(Acc a)
        {
            string u = tUser.Text.Trim();
            if (u.Length == 0) { Log("Chưa nhập tài khoản."); return false; }
            a.User = u; a.Pass = tPass.Text; a.Note = tNote.Text.Trim(); a.Group = cbGroupEdit.Text.Trim();
            a.Server = cbServer.SelectedIndex - 1;
            a.PassError = false;
            return true;
        }

        void Persist() { Store.Save(accs); RefreshGroups(); RefreshList(); }

        void DoAdd()
        {
            string u = tUser.Text.Trim();
            if (accs.Any(x => x.User == u)) { Log("Tài khoản " + u + " đã có, chọn dòng đó rồi bấm Lưu để sửa."); return; }
            Acc a = new Acc(); a.Id = Store.NextId(accs);
            if (!ReadFields(a)) return;
            accs.Add(a); Persist();
            Log("Đã thêm " + a.User + ".");
        }

        void DoSave()
        {
            List<Acc> s = Selected();
            if (s.Count != 1) { Log("Chọn đúng 1 tài khoản để lưu."); return; }
            Acc a = s[0];
            if (a.Running) { Log("Đóng cửa sổ " + a.User + " trước khi sửa."); return; }
            if (ReadFields(a)) { Persist(); Log("Đã lưu " + a.User + "."); }
        }

        void DoDelete()
        {
            List<Acc> s = Selected();
            if (s.Count == 0) return;
            if (s.Any(a => a.Running)) { Log("Đóng cửa sổ trước khi xóa."); return; }
            if (MessageBox.Show("Xóa " + s.Count + " tài khoản (kèm dữ liệu slot)?", "Xóa", MessageBoxButtons.YesNo) != DialogResult.Yes) return;
            foreach (Acc a in s)
            {
                try { SlotBuilder.DeleteSlot(a, cfg); } catch (Exception ex) { Log("Không xóa hết slot " + a.Id + ": " + ex.Message); }
                accs.Remove(a);
            }
            Persist(); ClearFields();
        }

        void DoResetSlot()
        {
            foreach (Acc a in Selected())
            {
                if (a.Running) { Log(a.User + " đang chạy, đóng trước."); continue; }
                try { SlotBuilder.DeleteSlot(a, cfg); Log("Đã xóa slot " + a.User + ", lần mở sau dựng lại."); }
                catch (Exception ex) { Log("Lỗi: " + ex.Message); }
            }
        }

        void SaveFnSettings()
        {
            if (loadingForm) return;
            cfg.CauHinh = cbCauHinh.SelectedIndex; cfg.Fps = cbFps.SelectedIndex;
            cfg.Save();
        }

        void Upsert(string user, string pass, string group, string note, ref int added, ref int updated)
        {
            Acc ex = accs.FirstOrDefault(a => a.User == user);
            if (ex != null) { ex.Pass = pass; ex.PassError = false; if (group.Length > 0) ex.Group = group; if (note.Length > 0) ex.Note = note; updated++; }
            else
            {
                Acc a = new Acc(); a.Id = Store.NextId(accs); a.User = user; a.Pass = pass; a.Group = group; a.Note = note;
                accs.Add(a); added++;
            }
        }

        void DoImportFile()
        {
            OpenFileDialog d = new OpenFileDialog(); d.Filter = "Văn bản|*.txt;*.csv|Tất cả|*.*";
            if (d.ShowDialog() != DialogResult.OK) return;
            int added = 0, updated = 0;
            foreach (string line in File.ReadAllLines(d.FileName, Encoding.UTF8))
            {
                string l = line.Trim();
                if (l.Length == 0 || l.StartsWith("#")) continue;
                string[] p = l.Split('|');
                if (p.Length == 1) p = l.Split(new char[] { '$', '\t', ',' }, StringSplitOptions.None);
                if (p.Length < 2 || p[0].Trim().Length == 0) continue;
                Upsert(p[0].Trim(), p[1].Trim(), p.Length > 2 ? p[2].Trim() : "", p.Length > 3 ? p[3].Trim() : "", ref added, ref updated);
            }
            Persist();
            Log("Nhập file: thêm " + added + ", cập nhật " + updated + ".");
        }

        void DoImportClient()
        {
            try
            {
                string[] l = File.ReadAllText(Path.Combine(cfg.GocDir, @"DragonBoy_Data\app.info")).Replace("\r", "").Split('\n');
                string s = SlotBuilder.ReadRmsString(Path.Combine(SlotBuilder.RmsDirOf(l[0], l[1]), "accManager"));
                if (string.IsNullOrEmpty(s)) { Log("Client gốc chưa lưu danh sách tài khoản (accManager)."); return; }
                int added = 0, updated = 0;
                foreach (string e in s.Split('|'))
                {
                    int i = e.IndexOf('$');
                    if (i <= 0) continue;
                    Upsert(e.Substring(0, i), e.Substring(i + 1), "", "", ref added, ref updated);
                }
                Persist();
                Log("Nhập từ client: thêm " + added + ", cập nhật " + updated + ".");
            }
            catch (Exception ex) { Log("Lỗi: " + ex.Message); }
        }

        void DoSettings()
        {
            if (SettingsForm.Edit(cfg)) { cfg.Save(); ReloadServers(); Log("Đã lưu cài đặt. Slot cũ tự dựng lại khi client gốc hoặc tùy chọn tự đăng nhập đổi."); }
        }

        // ================= mở / đóng =================

        async Task LaunchAsync(Acc a)
        {
            if (a.Running || a.Busy) return;
            if (a.PassError) { a.Status = "Lỗi: mật khẩu không đọc được trên máy này, nhập lại"; UpdateRow(a); return; }
            a.Busy = true; a.Status = "Đang mở..."; UpdateRow(a);
            try
            {
                Config c = cfg;
                SlotBuilder.Info info = await Task.Run(() => SlotBuilder.Prepare(a, c, false, Log));
                ProcessStartInfo psi = new ProcessStartInfo(Path.Combine(info.SlotDir, info.Exe));
                psi.WorkingDirectory = info.SlotDir; psi.UseShellExecute = false;
                Process p = Process.Start(psi);
                a.Proc = p; a.StartedAt = DateTime.Now;
                IntPtr h = IntPtr.Zero;
                for (int i = 0; i < 60 && !p.HasExited; i++)
                {
                    p.Refresh(); h = p.MainWindowHandle;
                    if (h != IntPtr.Zero) break;
                    await Task.Delay(500);
                }
                if (h != IntPtr.Zero) { await Task.Delay(1500); p.Refresh(); Win32.SetWindowText(p.MainWindowHandle, Title(a)); }
                a.Status = "Đang chạy";
                Log("Đã mở " + a.User + " (PID " + p.Id + ")");
            }
            catch (Exception ex)
            {
                a.Status = "Lỗi: " + ex.Message;
                Log("Lỗi mở " + a.User + ": " + ex.Message);
            }
            finally { a.Busy = false; UpdateRow(a); Store.SaveState(accs); }
        }

        static string Title(Acc a) { return "[" + a.Id + "] " + a.User; }

        async void OpenMany(List<Acc> list)
        {
            if (list.Count == 0) { Log("Chưa chọn tài khoản nào."); return; }
            if (cfg.GocDir.Length == 0) { Log("Chưa đặt thư mục client gốc (Cài Đặt)."); return; }
            try
            {
                for (int i = 0; i < list.Count; i++)
                {
                    bool was = list[i].Running;
                    await LaunchAsync(list[i]);
                    if (!was && i < list.Count - 1 && cfg.DelaySec > 0) await Task.Delay(cfg.DelaySec * 1000);
                }
            }
            catch (Exception ex) { Log("Lỗi: " + ex.Message); }
        }

        void OpenRange()
        {
            int from = (int)nFrom.Value, to = (int)nTo.Value;
            if (from > to) { int t = from; from = to; to = t; }
            List<Acc> all = Ordered();
            OpenMany(all.Skip(from - 1).Take(to - from + 1).ToList());
        }

        async void CloseMany(List<Acc> list)
        {
            foreach (Acc a in list)
            {
                if (!a.Running) continue;
                try
                {
                    a.Proc.CloseMainWindow();
                    for (int i = 0; i < 20 && !a.Proc.HasExited; i++) await Task.Delay(250);
                    if (!a.Proc.HasExited) a.Proc.Kill();
                    a.Status = "Đã tắt";
                    Log("Đã đóng " + a.User);
                }
                catch (Exception ex) { Log("Lỗi đóng " + a.User + ": " + ex.Message); }
                UpdateRow(a);
            }
            Store.SaveState(accs);
        }

        // ================= cửa sổ =================

        IntPtr WinOf(Acc a)
        {
            if (!a.Running) return IntPtr.Zero;
            try { a.Proc.Refresh(); return a.Proc.MainWindowHandle; } catch { return IntPtr.Zero; }
        }

        void ShowWin(List<Acc> list, bool minimize)
        {
            foreach (Acc a in list)
            {
                IntPtr h = WinOf(a);
                if (h == IntPtr.Zero) continue;
                if (minimize) Win32.ShowWindow(h, Win32.SW_MINIMIZE);
                else { Win32.ShowWindow(h, Win32.SW_RESTORE); Win32.SetForegroundWindow(h); }
            }
        }

        void DoubleClickRow()
        {
            List<Acc> s = Selected();
            if (s.Count == 0) return;
            if (s[0].Running) ShowWin(s, false); else OpenMany(s);
        }

        // ================= tick: theo dõi, tự mở lại =================

        void OnTick()
        {
            tick++;
            SyncWinList();
            bool changed = false;
            foreach (Acc a in accs)
            {
                if (a.Proc != null && !a.Running && a.Status == "Đang chạy")
                {
                    a.Status = "Đã tắt"; changed = true;
                    Log(a.User + " đã tắt");
                    UpdateRow(a);
                }
                if (a.Running && tick % 5 == 0) { IntPtr h = WinOf(a); if (h != IntPtr.Zero) Win32.SetWindowText(h, Title(a)); }
            }
            if (changed) Store.SaveState(accs);
        }
    }

    class SettingsForm : Form
    {
        TextBox tGoc = new TextBox(), tSlots = new TextBox();
        NumericUpDown nDelay = new NumericUpDown();
        CheckBox cLogin = new CheckBox();

        public static bool Edit(Config c)
        {
            SettingsForm f = new SettingsForm(c);
            if (f.ShowDialog() != DialogResult.OK) return false;
            c.GocDir = f.tGoc.Text.Trim(); c.SlotsDir = f.tSlots.Text.Trim();
            c.DelaySec = (int)f.nDelay.Value; c.TuDangNhap = f.cLogin.Checked;
            return true;
        }

        SettingsForm(Config c)
        {
            Text = "Cài đặt"; FormBorderStyle = FormBorderStyle.FixedDialog; MaximizeBox = false; MinimizeBox = false;
            StartPosition = FormStartPosition.CenterParent; ClientSize = new Size(480, 220); Font = new Font("Segoe UI", 9f);
            Lbl("Thư mục client gốc", 12, 16); tGoc.SetBounds(150, 12, 260, 22); tGoc.Text = c.GocDir; Controls.Add(tGoc);
            Browse(tGoc, 416, 11);
            Lbl("Thư mục slot (để trống = cạnh chương trình; nên cùng ổ đĩa với client gốc)", 12, 46);
            tSlots.SetBounds(12, 66, 398, 22); tSlots.Text = c.SlotsDir; Controls.Add(tSlots);
            Browse(tSlots, 416, 65);
            Lbl("Giây chờ giữa 2 lần mở", 12, 106); nDelay.SetBounds(160, 102, 60, 22); nDelay.Minimum = 0; nDelay.Maximum = 120; nDelay.Value = c.DelaySec; Controls.Add(nDelay);
            cLogin.Text = "Tự bấm đăng nhập (vá GameAssembly.dll của slot, không đụng client gốc)"; cLogin.SetBounds(12, 136, 460, 22); cLogin.Checked = c.TuDangNhap; Controls.Add(cLogin);
            Button ok = new Button(); ok.Text = "Lưu"; ok.SetBounds(310, 182, 75, 26); ok.DialogResult = DialogResult.OK; Controls.Add(ok);
            Button cancel = new Button(); cancel.Text = "Hủy"; cancel.SetBounds(391, 182, 75, 26); cancel.DialogResult = DialogResult.Cancel; Controls.Add(cancel);
            AcceptButton = ok; CancelButton = cancel;
        }

        void Lbl(string s, int x, int y) { Label l = new Label(); l.Text = s; l.AutoSize = true; l.Left = x; l.Top = y; Controls.Add(l); }

        void Browse(TextBox target, int x, int y)
        {
            Button b = new Button(); b.Text = "..."; b.SetBounds(x, y, 50, 24);
            b.Click += delegate
            {
                FolderBrowserDialog d = new FolderBrowserDialog();
                if (target.Text.Length > 0 && Directory.Exists(target.Text)) d.SelectedPath = target.Text;
                if (d.ShowDialog() == DialogResult.OK) target.Text = d.SelectedPath;
            };
            Controls.Add(b);
        }
    }

    static class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            int tab = 0;   // NroManager.exe --tab 2 : mở thẳng tab Control
            for (int i = 0; i + 1 < args.Length; i++) if (args[i] == "--tab") int.TryParse(args[i + 1], out tab);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            try { Application.Run(new MainForm(tab)); }
            catch (Exception ex)
            {
                try { File.WriteAllText(Path.Combine(Config.BaseDir, "loi.txt"), ex.ToString()); } catch { }
                MessageBox.Show(ex.ToString(), "NRO Long Manager: lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
