#!/bin/bash

echo "🚀 Lancement de l'application Notes..."
echo ""

# Vérifier que Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé ou n'est pas dans le PATH"
    exit 1
fi

# Installer les dépendances
echo "📦 Installation des dépendances..."
flutter pub get

# Analyser le code
echo "🔍 Analyse du code..."
flutter analyze

# Lancer l'application
echo "📱 Lancement de l'application..."
echo ""
echo "Identifiants de connexion :"
echo "👤 Utilisateur: admin"
echo "🔑 Mot de passe: password"
echo ""

flutter run