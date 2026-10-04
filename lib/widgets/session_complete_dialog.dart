import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../theme/app_theme.dart';
import 'garden_plant.dart';
import 'water_point_badge.dart';

/// Shown when Timer.periodic reaches 00:00. See docs/02-mockup.png screen 3
/// and docs/DESIGN_SYSTEM_V3.pdf section X, SessionCompleteDialog.
///
/// Returns true if the person chose to start a 5 minute break, false (or
/// null) if they dismissed.
Future<bool?> showSessionCompleteDialog(
  BuildContext context, {
  required int minutesFocused,
  required int pointsEarned,
  required int plantStage,
  String plantSpecies = 'sampaguita',
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: AppTheme.scrim,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(color: AppTheme.thumbTint, shape: BoxShape.circle),
              child: Center(child: GardenPlant(stage: plantStage, species: plantSpecies, size: 96)),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Session Complete!', style: OasisTextTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You stayed focused for $minutesFocused minutes. Your plant grew to stage $plantStage.',
              style: OasisTextTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            WaterPointBadge(points: pointsEarned, big: true),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondaryColor, foregroundColor: AppTheme.textColor),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Start 5 min break'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Dismiss', style: OasisTextTheme.bodyMedium.copyWith(color: AppTheme.textColor)),
            ),
          ],
        ),
      ),
    ),
  );
}
