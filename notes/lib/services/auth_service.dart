import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'database_manager.dart';
import 'web_storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseManager _dbManager = DatabaseManager();
  final WebStorageService _webStorage = WebStorageService();

  // Inscription d'un nouvel utilisateur
  Future<bool> register(String username, String password) async {
    // Sur le web, utiliser le stockage simplifié
    if (kIsWeb) {
      return await _registerWeb(username, password);
    }

    // Sur mobile, utiliser SQLite
    return await _registerMobile(username, password);
  }

  // Inscription sur le web (SharedPreferences)
  Future<bool> _registerWeb(String username, String password) async {
    debugPrint('🌐 Inscription WEB pour: $username');
    try {
      final user = User(
        username: username,
        password: password,
        createdAt: DateTime.now(),
      );

      final success = await _webStorage.addUser(user);
      if (success) {
        debugPrint('✅ Inscription WEB réussie pour: $username');
      } else {
        debugPrint('❌ Inscription WEB échouée pour: $username');
      }
      return success;
    } catch (e) {
      debugPrint('❌ Erreur inscription WEB: $e');
      return false;
    }
  }

  // Inscription sur mobile (SQLite)
  Future<bool> _registerMobile(String username, String password) async {
    debugPrint('🚀 DÉBUT INSCRIPTION - Version Debug Avancée');
    debugPrint(
      '📝 Paramètres: username="$username", password="${password.replaceAll(RegExp(r'.'), '*')}"',
    );

    try {
      // Étape 1: Obtenir la base de données
      debugPrint('📊 Étape 1: Connexion à la base de données...');
      final db = await _dbManager.database;
      debugPrint('✅ Base de données connectée');

      // Étape 2: Diagnostic complet AVANT insertion
      debugPrint('📊 Étape 2: Diagnostic pré-insertion...');

      // Vérifier que la table existe
      final tableCheck = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='users'",
      );
      debugPrint('🔍 Table users existe: ${tableCheck.isNotEmpty}');

      if (tableCheck.isEmpty) {
        debugPrint('❌ ERREUR CRITIQUE: Table users n\'existe pas !');
        return false;
      }

      // Compter tous les utilisateurs avec COUNT
      final countResult = await db.rawQuery(
        'SELECT COUNT(*) as total FROM users',
      );
      final totalUsers = countResult.first['total'] as int;
      debugPrint('📊 Nombre total d\'utilisateurs (COUNT): $totalUsers');

      // Lister tous les utilisateurs avec SELECT
      final allUsersQuery = await db.rawQuery('SELECT * FROM users');
      debugPrint('📊 Nombre d\'utilisateurs (SELECT): ${allUsersQuery.length}');

      if (allUsersQuery.isNotEmpty) {
        debugPrint('👥 Utilisateurs existants:');
        for (int i = 0; i < allUsersQuery.length; i++) {
          final user = allUsersQuery[i];
          debugPrint('   ${i + 1}. "${user['username']}" (ID: ${user['id']})');
        }
      } else {
        debugPrint('✅ Aucun utilisateur existant');
      }

      // Étape 3: Vérification spécifique du nom d'utilisateur
      debugPrint(
        '📊 Étape 3: Vérification du nom d\'utilisateur "$username"...',
      );

      // Méthode 1: Query avec WHERE
      final existingUsersWhere = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );
      debugPrint('🔍 Méthode WHERE: ${existingUsersWhere.length} résultat(s)');

      // Méthode 2: Raw query
      final existingUsersRaw = await db.rawQuery(
        'SELECT * FROM users WHERE username = ?',
        [username],
      );
      debugPrint('🔍 Méthode RAW: ${existingUsersRaw.length} résultat(s)');

      // Méthode 3: Vérification manuelle
      bool foundManually = false;
      for (var user in allUsersQuery) {
        if (user['username'] == username) {
          foundManually = true;
          debugPrint(
            '🔍 Trouvé manuellement: ${user['username']} == $username',
          );
          break;
        }
      }
      debugPrint(
        '🔍 Vérification manuelle: ${foundManually ? "TROUVÉ" : "NON TROUVÉ"}',
      );

      // Décision basée sur toutes les vérifications
      if (existingUsersWhere.isNotEmpty ||
          existingUsersRaw.isNotEmpty ||
          foundManually) {
        debugPrint('❌ CONFLIT DÉTECTÉ: L\'utilisateur "$username" existe déjà');
        debugPrint('   - WHERE query: ${existingUsersWhere.length}');
        debugPrint('   - RAW query: ${existingUsersRaw.length}');
        debugPrint('   - Vérification manuelle: $foundManually');
        return false;
      }

      debugPrint('✅ Aucun conflit détecté, procédure d\'insertion...');

      // Étape 4: Préparation des données
      debugPrint('📊 Étape 4: Préparation des données...');
      final now = DateTime.now();
      final userData = {
        'username': username,
        'password': password,
        'createdAt': now.toIso8601String(),
      };
      debugPrint('📝 Données à insérer: $userData');

      // Étape 5: Insertion
      debugPrint('📊 Étape 5: Insertion en base...');
      final insertedId = await db.insert('users', userData);
      debugPrint('✅ Insertion réussie avec ID: $insertedId');

      // Étape 6: Vérification post-insertion
      debugPrint('📊 Étape 6: Vérification post-insertion...');
      final verificationQuery = await db.rawQuery(
        'SELECT COUNT(*) as total FROM users',
      );
      final newTotal = verificationQuery.first['total'] as int;
      debugPrint('📊 Nouveau nombre total d\'utilisateurs: $newTotal');

      final insertedUser = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [insertedId],
      );
      if (insertedUser.isNotEmpty) {
        debugPrint('✅ Utilisateur vérifié: ${insertedUser.first['username']}');
      } else {
        debugPrint('❌ ERREUR: Utilisateur non trouvé après insertion !');
      }

      debugPrint(
        '🎉 SUCCÈS COMPLET: Utilisateur "$username" créé avec ID $insertedId',
      );
      return true;
    } catch (e, stackTrace) {
      debugPrint('💥 ERREUR CRITIQUE lors de l\'inscription:');
      debugPrint('❌ Erreur: $e');
      debugPrint('📍 Stack trace: $stackTrace');
      return false;
    } finally {
      debugPrint('🏁 FIN INSCRIPTION - Version Debug Avancée');
    }
  }

  // Connexion d'un utilisateur
  Future<User?> login(String username, String password) async {
    // Sur le web, utiliser le stockage simplifié
    if (kIsWeb) {
      debugPrint('🌐 Connexion WEB pour: $username');
      return await _webStorage.login(username, password);
    }

    // Sur mobile, utiliser SQLite
    try {
      final db = await _dbManager.database;

      final users = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (users.isNotEmpty) {
        debugPrint('Connexion réussie pour: $username');
        return User.fromMap(users.first);
      }

      debugPrint('Échec de connexion pour: $username');
      return null;
    } catch (e) {
      debugPrint('Erreur lors de la connexion: $e');
      return null;
    }
  }

  // Vérifier si un nom d'utilisateur existe
  Future<bool> usernameExists(String username) async {
    try {
      final db = await _dbManager.database;

      final users = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      return users.isNotEmpty;
    } catch (e) {
      debugPrint('Erreur lors de la vérification du nom d\'utilisateur: $e');
      return false;
    }
  }

  // Obtenir tous les utilisateurs (pour debug)
  Future<List<User>> getAllUsers() async {
    // Sur le web, utiliser le stockage simplifié
    if (kIsWeb) {
      return await _webStorage.loadUsers();
    }

    // Sur mobile, utiliser SQLite
    try {
      final users = await _dbManager.getAllUsers();
      return users.map((user) => User.fromMap(user)).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des utilisateurs: $e');
      return [];
    }
  }

  // Supprimer tous les utilisateurs (pour debug)
  Future<void> clearAllUsers() async {
    if (kIsWeb) {
      await _webStorage.clearUsers();
    } else {
      await _dbManager.clearUsers();
    }
  }

  // Diagnostic complet de la base de données
  Future<String> getDatabaseDiagnostic() async {
    try {
      final db = await _dbManager.database;

      // Vérifier si la table existe
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='users'",
      );

      if (tables.isEmpty) {
        return "❌ PROBLÈME: La table 'users' n'existe pas !";
      }

      // Vérifier la structure de la table
      final tableInfo = await db.rawQuery("PRAGMA table_info(users)");

      // Compter les utilisateurs
      final countResult = await db.rawQuery(
        "SELECT COUNT(*) as count FROM users",
      );
      final userCount = countResult.first['count'] as int;

      // Lister tous les utilisateurs
      final allUsers = await db.query('users');

      String diagnostic = "=== DIAGNOSTIC COMPLET ===\n";
      diagnostic += "✅ Table 'users' existe\n";
      diagnostic += "📊 Structure de la table:\n";
      for (var column in tableInfo) {
        diagnostic += "   - ${column['name']} (${column['type']})\n";
      }
      diagnostic += "👥 Nombre d'utilisateurs: $userCount\n";

      if (allUsers.isNotEmpty) {
        diagnostic += "📋 Liste des utilisateurs:\n";
        for (int i = 0; i < allUsers.length; i++) {
          final user = allUsers[i];
          diagnostic +=
              "   ${i + 1}. '${user['username']}' (ID: ${user['id']})\n";
        }
      } else {
        diagnostic += "✅ Aucun utilisateur dans la base\n";
      }

      return diagnostic;
    } catch (e) {
      return "❌ ERREUR lors du diagnostic: $e";
    }
  }

  // Forcer la recréation complète de la base de données
  Future<void> forceRecreateDatabase() async {
    try {
      debugPrint("🔄 RECRÉATION FORCÉE DE LA BASE DE DONNÉES");
      await _dbManager.resetDatabase();

      // Forcer la recréation en accédant à la base
      final db = await _dbManager.database;
      debugPrint("✅ Base de données recréée avec succès");

      // Vérifier que tout est propre
      final users = await db.query('users');
      debugPrint(
        "✅ Vérification: ${users.length} utilisateurs dans la nouvelle base",
      );
    } catch (e) {
      debugPrint("❌ Erreur lors de la recréation: $e");
    }
  }
}
