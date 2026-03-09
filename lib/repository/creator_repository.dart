import '../models/creator_model.dart';
import '../database/database_service.dart';

class CreatorRepository {

  Future<int> createCreator(Creator creator) async {

    final db = await DatabaseService.database;

    return db.insert(
      "creators",
      creator.toMap(),
    );
  }

  Future<List<Creator>> getCreators() async {

    final db = await DatabaseService.database;

    final result = await db.query(
      "creators",
      orderBy: "created_at DESC",
    );

    return result.map((e) => Creator.fromMap(e)).toList();
  }

  Future<Creator?> getCreatorById(int id) async {

    final db = await DatabaseService.database;

    final result = await db.query(
      "creators",
      where: "id=?",
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    return Creator.fromMap(result.first);
  }

  Future<int> updateCreator(Creator creator) async {

    final db = await DatabaseService.database;

    return db.update(
      "creators",
      creator.toMap(),
      where: "id=?",
      whereArgs: [creator.id],
    );
  }

  Future<int> deleteCreator(int id) async {

    final db = await DatabaseService.database;

    return db.delete(
      "creators",
      where: "id=?",
      whereArgs: [id],
    );
  }
}