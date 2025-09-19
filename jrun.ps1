# made by github.com/bipknit
# PowerShell version

param(
    [switch]$Debug,
    [switch]$MeasureTime,
    [switch]$Help,
    [switch]$Version,
    [string]$File
)

$ver = "2.0"
$dbgInfo = "the program ended running"

# map of extensions to commands
$runmap = @{
    "py"   = "python"
    "c"    = "gcc"
    "cpp"  = "g++"
    "java" = "javac"
    "d"    = "dmd"
    "go"   = "go run"
    "js"   = "node"
    "ts"   = "ts-node"
    "rb"   = "ruby"
    "rs"   = "rustc"
    "kt"   = "kotlinc"
    "swift"= "swift"
    "php"  = "php"
    "sh"   = "bash"
    "pl"   = "perl"
    "lua"  = "lua"
}

function Show-Help {
    @"
Usage: r.ps1 [-Debug] [-MeasureTime] [-Version] [-Help] [File]

Options:
  -Debug          Enable debug mode
  -MeasureTime    Measure runtime of the program
  -Version        Shows the version number
  -Help           Show this help message

Examples:
  .\r.ps1 main.c
  .\r.ps1 -Debug main.c
  .\r.ps1 -MeasureTime main.c
  .\r.ps1 -Debug -MeasureTime main.c
  .\r.ps1
"@
}

function Show-Version {
    Write-Output "Version: $ver"
}

function FExists {
    param([string]$ext)
    if (-not $runmap.ContainsKey($ext) -and $ext -notin @("class","out")) {
        Write-Error "Unknown or missing file extension: $ext"
        exit 1
    }
}

function AutoSelectFile {
    if ($File) { return }

    $candidates = @()
    foreach ($ext in $runmap.Keys) {
        $matches = Get-ChildItem -Path . -Filter "*.$ext"
        if ($matches.Count -eq 1) {
            $candidates += $matches.Name
        } elseif ($matches.Count -gt 1) {
            Write-Error "Multiple .$ext files found. Please specify which one to run."
            exit 1
        }
    }

    if ($candidates.Count -eq 1) {
        $File = $candidates[0]
        Write-Output "Auto-selecting $File"
    } else {
        Write-Error "No unique file found to run"
        exit 1
    }
}

if ($Help) { Show-Help; exit }
if ($Version) { Show-Version; exit }

AutoSelectFile
$ext = [System.IO.Path]::GetExtension($File).TrimStart('.')
FExists $ext
$cmd = "$($runmap[$ext]) $File"

if ($Debug) {
    Write-Output "debug header start"
    Write-Output "Debug=$Debug"
    Write-Output "File=$File"
    Write-Output "Extension=$ext"
    Write-Output "Default command=$cmd"
    Write-Output "Measuring time=$MeasureTime"
    Write-Output "debug header ended"
}

switch ($ext) {
    "c","cpp" {
        $exe = "a.exe"
        if (Test-Path $exe -and (Get-Item $exe).LastWriteTime -gt (Get-Item $File).LastWriteTime) {
            if ($MeasureTime) { Measure-Command { & .\$exe } } else { & .\$exe }
        } else {
            & $runmap[$ext] $File -o $exe
            if ($MeasureTime) { Measure-Command { & .\$exe } } else { & .\$exe }
        }
    }
    "d" {
        $bin = [System.IO.Path]::GetFileNameWithoutExtension($File) + ".exe"
        if (Test-Path $bin -and (Get-Item $bin).LastWriteTime -gt (Get-Item $File).LastWriteTime) {
            if ($MeasureTime) { Measure-Command { & .\$bin } } else { & .\$bin }
        } else {
            & $runmap[$ext] $File
            if ($MeasureTime) { Measure-Command { & .\$bin } } else { & .\$bin }
        }
    }
    "java" {
        $classname = [System.IO.Path]::GetFileNameWithoutExtension($File)
        if (Test-Path "$classname.class" -and (Get-Item "$classname.class").LastWriteTime -gt (Get-Item $File).LastWriteTime) {
            if ($MeasureTime) { Measure-Command { java $classname } } else { java $classname }
        } else {
            javac $File
            if ($MeasureTime) { Measure-Command { java $classname } } else { java $classname }
        }
    }
    "class" {
        java ([System.IO.Path]::GetFileNameWithoutExtension($File))
    }
    "out" {
        & .\$File
    }
    default {
        if ($MeasureTime) { Measure-Command { Invoke-Expression $cmd } } else { Invoke-Expression $cmd }
    }
}

if ($Debug) { Write-Output $dbgInfo }
