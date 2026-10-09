import 'dart:async';
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
  final VoidCallback onProgressChanged;

  const TasksScreen({
    super.key,
    required this.prefs,
    required this.waterPoints,
    required this.onWaterPointsChanged,
    required this.onProgressChanged,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  static const _kTasks = 'user_tasks';
  static const _kTasksResetDate = 'tasks_reset_date';
  late List<TaskModel> _tasks;
  Timer? _dailyResetTimer;
  bool _isResettingTasks = false;
  bool _isRefreshingFocusTasks = false;

  @override
  void initState() {
    super.initState();
    _tasks = _loadTasks();
    unawaited(_updateDailyTaskState());
    _dailyResetTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => unawaited(_updateDailyTaskState()),
    );
  }

  Future<void> _updateDailyTaskState() async {
    await _resetTasksForNewDay();
    await _refreshFocusVerifiedTasks();
  }

  String _localDateKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  Future<void> _resetTasksForNewDay() async {
    if (_isResettingTasks) return;
    _isResettingTasks = true;
    try {
      final today = _localDateKey();
      final lastReset = widget.prefs.getString(_kTasksResetDate);
      if (lastReset == null) {
        await widget.prefs.setInt('today_focus_minutes', 0);
        await widget.prefs.setString(_kTasksResetDate, today);
        widget.onProgressChanged();
        return;
      }
      if (lastReset == today || !mounted) return;

      setState(() {
        _tasks = _tasks
            .map((task) => task.copyWith(isCompleted: false, isClaimed: false))
            .toList();
      });
      await widget.prefs.setInt('today_focus_minutes', 0);
      await widget.prefs.setString(
        _kTasks,
        jsonEncode(_tasks.map((task) => task.toJson()).toList()),
      );
      await widget.prefs.setString(_kTasksResetDate, today);
      widget.onProgressChanged();
    } finally {
      _isResettingTasks = false;
    }
  }

  Future<void> _refreshFocusVerifiedTasks() async {
    if (_isRefreshingFocusTasks) return;
    _isRefreshingFocusTasks = true;
    try {
      final focusedMinutes = widget.prefs.getInt('today_focus_minutes') ?? 0;
      var changed = false;
      final updatedTasks = _tasks.map((task) {
        final requiredMinutes = task.requiredFocusMinutes;
        if (requiredMinutes == null || task.isClaimed) return task;
        final isComplete = focusedMinutes >= requiredMinutes;
        if (task.isCompleted == isComplete) return task;
        changed = true;
        return task.copyWith(isCompleted: isComplete);
      }).toList();

      if (changed && mounted) {
        setState(() => _tasks = updatedTasks);
        await _saveTasks();
      }
    } finally {
      _isRefreshingFocusTasks = false;
    }
  }

  @override
  void dispose() {
    _dailyResetTimer?.cancel();
    super.dispose();
  }

  List<TaskModel> _loadTasks() {
    final raw = widget.prefs.getString(_kTasks);
    if (raw == null || raw.isEmpty) return List.of(TaskModel.seedTasks());
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final tasks = decoded
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return tasks.isEmpty ? List.of(TaskModel.seedTasks()) : tasks;
    } catch (_) {
      return List.of(TaskModel.seedTasks());
    }
  }

  Future<void> _saveTasks() async {
    final raw = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await widget.prefs.setString(_kTasks, raw);
    widget.onProgressChanged();
  }

  void _toggle(TaskModel task, bool? value) {
    if (task.isFocusVerifiedTask) return;
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == task.id);
      if (i != -1) {
        _tasks[i] = task.copyWith(isCompleted: value ?? false);
      }
    });
    _saveTasks();
  }

  Future<void> _claim(TaskModel task) async {
    final i = _tasks.indexWhere((current) => current.id == task.id);
    if (i == -1) return;

    final currentTask = _tasks[i];
    if (!currentTask.isCompleted || currentTask.isClaimed) return;

    setState(() {
      _tasks[i] = currentTask.copyWith(isClaimed: true);
    });
    await _saveTasks();
    widget.onWaterPointsChanged(widget.waterPoints + task.rewardPoints);
    await widget.prefs
        .setInt('water_points', widget.waterPoints + task.rewardPoints);
    widget.onProgressChanged();
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
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: AppSpacing.xs,
                      children: [
                        Text(
                          '$doneCount of ${_tasks.length} quests done',
                          style: OasisTextTheme.bodyMedium
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (toClaim > 0)
                          Text('+$toClaim Water Points to claim',
                              style: OasisTextTheme.labelSmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _tasks.isEmpty ? 0 : doneCount / _tasks.length,
                      minHeight: 8,
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation(AppTheme.secondaryColor),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: _tasks.isEmpty
                        ? Center(
                            child: Text('No tasks yet. Add one below.',
                                style: OasisTextTheme.bodyMedium))
                        : ListView.builder(
                            itemCount: _tasks.length,
                            itemBuilder: (context, i) {
                              final task = _tasks[i];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.sm),
                                child: TaskCardTile(
                                  task: task,
                                  todayFocusMinutes:
                                      widget.prefs.getInt('today_focus_minutes') ??
                                          0,
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
