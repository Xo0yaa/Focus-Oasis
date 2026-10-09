import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'garden_plant.dart';

/// The circular countdown, with the growing plant and the digital readout
/// inside it. See docs/DESIGN_SYSTEM_V3.pdf section X, TimerRingDisplay.
class TimerRingDisplay extends StatelessWidget {
  /// 1.0 = full time remaining, 0.0 = finished.
  final double progress;
  final String timeLabel;
  final String subLabel;
  final int stage;
  final String species;
  final double diameter;

  const TimerRingDisplay({
    super.key,
    required this.progress,
    required this.timeLabel,
    required this.subLabel,
    required this.stage,
    this.species = 'sampaguita',
    this.diameter = 264,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: diameter,
            height: diameter,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 12,
              color: AppTheme.ringTrack,
            ),
          ),
          SizedBox(
            width: diameter,
            height: diameter,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: progress, end: progress),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, _) => CircularProgressIndicator(
                value: value,
                strokeWidth: 12,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GardenPlant(stage: stage, species: species, size: 56),
              const SizedBox(height: AppSpacing.xs),
              Text(timeLabel, style: OasisTextTheme.displayLarge),
              Text(subLabel, style: OasisTextTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
