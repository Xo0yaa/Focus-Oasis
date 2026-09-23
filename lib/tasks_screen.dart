import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  final int waterPoints;
  final ValueChanged<int> onWaterPointsChanged;

  const TasksScreen({
    super.key,
    required this.waterPoints,
    required this.onWaterPointsChanged,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // Sample daily focus tasks list
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Complete 1 Pomodoro Session', 'completed': true, 'reward': 10},
    {'title': 'Review Today’s Study Notes', 'completed': false, 'reward': 15},
    {'title': 'Water the Oasis Garden', 'completed': false, 'reward': 5},
    {'title': 'Organize Desk Workspace', 'completed': false, 'reward': 10},
  ];

  void _toggleTask(int index) {
    setState(() {
      final isCompleted = _tasks[index]['completed'] as bool;
      _tasks[index]['completed'] = !isCompleted;

      // Adjust water points based on check/uncheck action
      final reward = _tasks[index]['reward'] as int;
      if (!isCompleted) {
        widget.onWaterPointsChanged(widget.waterPoints + reward);
      } else {
        widget.onWaterPointsChanged(widget.waterPoints - reward);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Tasks & Streaks'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Streak Summary Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Current Streak', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 4),
                      Text('5 Days', style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 20),
                  Column(
                    children: [
                      Text('Water Balance', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 4),
                      Text('${widget.waterPoints} pts', style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Today’s Focus Goals',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Task Items List
          ..._tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: CheckboxListTile(
                title: Text(
                  task['title'],
                  style: TextStyle(
                    decoration: task['completed'] ? TextDecoration.lineThrough : null,
                    color: task['completed'] ? Colors.grey : theme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text('Reward: +${task['reward']} Water Points'),
                value: task['completed'],
                activeColor: theme.colorScheme.primary,
                onChanged: (_) => _toggleTask(index),
              ),
            );
          }),
        ],
      ),
    );
  }
}