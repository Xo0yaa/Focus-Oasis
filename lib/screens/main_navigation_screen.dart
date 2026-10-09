import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import '../services/progress_service.dart';
import 'shop_screen.dart';
import 'tasks_screen.dart';
import 'timer_home_screen.dart';

/// Holds waterPoints and activePlantId so both stay in sync across tabs —
/// see docs/DESIGN_SYSTEM_V3.pdf section X and the "State Lifting" risk in
/// the midterm journal. All three MVP tabs (Garden, Tasks, Shop &
/// Inventory) are wired up to this shared state as of this increment.
class MainNavigationScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final SupabaseClient? cloudClient;

  const MainNavigationScreen({
    super.key,
    required this.prefs,
    this.cloudClient,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;
  late int _waterPoints;
  late String _activePlantId;
  ProgressService? _progressService;
  Timer? _saveDebounce;
  bool _isRestoring = false;
  bool _cloudReady = false;

  @override
  void initState() {
    super.initState();
    _waterPoints = widget.prefs.getInt('water_points') ?? 150;
    _activePlantId = widget.prefs.getString('active_plant_id') ?? 'sampaguita';
    if (widget.cloudClient != null) {
      _progressService = ProgressService(widget.cloudClient!);
      _isRestoring = true;
      unawaited(_restoreProgress());
    }
  }

  Future<void> _restoreProgress() async {
    final service = _progressService!;
    try {
      final cloudState = await service.fetch();
      // Bootstrap the cloud row from the existing device cache on first
      // sign-in, preserving progress created before cloud sync was enabled.
      final state = cloudState ?? service.readLocal(widget.prefs);
      await service.apply(state, widget.prefs);
      if (cloudState == null) await service.save(state);
      if (!mounted) return;
      setState(() {
        _waterPoints = widget.prefs.getInt('water_points') ?? 150;
        _activePlantId =
            widget.prefs.getString('active_plant_id') ?? 'sampaguita';
        _isRestoring = false;
        _cloudReady = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isRestoring = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not sync your account. You can keep using locally saved progress.',
          ),
        ),
      );
    }
  }

  void _scheduleProgressSave() {
    if (!_cloudReady || _progressService == null) return;
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 700), () {
      unawaited(_saveCloudProgress());
    });
  }

  Future<void> _saveCloudProgress() async {
    if (!_cloudReady || _progressService == null) return;
    try {
      await _progressService!.save(_progressService!.readLocal(widget.prefs));
    } catch (_) {
      // Local preferences remain available when the device is offline.
    }
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    if (_cloudReady) unawaited(_saveCloudProgress());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      TimerHomeScreen(
        prefs: widget.prefs,
        waterPoints: _waterPoints,
        onWaterPointsChanged: (v) => setState(() => _waterPoints = v),
        activePlantId: _activePlantId,
        onProgressChanged: _scheduleProgressSave,
      ),
      TasksScreen(
        prefs: widget.prefs,
        waterPoints: _waterPoints,
        onWaterPointsChanged: (v) => setState(() => _waterPoints = v),
        onProgressChanged: _scheduleProgressSave,
      ),
      ShopScreen(
        prefs: widget.prefs,
        waterPoints: _waterPoints,
        onWaterPointsChanged: (v) => setState(() => _waterPoints = v),
        activePlantId: _activePlantId,
        onActivePlantChanged: (id) => setState(() => _activePlantId = id),
        onProgressChanged: _scheduleProgressSave,
      ),
    ];

    return Scaffold(
      body: _isRestoring
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(index: _index, children: screens),
      bottomNavigationBar: _isRestoring
          ? null
          : SafeArea(
              top: false,
              bottom: true,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceColor,
                  border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                ),
                child: SizedBox(
                  height: 76,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: NavigationBar(
                        height: 76,
                        indicatorShape: const StadiumBorder(),
                        labelBehavior:
                            NavigationDestinationLabelBehavior.alwaysShow,
                        selectedIndex: _index,
                        onDestinationSelected: (i) => setState(() => _index = i),
                        destinations: const [
                          NavigationDestination(
                            icon: Icon(Icons.spa_outlined),
                            selectedIcon: Icon(Icons.spa),
                            label: 'Garden',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.check_box_outlined),
                            selectedIcon: Icon(Icons.check_box),
                            label: 'Tasks',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.storefront_outlined),
                            selectedIcon: Icon(Icons.storefront),
                            label: 'Shop',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
