// Configuration des environnements
const ENVIRONMENTS = {
    development: {
        name: "Développement",
        apiBaseUrl: "https://dev-api.cycle-dev.com",
        debug: true,
        features: {
            payment: false,
            analytics: false,
            experimental: true
        },
        style: {
            primaryColor: "#4caf50",
            backgroundColor: "#e8f5e8"
        }
    },
    staging: {
        name: "Recette",
        apiBaseUrl: "https://staging-api.cycle-dev.com",
        debug: true,
        features: {
            payment: true,
            analytics: false,
            experimental: true
        },
        style: {
            primaryColor: "#ff9800",
            backgroundColor: "#fff3e0"
        }
    },
    production: {
        name: "Production",
        apiBaseUrl: "https://api.cycle-dev.com",
        debug: false,
        features: {
            payment: true,
            analytics: true,
            experimental: false
        },
        style: {
            primaryColor: "#f44336",
            backgroundColor: "#ffebee"
        }
    }
};