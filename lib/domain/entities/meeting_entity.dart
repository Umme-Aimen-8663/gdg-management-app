class MeetingEntity {
  final String id;
  final String teamId;
  final String topic;
  final DateTime scheduledAt;
  final String location;
  final String? notes;
  final String? attachmentUrl;

  const MeetingEntity({
    required this.id,
    required this.teamId,
    required this.topic,
    required this.scheduledAt,
    required this.location,
    this.notes,
    this.attachmentUrl,
  });
}
