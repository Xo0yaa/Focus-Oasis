import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card_tile.dart';
import '../widgets/water_point_badge.dart';

/// The Daily Tasks screen: docs/02-mockup.png screen 4.
///
/// Reads and writes `user_tasks` in shared_preferences (Proposal V2,
/// section IV). waterPoints itself stays lifted in MainNavigationScreen —
/// this screen only reports a claim upward through [onWaterPointsChanged],
/// the same pattern TimerHomeScreen uses, so the balance chip agrees on
/// both tabs.
class TasksScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final int waterPoints;
  final ValueChanged<int> onWaterPointsChanged;

  const TasksScreen({
    super.key,
    required this.prefs,
    required this.waterPoints,
    required this.onWaterPointsChanged,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  static const _kTasks = 'user_tasks';
  late List<TaskModel> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _loadTasks();
  }

  List<TaskModel> _loadTasks() {
    final raw = widget.prefs.getString(_kTasks);
    if (raw == null || raw.isEmpty) return TaskModel.seedTasks();
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final tasks = decoded.map((e) => TaskModel.fromJson(e as Map<String, dynamic>)).toList();
      return tasks.isEmpty ? TaskModel.seedTasks() : tasks;
    } catch (_) {
      // Saved data didn't parse — fall back rather than crash the screen.
      return TaskModel.seedTasks();
    }
  }

  Future<void> _saveTasks() async {
    final raw = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await widget.prefs.setString(_kTasks, raw);
  }

  void _toggle(TaskModel task, bool? value) {
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == task.id);
      _tasks[i] = task.copyWith(isCompleted: value ?? false);
    });
    _saveTasks();
  }

  void _claim(TaskModel task) {
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == task.id);
      _tasks[i] = task.copyWith(isClaimed: true);
    });
    _saveTasks();
    widget.onWaterPointsChanged(widget.waterPoints + task.rewardPoints);
    widget.prefs.setInt('water_points', widget.waterPoints + task.rewardPoints);
  }

  Future<void> _openAddTaskDialog() async {
    final controller = TextEditingController();
    int reward = 20;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Task title'),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Reward', style: OasisTextTheme.labelSmall),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                children: [20, 40, 60].map((points) {
                  return ChoiceChip(
                    label: Text('+$points'),
                    selected: reward == points,
                    onSelected: (_) => setDialogState(() => reward = points),
                    selectedColor: AppTheme.accentWater.withOpacity(0.25),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.pop(context, jsonEncode({'title': controller.text.trim(), 'reward': reward})),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (result == null) return;
    final decoded = jsonDecode(result) as Map<String, dynamic>;
    final title = decoded['title'] as String;
    if (title.isEmpty) return;

    setState(() {
      _tasks.add(TaskModel(
        id: 'task-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        rewardPoints: decoded['reward'] as int,
      ));
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _tasks.where((t) => t.isCompleted).length;
    final toClaim = _tasks
        .where((t) => t.isCompleted && !t.isClaimed)
        .fold<int>(0, (sum, t) => sum + t.rewardPoints);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: Text('Daily Tasks', style: OasisTextTheme.headlineSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: WaterPointBadge(points: widget.waterPoints),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$doneCount of ${_tasks.length} quests done',
                      style: OasisTextTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  if (toClaim > 0)
                    Text('+$toClaim Water Points to claim', style: OasisTextTheme.labelSmall),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _tasks.isEmpty ? 0 : doneCount / _tasks.length,
                  minHeight: 8,
                  backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation(AppTheme.secondaryColor),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: _tasks.isEmpty
                    ? Center(
                        child: Text('No tasks yet. Add one below.', style: OasisTextTheme.bodyMedium))
                    : ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, i) {
                          final task = _tasks[i];
                          return TaskCardTile(
                            task: task,
                            onToggle: (v) => _toggle(task, v),
                            onClaim: () => _claim(task),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTaskDialog,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
    );
  }
}
