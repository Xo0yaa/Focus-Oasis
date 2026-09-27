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
              // points back, which breaks the flow.
              onChanged: task.isClaimed ? null : onToggle,
              activeColor: AppTheme.secondaryColor,
              checkColor: AppTheme.textColor,
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
                      const Icon(Icons.water_drop, size: 12, color: AppTheme.accentWater),
                      const SizedBox(width: AppSpacing.xs),
                      Text('+${task.rewardPoints} Water Points', style: OasisTextTheme.labelSmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (task.isCompleted && !task.isClaimed)
              ElevatedButton(
                onPressed: onClaim,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Claim'),
              )
            else if (task.isClaimed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                decoration: BoxDecoration(color: AppTheme.secondaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check, size: 12, color: AppTheme.textColor),
                    const SizedBox(width: 4),
                    Text('Claimed', style: OasisTextTheme.labelSmall.copyWith(color: AppTheme.textColor)),
                  ],
                ),
              )
            else
              OutlinedButton(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide.none,
                ),
                child: const Text(''),
              ),
          ],
        ),
      ),
    );
  }
}