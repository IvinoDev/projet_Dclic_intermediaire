import 'database_manager.dart';

class DatabaseResetService {
  static Future<void> resetDatabase() async {
    final dbManager = DatabaseManager();
    await dbManager.resetDatabase();
  }

  static Future<void> clearAllTables() async {
    final dbManager = DatabaseManager();
    await dbManager.clearAllTables();
  }
}
