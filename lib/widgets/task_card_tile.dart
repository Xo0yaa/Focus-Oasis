import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import 'water_point_badge.dart';

/// The three states from docs/DESIGN_SYSTEM_V3.pdf section X, TaskCardTile:
/// uncompleted, completed-not-claimed (shows Claim), and claimed.
class TaskCardTile extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onClaim;

  const TaskCardTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = OasisTextTheme.bodyMedium.copyWith(
      fontWeight: FontWeight.bold,
      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
      color: task.isCompleted ? AppTheme.disabledText : AppTheme.textColor,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              // Once claimed, the checkbox can't be unchecked — the reward
              // is already banked, so undoing it would need to claw the
              // points back. Simplest to just lock it.
              onChanged: task.isClaimed ? null : onToggle,
              activeColor: AppTheme.secondaryColor,
              checkColor: AppTheme.textColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: titleStyle),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(Icons.water_drop, size: 12, color: AppTheme.accentWater),
                      const SizedBox(width: AppSpacing.xs),
                      Text('+${task.rewardPoints} Water Points', style: OasisTextTheme.labelSmall),
                    ],
                  ),
                ],
              ),
            ),
            if (task.isClaimed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.secondaryColor, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 12, color: AppTheme.textColor),
                    const SizedBox(width: 4),
                    Text('Claimed', style: OasisTextTheme.labelSmall.copyWith(color: AppTheme.textColor)),
                  ],
                ),
              )
            else if (task.isCompleted)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: AppTheme.textColor,
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                ),
                onPressed: onClaim,
                child: const Text('Claim'),
              ),
          ],
        ),
      ),
    );
  }
}
