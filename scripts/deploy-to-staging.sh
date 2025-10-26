#!/bin/bash

# ---------------------------
# 🚀 Script de déploiement develop → staging
# ---------------------------

set -e  # Arrêter si une commande échoue

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Déploiement de la branche develop vers staging${NC}"

# Vérifier repo Git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Ce n'est pas un repository Git${NC}"
    exit 1
fi

# Vérifier modifications non commitées
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}❌ Modifications non commitées détectées${NC}"
    git status --short
    exit 1
fi

# Branche actuelle
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "📋 Branche actuelle: ${GREEN}$CURRENT_BRANCH${NC}"

# Vérifier existence de develop et staging
for branch in develop staging; do
    if ! git show-ref --verify --quiet refs/heads/$branch; then
        echo -e "${RED}❌ La branche $branch n'existe pas${NC}"
        exit 1
    fi
done

# Mise à jour du repo distant
echo -e "📥 Mise à jour des branches..."
git fetch origin

# Mini diagramme ASCII : état initial des branches
echo -e "${YELLOW}🔍 État avant fusion :${NC}"
echo -e "
develop 🌱 : A - B - C
staging 🚀: A - B
"
echo -e "Objectif : fusionner 🌱 → 🚀"

# Passer sur staging et pull
git checkout staging
git pull origin staging

# Vérifier si merge nécessaire
if git merge-base --is-ancestor develop staging; then
    echo -e "${YELLOW}📭 Aucun nouveau commit à merger${NC}"
else
    # Affichage animé du merge
    echo -e "${YELLOW}🔄 Fusion en cours...${NC}"
    sleep 0.5
    echo -e "
Avant merge :
🌱 develop: A - B - C
🚀 staging: A - B
"
    sleep 0.5
    echo -e "Fusion → 🚀 staging reçoit commit C de 🌱 develop"
    sleep 0.5
    echo -e "
Après merge :
🌱 develop: A - B - C
🚀 staging: A - B - C ✅
"
    # Réaliser le merge réel
    git merge develop -m "Auto-deploy: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin staging
    echo -e "${GREEN}🎉 Merge et push réussis!${NC}"
fi

# Retour à la branche originale
git checkout $CURRENT_BRANCH
echo -e "↩️ Retour sur la branche: ${GREEN}$CURRENT_BRANCH${NC}"

# Mini diagramme final
echo -e "${GREEN}📊 Résumé visuel final :${NC}"
echo -e "
A = ancien commit
B = ancien commit
C = nouveau commit sur develop

🌱 develop: A - B - C
🚀 staging: A - B - C ✅
"
echo -e "${GREEN}🎯 Déploiement terminé avec succès !${NC}"
