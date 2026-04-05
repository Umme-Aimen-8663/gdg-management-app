import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({super.key});

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController(text: 'Conference Room');
  String _selectedTeam = '';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _selectedTeam = provider.teams.isNotEmpty ? provider.teams.first['name'] as String : '';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetings'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Meeting'),
        onPressed: () => _showAddDialog(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meeting schedule', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('See planned meetings and schedule new sessions with ease.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 18),
            Expanded(
              child: provider.meetings.isEmpty
                  ? Center(
                      child: Text('No meetings scheduled yet. Create your first meeting.', style: theme.textTheme.bodyLarge),
                    )
                  : ListView.separated(
                      itemCount: provider.meetings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final meeting = provider.meetings[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(meeting['title'], style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(meeting['team']),
                                      backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(meeting['location'], style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(meeting['date'], style: theme.textTheme.bodyMedium),
                                    const SizedBox(width: 24),
                                    const Icon(Icons.access_time, size: 18, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(meeting['time'], style: theme.textTheme.bodyMedium),
                                  ],
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

  Future<void> _pickDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (selected != null) {
      setState(() {
        _selectedTime = selected;
      });
    }
  }

  void _showAddDialog(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Schedule New Meeting'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Meeting Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedTeam.isEmpty ? null : _selectedTeam,
                  decoration: const InputDecoration(labelText: 'Team'),
                  items: provider.teams
                      .map((team) => DropdownMenuItem(value: team['name'] as String, child: Text(team['name'] as String)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedTeam = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickDate(context),
                        child: Text(DateFormat.yMMMd().format(_selectedDate)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickTime(context),
                        child: Text(_selectedTime.format(context)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final location = _locationController.text.trim();
                if (title.isEmpty || _selectedTeam.isEmpty || location.isEmpty) {
                  return;
                }
                provider.addMeeting(
                  title,
                  DateFormat.yMMMd().format(_selectedDate),
                  _selectedTime.format(context),
                  _selectedTeam,
                  location,
                );
                _titleController.clear();
                _locationController.text = 'Conference Room';
                Navigator.pop(context);
              },
              child: const Text('Schedule'),
            ),
          ],
        );
      },
    );
  }
}
