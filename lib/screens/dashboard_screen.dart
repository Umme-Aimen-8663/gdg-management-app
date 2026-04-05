import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'login_screen.dart';
import 'teams_screen.dart';
import 'meetings_screen.dart';
import 'attendance_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _roleMessage(String role) {
    switch (role) {
      case 'chapter_lead':
        return 'Lead chapter operations and keep the community aligned.';
      case 'team_lead':
        return 'Coordinate your team and ensure every meeting runs smoothly.';
      default:
        return 'Stay connected with your team and mark attendance with ease.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GDG Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            tooltip: 'Logout',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 4),
            Text(provider.userName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Chip(
              label: Text(provider.displayRole),
              backgroundColor: theme.colorScheme.primary.withOpacity(0.14),
              labelStyle: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Role overview', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(_roleMessage(provider.userRole), style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                    Icon(Icons.insights, size: 58, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.05,
              children: [
                _summaryCard(context, Icons.groups, 'Teams', provider.totalTeams.toString(), Colors.indigo),
                _summaryCard(context, Icons.event_available, 'Meetings', provider.totalMeetings.toString(), Colors.deepPurple),
                _summaryCard(context, Icons.check_circle_outline, 'Attendance', provider.totalAttendance.toString(), Colors.teal),
                _summaryCard(context, Icons.people, 'Role', provider.displayRole, Colors.purple),
              ],
            ),
            const SizedBox(height: 24),
            Text('Quick Actions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _actionCard(context, Icons.group, 'Teams', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeamsScreen()))),
                _actionCard(context, Icons.event, 'Meetings', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MeetingsScreen()))),
                _actionCard(context, Icons.checklist, 'Attendance', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(BuildContext context, IconData icon, String title, String value, Color color) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(title, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 30),
            const SizedBox(height: 18),
            Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Manage $label', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}
