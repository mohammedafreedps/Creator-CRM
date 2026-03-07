import 'package:creator_tracker/service/database_service.dart';

import '../models/reminder_model.dart';

class ReminderRepository {

  Future<int> addReminder(Reminder reminder) async {
    try {

      final db = await DatabaseService.database;

      return await db.insert(
        "reminders",
        reminder.toMap(),
      );

    } catch (e) {
      throw Exception("Failed to add reminder: $e");
    }
  }

  Future<List<Reminder>> getReminders(int creatorId) async {
    try {

      final db = await DatabaseService.database;

      final result = await db.query(
        "reminders",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      return result.map((e) => Reminder.fromMap(e)).toList();

    } catch (e) {
      throw Exception("Failed to fetch reminders: $e");
    }
  }

  Future<int> updateReminder(Reminder reminder) async {
    try {

      final db = await DatabaseService.database;

      return await db.update(
        "reminders",
        reminder.toMap(),
        where: "id=?",
        whereArgs: [reminder.id],
      );

    } catch (e) {
      throw Exception("Failed to update reminder: $e");
    }
  }

  Future<int> deleteReminder(int id) async {
    try {

      final db = await DatabaseService.database;

      return await db.delete(
        "reminders",
        where: "id=?",
        whereArgs: [id],
      );

    } catch (e) {
      throw Exception("Failed to delete reminder: $e");
    }
  }
}