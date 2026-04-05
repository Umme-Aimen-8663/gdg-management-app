import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  static const List<String> _statusOptions = ['Present', 'Absent', 'Late', 'Excused'];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attendance Tracker', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Mark attendance for upcoming meetings and keep records in one place.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 18),
            Expanded(
              child: provider.meetings.isEmpty
                  ? Center(
                      child: Text('No meetings available to track attendance.', style: theme.textTheme.bodyLarge),
                    )
                  : ListView.separated(
                      itemCount: provider.meetings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final meeting = provider.meetings[index];
                        final status = provider.attendanceStatus(meeting['id']);
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(meeting['title'], style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                    ),
                                    Chip(
                                      label: Text(status),
                                      backgroundColor: status == 'Not marked'
                                          ? Colors.grey.shade200
                                          : theme.colorScheme.primary.withOpacity(0.14),
                                      labelStyle: TextStyle(color: status == 'Not marked' ? Colors.grey[700] : theme.colorScheme.primary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text('${meeting['date']} • ${meeting['time']}', style: theme.textTheme.bodyMedium),
                                const SizedBox(height: 6),
                                Text('Team: ${meeting['team']} • ${meeting['location']}', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: _statusOptions.map((option) {
                                    final selected = option == status;
                                    return ChoiceChip(
                                      label: Text(option),
                                      selected: selected,
                                      onSelected: (_) {
                                        provider.markAttendance(meeting['id'], option);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Attendance marked $option')),
                                        );
                                      },
                                      selectedColor: theme.colorScheme.primary.withOpacity(0.18),
                                      backgroundColor: Colors.grey.shade200,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
