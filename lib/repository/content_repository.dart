import 'package:creator_tracker/service/database_service.dart';

import '../models/content_model.dart';

class ContentRepository {

  Future<int> addContent(Content content) async {
    try {

      final db = await DatabaseService.database;

      return await db.insert(
        "content",
        content.toMap(),
      );

    } catch (e) {
      throw Exception("Failed to add content: $e");
    }
  }

  Future<List<Content>> getContent(int creatorId) async {
    try {

      final db = await DatabaseService.database;

      final result = await db.query(
        "content",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      return result.map((e) => Content.fromMap(e)).toList();

    } catch (e) {
      throw Exception("Failed to fetch content: $e");
    }
  }

  Future<int> updateContent(Content content) async {
    try {

      final db = await DatabaseService.database;

      return await db.update(
        "content",
        content.toMap(),
        where: "id=?",
        whereArgs: [content.id],
      );

    } catch (e) {
      throw Exception("Failed to update content: $e");
    }
  }

  Future<int> deleteContent(int id) async {
    try {

      final db = await DatabaseService.database;

      return await db.delete(
        "content",
        where: "id=?",
        whereArgs: [id],
      );

    } catch (e) {
      throw Exception("Failed to delete content: $e");
    }
  }
}