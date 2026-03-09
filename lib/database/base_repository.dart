import 'package:creator_tracker/database/database_service.dart';

class BaseRepository {

  final String table;

  BaseRepository(this.table);

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await DatabaseService.database;
    return db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseService.database;
    return db.query(table);
  }

  Future<List<Map<String, dynamic>>> getByCreator(int creatorId) async {
    final db = await DatabaseService.database;

    return db.query(
      table,
      where: "creator_id=?",
      whereArgs: [creatorId],
    );
  }

  Future<int> update(int id, Map<String, dynamic> data) async {
    final db = await DatabaseService.database;

    return db.update(
      table,
      data,
      where: "id=?",
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DatabaseService.database;

    return db.delete(
      table,
      where: "id=?",
      whereArgs: [id],
    );
  }
}