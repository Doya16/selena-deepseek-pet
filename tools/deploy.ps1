param([switch]$NoLaunch, [switch]$NoStartMenu, [switch]$SkipPlugin, [switch]$Yes, [string]$ClientPath = '', [string]$DataHome = '')
# 赛琳娜 DeepSeek 桌宠 · 一键部署（完整包首次使用）
# 检查解压位置与文件、安装 Harness 连接插件、创建桌面和开始菜单快捷方式，然后启动桌宠。可重复运行。
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
function Say([string]$text, [string]$color = 'Gray') { Write-Host $text -ForegroundColor $color }
function Fail([string]$text) { Say ''; Say "部署没有完成：$text" 'Red'; exit 1 }

Say '赛琳娜 DeepSeek 桌宠 · 一键部署' 'Magenta'
Say "位置：$root"

# 1. 必须是完整解压后的目录，而不是压缩软件的临时目录
$temp = [IO.Path]::GetFullPath($env:TEMP).TrimEnd('\')
if ($root.StartsWith($temp, [StringComparison]::OrdinalIgnoreCase) -or $root -match '\\(Rar\$|7z[A-Z0-9]+|Temp\d+_)') {
    Fail '看起来是在压缩包里直接运行的。请先把整个 ZIP 解压到一个文件夹（例如 D:\赛琳娜DeepSeek桌宠），再双击里面的「一键部署.cmd」。'
}

# 2. 关键文件
$exe = Get-ChildItem -LiteralPath $root -Filter *.exe | Where-Object { $_.VersionInfo.InternalName -eq 'selena_pet' } | Select-Object -First 1
if (-not $exe) { Fail '没有找到 赛琳娜DeepSeek桌宠启动.exe。请重新下载完整包并完整解压。' }
$current = Join-Path $root 'current-program.json'
if (-not (Test-Path -LiteralPath $current)) { Fail '缺少 current-program.json，完整包可能没有解压完整。' }
$version = (Get-Content -LiteralPath $current -Raw -Encoding UTF8 | ConvertFrom-Json).version
$program = Join-Path $root ".programs\$version\$($exe.Name)"
$installer = Join-Path $PSScriptRoot 'install_deepseek_plugin.ps1'
foreach ($need in @($program, (Join-Path $root 'assets\catalog.json'), (Join-Path $root 'defaults\settings.json'), (Join-Path $PSScriptRoot 'create_shortcut.ps1'), $installer)) {
    if (-not (Test-Path -LiteralPath $need)) { Fail "缺少文件：$need。请重新完整解压。" }
}
Say "版本：v$version" 'Green'

# 3. 目录需要可写（保存设置、一键更新都要写入这里）
try {
    $probe = Join-Path $root ('.deploy-check-' + [guid]::NewGuid().ToString('N'))
    [IO.File]::WriteAllText($probe, 'ok'); Remove-Item -LiteralPath $probe -Force
} catch { Fail '这个文件夹不能写入（例如 C:\Program Files）。请换到自己的文件夹，例如 D:\赛琳娜DeepSeek桌宠。' }

# 4. DeepSeek Harness 连接插件
$pluginDone = $false
if ($SkipPlugin) {
    Say '已按要求跳过连接插件；之后可在 设置 → 连接 DeepSeek 中安装。' 'Yellow'
} else {
    if (-not $ClientPath) {
        foreach ($base in @($env:LOCALAPPDATA, $env:ProgramFiles)) {
            foreach ($suffix in @('Programs\DeepSeek Harness\DeepSeek Harness.exe', 'DeepSeek Harness\DeepSeek Harness.exe')) {
                if (-not $ClientPath -and $base -and (Test-Path -LiteralPath (Join-Path $base $suffix))) { $ClientPath = Join-Path $base $suffix }
            }
        }
    }
    if (-not $ClientPath) {
        # 自定义安装位置：正在运行的 Harness、安装程序登记的位置、开始菜单快捷方式
        $candidates = @()
        $candidates += Get-Process -Name 'DeepSeek Harness' -ErrorAction SilentlyContinue | ForEach-Object { $_.Path }
        $keys = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
        $candidates += Get-ItemProperty $keys -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -eq 'DeepSeek Harness' -and $_.InstallLocation } | ForEach-Object { Join-Path $_.InstallLocation 'DeepSeek Harness.exe' }
        $shell = New-Object -ComObject WScript.Shell
        $candidates += Get-ChildItem ([Environment]::GetFolderPath('Programs')), ([Environment]::GetFolderPath('CommonPrograms')) -Recurse -Filter 'DeepSeek Harness.lnk' -ErrorAction SilentlyContinue | ForEach-Object { $shell.CreateShortcut($_.FullName).TargetPath }
        $ClientPath = $candidates | Where-Object { $_ -and (Test-Path -LiteralPath $_) -and (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $_) 'resources\runtime\cli\bin\dsh.cmd')) } | Select-Object -First 1
    }
    if (-not $ClientPath) {
        Say '提示：没有找到 DeepSeek Harness。桌宠可以先运行；安装 Harness 并打开一次后，再运行一次「一键部署.cmd」，或在 设置 → 连接 DeepSeek 中安装连接插件。' 'Yellow'
    } else {
        Say "已找到 DeepSeek Harness：$ClientPath" 'Green'
        while (Get-Process -Name 'DeepSeek Harness' -ErrorAction SilentlyContinue) {
            if ($Yes) { break }
            Say ''
            Say '安装连接插件需要先完全退出 DeepSeek Harness（在托盘图标上右键 → 退出），登录状态会保留。' 'Yellow'
            $answer = Read-Host '退出后按回车继续；输入 S 跳过插件安装'
            if ($answer -match '^[sS]') { break }
        }
        if (Get-Process -Name 'DeepSeek Harness' -ErrorAction SilentlyContinue) {
            Say '跳过了连接插件：DeepSeek Harness 仍在运行。之后可再运行一次「一键部署.cmd」，或在 设置 → 连接 DeepSeek 中安装。' 'Yellow'
        } else {
            $arguments = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $installer, '-ClientPath', $ClientPath)
            if ($DataHome) { $arguments += @('-DataHome', $DataHome) }
            $output = & powershell.exe @arguments 2>&1
            if ($LASTEXITCODE -eq 0) {
                $pluginDone = $true; Say '已安装 Harness 连接插件，重新打开 DeepSeek Harness 后状态和余额会自动同步。' 'Green'
            } else {
                Say ('连接插件没有装上：' + (($output | Select-Object -Last 3) -join ' ')) 'Yellow'
                Say '桌宠仍可使用；处理后再运行一次「一键部署.cmd」，或在 设置 → 连接 DeepSeek 中重试。' 'Yellow'
            }
        }
    }
}

