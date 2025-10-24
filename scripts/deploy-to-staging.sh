#!/bin/bash
echo "🚀 Déploiement develop → recette"

# Sauvegarde de la branche actuelle
CURRENT_BRANCH=$(git branch)
echo "Branche actuelle: $CURRENT_BRANCH"

# Vérifications préalables
echo "📋 Vérifications..."
if ! git diff-index --quiet HEAD --; then
    echo "❌ Des modifications non commitées existent. Commit ou stash d'abord."
    exit 1
fi

# Récupérer les dernières versions
echo "📥 Mise à jour des branches..."
git fetch origin

# Merge develop vers recette
echo "🔄 Fusion develop → recette..."
git checkout recette
git pull origin recette
git merge develop -m "Auto-deploy: $(date +'%Y-%m-%d %H:%M:%S')"

if [ $? -eq 0 ]; then
    echo "✅ Merge réussi"
    git push origin recette
    echo "🎉 Déploiement recette terminé avec succès!"
else
    echo "❌ Conflits détectés - Résolution manuelle nécessaire"
    git merge --abort
    echo "🔄 Merge annulé"
fi

# Retour à la branche originale
git checkout $CURRENT_BRANCH
echo "↩️ Retour à la branche: $CURRENT_BRANCH"