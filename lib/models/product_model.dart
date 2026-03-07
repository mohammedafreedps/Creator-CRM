class ProductTracking {

  final int? id;
  final int creatorId;
  final String productName;
  final String status;
  final String? courier;
  final String? trackingNumber;
  final String? dispatchDate;
  final String? deliveryDate;

  ProductTracking({
    this.id,
    required this.creatorId,
    required this.productName,
    required this.status,
    this.courier,
    this.trackingNumber,
    this.dispatchDate,
    this.deliveryDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "creator_id": creatorId,
      "product_name": productName,
      "status": status,
      "courier": courier,
      "tracking_number": trackingNumber,
      "dispatch_date": dispatchDate,
      "delivery_date": deliveryDate
    };
  }

  factory ProductTracking.fromMap(Map<String, dynamic> map) {
    return ProductTracking(
      id: map["id"],
      creatorId: map["creator_id"],
      productName: map["product_name"],
      status: map["status"],
      courier: map["courier"],
      trackingNumber: map["tracking_number"],
      dispatchDate: map["dispatch_date"],
      deliveryDate: map["delivery_date"],
    );
  }
}