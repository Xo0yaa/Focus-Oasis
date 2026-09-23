import 'package:flutter/material.dart';
import 'timer_home_screen.dart';
import 'tasks_screen.dart';
import 'shop_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  // Lifted state shared across all tabs
  int _waterPoints = 120;

  void _updateWaterPoints(int newPoints) {
    setState(() {
      _waterPoints = newPoints;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of screens with access to shared water points
    final List<Widget> screens = [
      TimerHomeScreen(
        waterPoints: _waterPoints,
        onWaterPointsChanged: _updateWaterPoints,
      ),
      TasksScreen(
        waterPoints: _waterPoints,
        onWaterPointsChanged: _updateWaterPoints,
      ),
      ShopScreen(
        waterPoints: _waterPoints,
        onWaterPointsChanged: _updateWaterPoints,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Oasis Timer',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Shop',
          ),
        ],
      ),
    );
  }
}