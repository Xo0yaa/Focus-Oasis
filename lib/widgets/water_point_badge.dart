import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// White pill with a Water Blue outline and drop icon, and the balance in
/// onSurface. Restyled in Design System v3 because white text on Water Blue
/// is only 3.15:1 contrast, which fails for text — see docs/
/// DESIGN_SYSTEM_V3.pdf section IV.
class WaterPointBadge extends StatelessWidget {
  final int points;
  final bool big;

  const WaterPointBadge({super.key, required this.points, this.big = false});

  @override
  Widget build(BuildContext context) {
    final height = big ? 40.0 : 32.0;
    return Container(
      height: height,
      padding: EdgeInsets.only(left: AppSpacing.sm, right: big ? AppSpacing.lg : AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: AppTheme.accentWater, width: big ? 2 : 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.water_drop, size: big ? 20 : 16, color: AppTheme.accentWater),
          const SizedBox(width: AppSpacing.xs),
          Text('$points', style: OasisTextTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor)),
        ],
      ),
    );
  }
}
