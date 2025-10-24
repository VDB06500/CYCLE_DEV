// Charge la configuration selon l'environnement
class ConfigLoader {
    constructor() {
        this.env = this.detectEnvironment();
        this.config = {};
        this.loadConfig();
    }

    detectEnvironment() {
        const hostname = window.location.hostname;

        if (hostname.includes('localhost') || hostname.includes('127.0.0.1') || hostname.includes('.dev.')) {
            return 'development';
        } else if (hostname.includes('staging') || hostname.includes('.recette.')) {
            return 'staging';
        } else {
            return 'production';
        }
    }

    async loadConfig() {
        try {
            const response = await fetch(`../config/${this.env}.js`);
            const configText = await response.text();

            // Extraire l'objet config du fichier JS
            const configMatch = configText.match(/const config = ({[\s\S]*?});/);
            if (configMatch) {
                this.config = eval(`(${configMatch[1]})`);
                this.applyConfig();
            }
        } catch (error) {
            console.error('Erreur chargement config:', error);
            this.loadFallbackConfig();
        }
    }

    loadFallbackConfig() {
        this.config = {
            environment: this.env,
            apiUrl: "https://fallback-api.com",
            debug: true,
            features: { payment: false, analytics: false }
        };
        this.applyConfig();
    }

    applyConfig() {
        // Mettre à jour l'interface
        document.getElementById('env-name').textContent = this.config.environment;
        document.getElementById('api-url').textContent = this.config.apiUrl;
        document.getElementById('debug-mode').textContent = this.config.debug ? 'Activé' : 'Désactivé';

        // Appliquer les classes CSS selon l'environnement
        document.body.className = `env-${this.config.environment}`;

        // Afficher les fonctionnalités
        this.displayFeatures();
    }

    displayFeatures() {
        const featuresList = document.getElementById('features-list');
        featuresList.innerHTML = '';

        for (const [feature, enabled] of Object.entries(this.config.features)) {
            const featureEl = document.createElement('div');
            featureEl.className = `feature ${enabled ? 'enabled' : 'disabled'}`;
            featureEl.innerHTML = `
                <span class="feature-name">${feature}</span>
                <span class="feature-status">${enabled ? '✅' : '❌'}</span>
            `;
            featuresList.appendChild(featureEl);
        }
    }
}

// Initialiser le chargeur de configuration
window.configLoader = new ConfigLoader();