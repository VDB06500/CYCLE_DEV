#!/bin/bash

set -e  # Arrêter en cas d'erreur

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Déploiement develop → staging${NC}"

# Vérifier si on est dans un repository Git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Ce n'est pas un repository Git${NC}"
    exit 1
fi

# Vérifier les modifications non commitées
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}❌ Modifications non commitées détectées${NC}"
    echo "Veuillez commit ou stash vos modifications avant de déployer."
    git status --short
    exit 1
fi

# Sauvegarde branche actuelle
CURRENT_BRANCH=$(git branch --show-current)
echo -e "📋 Branche actuelle: ${GREEN}$CURRENT_BRANCH${NC}"

# Vérifier que develop existe
if ! git show-ref --verify --quiet refs/heads/develop; then
    echo -e "${RED}❌ La branche develop n'existe pas${NC}"
    exit 1
fi

# Vérifier que staging existe
if ! git show-ref --verify --quiet refs/heads/staging; then
    echo -e "${RED}❌ La branche staging n'existe pas${NC}"
    exit 1
fi

echo -e "📥 Mise à jour des branches..."
git fetch origin

echo -e "🔄 Fusion develop → staging..."
git checkout staging
git pull origin staging

# Vérifier s'il y a des choses à merger
if git merge-base --is-ancestor develop staging; then
    echo -e "${YELLOW}📭 Aucun nouveau commit à merger${NC}"
else
    git merge develop -m "Auto-deploy: $(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "${GREEN}✅ Merge réussi${NC}"
    git push origin staging
    echo -e "${GREEN}🎉 Déploiement staging terminé!${NC}"
fi

# Retour à la branche originale
git checkout $CURRENT_BRANCH
echo -e "↩️ Retour à la branche: ${GREEN}$CURRENT_BRANCH${NC}"