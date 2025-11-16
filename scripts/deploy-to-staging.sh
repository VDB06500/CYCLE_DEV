#!/bin/bash

<<<<<<< Updated upstream
# ---------------------------
# 🚀 Script de déploiement develop → staging (VERSION AVANCÉE)
# Avec gestion intelligente des conflits
# ---------------------------

# ⚡ Arrêter le script dès qu'une commande échoue
set -e  

# ---------------------------
# 🎨 Couleurs pour les messages dans le terminal
# ---------------------------
RED='\033[0;31m'       # Rouge pour les erreurs
GREEN='\033[0;32m'     # Vert pour succès
YELLOW='\033[1;33m'    # Jaune pour info/alerte
BLUE='\033[0;34m'      # Bleu pour info
MAGENTA='\033[0;35m'   # Magenta pour questions
NC='\033[0m'           # No Color

# ---------------------------
# 🔧 Configuration
# ---------------------------
MERGE_STRATEGY=${MERGE_STRATEGY:-"manual"}  # manual, auto-develop, auto-staging
INTERACTIVE=${INTERACTIVE:-true}             # Poser des questions ou non

echo -e "${YELLOW}🚀 Déploiement de la branche develop vers staging${NC}"
echo -e "${BLUE}📋 Stratégie de merge: ${MERGE_STRATEGY}${NC}"

# ---------------------------
# 🔍 Vérifier si on est dans un repository Git
# ---------------------------
=======
set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Déploiement develop → staging (avec auto-stash)${NC}"

# Vérifier repository Git
>>>>>>> Stashed changes
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Ce n'est pas un repository Git${NC}"
    exit 1
fi

<<<<<<< Updated upstream
# ---------------------------
# 🛑 Vérifier si des modifications locales non commitées existent
# ---------------------------
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}❌ Modifications non commitées détectées${NC}"
    git status --short
    exit 1
fi

# ---------------------------
# 📋 Sauvegarder la branche actuelle
# ---------------------------
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "📋 Branche actuelle: ${GREEN}$CURRENT_BRANCH${NC}"

# ---------------------------
# ✅ Vérifier que les branches develop et staging existent
# ---------------------------
for branch in develop staging; do
    if ! git show-ref --verify --quiet refs/heads/$branch; then
        echo -e "${RED}❌ La branche $branch n'existe pas${NC}"
        exit 1
    fi
done
=======
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
>>>>>>> Stashed changes

# ---------------------------
# 🌐 Mettre à jour les branches depuis le dépôt distant
# ---------------------------
echo -e "📥 Mise à jour des branches..."
git fetch origin

# ---------------------------
# 🔀 Passer sur staging et récupérer les derniers changements
# ---------------------------
git checkout staging
git pull origin staging

<<<<<<< Updated upstream
# ---------------------------
# ⚡ Vérifier si un merge est nécessaire
# ---------------------------
=======
>>>>>>> Stashed changes
if git merge-base --is-ancestor develop staging; then
    echo -e "${YELLOW}📭 Aucun nouveau commit à merger${NC}"
    git checkout $CURRENT_BRANCH
    echo -e "${GREEN}✅ Staging est déjà à jour avec develop${NC}"
    exit 0
fi

# ---------------------------
# 🎬 Tentative de merge
# ---------------------------
echo -e "${YELLOW}🔄 Fusion en cours...${NC}"

# Désactiver l'arrêt automatique temporairement
set +e
git merge develop -m "Auto-deploy: $(date +'%Y-%m-%d %H:%M:%S')"
MERGE_EXIT_CODE=$?
set -e

