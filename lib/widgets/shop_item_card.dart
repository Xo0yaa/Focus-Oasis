import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../theme/app_theme.dart';
import 'garden_plant.dart';
import 'water_point_badge.dart';

/// The three ShopItemCard states from Design System v3 section X:
/// locked-and-affordable, locked-and-too-expensive, and owned.
class ShopItemCard extends StatelessWidget {
  final PlantModel plant;
  final bool canAfford;
  final VoidCallback onBuy;

  const ShopItemCard({super.key, required this.plant, required this.canAfford, required this.onBuy});

  Color get _rarityColor => switch (plant.rarity) {
        'Rare' => AppTheme.accentBloom,
        'Legendary' => AppTheme.accentFlora,
        _ => AppTheme.textColor,
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 92,
                  width: double.infinity,
                  decoration: BoxDecoration(color: AppTheme.thumbTint, borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: plant.isUnlocked
                        ? GardenPlant(stage: 4, species: plant.id, size: 72)
                        : Opacity(
                            opacity: 0.55,
                            child: ColorFiltered(
                              // Greyscale via the standard luminance matrix,
                              // so locked plants read as "not yours yet"
                              // the way the mockup's locked cards do.
                              colorFilter: const ColorFilter.matrix(<double>[
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0, 0, 0, 1, 0,
                              ]),
                              child: GardenPlant(stage: 4, species: plant.id, size: 72),
                            ),
                          ),
                  ),
                ),
                if (!plant.isUnlocked) ...[
                  Positioned(
                    right: 4,
                    top: 4,
                    child: WaterPointBadge(points: plant.cost),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Icon(Icons.lock, size: 14, color: AppTheme.textColor),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.name, style: OasisTextTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  if (plant.isUnlocked)
                    Container(
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      decoration: BoxDecoration(color: AppTheme.secondaryColor, borderRadius: BorderRadius.circular(11)),
                      alignment: Alignment.center,
                      child: Text('Unlocked', style: OasisTextTheme.labelSmall.copyWith(color: AppTheme.textColor)),
                    )
                  else
                    Container(
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: _rarityColor, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: _rarityColor, shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          Text(plant.rarity, style: OasisTextTheme.labelSmall),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: plant.isUnlocked
                  ? ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [Icon(Icons.check, size: 16), SizedBox(width: 4), Text('Owned')],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: canAfford ? onBuy : null,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
                      child: const Text('Buy'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
