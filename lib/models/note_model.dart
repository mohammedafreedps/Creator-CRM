class Note {

  final int? id;
  final int creatorId;
  final String note;
  final String createdAt;

  Note({
    this.id,
    required this.creatorId,
    required this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "creator_id": creatorId,
      "note": note,
      "created_at": createdAt
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map["id"],
      creatorId: map["creator_id"],
      note: map["note"],
      createdAt: map["created_at"],
    );
  }
}