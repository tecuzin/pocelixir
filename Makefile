# Variables
SHELL := pwsh.exe
.SHELLFLAGS := -NoProfile -Command

# Couleurs pour Windows PowerShell
BLUE = Write-Host "`n=== $1 ===`n" -ForegroundColor Blue;
GREEN = Write-Host $1 -ForegroundColor Green;
RED = Write-Host $1 -ForegroundColor Red;

# Cibles principales
.PHONY: all all_my_app all_blockchain test run_my_app run_blockchain install setup

# Cible par défaut
all: all_blockchain

# Chaînes de dépendances complètes
all_my_app: install setup test run_my_app

all_blockchain: install setup test run_blockchain

# Installation des dépendances
install:
	@$(call BLUE,Installation des dépendances)
	@if (!(Test-Path "scripts/setup_windows.ps1")) { \
		$(call RED,Le script setup_windows.ps1 est manquant!); \
		exit 1; \
	}
	@.\scripts\setup_windows.ps1

# Configuration initiale du projet
setup: install
	@$(call BLUE,Configuration du projet)
	@if (!(Test-Path "scripts/install.ps1")) { \
		$(call RED,Le script install.ps1 est manquant!); \
		exit 1; \
	}
	@.\scripts\install.ps1

# Exécution des tests
test:
	@$(call BLUE,Exécution des tests)
	@if (!(Test-Path "scripts/test.ps1")) { \
		$(call RED,Le script test.ps1 est manquant!); \
		exit 1; \
	}
	@.\scripts\test.ps1 all

# Lancement de my_app
run_my_app: test
	@$(call BLUE,Lancement de my_app)
	mix phx.server

# Lancement de blockchain
run_blockchain: test
	@$(call BLUE,Lancement de blockchain)
	iex -S mix

# Cibles utilitaires
clean:
	@$(call BLUE,Nettoyage du projet)
	@if (Test-Path "_build") { Remove-Item "_build" -Recurse -Force }
	@if (Test-Path "deps") { Remove-Item "deps" -Recurse -Force }
	@$(call GREEN,Nettoyage terminé)

help:
	@Write-Host "Cibles disponibles:" -ForegroundColor Yellow
	@Write-Host "  all            : Exécute la chaîne complète pour blockchain (par défaut)"
	@Write-Host "  all_my_app     : Installation + Setup + Tests + Lancement de my_app"
	@Write-Host "  all_blockchain : Installation + Setup + Tests + Lancement de blockchain"
	@Write-Host "  install        : Installation des dépendances"
	@Write-Host "  setup         : Configuration du projet"
	@Write-Host "  test          : Exécution des tests"
	@Write-Host "  run_my_app    : Lancement de my_app"
	@Write-Host "  run_blockchain: Lancement de blockchain"
	@Write-Host "  clean         : Nettoyage du projet"
	@Write-Host "  help          : Affiche cette aide" 