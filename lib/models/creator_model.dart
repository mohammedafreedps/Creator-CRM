class Creator {
  final int? id;
  final String name;
  final String platform;
  final String niche;
  final int followers;
  final String engagementRate;
  final String? phone;
  final String? email;
  final String? address;
  final String? location;
  final double? rating;
  final bool isFavorite;
  final bool isBlacklisted;
  final String createdAt;

  Creator({
    this.id,
    required this.name,
    required this.platform,
    required this.niche,
    required this.followers,
    required this.engagementRate,
    this.phone,
    this.email,
    this.address,
    this.location,
    this.rating,
    this.isFavorite = false,
    this.isBlacklisted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "platform": platform,
      "niche": niche,
      "followers": followers,
      "engagement_rate": engagementRate,
      "phone": phone,
      "email": email,
      "address": address,
      "location": location,
      "rating": rating,
      "is_favorite": isFavorite ? 1 : 0,
      "is_blacklisted": isBlacklisted ? 1 : 0,
      "created_at": createdAt
    };
  }

  factory Creator.fromMap(Map<String, dynamic> map) {
    return Creator(
      id: map["id"],
      name: map["name"],
      platform: map["platform"],
      niche: map["niche"],
      followers: map["followers"],
      engagementRate: map["engagement_rate"],
      phone: map["phone"],
      email: map["email"],
      address: map["address"],
      location: map["location"],
      rating: map["rating"],
      isFavorite: map["is_favorite"] == 1,
      isBlacklisted: map["is_blacklisted"] == 1,
      createdAt: map["created_at"],
    );
  }
}