import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final _nameController = TextEditingController();
  final _leadController = TextEditingController();
  final _countController = TextEditingController(text: '6');

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Team directory', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Manage chapter teams and add new squads quickly.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 18),
            Expanded(
              child: provider.teams.isEmpty
                  ? Center(
                      child: Text('No teams yet. Create a team to get started.', style: theme.textTheme.bodyLarge),
                    )
                  : ListView.separated(
                      itemCount: provider.teams.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final team = provider.teams[index];
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
                                      child: Text(team['name'], style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                    ),
                                    Chip(
                                      label: Text('${team['memberCount']} members'),
                                      backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(team['description'], style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline, size: 20, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text('Lead: ${team['lead']}', style: theme.textTheme.bodyMedium),
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

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Create New Team'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Team Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _leadController,
                decoration: const InputDecoration(labelText: 'Team Lead'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _countController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Member Count'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final lead = _leadController.text.trim();
                final count = int.tryParse(_countController.text) ?? 6;
                if (name.isEmpty || lead.isEmpty) {
                  return;
                }
                Provider.of<AppProvider>(context, listen: false).addTeam(name, lead, memberCount: count);
                _nameController.clear();
                _leadController.clear();
                _countController.text = '6';
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
