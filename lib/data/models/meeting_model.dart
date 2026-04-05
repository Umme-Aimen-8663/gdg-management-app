import '../../domain/entities/meeting_entity.dart';

class MeetingModel extends MeetingEntity {
  const MeetingModel({
    required super.id,
    required super.teamId,
    required super.topic,
    required super.scheduledAt,
    required super.location,
    super.notes,
    super.attachmentUrl,
  });

  factory MeetingModel.fromMap(Map<String, dynamic> map) {
    return MeetingModel(
      id: map['id'] as String,
      teamId: map['teamId'] as String,
      topic: map['topic'] as String,
      scheduledAt: DateTime.parse(map['scheduledAt'] as String),
      location: map['location'] as String,
      notes: map['notes'] as String?,
      attachmentUrl: map['attachmentUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamId': teamId,
      'topic': topic,
      'scheduledAt': scheduledAt.toIso8601String(),
      'location': location,
      'notes': notes,
      'attachmentUrl': attachmentUrl,
    };
  }
}
