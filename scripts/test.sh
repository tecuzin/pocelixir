#!/bin/bash

# Couleurs pour le formatage
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Vérifier si un argument a été passé
case "$1" in
    "unit")
        print_header "Lancement des tests unitaires"
        mix test
        ;;
    "cover")
        print_header "Lancement des tests avec couverture"
        mix coveralls
        ;;
    "lint")
        print_header "Lancement du linter (Credo)"
        mix credo
        ;;
    "all")
        print_header "Lancement de tous les tests"
        
        print_header "Tests unitaires"
        mix test
        
        print_header "Couverture de code"
        mix coveralls
        
        print_header "Linter"
        mix credo
        ;;
    *)
        echo -e "${RED}Usage: $0 {unit|cover|lint|all}${NC}"
        echo "  unit  : Lance les tests unitaires"
        echo "  cover : Lance les tests avec rapport de couverture"
        echo "  lint  : Lance le linter (Credo)"
        echo "  all   : Lance tous les tests"
        exit 1
        ;;
esac

# Vérifier si la dernière commande a réussi
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}Tests terminés avec succès!${NC}"
else
    echo -e "\n${RED}Erreur lors des tests${NC}"
    exit 1
fi 