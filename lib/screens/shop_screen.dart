import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/plant_model.dart';
import '../theme/app_theme.dart';
import '../widgets/collection_card.dart';
import '../widgets/inventory_item_card.dart';
import '../widgets/shop_item_card.dart';
import '../widgets/water_point_badge.dart';

/// Botanic Shop & Inventory screen: docs/02-mockup.png screens 5 and 6.
///
/// Reads and writes `user_inventory` in shared_preferences (Proposal V2,
/// section IV). waterPoints and the active plant are both lifted to
/// MainNavigationScreen, the same pattern TimerHomeScreen and TasksScreen
/// already use, so Home shows whichever plant was actually placed here.
class ShopScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final int waterPoints;
  final ValueChanged<int> onWaterPointsChanged;
  final String activePlantId;
  final ValueChanged<String> onActivePlantChanged;

  const ShopScreen({
    super.key,
    required this.prefs,
    required this.waterPoints,
    required this.onWaterPointsChanged,
    required this.activePlantId,
    required this.onActivePlantChanged,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  static const _kInventory = 'user_inventory';
  late List<PlantModel> _catalog;
  int _view = 0; // 0 = Shop, 1 = Inventory

  @override
  void initState() {
    super.initState();
    _catalog = _loadCatalog();
  }

  List<PlantModel> _loadCatalog() {
    final raw = widget.prefs.getString(_kInventory);
    if (raw == null || raw.isEmpty) return List.of(PlantModel.starterCatalog());
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final list = decoded.map((e) => PlantModel.fromJson(e as Map<String, dynamic>)).toList();
      return list.isEmpty ? List.of(PlantModel.starterCatalog()) : list;
    } catch (_) {
      return List.of(PlantModel.starterCatalog());
    }
  }

  Future<void> _saveCatalog() async {
    final raw = jsonEncode(_catalog.map((p) => p.toJson()).toList());
    await widget.prefs.setString(_kInventory, raw);
  }

  Future<void> _buy(PlantModel plant) async {
    // FIX: re-check balance even though the button is disabled when unaffordable
    if (widget.waterPoints < plant.cost) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buy ${plant.name}?'),
        content: Text('This costs ${plant.cost} Water Points.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Buy')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final newBalance = widget.waterPoints - plant.cost;

    setState(() {
      // FIX: build a new list instead of mutating in place
      _catalog = _catalog
          .map((p) => p.id == plant.id ? p.copyWith(isUnlocked: true, isNew: true) : p)
          .toList();
    });

    // Lift the new balance first so every tab's badge updates immediately
    widget.onWaterPointsChanged(newBalance);

    await _saveCatalog();
    await widget.prefs.setInt('water_points', newBalance);
  }

  Future<void> _place(PlantModel plant) async {
    setState(() {
      _catalog = _catalog.map((p) {
        if (p.id == plant.id) return p.copyWith(isPlaced: true, isNew: false);
        if (p.isPlaced) return p.copyWith(isPlaced: false);
        return p;
      }).toList();
    });
    await _saveCatalog();
    widget.onActivePlantChanged(plant.id);
    await widget.prefs.setString('active_plant_id', plant.id);
  }

  @override
  Widget build(BuildContext context) {
    final owned = _catalog.where((p) => p.isUnlocked).toList();
    final unowned = _catalog.where((p) => !p.isUnlocked).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Botanic Shop', style: OasisTextTheme.headlineSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: WaterPointBadge(points: widget.waterPoints),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Shop')),
                  ButtonSegment(value: 1, label: Text('Inventory')),
                ],
                selected: {_view},
                onSelectionChanged: (s) => setState(() => _view = s.first),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: _view == 0 ? _buildShop(unowned, owned) : _buildInventory(owned),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShop(List<PlantModel> unowned, List<PlantModel> owned) {
    final items = [...unowned, ...owned]; // unlocked-to-buy first, owned after
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, i) {
        final plant = items[i];
        return ShopItemCard(
          plant: plant,
          canAfford: widget.waterPoints >= plant.cost,
          onBuy: () => _buy(plant),
        );
      },
    );
  }

  Widget _buildInventory(List<PlantModel> owned) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CollectionCard(unlockedCount: owned.length, catalogSize: _catalog.length),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: owned.length + 1, // +1 for the "find more seeds" card
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, i) {
              if (i == owned.length) {
                return EmptyShopSlotCard(onTap: () => setState(() => _view = 0));
              }
              final plant = owned[i];
              return InventoryItemCard(plant: plant, onPlace: () => _place(plant));
            },
          ),
        ],
      ),
    );
  }
}
