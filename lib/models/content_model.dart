class Content {

  final int? id;
  final int creatorId;
  final bool contentReceived;
  final bool contentApproved;
  final bool creatorBriefSent;
  final String? postedDate;
  final String? contentLink;
  final bool adPermission;
  
  Content({
    this.id,
    required this.creatorId,
    this.contentReceived = false,
    this.contentApproved = false,
    this.creatorBriefSent = false,
    this.postedDate,
    this.contentLink,
    this.adPermission = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "creator_id": creatorId,
      "content_received": contentReceived ? 1 : 0,
      "content_approved": contentApproved ? 1 : 0,
      "creator_brief_sent": creatorBriefSent ? 1 : 0,
      "posting_date": postedDate,
      "content_link": contentLink,
      "ad_permission": adPermission ? 1 : 0,
    };
  }

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map["id"],
      creatorId: map["creator_id"],
      contentReceived: map["content_received"] == 1,
      contentApproved: map["content_approved"] == 1,
      creatorBriefSent: map["creator_brief_sent"] == 1,
      postedDate: map["posted_date"],
      contentLink: map["content_link"],
      adPermission: map["ad_permission"] == 1,
    );
  }
}