class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final List<String> teamIds;
  final String chapterId;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.teamIds,
    required this.chapterId,
  });
}
