import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'web_storage_service.dart'
    if (dart.library.io) 'web_storage_service_stub.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db');

    debugPrint('Initialisation de la base de données: $path');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    debugPrint('Création de la base de données version $version');

    // Créer la table des notes
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Créer la table des utilisateurs
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    debugPrint('Tables créées avec succès');
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    debugPrint(
      'Mise à jour de la base de données de v$oldVersion vers v$newVersion',
    );

    if (oldVersion < 2) {
      // Ajouter la table users si elle n'existe pas
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL,
          createdAt TEXT NOT NULL
        )
      ''');
      debugPrint('Table users ajoutée');
    }
  }

  // Méthodes utilitaires pour le debug
  Future<void> resetDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'notes.db');

      // Fermer la connexion existante
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      // Supprimer complètement la base de données
      await deleteDatabase(path);

      debugPrint('Base de données supprimée avec succès');
    } catch (e) {
      debugPrint('Erreur lors de la suppression de la base de données: $e');
    }
  }

  Future<void> clearAllTables() async {
    try {
      final db = await database;

      // Vider toutes les tables
      await db.delete('notes');
      await db.delete('users');

      debugPrint('Toutes les tables ont été vidées');
    } catch (e) {
      debugPrint('Erreur lors du vidage des tables: $e');
    }
  }

  Future<void> clearUsers() async {
    try {
      final db = await database;
      await db.delete('users');
      debugPrint('Table users vidée');
    } catch (e) {
      debugPrint('Erreur lors du vidage de la table users: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final db = await database;
      final users = await db.query('users');
      debugPrint('Récupération de ${users.length} utilisateurs');
      return users;
    } catch (e) {
      debugPrint('Erreur lors de la récupération des utilisateurs: $e');
      return [];
    }
  }
}
