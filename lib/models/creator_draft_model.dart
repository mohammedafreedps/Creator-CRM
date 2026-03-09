class CreatorDraft {

  // =============================
  // CREATOR (Step 1)
  // =============================
  String? name;
  String? platform;
  String? niche;
  int? followers;
  String? engagementRate;
  String? phone;
  String? email;
  String? address;
  String? location;
  double? rating;
  bool isFavorite = false;
  bool isBlacklisted = false;
  DateTime? createdAt;

  // =============================
  // OUTREACH (Step 2)
  // =============================
  String? outreachStatus;
  DateTime? firstMessageDate;
  DateTime? lastFollowupDate;
  DateTime? nextFollowupDate;
  String? communicationChannel;
  int? followupCount;

  // =============================
  // DEALS (Step 3)
  // =============================
  String? collaborationType;
  double? askedPrice;
  double? finalPrice;
  String? deliverables;
  String? dealStatus;

  // =============================
  // PRODUCT TRACKING (Step 4)
  // =============================
  String? productName;
  String? productStatus;
  String? courier;
  String? trackingNumber;
  DateTime? dispatchDate;
  DateTime? deliveryDate;

  // =============================
  // CONTENT (Step 5)
  // =============================
  bool? contentReceived;
  bool? contentApproved;
  DateTime? postingDate;
  String? contentLink;
  bool? adPermission;

  // =============================
  // PAYMENTS (Step 6)
  // =============================
  double? amount;
  String? paymentStatus;
  DateTime? paymentDate;
  String? paymentMethod;
  String? invoiceNumber;

  // =============================
  // NOTES (Step 7)
  // =============================
  String? note;

  Map<String, dynamic> toMap() {
  return {
    "name": name,
    "platform": platform,
    "niche": niche,
    "followers": followers,
    "engagementRate": engagementRate,
    "phone": phone,
    "email": email,
    "address": address,
    "location": location,

    "outreachStatus": outreachStatus,
    "firstMessageDate": firstMessageDate,
    "lastFollowupDate": lastFollowupDate,
    "nextFollowupDate": nextFollowupDate,
    "communicationChannel": communicationChannel,

    "collaborationType": collaborationType,
    "askedPrice": askedPrice,
    "finalPrice": finalPrice,
    "deliverables": deliverables,
    "productNames": productName,

    "productName": productName,
    "productStatus": productStatus,
    "trackingNumber": trackingNumber,
    "courier": courier,
    "dispatchDate": dispatchDate,
    "deliveryDate": deliveryDate,

    "contentReceived": contentReceived,
    "contentApproved": contentApproved,
    "postingDate": postingDate,
    "adPermission": adPermission,

    "amount": amount,
    "paymentStatus": paymentStatus,
    "paymentDate": paymentDate,
    "paymentMethod": paymentMethod,
    "invoiceNumber": invoiceNumber,

    "note": note,
  };
}
}

