import 'package:creator_tracker/service/database_service.dart';

import '../models/product_model.dart';

class ProductRepository {

  Future<int> addProduct(ProductTracking product) async {
    try {

      final db = await DatabaseService.database;

      return await db.insert(
        "product_tracking",
        product.toMap(),
      );

    } catch (e) {
      throw Exception("Failed to add product: $e");
    }
  }

  Future<List<ProductTracking>> getProducts(int creatorId) async {
    try {

      final db = await DatabaseService.database;

      final result = await db.query(
        "product_tracking",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      return result.map((e) => ProductTracking.fromMap(e)).toList();

    } catch (e) {
      throw Exception("Failed to fetch products: $e");
    }
  }

  Future<int> updateProduct(ProductTracking product) async {
    try {

      final db = await DatabaseService.database;

      return await db.update(
        "product_tracking",
        product.toMap(),
        where: "id=?",
        whereArgs: [product.id],
      );

    } catch (e) {
      throw Exception("Failed to update product: $e");
    }
  }

  Future<int> deleteProduct(int id) async {
    try {

      final db = await DatabaseService.database;

      return await db.delete(
        "product_tracking",
        where: "id=?",
        whereArgs: [id],
      );

    } catch (e) {
      throw Exception("Failed to delete product: $e");
    }
  }
}