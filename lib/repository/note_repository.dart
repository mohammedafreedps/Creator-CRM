import 'package:creator_tracker/service/database_service.dart';

import '../models/note_model.dart';

class NoteRepository {

  Future<int> addNote(Note note) async {
    try {

      final db = await DatabaseService.database;

      return await db.insert(
        "notes",
        note.toMap(),
      );

    } catch (e) {
      throw Exception("Failed to add note: $e");
    }
  }

  Future<List<Note>> getNotes(int creatorId) async {
    try {

      final db = await DatabaseService.database;

      final result = await db.query(
        "notes",
        where: "creator_id=?",
        whereArgs: [creatorId],
        orderBy: "created_at DESC",
      );

      return result.map((e) => Note.fromMap(e)).toList();

    } catch (e) {
      throw Exception("Failed to fetch notes: $e");
    }
  }

  Future<int> deleteNote(int id) async {
    try {

      final db = await DatabaseService.database;

      return await db.delete(
        "notes",
        where: "id=?",
        whereArgs: [id],
      );

    } catch (e) {
      throw Exception("Failed to delete note: $e");
    }
  }
}