import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TimerLengthStepper extends StatelessWidget {
  final int minutes;
  final ValueChanged<int> onChanged;

  const TimerLengthStepper({
    super.key,
    required this.minutes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Focus Duration', style: OasisTextTheme.bodyMedium),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: minutes > 5 ? () => onChanged(minutes - 5) : null,
                ),
                Text('$minutes min', style: OasisTextTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: minutes < 60 ? () => onChanged(minutes + 5) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}