class TeamEntity {
  final String id;
  final String name;
  final String leadId;
  final List<String> memberIds;

  const TeamEntity({
    required this.id,
    required this.name,
    required this.leadId,
    required this.memberIds,
  });
}
