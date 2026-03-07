class Content {

  final int? id;
  final int creatorId;
  final bool contentReceived;
  final bool contentApproved;
  final String? postingDate;
  final String? contentLink;
  final bool adPermission;

  final int? views;
  final int? likes;
  final int? comments;
  final int? shares;
  final int? saves;

  Content({
    this.id,
    required this.creatorId,
    this.contentReceived = false,
    this.contentApproved = false,
    this.postingDate,
    this.contentLink,
    this.adPermission = false,
    this.views,
    this.likes,
    this.comments,
    this.shares,
    this.saves,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "creator_id": creatorId,
      "content_received": contentReceived ? 1 : 0,
      "content_approved": contentApproved ? 1 : 0,
      "posting_date": postingDate,
      "content_link": contentLink,
      "ad_permission": adPermission ? 1 : 0,
      "views": views,
      "likes": likes,
      "comments": comments,
      "shares": shares,
      "saves": saves
    };
  }

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map["id"],
      creatorId: map["creator_id"],
      contentReceived: map["content_received"] == 1,
      contentApproved: map["content_approved"] == 1,
      postingDate: map["posting_date"],
      contentLink: map["content_link"],
      adPermission: map["ad_permission"] == 1,
      views: map["views"],
      likes: map["likes"],
      comments: map["comments"],
      shares: map["shares"],
      saves: map["saves"],
    );
  }
}