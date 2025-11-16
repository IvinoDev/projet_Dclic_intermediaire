# Notes App - Application Flutter de Prise de Notes

Une application Flutter complète pour la gestion de notes personnelles avec authentification et base de données SQLite locale.

## 🚀 Fonctionnalités

### ✅ Authentification Complète
- **Inscription** : Création de nouveaux comptes utilisateur
- **Connexion** : Authentification sécurisée avec base de données
- **Validation** : Contrôles de saisie et messages d'erreur clairs
- **Interface moderne** : Identifiants de test masqués par défaut
- **Sécurité** : Noms d'utilisateur uniques, validation des mots de passe

### ✅ Gestion des Notes
- **Création** : Ajout de nouvelles notes avec titre et contenu
- **Lecture** : Affichage de toutes les notes dans une liste organisée
- **Modification** : Édition complète des notes existantes
- **Suppression** : Suppression avec confirmation

### ✅ Interface Utilisateur
- Design moderne et intuitif
- Navigation fluide entre les écrans
- Indicateurs de chargement
- Messages de confirmation
- Formatage automatique des dates

### ✅ Base de Données
- Stockage local avec SQLite
- Persistance des données
- Gestion automatique des dates de création/modification

## 🛠️ Installation et Lancement

### Prérequis
- Flutter SDK (version 3.9.2 ou supérieure)
- Dart SDK
- Un émulateur Android/iOS ou un appareil physique

### Étapes d'installation

1. **Cloner le projet** (si applicable)
```bash
git clone <url-du-repo>
cd notes
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Lancer l'application**
```bash
flutter run
```

## 📱 Utilisation

### 1. Première Utilisation
- **Inscription obligatoire** : Cliquez sur "Créer un compte" et remplissez le formulaire
- Aucun compte par défaut n'est créé, vous devez vous inscrire

### 2. Connexion
- Saisissez vos identifiants personnels créés lors de l'inscription
- Utilisez l'œil pour afficher/masquer le mot de passe

### 3. Gestion des Notes
- **Créer une note** : Appuyez sur le bouton `+`
- **Voir une note** : Appuyez sur une note dans la liste
- **Modifier une note** : Appuyez sur une note pour l'ouvrir en édition
- **Supprimer une note** : Utilisez le menu `⋮` sur chaque note

### 4. Navigation
- **Déconnexion** : Bouton de déconnexion dans la barre d'application
- **Retour** : Boutons "Annuler" ou flèche de retour

## 🏗️ Architecture

### Structure du Projet
```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/
│   ├── note.dart            # Modèle de données pour les notes
│   └── user.dart            # Modèle de données pour les utilisateurs
├── services/
│   ├── database_service.dart # Service de gestion SQLite (notes)
│   └── auth_service.dart     # Service d'authentification
├── providers/
│   └── notes_provider.dart   # Gestion d'état avec Provider
└── screens/
    ├── login_screen.dart     # Écran de connexion
    ├── register_screen.dart  # Écran d'inscription
    ├── notes_list_screen.dart # Liste des notes
    └── note_edit_screen.dart  # Édition des notes
```

### Technologies Utilisées
- **Flutter** : Framework de développement
- **Provider** : Gestion d'état
- **SQLite** (sqflite) : Base de données locale
- **Material Design** : Interface utilisateur

### Base de Données
**Table `users` :**
- `id` : Clé primaire auto-incrémentée
- `username` : Nom d'utilisateur (unique)
- `password` : Mot de passe
- `createdAt` : Date de création du compte

**Table `notes` :**
- `id` : Clé primaire auto-incrémentée
- `title` : Titre de la note
- `content` : Contenu de la note
- `createdAt` : Date de création
- `updatedAt` : Date de dernière modification

## 🔧 Développement

### Commandes Utiles
```bash
# Analyser le code
flutter analyze

# Lancer les tests
flutter test

# Construire pour Android
flutter build apk

# Construire pour iOS
flutter build ios
```

### Dépendances Principales
- `sqflite: ^2.3.0` - Base de données SQLite
- `provider: ^6.1.1` - Gestion d'état
- `path: ^1.8.3` - Gestion des chemins de fichiers

## 📋 Fonctionnalités Implémentées

- ✅ **Authentification complète** (inscription + connexion)
- ✅ **Écrans de connexion et inscription** avec validation
- ✅ **Base de données utilisateurs** avec SQLite
- ✅ **Liste des notes** avec tri par date de modification
- ✅ **Création de nouvelles notes**
- ✅ **Édition de notes existantes**
- ✅ **Suppression avec confirmation**
- ✅ **Base de données SQLite locale** (notes + utilisateurs)
- ✅ **Gestion d'état avec Provider**
- ✅ **Interface responsive et intuitive**
- ✅ **Gestion des erreurs et messages utilisateur**
- ✅ **Base de données vide par défaut** (inscription obligatoire)

## 🎯 Prochaines Améliorations Possibles

- 🔄 Synchronisation cloud
- 🔍 Recherche dans les notes
- 🏷️ Système de tags/catégories
- 🌙 Mode sombre
- 📤 Export/Import des notes
- 🔐 Authentification biométrique

---

**Développé avec Flutter** 💙
