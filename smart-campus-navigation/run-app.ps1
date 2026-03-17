param(
    [string]$AvdName = "Medium_Phone_API_36.1",
    [string]$DeviceId = "emulator-5554",
    [switch]$Clean,
    [switch]$PubGet,
    [switch]$PilotMode = $true,
    [switch]$DemoMode = $true
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$adbPath = Join-Path $env:USERPROFILE "AppData\Local\Android\Sdk\platform-tools\adb.exe"
$emulatorPath = Join-Path $env:USERPROFILE "AppData\Local\Android\Sdk\emulator\emulator.exe"

function Assert-ToolExists {
    param(
        [string]$Path,
        [string]$Name
    )

    if (-not (Test-Path $Path)) {
        throw "$Name not found at: $Path"
    }
}

function Wait-ForDevice {
    param(
        [string]$TargetDeviceId,
        [int]$TimeoutSeconds = 120
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $adbOutput = & $adbPath devices
        if ($adbOutput -match "$TargetDeviceId\s+device") {
            return $true
        }
        Start-Sleep -Seconds 3
    }

    return $false
}

Assert-ToolExists -Path $adbPath -Name "ADB"
Assert-ToolExists -Path $emulatorPath -Name "Android emulator"

Push-Location $projectRoot
try {
    if (-not (Test-Path "pubspec.yaml")) {
        throw "pubspec.yaml not found in project root: $projectRoot"
    }

    Write-Host "Project root: $projectRoot"

    $adbDevices = & $adbPath devices
    if ($adbDevices -notmatch "$DeviceId\s+device") {
        Write-Host "Launching emulator: $AvdName"
        Start-Process -FilePath $emulatorPath -ArgumentList "-avd", $AvdName | Out-Null

        if (-not (Wait-ForDevice -TargetDeviceId $DeviceId)) {
            throw "Emulator did not come online within timeout."
        }
    }

    Write-Host "Emulator online: $DeviceId"

    & $adbPath shell am force-stop com.example.smart_campus_navigation 2>$null | Out-Null

    if ($Clean) {
        Write-Host "Running flutter clean"
        flutter clean
    }

    if ($PubGet -or $Clean) {
        Write-Host "Running flutter pub get"
        flutter pub get
    }

    $dartDefines = @()
    if ($DemoMode) {
        $dartDefines += "--dart-define=DEMO_MODE=true"
    }
    if ($PilotMode) {
        $dartDefines += "--dart-define=PILOT_MODE=true"
    }

    $runArgs = @(
        "run",
        "-d",
        $DeviceId,
        "--android-skip-build-dependency-validation"
    ) + $dartDefines

    Write-Host "Starting Flutter app..."
    & flutter @runArgs
}
finally {
    Pop-Location
}