# ---------------------------
# ✅ Merge réussi
# ---------------------------
if [ $MERGE_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ Merge réussi sans conflit${NC}"
    git push origin staging
    echo -e "${GREEN}🎉 Merge et push réussis!${NC}"
    git checkout $CURRENT_BRANCH
    echo -e "↩️ Retour sur la branche: ${GREEN}$CURRENT_BRANCH${NC}"
    echo -e "${GREEN}🎯 Déploiement terminé avec succès !${NC}"
    exit 0
fi

# ---------------------------
# ⚠️ CONFLITS DÉTECTÉS - Gestion intelligente
# ---------------------------
echo -e "${RED}⚠️  CONFLITS DE MERGE DÉTECTÉS${NC}"
echo ""

# Lister les fichiers en conflit
CONFLICT_FILES=$(git diff --name-only --diff-filter=U)
echo -e "${YELLOW}📄 Fichiers en conflit:${NC}"
echo "$CONFLICT_FILES" | while read file; do
    echo -e "   ${RED}✖${NC} $file"
done
echo ""

# ---------------------------
# 🤔 Proposer des stratégies de résolution
# ---------------------------
echo -e "${MAGENTA}🔧 STRATÉGIES DE RÉSOLUTION:${NC}"
echo ""
echo -e "${BLUE}1)${NC} ${GREEN}Favoriser develop${NC} (Écraser staging avec develop)"
echo -e "   → Recommandé si develop contient la version la plus récente"
echo ""
echo -e "${BLUE}2)${NC} ${YELLOW}Favoriser staging${NC} (Garder staging, ignorer develop)"
echo -e "   → Recommandé si staging a des correctifs importants"
echo ""
echo -e "${BLUE}3)${NC} ${RED}Annuler${NC} (Stopper le déploiement et résoudre manuellement)"
echo -e "   → Recommandé pour des conflits complexes"
echo ""
echo -e "${BLUE}4)${NC} ${MAGENTA}Résolution manuelle${NC} (Ouvrir les fichiers et résoudre)"
echo -e "   → Pour garder les deux versions ou faire du cherry-picking"
echo ""

# ---------------------------
# 📊 Mode interactif ou automatique
# ---------------------------
if [ "$INTERACTIVE" = true ]; then
    echo -e "${MAGENTA}Votre choix (1/2/3/4): ${NC}"
    read -r CHOICE
else
    # Mode automatique basé sur MERGE_STRATEGY
    case $MERGE_STRATEGY in
        "auto-develop")
            CHOICE=1
            ;;
        "auto-staging")
            CHOICE=2
            ;;
        *)
            CHOICE=3
            ;;
    esac
    echo -e "${BLUE}Mode automatique: Choix $CHOICE${NC}"
fi

# ---------------------------
# 🎯 Exécuter la stratégie choisie
# ---------------------------
case $CHOICE in
    1)
        echo -e "${GREEN}✓ Stratégie: Favoriser develop${NC}"
        echo -e "${YELLOW}⏳ Application des changements de develop...${NC}"
        
        # Accepter toutes les modifications de develop
        git checkout --theirs .
        git add .
        git commit -m "Merge develop into staging - resolved conflicts (favor develop)"
        
        git push origin staging
        echo -e "${GREEN}🎉 Déploiement réussi! (version develop appliquée)${NC}"
        ;;
    
    2)
        echo -e "${YELLOW}✓ Stratégie: Favoriser staging${NC}"
        echo -e "${YELLOW}⏳ Conservation des changements de staging...${NC}"
        
        # Accepter toutes les modifications de staging
        git checkout --ours .
        git add .
        git commit -m "Merge develop into staging - resolved conflicts (favor staging)"
        
        git push origin staging
        echo -e "${GREEN}🎉 Déploiement réussi! (version staging conservée)${NC}"
        ;;
    
    3)
        echo -e "${RED}✖ Déploiement annulé${NC}"
        git merge --abort
        git checkout $CURRENT_BRANCH
        echo ""
        echo -e "${YELLOW}📝 Pour résoudre manuellement:${NC}"
        echo -e "   1. git checkout staging"
        echo -e "   2. git merge develop"
        echo -e "   3. Éditer les fichiers en conflit"
        echo -e "   4. git add <fichiers>"
        echo -e "   5. git commit"
        echo -e "   6. git push origin staging"
        echo ""
        exit 1
        ;;
    
    4)
        echo -e "${MAGENTA}✓ Résolution manuelle${NC}"
        echo ""
        echo -e "${YELLOW}📝 Fichiers à éditer:${NC}"
        echo "$CONFLICT_FILES" | while read file; do
            echo -e "   ${BLUE}→${NC} $file"
        done
        echo ""
        echo -e "${YELLOW}🔍 Cherchez ces marqueurs dans les fichiers:${NC}"
        echo -e "   ${RED}<<<<<<< HEAD${NC}       (version staging)"
        echo -e "   ${BLUE}=======${NC}"
        echo -e "   ${GREEN}>>>>>>> develop${NC}   (version develop)"
        echo ""
        echo -e "${YELLOW}⏳ Une fois les conflits résolus:${NC}"
        echo -e "   1. git add <fichiers-résolus>"
        echo -e "   2. git commit"
        echo -e "   3. Relancez ce script"
        echo ""
        git checkout $CURRENT_BRANCH
        exit 1
        ;;
    
    *)
        echo -e "${RED}❌ Choix invalide${NC}"
        git merge --abort
        git checkout $CURRENT_BRANCH
        exit 1
        ;;
esac

# ---------------------------
# ↩️ Retour sur la branche originale
# ---------------------------
git checkout $CURRENT_BRANCH
echo -e "↩️ Retour sur la branche: ${GREEN}$CURRENT_BRANCH${NC}"

echo -e "${GREEN}🎯 Déploiement terminé avec succès !${NC}"