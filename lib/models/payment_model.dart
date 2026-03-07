class Payment {

  final int? id;
  final int creatorId;
  final double amount;
  final String status;
  final String? paymentDate;
  final String? paymentMethod;
  final String? invoiceNumber;

  Payment({
    this.id,
    required this.creatorId,
    required this.amount,
    required this.status,
    this.paymentDate,
    this.paymentMethod,
    this.invoiceNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "creator_id": creatorId,
      "amount": amount,
      "status": status,
      "payment_date": paymentDate,
      "payment_method": paymentMethod,
      "invoice_number": invoiceNumber
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map["id"],
      creatorId: map["creator_id"],
      amount: map["amount"],
      status: map["status"],
      paymentDate: map["payment_date"],
      paymentMethod: map["payment_method"],
      invoiceNumber: map["invoice_number"],
    );
  }
}