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
        Write-Host "Enabling $($feature.Label)..." -ForegroundColor Yellow
        dism.exe /online /enable-feature /featurename:$($feature.Name) /all /norestart
        $restartNeeded = $true
    }
}

if ($restartNeeded) {
    Write-Host "`nYou must restart your computer before continuing WSL setup." -ForegroundColor Red
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

Write-Host "`nChecking for existing dotfiles setup inside WSL..." -ForegroundColor Cyan
$userCheckCommand = "if [ -d ~/dotfiles ]; then echo exists; fi"
$dotfilesExists = wsl -e bash -c "$userCheckCommand"

if ($dotfilesExists -match "exists") {
    Write-Host "`nExisting dotfiles found. Pulling latest and running bootstrap..." -ForegroundColor Cyan
    $runCommand = "cd ~/dotfiles && git branch --set-upstream-to=origin/MultiOS MultiOS && git pull && bash bootstrap.sh"
    Write-Host "Executing in WSL: $runCommand" -ForegroundColor DarkGray
    wsl -e bash -c "$runCommand"
    pause
    exit
}

# --- 4. Prompt for distro selection and install ---
Write-Host "`nAvailable Distros:" -ForegroundColor Green
wsl --list --online

$distro = Read-Host "`nEnter the distro name to install (e.g. Ubuntu)"

if ($distro -ne "") {
    $existingDistros = wsl --list --quiet
    if ($existingDistros -match "^$distro$") {
        Write-Host "`nDistro '$distro' is already installed. Skipping installation." -ForegroundColor Yellow
    } else {
        Write-Host "Installing $distro..." -ForegroundColor Yellow
        wsl --install -d $distro
        Write-Host "`nOnce installation completes, set up your Linux user and password." -ForegroundColor Green
        pause
    }
}

# --- 5. Clone repo and run bootstrap.sh inside WSL ---

$repoURL = "https://github.com/Devan-OHaro/dotfiles.git"
$runIfMissingCommand = "if [ ! -d \"~/dotfiles\" ]; then git clone $repoURL ~/dotfiles; fi && cd ~/dotfiles && bash bootstrap.sh"

Write-Host "`nLaunching WSL to continue setup and run bootstrap.sh..." -ForegroundColor Cyan
Write-Host "Executing in WSL: $runIfMissingCommand" -ForegroundColor DarkGray
wsl -e bash -c "$runIfMissingCommand"
pause

