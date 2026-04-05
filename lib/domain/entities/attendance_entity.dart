class AttendanceEntity {
  final String id;
  final String meetingId;
  final String userId;
  final String status;

  const AttendanceEntity({
    required this.id,
    required this.meetingId,
    required this.userId,
    required this.status,
  });
}
