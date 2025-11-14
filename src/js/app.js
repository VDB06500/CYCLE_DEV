// Script principal de l'application
function simulateDeployment(targetEnv) {
    const currentEnv = window.envManager.getCurrentEnvironment();

    if (targetEnv === currentEnv) {
        alert(`✅ Déjà sur l'environnement ${targetEnv}`);
        return;
    }

    const confirmMessage = {
        'development': '🚀 Déployer cette version en développement?',
        'staging': '🧪 Déployer cette version en recette pour tests?',
        'production': '🔴 DÉPLOIEMENT PRODUCTION - Êtes-vous ABSOLUMENT certain?'
    }[targetEnv];

    if (confirm(confirmMessage)) {
        console.log(`📦 Simulation déploiement: ${currentEnv} → ${targetEnv}`);

        // Simulation d'un déploiement
        setTimeout(() => {
            alert(`✅ Déploiement simulé vers ${targetEnv} réussi!`);

            // En vrai, on redirigerait vers l'URL de l'environnement cible
            const urls = {
                'development': 'http://localhost:3000',
                'staging': 'https://staging.cycle-dev.com',
                'production': 'https://cycle-dev.com'
            };

            console.log(`Redirection vers: ${urls[targetEnv]}`);
            // window.location.href = urls[targetEnv];
        }, 1000);
    }
}

function deployStaging() {
    if (confirm("🧪 Déployer cette version en recette pour tests?")) {
        fetch('../../scripts/deploy-staging.sh')
            .then(response => response.text())
            .then(data => {
                alert(`Résultat du déploiement:\n${data}`);
            })
            .catch(err => {
                alert(`❌ Erreur lors du déploiement: ${err}`);
            });
    }
}

// Initialisation
document.addEventListener('DOMContentLoaded', function () {
    console.log('🚀 CYCLE_DEV - Application initialisée');
    console.log('Environnement:', window.envManager.getCurrentEnvironment());
});