class Reminder {

  final int? id;
  final int creatorId;
  final String title;
  final String description;
  final String reminderDate;
  final bool completed;

  Reminder({
    this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.reminderDate,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "creator_id": creatorId,
      "title": title,
      "description": description,
      "reminder_date": reminderDate,
      "completed": completed ? 1 : 0
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map["id"],
      creatorId: map["creator_id"],
      title: map["title"],
      description: map["description"],
      reminderDate: map["reminder_date"],
      completed: map["completed"] == 1,
    );
  }
}