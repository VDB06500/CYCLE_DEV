// Détection et gestion des environnements
class EnvironmentManager {
    constructor() {
        this.currentEnv = this.detectEnvironment();
        this.config = this.loadConfig();
        this.applyEnvironment();
    }

    detectEnvironment() {
        const url = window.location.hostname;

        if (url.includes('localhost') || url.includes('127.0.0.1') || url.includes('.dev.')) {
            return 'development';
        } else if (url.includes('staging') || url.includes('.recette.') || url.includes('-staging.')) {
            return 'staging';
        } else {
            return 'production';
        }
    }

    loadConfig() {
        // En production, cette config serait chargée depuis un serveur
        return {
            development: {
                name: "🚧 Développement",
                apiUrl: "https://dev-api.cycle-dev.com",
                debug: true,
                warning: "Environnement de développement - Données de test",
                features: {
                    "Paiement en ligne": false,
                    "Analytics": false,
                    "Mode Debug": true,
                    "Fonctions expérimentales": true
                }
            },
            staging: {
                name: "🧪 Recette",
                apiUrl: "https://staging-api.cycle-dev.com",
                debug: true,
                warning: "Environnement de recette - Tests utilisateurs",
                features: {
                    "Paiement en ligne": true,
                    "Analytics": false,
                    "Mode Debug": true,
                    "Fonctions expérimentales": true
                }
            },
            production: {
                name: "🔴 Production",
                apiUrl: "https://api.cycle-dev.com",
                debug: false,
                warning: "Environnement de production - Données réelles",
                features: {
                    "Paiement en ligne": true,
                    "Analytics": true,
                    "Mode Debug": false,
                    "Fonctions expérimentales": false
                }
            }
        }[this.currentEnv];
    }

    applyEnvironment() {
        // Appliquer la classe CSS
        document.body.className = `env-${this.currentEnv}`;

        // Mettre à jour le DOM
        document.getElementById('env-name').textContent = this.config.name;
        document.getElementById('env-warning').textContent = this.config.warning;
        document.getElementById('api-url').textContent = this.config.apiUrl;
        document.getElementById('debug-status').textContent = this.config.debug ? '🟢 Activé' : '🔴 Désactivé';
        document.getElementById('git-branch').textContent = this.currentEnv;

        // Afficher les fonctionnalités
        this.displayFeatures();

        // Logger pour le debug
        if (this.config.debug) {
            console.log(`🎯 Environnement: ${this.currentEnv}`, this.config);
        }
    }

    displayFeatures() {
        const grid = document.getElementById('features-grid');
        grid.innerHTML = '';

        for (const [feature, enabled] of Object.entries(this.config.features)) {
            const card = document.createElement('div');
            card.className = `feature-card ${enabled ? 'feature-enabled' : 'feature-disabled'}`;
            card.innerHTML = `
                <span class="feature-name">${feature}</span>
                <span class="feature-status">${enabled ? '✅ Activé' : '❌ Désactivé'}</span>
            `;
            grid.appendChild(card);
        }
    }

    getCurrentEnvironment() {
        return this.currentEnv;
    }
}

// Initialiser le gestionnaire d'environnement
window.envManager = new EnvironmentManager();