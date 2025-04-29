# bootstrap.ps1

Write-Host "== Windows Dotfiles Bootstrapper ==" -ForegroundColor Cyan

# --- 1. Check for required features ---

$features = @(
    @{ Name = "Microsoft-Windows-Subsystem-Linux"; Label = "WSL" },
    @{ Name = "VirtualMachinePlatform"; Label = "Virtual Machine Platform" }
)

foreach ($feature in $features) {
    $status = Get-WindowsOptionalFeature -Online -FeatureName $feature.Name
    if ($status.State -ne "Enabled") {
        Write-Host "Enabling ${($feature.Label)}..." -ForegroundColor Yellow
        dism.exe /online /enable-feature /featurename:$($feature.Name) /all /norestart
        $restartNeeded = $true
    }
}

if ($restartNeeded) {
    Write-Host "\nYou must restart your computer before continuing WSL setup." -ForegroundColor Red
    pause
    exit
}

# --- 2. Ensure WSL2 is default ---
try {
    $wslStatus = wsl --status 2>$null
    if ($wslStatus -notmatch "Default Version: 2") {
        wsl --set-default-version 2
        Write-Host "WSL default version set to 2." -ForegroundColor Green
    }
} catch {
    Write-Host "Failed to get WSL status. Make sure WSL is installed properly." -ForegroundColor Red
    exit 1
}

# --- 3. Check if WSL user and dotfiles directory already exist ---

$userCheckCommand = "test -d ~ && test -d ~/dotfiles"
$exists = wsl bash -c "$userCheckCommand" 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "\nExisting WSL user and dotfiles detected. Running bootstrap.sh..." -ForegroundColor Cyan
    wsl bash -c "cd ~/dotfiles && git pull && bash bootstrap.sh"
    exit
}

# --- 4. Prompt for distro selection and install ---
Write-Host "\nAvailable Distros:" -ForegroundColor Green
wsl --list --online

$distro = Read-Host "\nEnter the distro name to install (e.g. Ubuntu)"

if ($distro -ne "") {
    Write-Host "Installing $distro..." -ForegroundColor Yellow
    wsl --install -d $distro
    Write-Host "\nOnce installation completes, set up your Linux user and password." -ForegroundColor Green
    pause
}

# --- 5. Clone repo and run bootstrap.sh inside WSL ---

$repoURL = "https://github.com/Devan-OHaro/dotfiles.git"
$cloneCommand = "cd ~ && git clone $repoURL && cd dotfiles && bash bootstrap.sh"

Write-Host "\nLaunching WSL to continue setup..." -ForegroundColor Cyan
wsl bash -c "$cloneCommand"

