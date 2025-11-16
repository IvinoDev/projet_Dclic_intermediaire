import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../services/database_service.dart';

class NotesProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  // Charger toutes les notes
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notes = await _databaseService.getAllNotes();
    } catch (e) {
      debugPrint('Erreur lors du chargement des notes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajouter une nouvelle note
  Future<void> addNote(String title, String content) async {
    try {
      final now = DateTime.now();
      final note = Note(
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );

      await _databaseService.insertNote(note);

      // Recharger toutes les notes depuis la base de données
      await loadNotes();
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout de la note: $e');
    }
  }

  // Mettre à jour une note
  Future<void> updateNote(Note note) async {
    try {
      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      await _databaseService.updateNote(updatedNote);

      // Recharger toutes les notes depuis la base de données
      await loadNotes();
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de la note: $e');
    }
  }

  // Supprimer une note
  Future<void> deleteNote(int id) async {
    try {
      await _databaseService.deleteNote(id);

      // Recharger toutes les notes depuis la base de données
      await loadNotes();
    } catch (e) {
      debugPrint('Erreur lors de la suppression de la note: $e');
    }
  }

  // Obtenir une note par ID
  Note? getNoteById(int id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }
}
