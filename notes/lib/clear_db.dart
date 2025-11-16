import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'services/database_service.dart';

/// Script pour vider complètement la base de données
/// Usage: flutter run -d chrome lib/clear_db.dart
Future<void> main() async {
  // Initialiser SQLite pour le web si nécessaire
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  print('🗑️  Début du vidage de la base de données...');

  try {
    await DatabaseService().clearAllData();
    print('✅ Base de données vidée avec succès !');
  } catch (e) {
    print('❌ Erreur lors du vidage de la base de données: $e');
  }
}

