import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shop_screen.dart';
import 'tasks_screen.dart';
import 'timer_home_screen.dart';

/// Holds waterPoints and activePlantId so both stay in sync across tabs —
/// see docs/DESIGN_SYSTEM_V3.pdf section X and the "State Lifting" risk in
/// the midterm journal. All three MVP tabs (Garden, Tasks, Shop &
/// Inventory) are wired up to this shared state as of this increment.
class MainNavigationScreen extends StatefulWidget {
  final SharedPreferences prefs;
  const MainNavigationScreen({super.key, required this.prefs});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;
  late int _waterPoints;
  late String _activePlantId;

  @override
  void initState() {
    super.initState();
    _waterPoints = widget.prefs.getInt('water_points') ?? 150;
    _activePlantId = widget.prefs.getString('active_plant_id') ?? 'sampaguita';
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      TimerHomeScreen(
        prefs: widget.prefs,
        waterPoints: _waterPoints,
        onWaterPointsChanged: (v) => setState(() => _waterPoints = v),
        activePlantId: _activePlantId,
      ),
      TasksScreen(
        prefs: widget.prefs,
        waterPoints: _waterPoints,
        onWaterPointsChanged: (v) => setState(() => _waterPoints = v),
      ),
      ShopScreen(
        prefs: widget.prefs,
        waterPoints: _waterPoints,
        onWaterPointsChanged: (v) => setState(() => _waterPoints = v),
        activePlantId: _activePlantId,
        onActivePlantChanged: (id) => setState(() => _activePlantId = id),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.spa_outlined), selectedIcon: Icon(Icons.spa), label: 'Garden'),
          NavigationDestination(icon: Icon(Icons.check_box_outlined), selectedIcon: Icon(Icons.check_box), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Shop'),
        ],
      ),
    );
  }
}
