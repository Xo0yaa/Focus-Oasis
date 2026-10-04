import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A single achievement badge, earned (Sun Gold) or locked (outlined).
class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool earned;
  const _Badge({required this.icon, required this.label, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: earned ? AppTheme.accentSun : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: earned ? null : Border.all(color: AppTheme.outline, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(earned ? icon : Icons.lock, size: 14, color: AppTheme.textColor),
          const SizedBox(width: 4),
          Text(label, style: OasisTextTheme.labelSmall),
        ],
      ),
    );
  }
}

/// Collection progress bar and badges, shown at the top of the Inventory
/// view. Design System v3 section X, CollectionCard.
///
/// Badge rules are a simple, honest placeholder — not a real achievement
/// system yet: "First Sprout" is earned once any plant is bought from the
/// shop, "Master Botanist" once the whole catalog is unlocked. "Early
/// Bird" has no real signal to key off yet (that needs session timestamps,
/// which aren't tracked), so it always shows locked. See README.
class CollectionCard extends StatelessWidget {
  final int unlockedCount;
  final int catalogSize;

  const CollectionCard({super.key, required this.unlockedCount, required this.catalogSize});

  @override
  Widget build(BuildContext context) {
    final progress = catalogSize == 0 ? 0.0 : unlockedCount / catalogSize;
    final boughtAtLeastOne = unlockedCount > 2; // 2 starters are free
    final ownsEverything = unlockedCount >= catalogSize;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Collection', style: OasisTextTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                Text('$unlockedCount of $catalogSize plants', style: OasisTextTheme.labelSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppTheme.accentBloom.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(AppTheme.accentBloom),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _Badge(icon: Icons.spa, label: 'First Sprout', earned: boughtAtLeastOne),
                const _Badge(icon: Icons.access_time, label: 'Early Bird', earned: false),
                _Badge(icon: Icons.emoji_events, label: 'Master Botanist', earned: ownsEverything),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
