class Outreach {

  final int? id;
  final int creatorId;
  final String? status;
  final String? firstMessageDate;
  final String? lastFollowupDate;
  final String? nextFollowupDate;
  final String? communicationChannel;
  final int followupCount;

  Outreach({
    this.id,
    required this.creatorId,
    this.status,
    this.firstMessageDate,
    this.lastFollowupDate,
    this.nextFollowupDate,
    this.communicationChannel,
    this.followupCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "creator_id": creatorId,
      "status": status,
      "first_message_date": firstMessageDate,
      "last_followup_date": lastFollowupDate,
      "next_followup_date": nextFollowupDate,
      "communication_channel": communicationChannel,
      "followup_count": followupCount
    };
  }

  factory Outreach.fromMap(Map<String, dynamic> map) {
    return Outreach(
      id: map["id"],
      creatorId: map["creator_id"],
      status: map["status"] ?? '',
      firstMessageDate: map["first_message_date"] ?? '',
      lastFollowupDate: map["last_followup_date"] ?? '',
      nextFollowupDate: map["next_followup_date"] ?? '',
      communicationChannel: map["communication_channel"] ?? '',
      followupCount: map["followup_count"] ?? 0,
    );
  }
}