import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card_tile.dart';
import '../widgets/water_point_badge.dart';

/// The Daily Tasks screen: docs/02-mockup.png screen 4.
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
    if (raw == null || raw.isEmpty) return List.of(TaskModel.seedTasks());
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final tasks = decoded.map((e) => TaskModel.fromJson(e as Map<String, dynamic>)).toList();
      return tasks.isEmpty ? List.of(TaskModel.seedTasks()) : tasks;
    } catch (_) {
      return List.of(TaskModel.seedTasks());
    }
  }

  Future<void> _saveTasks() async {
    final raw = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await widget.prefs.setString(_kTasks, raw);
  }

  void _toggle(TaskModel task, bool? value) {
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == task.id);
      if (i != -1) {
        _tasks[i] = task.copyWith(isCompleted: value ?? false);
      }
    });
    _saveTasks();
  }

  void _claim(TaskModel task) {
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == task.id);
      if (i != -1) {
        _tasks[i] = task.copyWith(isClaimed: true);
      }
    });
    _saveTasks();
    widget.onWaterPointsChanged(widget.waterPoints + task.rewardPoints);
    widget.prefs.setInt('water_points', widget.waterPoints + task.rewardPoints);
  }

  Future<void> _openAddTaskDialog() async {
    final controller = TextEditingController();
    int reward = 20;

    final result = await showDialog<Map<String, dynamic>>(
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
              onPressed: () {
                final title = controller.text.trim();
                if (title.isNotEmpty) {
                  Navigator.pop(context, {'title': title, 'reward': reward});
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (result == null || !mounted) return;

    final newTask = TaskModel(
      id: 'task-${DateTime.now().millisecondsSinceEpoch}',
      title: result['title'] as String,
      rewardPoints: result['reward'] as int,
    );

    setState(() {
      // FIX: new list instead of .add() on a possibly unmodifiable list
      _tasks = [..._tasks, newTask];
    });

    await _saveTasks();
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
              // Adjusted top padding for clean balance below the App Bar
              const SizedBox(height: AppSpacing.md),
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: TaskCardTile(
                              task: task,
                              onToggle: (v) => _toggle(task, v),
                              onClaim: () => _claim(task),
                            ),
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