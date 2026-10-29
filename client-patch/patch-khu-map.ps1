# Đổi dòng "Khu: 3" (ngay trên dòng tọa độ, trong ModFunc.Paint) thành "<tên map> K(3)".
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-khu-map.ps1 "D:\nr-long\GameAssembly.dll"
# Chạy được trên bản int hoặc long. Chi tiết: CLIENT-UNITY.md.
param([Parameter(Mandatory = $true)][string]$Dll)

$INIT = 0x99030      # il2cpp_codegen_initialize_runtime_metadata
$TOSTR = 0x8C99F0    # System.Int32.ToString
$CONCAT4 = 0x785FB0  # System.String.Concat(string, string, string, string)
$S_SPACE = 0xCA8F30; $S_K = 0xCA54C8; $S_OPEN = 0xCAB660; $S_CLOSE = 0xCABC28  # " ", "K", "(", ")"
# hook: chỗ bắt đầu lấy TileMap.zoneID, back: lệnh ngay sau String.Concat("Khu: ", ...)
$targets = @(
    @{ Name = 'Game1'; Hook = 0x3E094C; Back = 0x3E0973; TileMap = 0xC96AB8; Cave = 0xA52C40 },
    @{ Name = 'Game2'; Hook = 0x597BEC; Back = 0x597C13; TileMap = 0xC96AD8; Cave = 0xA52CF0 }
)
# Byte gốc ở hook (mov rcx,[rcx+0B8h]; xor edx,edx; add rcx,84h)
$hookOrig = [byte[]](0x48, 0x8B, 0x89, 0xB8, 0, 0, 0, 0x33, 0xD2, 0x48, 0x81, 0xC1, 0x84, 0, 0, 0)

$b = [IO.File]::ReadAllBytes($Dll)
function Off([long]$rva) { [int]($rva - 0x1800) }

$script:code = New-Object System.Collections.Generic.List[byte]
$script:base = 0
function Emit([byte[]]$x) { $script:code.AddRange($x) }
function Rel([byte[]]$op, [long]$target) {
    # lệnh có rel32 ở cuối: op + disp32, disp tính từ cuối lệnh
    $end = $script:base + $script:code.Count + $op.Length + 4
    Emit $op; Emit ([BitConverter]::GetBytes([int]($target - $end)))
}

foreach ($t in $targets) {
    $h = Off $t.Hook
    if ($b[$h] -eq 0xE9) { Write-Host "$($t.Name): da patch roi."; continue }
    for ($i = 0; $i -lt $hookOrig.Length; $i++) {
        if ($b[$h + $i] -ne $hookOrig[$i]) { Write-Host ("{0}: byte tai 0x{1:X} khong dung. Dung lai." -f $t.Name, $t.Hook); exit 1 }
    }
    for ($i = 0; $i -lt 160; $i++) {
        if ($b[(Off $t.Cave) + $i] -ne 0) { Write-Host "$($t.Name): vung trong da bi dung. Dung lai."; exit 1 }
    }
}

foreach ($t in $targets) {
    $h = Off $t.Hook
    if ($b[$h] -eq 0xE9) { continue }
    $script:code.Clear(); $script:base = $t.Cave
    foreach ($s in @($S_SPACE, $S_K, $S_OPEN, $S_CLOSE)) {
        Rel ([byte[]](0x48, 0x8D, 0x0D)) $s          # lea rcx,[chuỗi]
        Rel ([byte[]](0xE8)) $INIT                     # khởi tạo chuỗi nếu chưa có
    }
    Rel ([byte[]](0x48, 0x8B, 0x0D)) $t.TileMap        # mov rcx,[TileMap_TypeInfo]
    Emit ([byte[]](0x48, 0x8B, 0x89, 0xB8, 0, 0, 0))   # mov rcx,[rcx+0B8h]  (static fields)
    Emit ([byte[]](0x48, 0x8B, 0x41, 0x70))            # mov rax,[rcx+70h]   TileMap.mapName
    Emit ([byte[]](0x48, 0x89, 0x44, 0x24, 0x28))      # mov [rsp+28h],rax
    Emit ([byte[]](0x48, 0x81, 0xC1, 0x84, 0, 0, 0))   # add rcx,84h         &TileMap.zoneID
    Emit ([byte[]](0x33, 0xD2))                        # xor edx,edx
    Rel ([byte[]](0xE8)) $TOSTR                        # zoneID.ToString()
    Emit ([byte[]](0x48, 0x89, 0x44, 0x24, 0x30))      # mov [rsp+30h],rax
    Emit ([byte[]](0x48, 0x8B, 0x4C, 0x24, 0x28))      # mov rcx,mapName
    Rel ([byte[]](0x48, 0x8B, 0x15)) $S_SPACE          # mov rdx," "
    Rel ([byte[]](0x4C, 0x8B, 0x05)) $S_K              # mov r8,"K"
    Rel ([byte[]](0x4C, 0x8B, 0x0D)) $S_OPEN           # mov r9,"("
    Emit ([byte[]](0x4C, 0x89, 0x6C, 0x24, 0x20))      # MethodInfo = null (r13 = 0)
    Rel ([byte[]](0xE8)) $CONCAT4                      # mapName + " K("
    Emit ([byte[]](0x48, 0x8B, 0xC8))                  # mov rcx,rax
    Emit ([byte[]](0x48, 0x8B, 0x54, 0x24, 0x30))      # mov rdx,zone
    Rel ([byte[]](0x4C, 0x8B, 0x05)) $S_CLOSE          # mov r8,")"
    Emit ([byte[]](0x45, 0x33, 0xC9))                  # xor r9d,r9d
    Emit ([byte[]](0x4C, 0x89, 0x6C, 0x24, 0x20))
    Rel ([byte[]](0xE8)) $CONCAT4                      # ... + zone + ")"
    Rel ([byte[]](0xE9)) $t.Back                       # quay lại, rax = chuỗi mới
    [Array]::Copy($script:code.ToArray(), 0, $b, (Off $t.Cave), $script:code.Count)

    $script:code.Clear(); $script:base = $t.Hook
    Rel ([byte[]](0xE9)) $t.Cave
    for ($i = 5; $i -lt ($t.Back - $t.Hook); $i++) { $b[$h + $i] = 0x90 }
    [Array]::Copy($script:code.ToArray(), 0, $b, $h, 5)
    Write-Host "$($t.Name): da patch."
}

# Cho VirtualSize của section il2cpp phủ hết vùng mã mới (tới cuối RawSize)
$pe = [BitConverter]::ToInt32($b, 0x3C); $sh = $pe + 24 + [BitConverter]::ToInt16($b, $pe + 20)
for ($i = 0; $i -lt [BitConverter]::ToInt16($b, $pe + 6); $i++) {
    $o = $sh + 40 * $i
    if ([Text.Encoding]::ASCII.GetString($b, $o, 6) -eq 'il2cpp') {
        $raw = [BitConverter]::ToInt32($b, $o + 16)
        [Array]::Copy([BitConverter]::GetBytes([int]$raw), 0, $b, $o + 8, 4)
    }
}

if (-not (Test-Path "$Dll.truoc-khu-map")) { Copy-Item $Dll "$Dll.truoc-khu-map" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Xong. Ban cu: $Dll.truoc-khu-map"
