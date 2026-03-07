import 'package:creator_tracker/service/database_service.dart';

import '../models/payment_model.dart';

class PaymentRepository {

  Future<int> addPayment(Payment payment) async {
    try {

      final db = await DatabaseService.database;

      return await db.insert(
        "payments",
        payment.toMap(),
      );

    } catch (e) {
      throw Exception("Failed to add payment: $e");
    }
  }

  Future<List<Payment>> getPayments(int creatorId) async {
    try {

      final db = await DatabaseService.database;

      final result = await db.query(
        "payments",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      return result.map((e) => Payment.fromMap(e)).toList();

    } catch (e) {
      throw Exception("Failed to fetch payments: $e");
    }
  }

  Future<int> updatePayment(Payment payment) async {
    try {

      final db = await DatabaseService.database;

      return await db.update(
        "payments",
        payment.toMap(),
        where: "id=?",
        whereArgs: [payment.id],
      );

    } catch (e) {
      throw Exception("Failed to update payment: $e");
    }
  }
}