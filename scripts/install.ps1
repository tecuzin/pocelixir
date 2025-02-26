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

# Fonction pour exécuter une commande avec gestion d'erreur
function Invoke-SafeCommand {
    param(
        [string]$Command,
        [string]$ErrorMessage
    )
    
    Write-Host "> $Command" -ForegroundColor $Yellow
    
    Invoke-Expression $Command
    if ($LASTEXITCODE -ne 0) {
        Write-Host "`n$ErrorMessage" -ForegroundColor $Red
        exit 1
    }
}

# Vérification des prérequis
Write-Step "Vérification des prérequis"

if (-not (Test-CommandExists "elixir")) {
    Write-Host "Erreur: Elixir n'est pas installé." -ForegroundColor $Red
    Write-Host "Veuillez installer Elixir depuis : https://elixir-lang.org/install.html" -ForegroundColor $Yellow
    exit 1
}

if (-not (Test-CommandExists "mix")) {
    Write-Host "Erreur: Mix n'est pas installé correctement." -ForegroundColor $Red
    Write-Host "Veuillez réinstaller Elixir depuis : https://elixir-lang.org/install.html" -ForegroundColor $Yellow
    exit 1
}

# Afficher les versions
Write-Host "Versions installées :"
Invoke-Expression "elixir --version"
Write-Host ""

# Nettoyage des dépendances existantes
Write-Step "Nettoyage de l'environnement"
if (Test-Path "_build") {
    Remove-Item "_build" -Recurse -Force
}
if (Test-Path "deps") {
    Remove-Item "deps" -Recurse -Force
}

# Installation des dépendances
Write-Step "Installation des dépendances"
Invoke-SafeCommand "mix deps.get" "Erreur lors de l'installation des dépendances"

# Compilation du projet
Write-Step "Compilation du projet"
Invoke-SafeCommand "mix compile" "Erreur lors de la compilation"

# Configuration de l'environnement de développement
Write-Step "Configuration de l'environnement de développement"

# Création des répertoires nécessaires s'ils n'existent pas
$directories = @(
    "lib/blockchain",
    "test/blockchain",
    "priv/repo/migrations",
    "config"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Création du répertoire: $dir" -ForegroundColor $Yellow
    }
}

# Vérification de la configuration initiale
Write-Step "Vérification de l'installation"
Invoke-SafeCommand "mix test" "Erreur lors des tests initiaux"

# Installation terminée avec succès
Write-Host "`nInstallation terminée avec succès!" -ForegroundColor $Green
Write-Host @"

Pour commencer à développer :
1. Lancer les tests : .\scripts\test.ps1 unit
2. Vérifier la couverture : .\scripts\test.ps1 cover
3. Lancer le linter : .\scripts\test.ps1 lint

Pour lancer tous les tests : .\scripts\test.ps1 all

"@ -ForegroundColor $Yellow 