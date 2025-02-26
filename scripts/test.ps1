# Couleurs pour le formatage
$Green = [System.ConsoleColor]::Green
$Red = [System.ConsoleColor]::Red
$Blue = [System.ConsoleColor]::Blue

# Fonction pour afficher les messages
function Write-Header {
    param([string]$Message)
    Write-Host "`n=== $Message ===`n" -ForegroundColor $Blue
}

# Fonction pour exécuter une commande et vérifier son résultat
function Invoke-MixCommand {
    param([string]$Command)
    
    Invoke-Expression $Command
    if ($LASTEXITCODE -ne 0) {
        Write-Host "`nErreur lors des tests" -ForegroundColor $Red
        exit 1
    }
}

# Vérifier si un argument a été passé
$command = $args[0]

switch ($command) {
    "unit" {
        Write-Header "Lancement des tests unitaires"
        Invoke-MixCommand "mix test"
    }
    "cover" {
        Write-Header "Lancement des tests avec couverture"
        Invoke-MixCommand "mix coveralls"
    }
    "lint" {
        Write-Header "Lancement du linter (Credo)"
        Invoke-MixCommand "mix credo"
    }
    "all" {
        Write-Header "Lancement de tous les tests"
        
        Write-Header "Tests unitaires"
        Invoke-MixCommand "mix test"
        
        Write-Header "Couverture de code"
        Invoke-MixCommand "mix coveralls"
        
        Write-Header "Linter"
        Invoke-MixCommand "mix credo"
    }
    default {
        Write-Host "Usage: .\test.ps1 {unit|cover|lint|all}" -ForegroundColor $Red
        Write-Host "  unit  : Lance les tests unitaires"
        Write-Host "  cover : Lance les tests avec rapport de couverture"
        Write-Host "  lint  : Lance le linter (Credo)"
        Write-Host "  all   : Lance tous les tests"
        exit 1
    }
}

Write-Host "`nTests terminés avec succès!" -ForegroundColor $Green 