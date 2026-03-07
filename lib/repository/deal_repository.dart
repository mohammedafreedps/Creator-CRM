import 'package:creator_tracker/service/database_service.dart';

import '../models/deal_model.dart';

class DealRepository {

  Future<int> createDeal(Deal deal) async {
    try {

      final db = await DatabaseService.database;

      return await db.insert(
        "deals",
        deal.toMap(),
      );

    } catch (e) {
      throw Exception("Failed to create deal: $e");
    }
  }

  Future<List<Deal>> getDeals(int creatorId) async {
    try {

      final db = await DatabaseService.database;

      final result = await db.query(
        "deals",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      return result.map((e) => Deal.fromMap(e)).toList();

    } catch (e) {
      throw Exception("Failed to fetch deals: $e");
    }
  }

  Future<int> updateDeal(Deal deal) async {
    try {

      final db = await DatabaseService.database;

      return await db.update(
        "deals",
        deal.toMap(),
        where: "id=?",
        whereArgs: [deal.id],
      );

    } catch (e) {
      throw Exception("Failed to update deal: $e");
    }
  }

  Future<int> deleteDeal(int id) async {
    try {

      final db = await DatabaseService.database;

      return await db.delete(
        "deals",
        where: "id=?",
        whereArgs: [id],
      );

    } catch (e) {
      throw Exception("Failed to delete deal: $e");
    }
  }
}