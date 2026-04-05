import '../entities/team_entity.dart';

abstract class TeamRepository {
  Stream<List<TeamEntity>> teamsForChapter(String chapterId);
  Stream<List<TeamEntity>> teamsForUser(String userId, List<String> userTeamIds);
  Future<void> createTeam(TeamEntity team);
  Future<void> updateTeam(TeamEntity team);
  Future<void> deleteTeam(String teamId);
}
