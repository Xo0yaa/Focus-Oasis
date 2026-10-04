import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../theme/app_theme.dart';
import 'garden_plant.dart';

/// The InventoryItemCard states from Design System v3 section X: owned,
/// in garden (disabled), and new (a Sun Gold tag on a just-bought plant).
class InventoryItemCard extends StatelessWidget {
  final PlantModel plant;
  final VoidCallback onPlace;

  const InventoryItemCard({super.key, required this.plant, required this.onPlace});

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
                  child: Center(child: GardenPlant(stage: 4, species: plant.id, size: 72)),
                ),
                if (plant.isNew && !plant.isPlaced)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      decoration: BoxDecoration(color: AppTheme.accentSun, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Text('New', style: OasisTextTheme.labelSmall.copyWith(color: AppTheme.textColor)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.name, style: OasisTextTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    plant.isPlaced ? 'Active in your garden' : 'In your inventory',
                    style: OasisTextTheme.labelSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: plant.isPlaced
                  ? ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [Icon(Icons.check, size: 16), SizedBox(width: 4), Text('In garden')],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: onPlace,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
                      child: const Text('Place'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown at the end of the Inventory grid so there's always a path back to
/// the Shop, matching docs/02-mockup.png screen 6.
class EmptyShopSlotCard extends StatelessWidget {
  final VoidCallback onTap;
  const EmptyShopSlotCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.outline, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined, size: 24, color: AppTheme.textColor),
            const SizedBox(height: AppSpacing.sm),
            Text('Find more seeds in the Shop', style: OasisTextTheme.labelSmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
