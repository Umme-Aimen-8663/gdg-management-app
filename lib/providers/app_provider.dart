import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  String userRole = 'member';
  String userName = 'GDG Member';

  final List<Map<String, dynamic>> teams = [
    {
      'id': 'team-1',
      'name': 'Mobile Development',
      'lead': 'Samra Arif',
      'memberCount': 8,
      'description': 'Build Flutter apps and mobile solutions for the chapter.',
    },
    {
      'id': 'team-2',
      'name': 'AI & ML',
      'lead': 'Meher Ali',
      'memberCount': 6,
      'description': 'Design smart experiences with machine learning.',
    },
    {
      'id': 'team-3',
      'name': 'Community Growth',
      'lead': 'Imran Khan',
      'memberCount': 5,
      'description': 'Drive outreach, mentoring, and event planning.',
    },
  ];

  final List<Map<String, dynamic>> meetings = [
    {
      'id': 'meet-1',
      'title': 'Weekly Sync',
      'date': '2026-04-06',
      'time': '10:00 AM',
      'team': 'Mobile Development',
      'location': 'Hybrid Room A',
    },
    {
      'id': 'meet-2',
      'title': 'Project Review',
      'date': '2026-04-07',
      'time': '02:00 PM',
      'team': 'AI & ML',
      'location': 'Online Zoom',
    },
    {
      'id': 'meet-3',
      'title': 'Chapter Strategy',
      'date': '2026-04-09',
      'time': '04:30 PM',
      'team': 'Community Growth',
      'location': 'Main Hall',
    },
  ];

  final List<Map<String, dynamic>> attendanceRecords = [];

  String get displayRole {
    switch (userRole) {
      case 'chapter_lead':
        return 'Chapter Lead';
      case 'team_lead':
        return 'Team Lead';
      default:
        return 'Member';
    }
  }

  int get totalTeams => teams.length;
  int get totalMeetings => meetings.length;
  int get totalAttendance => attendanceRecords.length;

  void changeUser(String role, String name) {
    userRole = role;
    userName = name.isNotEmpty ? name : 'GDG Member';
    notifyListeners();
  }

  void addTeam(String name, String lead, {int memberCount = 5}) {
    teams.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'lead': lead,
      'memberCount': memberCount,
      'description': 'Active team driving chapter goals.',
    });
    notifyListeners();
  }

  void addMeeting(String title, String date, String time, String team, String location) {
    meetings.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'date': date,
      'time': time,
      'team': team,
      'location': location,
    });
    notifyListeners();
  }

  void markAttendance(String meetingId, String status) {
    final existingIndex = attendanceRecords.indexWhere((record) => record['meetingId'] == meetingId);
    final record = {
      'meetingId': meetingId,
      'status': status,
      'markedAt': DateTime.now().toIso8601String(),
    };

    if (existingIndex >= 0) {
      attendanceRecords[existingIndex] = record;
    } else {
      attendanceRecords.add(record);
    }
    notifyListeners();
  }

  String attendanceStatus(String meetingId) {
    final record = attendanceRecords.firstWhere(
      (entry) => entry['meetingId'] == meetingId,
      orElse: () => {},
    );

    if (record.isEmpty) {
      return 'Not marked';
    }

    final status = record['status'] as String;
    return status[0].toUpperCase() + status.substring(1);
  }
}
