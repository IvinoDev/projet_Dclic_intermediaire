import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/note.dart';

/// Service de stockage spécifique pour le web utilisant SharedPreferences
class WebStorageService {
  static const String _usersKey = 'web_users';
  static const String _notesKey = 'web_notes';

  // Sauvegarder les utilisateurs
  Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((u) => u.toMap()).toList();
    await prefs.setString(_usersKey, jsonEncode(usersJson));
    debugPrint('💾 ${users.length} utilisateurs sauvegardés sur le web');
  }

  // Charger les utilisateurs
  Future<List<User>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(_usersKey);

    if (usersString == null) {
      debugPrint('📂 Aucun utilisateur trouvé sur le web');
      return [];
    }

    final List<dynamic> usersJson = jsonDecode(usersString);
    final users = usersJson.map((json) => User.fromMap(json)).toList();
    debugPrint('📂 ${users.length} utilisateurs chargés depuis le web');
    return users;
  }

  // Ajouter un utilisateur
  Future<bool> addUser(User user) async {
    try {
      final users = await loadUsers();

      // Vérifier si l'utilisateur existe déjà
      if (users.any((u) => u.username == user.username)) {
        debugPrint('❌ Utilisateur ${user.username} existe déjà');
        return false;
      }

      // Générer un ID
      final newId = users.isEmpty
          ? 1
          : users.map((u) => u.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      final userWithId = user.copyWith(id: newId);

      users.add(userWithId);
      await saveUsers(users);

      debugPrint('✅ Utilisateur ${user.username} ajouté avec ID $newId');
      return true;
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'ajout de l\'utilisateur: $e');
      return false;
    }
  }

  // Vérifier les identifiants
  Future<User?> login(String username, String password) async {
    try {
      final users = await loadUsers();

      for (var user in users) {
        if (user.username == username && user.password == password) {
          debugPrint('✅ Connexion réussie pour ${user.username}');
          return user;
        }
      }

      debugPrint('❌ Identifiants incorrects pour $username');
      return null;
    } catch (e) {
      debugPrint('❌ Erreur lors de la connexion: $e');
      return null;
    }
  }

  // Supprimer tous les utilisateurs
  Future<void> clearUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
    debugPrint('🗑️ Tous les utilisateurs supprimés');
  }

  // Sauvegarder les notes
  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((n) => n.toMap()).toList();
    await prefs.setString(_notesKey, jsonEncode(notesJson));
    debugPrint('💾 ${notes.length} notes sauvegardées sur le web');
  }

  // Charger les notes
  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString(_notesKey);

    if (notesString == null) {
      return [];
    }

    final List<dynamic> notesJson = jsonDecode(notesString);
    return notesJson.map((json) => Note.fromMap(json)).toList();
  }

  // Ajouter une note
  Future<int> addNote(Note note) async {
    final notes = await loadNotes();
    final newId = notes.isEmpty
        ? 1
        : notes.map((n) => n.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    final noteWithId = note.copyWith(id: newId);
    notes.add(noteWithId);
    await saveNotes(notes);
    return newId;
  }

  // Mettre à jour une note
  Future<void> updateNote(Note note) async {
    final notes = await loadNotes();
    final index = notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      notes[index] = note;
      await saveNotes(notes);
    }
  }

  // Supprimer une note
  Future<void> deleteNote(int id) async {
    final notes = await loadNotes();
    notes.removeWhere((n) => n.id == id);
    await saveNotes(notes);
  }

  // Supprimer toutes les notes
  Future<void> clearNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notesKey);
    debugPrint('🗑️ Toutes les notes supprimées');
  }

  // Tout supprimer
  Future<void> clearAll() async {
    await clearUsers();
    await clearNotes();
    debugPrint('🗑️ Toutes les données supprimées');
  }
}
