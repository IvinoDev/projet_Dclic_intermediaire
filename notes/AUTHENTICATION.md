# 🔐 Système d'Authentification - Notes App

## Nouvelles Fonctionnalités

### ✅ Page d'Inscription
- Création de nouveaux comptes utilisateur
- Validation des données (nom d'utilisateur unique, mot de passe sécurisé)
- Interface intuitive avec confirmations

### ✅ Page de Connexion Améliorée
- Identifiants de test masqués par défaut
- Bouton pour afficher/masquer les identifiants de démonstration
- Possibilité de basculer vers l'inscription
- Affichage/masquage du mot de passe

### ✅ Base de Données Étendue
- Table `users` pour stocker les comptes
- Utilisateur admin créé automatiquement
- Gestion des versions de base de données

## 🚀 Comment Utiliser

### 1. Première Utilisation
1. Lancez l'application
2. Vous arrivez sur l'écran de connexion
3. **Option A** : Créez un nouveau compte
   - Cliquez sur "Créer un compte"
   - Remplissez le formulaire d'inscription
   - Vous êtes automatiquement connecté
4. **Option B** : Utilisez le compte de test
   - Cliquez sur "Afficher les identifiants de test"
   - Cliquez sur "Remplir" pour auto-compléter
   - Ou saisissez manuellement : `admin` / `password`

### 2. Inscription
- **Nom d'utilisateur** : 3-20 caractères, lettres, chiffres et _ uniquement
- **Mot de passe** : minimum 6 caractères
- **Confirmation** : doit correspondre au mot de passe
- Validation en temps réel des erreurs

### 3. Connexion
- Saisissez vos identifiants
- Bouton œil pour afficher/masquer le mot de passe
- Messages d'erreur clairs en cas d'échec

## 🛠️ Architecture Technique

### Modèles de Données

#### User (`lib/models/user.dart`)
```dart
class User {
  final int? id;
  final String username;
  final String password;
  final DateTime createdAt;
}
```

#### Note (`lib/models/note.dart`)
```dart
class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### Services

#### AuthService (`lib/services/auth_service.dart`)
- `register(username, password)` : Inscription
- `login(username, password)` : Connexion
- `usernameExists(username)` : Vérification d'unicité
- Gestion de la base de données utilisateurs

#### DatabaseService (`lib/services/database_service.dart`)
- Gestion des notes
- Partage la même base de données que AuthService
- Migration automatique vers la version 2

### Écrans

#### LoginScreen (`lib/screens/login_screen.dart`)
- Interface de connexion moderne
- Identifiants de test masqués par défaut
- Navigation vers l'inscription

#### RegisterScreen (`lib/screens/register_screen.dart`)
- Formulaire d'inscription complet
- Validation en temps réel
- Confirmation de mot de passe

## 🔒 Sécurité

### Implémentations Actuelles
- Validation côté client des données
- Noms d'utilisateur uniques
- Mots de passe minimum 6 caractères

### Améliorations Futures Recommandées
- **Hashage des mots de passe** (bcrypt, Argon2)
- **Authentification biométrique**
- **Tokens JWT** pour les sessions
- **Chiffrement de la base de données**
- **Politique de mots de passe renforcée**

## 📊 Base de Données

### Structure
```sql
-- Table des utilisateurs
CREATE TABLE users(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  createdAt TEXT NOT NULL
);

-- Table des notes (inchangée)
CREATE TABLE notes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL
);
```

### Migration Automatique
- Version 1 → Version 2 : Ajout de la table `users`
- Utilisateur admin créé automatiquement
- Données existantes préservées

## 🧪 Tests

### Scénarios de Test

1. **Inscription Nouvelle**
   - Créer un compte avec un nom unique
   - Vérifier la redirection automatique
   - Tester les validations (nom trop court, mots de passe différents)

2. **Connexion Existante**
   - Se connecter avec le compte admin
   - Tester les identifiants incorrects
   - Vérifier les messages d'erreur

3. **Interface**
   - Basculer entre connexion et inscription
   - Afficher/masquer les identifiants de test
   - Tester l'affichage/masquage des mots de passe

### Commandes de Test
```bash
# Tests unitaires
flutter test

# Analyse du code
flutter analyze

# Lancement de l'app
flutter run
```

## 🎯 Prochaines Étapes Suggérées

1. **Sécurité Renforcée**
   - Hashage des mots de passe
   - Sessions utilisateur
   - Déconnexion automatique

2. **Fonctionnalités Utilisateur**
   - Profil utilisateur
   - Changement de mot de passe
   - Suppression de compte

3. **Notes Personnalisées**
   - Associer les notes aux utilisateurs
   - Notes privées par utilisateur
   - Partage de notes entre utilisateurs

---

**L'authentification est maintenant fonctionnelle !** 🎉