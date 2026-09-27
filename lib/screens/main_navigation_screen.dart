import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import 'tasks_screen.dart';
import 'timer_home_screen.dart';

/// Holds waterPoints so the balance chip stays in sync across tabs — see
/// docs/DESIGN_SYSTEM_V3.pdf section X and the "State Lifting" risk in the
/// midterm journal. Garden and Tasks are both wired up to it now (Week 2);
/// Shop is still a placeholder.
class MainNavigationScreen extends StatefulWidget {
  final SharedPreferences prefs;
  const MainNavigationScreen({super.key, required this.prefs});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;
  late int _waterPoints;

  @override
  void initState() {
    super.initState();
    _waterPoints = widget.prefs.getInt('water_points') ?? 150;
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      TimerHomeScreen(
        prefs: widget.prefs,
        waterPoints: _waterPoints,
        onWaterPointsChanged: (v) => setState(() => _waterPoints = v),
      ),
      TasksScreen(
        prefs: widget.prefs,
        waterPoints: _waterPoints,
        onWaterPointsChanged: (v) => setState(() => _waterPoints = v),
      ),
      const _ComingSoonScreen(title: 'Botanic Shop', screenNumber: 5),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppTheme.surfaceColor,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.spa_outlined), selectedIcon: Icon(Icons.spa), label: 'Garden'),
          NavigationDestination(icon: Icon(Icons.check_box_outlined), selectedIcon: Icon(Icons.check_box), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Shop'),
        ],
      ),
    );
  }
}

/// Placeholder for the Daily Tasks and Botanic Shop & Inventory tabs.
/// Not part of this progress drop — see docs/02-mockup.png for the target
/// design once these are built.
class _ComingSoonScreen extends StatelessWidget {
  final String title;
  final int screenNumber;
  const _ComingSoonScreen({required this.title, required this.screenNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: AppTheme.backgroundColor, elevation: 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.construction, size: 40, color: AppTheme.outline),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Screen $screenNumber is next — see docs/02-mockup.png.',
                style: OasisTextTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
