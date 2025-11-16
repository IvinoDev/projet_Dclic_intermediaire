import 'package:flutter/foundation.dart';
import '../models/note.dart';
import 'database_manager.dart';
import 'web_storage_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final DatabaseManager _dbManager = DatabaseManager();
  final WebStorageService _webStorage = WebStorageService();

  // Créer une nouvelle note
  Future<int> insertNote(Note note) async {
    if (kIsWeb) {
      debugPrint('🌐 Insertion note WEB: ${note.title}');
      return await _webStorage.addNote(note);
    }

    final db = await _dbManager.database;
    final id = await db.insert('notes', note.toMap());
    debugPrint('Note insérée avec ID: $id, titre: ${note.title}');
    return id;
  }

  // Récupérer toutes les notes
  Future<List<Note>> getAllNotes() async {
    if (kIsWeb) {
      debugPrint('🌐 Chargement notes WEB');
      final notes = await _webStorage.loadNotes();
      // Trier par date de mise à jour
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      debugPrint('🌐 ${notes.length} notes chargées depuis le WEB');
      return notes;
    }

    final db = await _dbManager.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      orderBy: 'updatedAt DESC',
    );

    debugPrint('Nombre de notes récupérées: ${maps.length}');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Récupérer une note par ID
  Future<Note?> getNoteById(int id) async {
    if (kIsWeb) {
      final notes = await _webStorage.loadNotes();
      try {
        return notes.firstWhere((note) => note.id == id);
      } catch (e) {
        return null;
      }
    }

    final db = await _dbManager.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  // Mettre à jour une note
  Future<int> updateNote(Note note) async {
    if (kIsWeb) {
      debugPrint('🌐 Mise à jour note WEB: ${note.title}');
      await _webStorage.updateNote(note);
      return 1; // Succès
    }

    final db = await _dbManager.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Supprimer une note
  Future<int> deleteNote(int id) async {
    if (kIsWeb) {
      debugPrint('🌐 Suppression note WEB ID: $id');
      await _webStorage.deleteNote(id);
      return 1; // Succès
    }

    final db = await _dbManager.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // Vider toutes les données (notes et utilisateurs)
  Future<void> clearAllData() async {
    if (kIsWeb) {
      debugPrint('🌐 Vidage de toutes les données WEB');
      await _webStorage.clearAll();
      debugPrint('🌐 Toutes les données WEB ont été vidées');
    } else {
      debugPrint('📱 Vidage de toutes les données SQLite');
      await _dbManager.clearAllTables();
      debugPrint('📱 Toutes les données SQLite ont été vidées');
    }
  }

  // Fermer la base de données
  Future<void> close() async {
    if (kIsWeb) {
      // Rien à fermer sur le web
      return;
    }

    final db = await _dbManager.database;
    db.close();
  }
}
