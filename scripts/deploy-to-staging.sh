#!/bin/bash

# ---------------------------
# 🚀 Script de déploiement develop → staging
# ---------------------------

# ⚡ Arrêter le script dès qu'une commande échoue
set -e  

# ---------------------------
# 🎨 Couleurs pour les messages dans le terminal
# ---------------------------
RED='\033[0;31m'       # Rouge pour les erreurs
GREEN='\033[0;32m'     # Vert pour succès
YELLOW='\033[1;33m'    # Jaune pour info/alerte
NC='\033[0m'           # No Color pour revenir à la couleur normale

echo -e "${YELLOW}🚀 Déploiement de la branche develop vers staging${NC}"

# ---------------------------
# 🔍 Vérifier si on est dans un repository Git
# ---------------------------
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Ce n'est pas un repository Git${NC}"
    exit 1
fi

# ---------------------------
# 🛑 Vérifier si des modifications locales non commitées existent
# ---------------------------
# Si des fichiers sont modifiés mais pas commités, le script s'arrête
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}❌ Modifications non commitées détectées${NC}"
    git status --short   # Affiche les fichiers modifiés
    exit 1
fi

# ---------------------------
# 📋 Sauvegarder la branche actuelle
# ---------------------------
# Cela permet de revenir dessus à la fin
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

# ---------------------------
# 🌐 Mettre à jour les branches depuis le dépôt distant
# ---------------------------
echo -e "📥 Mise à jour des branches..."
git fetch origin

# ---------------------------
# 🖼 Mini diagramme ASCII : état initial des branches
# ---------------------------
# Pour visualiser la situation avant le merge
echo -e "${YELLOW}🔍 État avant fusion :${NC}"
echo -e "
develop 🌱 : A - B - C   (3 commits sur develop)
staging 🚀: A - B       (2 commits sur staging)
"
echo -e "Objectif : fusionner 🌱 → 🚀"

# ---------------------------
# 🔀 Passer sur staging et récupérer les derniers changements
# ---------------------------
git checkout staging
git pull origin staging

# ---------------------------
# ⚡ Vérifier si un merge est nécessaire
# ---------------------------
if git merge-base --is-ancestor develop staging; then
    # Si develop est déjà inclus dans staging → pas de merge
    echo -e "${YELLOW}📭 Aucun nouveau commit à merger${NC}"
else
    # ---------------------------
    # 🎬 Affichage animé du merge (pour le fun et la pédagogie)
    # ---------------------------
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
    # ---------------------------
    # 🔨 Réaliser le merge réel
    # ---------------------------
    git merge develop -m "Auto-deploy: $(date +'%Y-%m-%d %H:%M:%S')"

    # ---------------------------
    # 🌐 Pousser la branche staging mise à jour sur GitHub
    # ---------------------------
    git push origin staging
    echo -e "${GREEN}🎉 Merge et push réussis!${NC}"
fi

# ---------------------------
# ↩️ Retour sur la branche originale
# ---------------------------
git checkout $CURRENT_BRANCH
echo -e "↩️ Retour sur la branche: ${GREEN}$CURRENT_BRANCH${NC}"

# ---------------------------
# 🖼 Mini diagramme final pour récap visuel
# ---------------------------
echo -e "${GREEN}📊 Résumé visuel final :${NC}"
echo -e "
A = ancien commit
B = ancien commit
C = nouveau commit sur develop

🌱 develop: A - B - C
🚀 staging: A - B - C ✅
"
echo -e "${GREEN}🎯 Déploiement terminé avec succès !${NC}"
