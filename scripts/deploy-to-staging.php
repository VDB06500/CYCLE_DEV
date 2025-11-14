<?php
// deploy-staging.php
header('Content-Type: text/plain');

// Exécuter le script Bash
$script = './deploy-to-staging.sh';  // chemin relatif ou absolu vers ton .sh

// Vérifier que le script existe et est exécutable
if (!file_exists($script) || !is_executable($script)) {
    http_response_code(500);
    echo "❌ Script introuvable ou non exécutable";
    exit;
}

// Exécuter le script et capturer la sortie
$output = [];
$return_var = 0;
exec($script . ' 2>&1', $output, $return_var);

if ($return_var !== 0) {
    http_response_code(500);
    echo "❌ Erreur lors du déploiement\n";
} else {
    echo "✅ Déploiement terminé avec succès\n";
}

echo implode("\n", $output);
