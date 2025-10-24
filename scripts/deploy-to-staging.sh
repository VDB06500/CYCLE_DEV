#!/bin/bash

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Déploiement develop → staging (avec auto-stash)${NC}"

# Vérifier repository Git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Ce n'est pas un repository Git${NC}"
    exit 1
fi

CURRENT_BRANCH=$(git branch)
HAS_STASH=false

# Gestion des modifications non commitées
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}📦 Modifications non commitées détectées - création stash...${NC}"
    git stash push -m "Auto-stash: déploiement staging $(date +'%Y-%m-%d %H:%M')"
    HAS_STASH=true
    echo -e "${GREEN}✅ Modifications sauvegardées dans stash${NC}"
fi

# Fonction de nettoyage
cleanup() {
    if [ "$HAS_STASH" = true ]; then
        echo -e "${YELLOW}🔄 Récupération des modifications stashées...${NC}"
        git stash pop
        echo -e "${GREEN}✅ Modifications restaurées${NC}"
    fi
}

# Exécuter cleanup même en cas d'erreur
trap cleanup EXIT

echo -e "📋 Branche actuelle: ${GREEN}$CURRENT_BRANCH${NC}"

# Vérifications des branches
if ! git show-ref --verify --quiet refs/heads/develop; then
    echo -e "${RED}❌ La branche develop n'existe pas${NC}"
    exit 1
fi

if ! git show-ref --verify --quiet refs/heads/staging; then
    echo -e "${RED}❌ La branche staging n'existe pas${NC}"
    exit 1
fi

echo -e "📥 Mise à jour des branches..."
git fetch origin

echo -e "🔄 Fusion develop → staging..."
git checkout staging
git pull origin staging

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