/// TaskModel(id, title, isCompleted, rewardPoints) — see Proposal V2
/// section IV, "What I Save Concretely", and Data the App Remembers
/// section VII. Stored as a JSON string list under the 'user_tasks' key.
class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isClaimed;
  final int rewardPoints;

  const TaskModel({
    required this.id,
    required this.title,
    required this.rewardPoints,
    this.isCompleted = false,
    this.isClaimed = false,
  });

  TaskModel copyWith({bool? isCompleted, bool? isClaimed}) {
    return TaskModel(
      id: id,
      title: title,
      rewardPoints: rewardPoints,
      isCompleted: isCompleted ?? this.isCompleted,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'isClaimed': isClaimed,
        'rewardPoints': rewardPoints,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as String,
        title: json['title'] as String,
        isCompleted: json['isCompleted'] as bool? ?? false,
        // Older saved tasks (from before isClaimed existed) default to
        // false rather than crashing on a missing key.
        isClaimed: json['isClaimed'] as bool? ?? false,
        rewardPoints: json['rewardPoints'] as int? ?? 0,
      );

  /// Shown the first time the app runs, before any real tasks are saved.
  /// Matches docs/02-mockup.png screen 4.
  // FIX: list is growable (was const = unmodifiable)
  static List<TaskModel> seedTasks() => [
        const TaskModel(id: 'seed-1', title: 'Focus for 25 minutes', rewardPoints: 50),
        const TaskModel(id: 'seed-2', title: 'Plan today\'s tasks', rewardPoints: 20),
        const TaskModel(id: 'seed-3', title: 'Water your plants', rewardPoints: 20),
      ];
}
