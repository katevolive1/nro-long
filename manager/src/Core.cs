using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;

namespace NroManager
{
    static class Win32
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct RECT { public int Left, Top, Right, Bottom; }

        [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern bool CreateHardLink(string link, string existing, IntPtr security);
        [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr after, int x, int y, int cx, int cy, uint flags);
        [DllImport("user32.dll", CharSet = CharSet.Unicode)] public static extern bool SetWindowText(IntPtr h, string text);
        [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
        [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int cmd);
        [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
        [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
        [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr h);

        public const uint SWP_NOSIZE = 0x1, SWP_SHOWWINDOW = 0x40;
        public const int SW_RESTORE = 9, SW_MINIMIZE = 6;
    }

    class Config
    {
        public string GocDir = "";
        public string SlotsDir = "";
        public int DelaySec = 5;
        public bool TuDangNhap = true;
        public int CauHinh = 0;          // 0 mặc định, 1 giảm dung lượng (ô "Giảm Dung Lượng" của mod, RMS background)
        public int Fps = 1;              // 1 cao, 0 thường (ô "FPS Cao", RMS isHighFps)
        public int GuiPhim = 0;          // tab Control: 0 gửi nền (PostMessage), 1 bật cửa sổ lên rồi gõ (SendInput)
        public List<string> NutPhim = new List<string> { "f", "j", "k", "l" };   // nút phím tùy chỉnh

        public static string BaseDir { get { return AppDomain.CurrentDomain.BaseDirectory; } }
        public static string FilePath { get { return Path.Combine(BaseDir, "config.ini"); } }

        public string EffectiveSlotsDir { get { return SlotsDir.Length > 0 ? SlotsDir : Path.Combine(BaseDir, "slots"); } }

        public static Config Load()
        {
            Config c = new Config();
            if (File.Exists(FilePath))
            {
                foreach (string line in File.ReadAllLines(FilePath, Encoding.UTF8))
                {
                    int i = line.IndexOf('=');
                    if (i <= 0) continue;
                    string k = line.Substring(0, i).Trim(), v = line.Substring(i + 1).Trim();
                    int n;
                    switch (k)
                    {
                        case "GocDir": c.GocDir = v; break;
                        case "SlotsDir": c.SlotsDir = v; break;
                        case "DelaySec": if (int.TryParse(v, out n) && n >= 0) c.DelaySec = n; break;
                        case "TuDangNhap": c.TuDangNhap = v == "1"; break;
                        case "CauHinh": if (int.TryParse(v, out n)) c.CauHinh = n; break;
                        case "Fps": if (int.TryParse(v, out n)) c.Fps = n; break;
                        case "GuiPhim": if (int.TryParse(v, out n)) c.GuiPhim = n; break;
                        case "NutPhim": c.NutPhim = v.Split(new char[] { '|' }, StringSplitOptions.RemoveEmptyEntries).ToList(); break;
                    }
                }
            }
            if (c.GocDir.Length == 0)
            {
                foreach (string d in new string[] { @"F:\nr-long", @"D:\nr-long" })
                    if (Directory.Exists(d)) { c.GocDir = d; break; }
            }
            return c;
        }

        public void Save()
        {
            File.WriteAllLines(FilePath, new string[] {
                "GocDir=" + GocDir, "SlotsDir=" + SlotsDir, "DelaySec=" + DelaySec,
                "TuDangNhap=" + (TuDangNhap ? "1" : "0"),
                "CauHinh=" + CauHinh, "Fps=" + Fps, "GuiPhim=" + GuiPhim, "NutPhim=" + string.Join("|", NutPhim)
            }, new UTF8Encoding(false));
        }
    }

    class Acc
    {
        public int Id;
        public string User = "", Pass = "", Group = "", Note = "";
        public int Server = -1;      // chỉ số svselect (0 = server đầu danh sách), -1 = như client gốc
        public bool PassError;

        // trạng thái chạy (không lưu file)
        public Process Proc;
        public string Status = "Chưa mở";
        public DateTime StartedAt = DateTime.MinValue;
        public bool Busy;

        public override string ToString() { return "[" + Id + "] " + User; }

        public bool Running { get { try { return Proc != null && !Proc.HasExited; } catch { return false; } } }
    }

    static class Store
    {
        static string FilePath { get { return Path.Combine(Config.BaseDir, "accounts.txt"); } }
        static string StatePath { get { return Path.Combine(Config.BaseDir, "state.ini"); } }

        static string Clean(string s) { return (s ?? "").Replace("|", "/").Replace("\r", " ").Replace("\n", " ").Trim(); }

        public static string Protect(string plain)
        {
            byte[] enc = ProtectedData.Protect(Encoding.UTF8.GetBytes(plain), null, DataProtectionScope.CurrentUser);
            return "dp:" + Convert.ToBase64String(enc);
        }

        public static List<Acc> Load()
        {
            List<Acc> list = new List<Acc>();
            if (!File.Exists(FilePath)) return list;
            foreach (string line in File.ReadAllLines(FilePath, Encoding.UTF8))
            {
                if (line.Trim().Length == 0 || line.StartsWith("#")) continue;
                string[] p = line.Split('|');
                int id;
                if (p.Length < 3 || !int.TryParse(p[0], out id)) continue;
                Acc a = new Acc();
                a.Id = id; a.User = p[1];
                string pw = p[2];
                try
                {
                    if (pw.StartsWith("dp:"))
                        a.Pass = Encoding.UTF8.GetString(ProtectedData.Unprotect(Convert.FromBase64String(pw.Substring(3)), null, DataProtectionScope.CurrentUser));
                    else if (pw.StartsWith("raw:")) a.Pass = pw.Substring(4);
                    else a.Pass = pw;
                }
                catch { a.PassError = true; }
                a.Group = p.Length > 3 ? p[3] : "";
                a.Note = p.Length > 4 ? p[4] : "";
                int sv;
                if (p.Length > 5 && int.TryParse(p[5], out sv)) a.Server = sv;
                list.Add(a);
            }
            return list;
        }

        public static void Save(List<Acc> list)
        {
            List<string> lines = new List<string>();
            lines.Add("# id|tai khoan|mat khau (dp: = DPAPI cua may nay, raw: = chu thuong, se tu ma hoa lai khi luu)|nhom|ghi chu|may chu (svselect, -1 = nhu client goc)");
            foreach (Acc a in list)
            {
                string pw = a.PassError ? "raw:" : Protect(a.Pass);
                lines.Add(a.Id + "|" + Clean(a.User) + "|" + pw + "|" + Clean(a.Group) + "|" + Clean(a.Note) + "|" + a.Server);
            }
            File.WriteAllLines(FilePath, lines.ToArray(), new UTF8Encoding(false));
        }

        public static int NextId(List<Acc> list)
        {
            int max = 0;
            foreach (Acc a in list) if (a.Id > max) max = a.Id;
            return max + 1;
        }

        public static void SaveState(List<Acc> list)
        {
            List<string> lines = new List<string>();
            foreach (Acc a in list)
                if (a.Running) lines.Add(a.Id + "=" + a.Proc.Id + "|" + a.Proc.StartTime.ToFileTimeUtc());
            File.WriteAllLines(StatePath, lines.ToArray());
        }

        // nhận lại cửa sổ còn chạy từ lần mở manager trước
        public static void LoadState(List<Acc> list)
        {
            if (!File.Exists(StatePath)) return;
            foreach (string line in File.ReadAllLines(StatePath))
            {
                int eq = line.IndexOf('=');
                if (eq <= 0) continue;
                int id;
                if (!int.TryParse(line.Substring(0, eq), out id)) continue;
                string[] p = line.Substring(eq + 1).Split('|');
                int pid; long ft;
                if (p.Length < 2 || !int.TryParse(p[0], out pid) || !long.TryParse(p[1], out ft)) continue;
                try
                {
                    Process pr = Process.GetProcessById(pid);
                    if (pr.StartTime.ToFileTimeUtc() != ft || pr.HasExited) continue;
                    foreach (Acc a in list)
                        if (a.Id == id)
                        {
                            a.Proc = pr; a.Status = "Đang chạy";
                            a.StartedAt = pr.StartTime;
                        }
                }
                catch { }
            }
        }
    }

    // Dựng thư mục "slot" cho từng tài khoản: client gốc bằng hard link, riêng GameAssembly.dll (nếu vá) và 2 file đổi tên công ty
    // để mỗi cửa sổ có thư mục lưu dữ liệu (RMS) riêng trong LocalLow\<công ty>\<sản phẩm>.
    static class SlotBuilder
    {
        // vá tự đăng nhập: xem tools\patch-tu-dang-nhap.ps1
        const int SiteRva = 0x3D4575, BackRva = 0x3D457B, CaveRva = 0x59C200, CaveEndRva = 0x59C3A0;
        const int ObjNew = 0x991F0, InitMeta = 0x99030, AutoCtor = 0x2D2D90, WBarrier = 0x98390, TiAutoLogin = 0xCA45E0, TiModFunc = 0xCAA740;
        const int PatchVersion = 3;   // đổi bản vá thì tăng để mọi slot tự dựng lại

        static readonly string[] SkipRms = { "accManager", "acc", "pass", "check", "userAo1", "Player.log", "Player-prev.log" };
        static readonly string[] AlwaysRms = { "svselect", "NRlink2", "NRO_CUSTOM_SERVER" };

        public class Info { public string Exe, Company, Product, SlotDir, RmsDir; }

        public static string LocalLow { get { return Path.Combine(Environment.GetEnvironmentVariable("USERPROFILE"), @"AppData\LocalLow"); } }

        static void ReadAppInfo(string gocDir, out string company, out string product)
        {
            string p = Path.Combine(gocDir, @"DragonBoy_Data\app.info");
            if (!File.Exists(p)) throw new Exception("Không thấy DragonBoy_Data\\app.info trong " + gocDir);
            string[] l = File.ReadAllText(p).Replace("\r", "").Split('\n');
            if (l.Length < 2) throw new Exception("app.info sai định dạng");
            company = l[0]; product = l[1];
        }

        public static string SlotCompany(int id, int len)
        {
            if (len < 8) throw new Exception("Tên công ty trong client quá ngắn (" + len + ")");
            string num = id.ToString("D" + (len - 7));
            if (num.Length > len - 7) throw new Exception("Id tài khoản quá lớn");
            return "NROSLOT" + num;
        }

        public static string RmsDirOf(string company, string product) { return Path.Combine(LocalLow, company + "\\" + product); }

        static int IndexOf(byte[] b, byte[] pat, int from)
        {
            for (int i = from; i <= b.Length - pat.Length; i++)
            {
                if (b[i] != pat[0]) continue;
                bool ok = true;
                for (int j = 1; j < pat.Length; j++) if (b[i + j] != pat[j]) { ok = false; break; }
                if (ok) return i;
            }
            return -1;
        }

        static byte[] ReplaceSame(byte[] data, string from, string to)
        {
            byte[] f = Encoding.ASCII.GetBytes(from), t = Encoding.ASCII.GetBytes(to);
            byte[] r = (byte[])data.Clone();
            int n = 0, i = 0;
            while ((i = IndexOf(r, f, i)) >= 0) { Array.Copy(t, 0, r, i, t.Length); i += t.Length; n++; }
            if (n == 0) throw new Exception("Không thấy chuỗi công ty trong file client");
            return r;
        }

        static byte[] Rel(long from, long to) { return BitConverter.GetBytes((int)(to - from)); }

        static byte[] Cat(params byte[][] parts)
        {
            List<byte> l = new List<byte>();
            foreach (byte[] p in parts) l.AddRange(p);
            return l.ToArray();
        }

        static byte[] H(params byte[] b) { return b; }

        // trả true nếu vá được (hoặc đã vá)
        // Nhận phím gửi nền (tab Control): Main.checkInput (Game1 0x3BE830) chỉ đọc phím khi Input.anyKeyDown = true
        // (0x3BEC1F call, 0x3BEC26 je 0x3BED1E), mà cờ này chỉ bật với phím thật. Bỏ lệnh je (6 byte NOP) để chỉ cần
        // Event.current.type == KeyDown, phím PostMessage vào cửa sổ cũng được nhận. Chỉ vá GameAssembly của slot.
        const int KeySiteRva = 0x3BEC26;

        static bool PatchKeyInput(byte[] b, out string why)
        {
            why = null;
            int off = KeySiteRva - 0x1800;
            byte[] orig = H(0x0F, 0x84, 0xF2, 0x00, 0x00, 0x00), nop = H(0x66, 0x0F, 0x1F, 0x44, 0x00, 0x00);
            bool isOrig = true, isNop = true;
            for (int i = 0; i < 6; i++) { if (b[off + i] != orig[i]) isOrig = false; if (b[off + i] != nop[i]) isNop = false; }
            if (isNop) return true;
            if (!isOrig) { why = "client khác bản (byte tại 0x3BEC26 không khớp)"; return false; }
            Array.Copy(nop, 0, b, off, 6);
            return true;
        }

        static bool PatchAutoLogin(byte[] b, out string why)
        {
            why = null;
            long caveCur = CaveRva;
            List<byte> c = new List<byte>();
            Action<byte[]> emit = delegate(byte[] x) { c.AddRange(x); caveCur += x.Length; };
            emit(H(0x48, 0x8D, 0x0D)); emit(Rel(caveCur + 4, TiAutoLogin));   // lea rcx,[ô TypeInfo]
            emit(H(0xE8)); emit(Rel(caveCur + 4, InitMeta));                  // call 0x99030: nạp lười TypeInfo (AutoLogin() chưa dùng kiểu này)
            emit(H(0x48, 0x8B, 0x0D)); emit(Rel(caveCur + 4, TiAutoLogin));
            emit(H(0xE8)); emit(Rel(caveCur + 4, ObjNew));
            emit(H(0x48, 0x8B, 0xD8, 0x48, 0x8B, 0xC8, 0x33, 0xD2));
            emit(H(0xE8)); emit(Rel(caveCur + 4, AutoCtor));
            emit(H(0xC6, 0x43, 0x20, 0x01));
            emit(H(0x48, 0x8B, 0x0D)); emit(Rel(caveCur + 4, TiModFunc));
            emit(H(0x48, 0x8B, 0x89, 0xB8, 0x00, 0x00, 0x00, 0x48, 0x89, 0x59, 0x70, 0x48, 0x8B, 0xD3, 0x48, 0x83, 0xC1, 0x70));
            emit(H(0xE8)); emit(Rel(caveCur + 4, WBarrier));
            emit(H(0x48, 0x8B, 0x0D)); emit(Rel(caveCur + 4, TiModFunc));
            emit(H(0xE9)); emit(Rel(caveCur + 4, BackRva));
            if (CaveRva + c.Count > CaveEndRva) { why = "cave quá dài"; return false; }

            byte[] jmp = Cat(H(0x0F, 0x84), Rel(SiteRva + 6, CaveRva));
            int siteOff = SiteRva - 0x1800, caveOff = CaveRva - 0x1800;
            if (siteOff + 6 > b.Length) { why = "file quá ngắn"; return false; }
            bool already = true;
            for (int i = 0; i < 6; i++) if (b[siteOff + i] != jmp[i]) already = false;
            if (already) return true;
            byte[] orig = H(0x0F, 0x84, 0xCE, 0x04, 0x00, 0x00);
            for (int i = 0; i < 6; i++) if (b[siteOff + i] != orig[i]) { why = "client khác bản (byte tại 0x3D4575 không khớp)"; return false; }
            c.CopyTo(0, b, caveOff, c.Count);
            Array.Copy(jmp, 0, b, siteOff, 6);
            return true;
        }

        static void Link(string src, string dst)
        {
            if (File.Exists(dst)) File.Delete(dst);
            if (!Win32.CreateHardLink(dst, src, IntPtr.Zero)) File.Copy(src, dst, true); // khác ổ đĩa thì chép
        }

        static string Signature(string gocDir, string exe, Config cfg, string company)
        {
            FileInfo e = new FileInfo(Path.Combine(gocDir, exe)), g = new FileInfo(Path.Combine(gocDir, "GameAssembly.dll"));
            return string.Format("v{0}|{1}|{2}|{3}|{4}|{5}|{6}|{7}", PatchVersion, e.Length, e.LastWriteTimeUtc.Ticks, g.Length, g.LastWriteTimeUtc.Ticks, cfg.TuDangNhap ? 1 : 0, company, gocDir);
        }

        static void WriteRmsString(string path, string s)
        {
            byte[] u = Encoding.UTF8.GetBytes(s);
            byte[] o = new byte[u.Length + 2];
            o[0] = (byte)(u.Length >> 8); o[1] = (byte)u.Length;
            Array.Copy(u, 0, o, 2, u.Length);
            File.WriteAllBytes(path, o);
        }

        public static string ReadRmsString(string path)
        {
            if (!File.Exists(path)) return null;
            byte[] b = File.ReadAllBytes(path);
            if (b.Length < 2) return "";
            int n = (b[0] << 8) | b[1];
            if (n > b.Length - 2) n = b.Length - 2;
            return Encoding.UTF8.GetString(b, 2, n);
        }

        public static Info Prepare(Acc a, Config cfg, bool slotRunning, Action<string> log)
        {
            string goc = cfg.GocDir;
            if (goc.Length == 0 || !Directory.Exists(goc)) throw new Exception("Chưa đặt thư mục client gốc (Cài đặt)");
            string oldCompany, product;
            ReadAppInfo(goc, out oldCompany, out product);
            Info info = new Info();
            info.Product = product;
            info.Company = SlotCompany(a.Id, oldCompany.Length);
            info.Exe = product + ".exe";
            if (!File.Exists(Path.Combine(goc, info.Exe))) throw new Exception("Không thấy " + info.Exe + " trong " + goc);
            string slotsRoot = Path.GetFullPath(cfg.EffectiveSlotsDir);
            info.SlotDir = Path.Combine(slotsRoot, a.Id.ToString());
            info.RmsDir = RmsDirOf(info.Company, product);
            string marker = Path.Combine(info.SlotDir, ".nro-slot");
            string sig = Signature(goc, info.Exe, cfg, info.Company);

            bool ok = File.Exists(marker) && File.ReadAllText(marker) == sig;
            if (!ok)
            {
                if (slotRunning) throw new Exception("Client gốc đã đổi nhưng cửa sổ đang chạy, đóng cửa sổ này rồi mở lại");
                log("Tài khoản " + a.User + ": dựng slot " + a.Id + "...");
                if (Directory.Exists(info.SlotDir))
                {
                    if (!info.SlotDir.StartsWith(slotsRoot, StringComparison.OrdinalIgnoreCase)) throw new Exception("Đường dẫn slot lạ, dừng");
                    DeleteDirRetry(info.SlotDir, product);
                }
                Directory.CreateDirectory(info.SlotDir);
                string gocFull = Path.GetFullPath(goc).TrimEnd('\\');
                string patchWarn = null;
                foreach (string f in Directory.GetFiles(gocFull, "*", SearchOption.AllDirectories))
                {
                    string rel = f.Substring(gocFull.Length + 1);
                    string name = Path.GetFileName(f);
                    if (name.StartsWith("GameAssembly.dll.truoc-")) continue;
                    string dst = Path.Combine(info.SlotDir, rel);
                    Directory.CreateDirectory(Path.GetDirectoryName(dst));
                    if (rel == @"DragonBoy_Data\globalgamemanagers" || rel == @"DragonBoy_Data\app.info")
                        File.WriteAllBytes(dst, ReplaceSame(File.ReadAllBytes(f), oldCompany, info.Company));
                    else if (rel == "GameAssembly.dll")
                    {
                        byte[] b = File.ReadAllBytes(f);
                        if (cfg.TuDangNhap && !PatchAutoLogin(b, out patchWarn)) log("Cảnh báo: không vá được tự đăng nhập: " + patchWarn);
                        string why;
                        if (!PatchKeyInput(b, out why)) log("Cảnh báo: không vá được nhận phím nền: " + why);
                        File.WriteAllBytes(dst, b);
                    }
                    else Link(f, dst);
                }
                File.WriteAllText(marker, sig);
            }

            // dữ liệu RMS của slot
            if (!slotRunning)
            {
                string gocRms = RmsDirOf(oldCompany, product);
                Directory.CreateDirectory(info.RmsDir);
                if (Directory.Exists(gocRms))
                {
                    foreach (string f in Directory.GetFiles(gocRms))
                    {
                        string name = Path.GetFileName(f);
                        if (Array.IndexOf(SkipRms, name) >= 0) continue;
                        string dst = Path.Combine(info.RmsDir, name);
                        if (File.Exists(dst) && Array.IndexOf(AlwaysRms, name) < 0) continue;
                        File.Copy(f, dst, true);
                    }
                }
                WriteRmsString(Path.Combine(info.RmsDir, "acc"), a.User);
                WriteRmsString(Path.Combine(info.RmsDir, "pass"), a.Pass);
                File.WriteAllBytes(Path.Combine(info.RmsDir, "check"), new byte[] { 1 });
                if (a.Server >= 0) File.WriteAllBytes(Path.Combine(info.RmsDir, "svselect"), new byte[] { (byte)a.Server });
                File.WriteAllBytes(Path.Combine(info.RmsDir, "isHighFps"), new byte[] { (byte)(cfg.Fps == 1 ? 1 : 0) });
                File.WriteAllBytes(Path.Combine(info.RmsDir, "background"), new byte[] { (byte)(cfg.CauHinh == 1 ? 1 : 0) });
            }
            return info;
        }

        // Danh sách server client đang lưu (RMS NRlink2 của client gốc: chuỗi "XX-XX-..." là byte XOR khóa "69",
        // giải ra "tên:ip:port:0,tên:ip:port:0,...,0,0"; server gửi lại mỗi lần kết nối). Trả "tên (ip:port)".
        public static List<string> ServerList(Config cfg)
        {
            List<string> r = new List<string>();
            try
            {
                string oc, pr; ReadAppInfo(cfg.GocDir, out oc, out pr);
                string hex = ReadRmsString(Path.Combine(RmsDirOf(oc, pr), "NRlink2"));
                if (string.IsNullOrEmpty(hex)) return r;
                byte[] key = Encoding.ASCII.GetBytes("69");
                List<byte> b = new List<byte>();
                string[] parts = hex.Split('-');
                for (int i = 0; i < parts.Length; i++) b.Add((byte)(Convert.ToByte(parts[i], 16) ^ key[i % key.Length]));
                string s = Encoding.UTF8.GetString(b.ToArray());
                foreach (string e in s.Split(','))
                {
                    string[] f = e.Split(':');
                    if (f.Length >= 3) r.Add(f[0] + " (" + f[1] + ":" + f[2] + ")");
                }
            }
            catch { }
            return r;
        }

        // File trong slot là hard link: khi slot khác (hoặc client gốc) đang chạy thì DLL/exe cùng dữ liệu đang được nạp,
        // Windows không cho XÓA tên nào của file đó ("Access ... denied") nhưng vẫn cho ĐỔI TÊN. Nên dời slot cũ sang
        // slots\_rac\ rồi dọn dần (DonRac) khi không còn cửa sổ nào dùng.
        static void DeleteDirRetry(string dir, string product)
        {
            foreach (Process p in Process.GetProcessesByName(product))
            {
                string path = null;
                try { path = p.MainModule.FileName; } catch { }
                if (path != null && path.StartsWith(dir + "\\", StringComparison.OrdinalIgnoreCase))
                    throw new Exception("cửa sổ game của slot này vẫn đang chạy (PID " + p.Id + "), đóng nó trước");
            }
            try { Directory.Delete(dir, true); return; }
            catch (Exception ex) { if (!(ex is IOException || ex is UnauthorizedAccessException)) throw; }
            string rac = Path.Combine(Path.GetDirectoryName(dir), "_rac");
            Directory.CreateDirectory(rac);
            Directory.Move(dir, Path.Combine(rac, Path.GetFileName(dir) + "-" + DateTime.Now.Ticks));
            DonRac(Path.GetDirectoryName(dir));
        }

        // xóa các slot cũ trong slots\_rac (bỏ qua cái còn bị giữ, lần sau dọn tiếp)
        public static void DonRac(string slotsRoot)
        {
            string rac = Path.Combine(slotsRoot, "_rac");
            if (!Directory.Exists(rac)) return;
            foreach (string d in Directory.GetDirectories(rac))
            {
                try { Directory.Delete(d, true); }
                catch
                {
                    foreach (string f in Directory.GetFiles(d, "*", SearchOption.AllDirectories)) { try { File.Delete(f); } catch { } }
                }
            }
            try { Directory.Delete(rac, true); } catch { }
        }

        public static void DeleteSlot(Acc a, Config cfg)
        {
            string root = Path.GetFullPath(cfg.EffectiveSlotsDir);
            string d = Path.Combine(root, a.Id.ToString());
            string oc0, pr0; ReadAppInfo(cfg.GocDir, out oc0, out pr0);
            if (Directory.Exists(d) && d.StartsWith(root, StringComparison.OrdinalIgnoreCase)) DeleteDirRetry(d, pr0);
            try
            {
                string oc, pr; ReadAppInfo(cfg.GocDir, out oc, out pr);
                string r = Path.Combine(LocalLow, SlotCompany(a.Id, oc.Length));
                if (Directory.Exists(r) && Path.GetFileName(r).StartsWith("NROSLOT")) Directory.Delete(r, true);
            }
            catch { }
        }
    }
}
