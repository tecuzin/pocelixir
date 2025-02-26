# Couleurs pour le formatage
$Green = [System.ConsoleColor]::Green
$Red = [System.ConsoleColor]::Red
$Blue = [System.ConsoleColor]::Blue
$Yellow = [System.ConsoleColor]::Yellow

# Fonction pour afficher les messages
function Write-Step {
    param([string]$Message)
    Write-Host "`n=== $Message ===`n" -ForegroundColor $Blue
}

# Fonction pour vérifier si une commande existe
function Test-CommandExists {
    param([string]$Command)
    
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Fonction pour installer un package Chocolatey
function Install-ChocoPackage {
    param(
        [string]$PackageName,
        [string]$Description
    )
    
    Write-Host "Installation de $Description..." -ForegroundColor $Yellow
    choco install $PackageName -y
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erreur lors de l'installation de $Description" -ForegroundColor $Red
        exit 1
    }
    Write-Host "$Description installé avec succès" -ForegroundColor $Green
    Write-Host "------------------------" -ForegroundColor $Blue
}

# Vérifier si le script est exécuté en tant qu'administrateur
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Ce script doit être exécuté en tant qu'administrateur!" -ForegroundColor $Red
    Write-Host "Veuillez relancer PowerShell en tant qu'administrateur et réessayer." -ForegroundColor $Yellow
    exit 1
}

# Vérifier si Chocolatey est installé
Write-Step "Vérification de Chocolatey"

if (-not (Test-CommandExists "choco")) {
    Write-Host "Installation de Chocolatey..." -ForegroundColor $Yellow
    
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    catch {
        Write-Host "Erreur lors de l'installation de Chocolatey" -ForegroundColor $Red
        Write-Host $_.Exception.Message -ForegroundColor $Red
        exit 1
    }
    
    Write-Host "Chocolatey installé avec succès" -ForegroundColor $Green
    # Recharger le PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Installation des dépendances
Write-Step "Installation des dépendances"

# Installation d'Erlang (prérequis pour Elixir)
Install-ChocoPackage "erlang" "Erlang"

# Installation d'Elixir
Install-ChocoPackage "elixir" "Elixir"

# Installation de Git si nécessaire
if (-not (Test-CommandExists "git")) {
    Install-ChocoPackage "git" "Git"
}

# Installation de Make si nécessaire
if (-not (Test-CommandExists "make")) {
    Install-ChocoPackage "make" "Make"
}

# Recharger le PATH pour prendre en compte les nouvelles installations
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Vérification des installations
Write-Step "Vérification des installations"

# Vérifier Elixir
if (Test-CommandExists "elixir") {
    Write-Host "Elixir version :" -ForegroundColor $Yellow
    elixir --version
} else {
    Write-Host "Erreur : Elixir n'est pas correctement installé" -ForegroundColor $Red
    exit 1
}

# Vérifier Mix
if (Test-CommandExists "mix") {
    Write-Host "`nMix est correctement installé" -ForegroundColor $Green
} else {
    Write-Host "Erreur : Mix n'est pas correctement installé" -ForegroundColor $Red
    exit 1
}

# Installation réussie
Write-Host @"

Installation terminée avec succès!

Pour continuer :
1. Fermez et rouvrez votre terminal PowerShell
2. Naviguez vers le dossier du projet
3. Exécutez : .\scripts\install.ps1

"@ -ForegroundColor $Green

# Demander à l'utilisateur s'il veut redémarrer PowerShell
$restart = Read-Host "Voulez-vous redémarrer PowerShell maintenant? (O/N)"
if ($restart -eq "O" -or $restart -eq "o") {
    Start-Process powershell
    exit
} 