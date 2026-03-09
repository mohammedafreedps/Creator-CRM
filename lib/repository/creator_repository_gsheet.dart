import 'package:creator_tracker/database/database_service.dart';
import 'package:sqflite/sqflite.dart';
import '../models/creator_model.dart';

class CreatorRepository {

  Future<int> createCreator(Creator creator) async {
    try {
      final db = await DatabaseService.database;

      return await db.insert(
        "creators",
        creator.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

    } catch (e) {
      throw Exception("Failed to create creator: $e");
    }
  }

  Future<List<Creator>> getCreators() async {
    try {
      final db = await DatabaseService.database;

      final result = await db.query("creators");

      return result.map((e) => Creator.fromMap(e)).toList();

    } catch (e) {
      throw Exception("Failed to fetch creators: $e");
    }
  }

  Future<int> updateCreator(Creator creator) async {
    try {
      final db = await DatabaseService.database;

      return await db.update(
        "creators",
        creator.toMap(),
        where: "id=?",
        whereArgs: [creator.id],
      );

    } catch (e) {
      throw Exception("Failed to update creator: $e");
    }
  }

  Future<int> deleteCreator(int id) async {
    try {
      final db = await DatabaseService.database;

      return await db.delete(
        "creators",
        where: "id=?",
        whereArgs: [id],
      );

    } catch (e) {
      throw Exception("Failed to delete creator: $e");
    }
  }
}