# 5. 快捷方式
$maker = Join-Path $PSScriptRoot 'create_shortcut.ps1'
$desktop = [Environment]::GetFolderPath('Desktop')
& $maker -Destination $desktop -Target $exe.FullName | Out-Null
Say "已创建桌面快捷方式：$($exe.BaseName)" 'Green'
if (-not $NoStartMenu) {
    $menu = [Environment]::GetFolderPath('Programs')
    if ($menu -and (Test-Path -LiteralPath $menu)) {
        & $maker -Destination $menu -Target $exe.FullName | Out-Null
        Say '已添加到开始菜单。' 'Green'
    }
}

# 6. 启动
if (-not $NoLaunch) {
    $running = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith($root, [StringComparison]::OrdinalIgnoreCase) -and $_.ProcessName -like '赛琳娜*' }
    if ($running) { Say '赛琳娜已经在运行了。' 'Green' }
    else { Start-Process -FilePath $exe.FullName -WorkingDirectory $root; Say '正在启动赛琳娜……' 'Green' }
}
Say ''
if ($pluginDone) { Say '部署完成。现在重新打开 DeepSeek Harness 即可；之后从桌面快捷方式启动，有新版本时桌宠会提示一键更新。' 'Magenta' }
else { Say '部署完成。之后从桌面快捷方式启动；有新版本时，桌宠会提示一键更新。' 'Magenta' }
