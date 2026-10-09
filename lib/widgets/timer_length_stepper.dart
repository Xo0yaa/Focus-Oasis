import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Lets the person set the focus length before starting a session:
/// minus/plus buttons in 5 minute steps (5 to 120), or tap the value to
/// type an exact number of minutes. Hidden by TimerHomeScreen while a
/// session is running, so the countdown can't be edited mid-session.
class TimerLengthStepper extends StatelessWidget {
  static const int minMinutes = 5;
  static const int maxMinutes = 120;
  static const int step = 5;

  final int minutes;
  final ValueChanged<int> onChanged;

  const TimerLengthStepper({super.key, required this.minutes, required this.onChanged});

  Future<void> _openExactEntry(BuildContext context) async {
    final controller = TextEditingController(text: '$minutes');
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set focus length'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(suffixText: 'minutes'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null) {
                Navigator.pop(context, value.clamp(minMinutes, maxMinutes));
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Focus length', style: OasisTextTheme.bodyMedium),
                Text('$minMinutes to $maxMinutes min', style: OasisTextTheme.labelSmall),
              ],
            ),
            Row(
              children: [
                _StepButton(
                  icon: Icons.remove,
                  onTap: minutes > minMinutes ? () => onChanged((minutes - step).clamp(minMinutes, maxMinutes)) : null,
                ),
                const SizedBox(width: AppSpacing.sm),
                InkWell(
                  onTap: () => _openExactEntry(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 72,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.outline),
                    ),
                    child: Text('$minutes min', style: OasisTextTheme.bodyMedium),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _StepButton(
                  icon: Icons.add,
                  onTap: minutes < maxMinutes ? () => onChanged((minutes + step).clamp(minMinutes, maxMinutes)) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.textColor, width: 2),
        ),
        child: Icon(icon, size: 20, color: onTap == null ? AppTheme.disabledText : AppTheme.textColor),
      ),
    );
  }
}
