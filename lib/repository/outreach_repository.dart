import 'package:creator_tracker/service/database_service.dart';

import '../models/outreach_model.dart';

class OutreachRepository {

  Future<int> createOutreach(Outreach outreach) async {
    try {
      final db = await DatabaseService.database;

      return await db.insert(
        "outreach",
        outreach.toMap(),
      );

    } catch (e) {
      throw Exception("Failed to create outreach: $e");
    }
  }

  Future<List<Outreach>> getCreatorOutreach(int creatorId) async {
    try {
      final db = await DatabaseService.database;

      final result = await db.query(
        "outreach",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      return result.map((e) => Outreach.fromMap(e)).toList();

    } catch (e) {
      throw Exception("Failed to fetch outreach: $e");
    }
  }

  Future<int> updateOutreach(Outreach outreach) async {
    try {
      final db = await DatabaseService.database;

      return await db.update(
        "outreach",
        outreach.toMap(),
        where: "id=?",
        whereArgs: [outreach.id],
      );

    } catch (e) {
      throw Exception("Failed to update outreach: $e");
    }
  }

  Future<int> deleteOutreach(int id) async {
    try {
      final db = await DatabaseService.database;

      return await db.delete(
        "outreach",
        where: "id=?",
        whereArgs: [id],
      );

    } catch (e) {
      throw Exception("Failed to delete outreach: $e");
    }
  }
}