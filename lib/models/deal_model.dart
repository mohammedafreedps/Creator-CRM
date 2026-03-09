class Deal {

  final int? id;
  final int creatorId;
  final String collaborationType;
  final double? askedPrice;
  final double? finalPrice;
  final String? deliverables;
  final int? productCount;
  final String status;

  Deal({
    this.id,
    required this.creatorId,
    required this.collaborationType,
    this.askedPrice,
    this.finalPrice,
    this.deliverables,
    this.productCount,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "creator_id": creatorId,
      "collaboration_type": collaborationType,
      "asked_price": askedPrice,
      "final_price": finalPrice,
      "deliverables": deliverables,
      "product_count": productCount,
      "status": status
    };
  }

  factory Deal.fromMap(Map<String, dynamic> map) {
    return Deal(
      id: map["id"],
      creatorId: map["creator_id"],
      collaborationType: map["collaboration_type"],
      askedPrice: map["asked_price"],
      finalPrice: map["final_price"],
      deliverables: map["deliverables"],
      productCount: map["product_count"],
      status: map["status"],
    );
  }
}