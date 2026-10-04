import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/plant_model.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/garden_plant.dart';
import '../widgets/session_complete_dialog.dart';
import '../widgets/timer_length_stepper.dart';
import '../widgets/timer_ring_display.dart';
import '../widgets/water_point_badge.dart';

enum _SessionStatus { idle, running, paused }

/// The Home / Garden Timer screen: docs/02-mockup.png screens 1 to 3.
///
/// Owns the Timer.periodic countdown and the shared_preferences reads and
/// writes for work_duration and water_points (see docs/PROPOSAL_V2, section
/// IV, "What I Save Concretely"). waterPoints itself is lifted to
/// MainNavigationScreen so the balance chip stays in sync across tabs — see
/// the "State Lifting Without External Packages" risk in the midterm
/// journal — this screen only reports changes upward through
/// [onWaterPointsChanged].
class TimerHomeScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final int waterPoints;
  final ValueChanged<int> onWaterPointsChanged;
  final String activePlantId;

  const TimerHomeScreen({
    super.key,
    required this.prefs,
    required this.waterPoints,
    required this.onWaterPointsChanged,
    required this.activePlantId,
  });

  @override
  State<TimerHomeScreen> createState() => _TimerHomeScreenState();
}

class _TimerHomeScreenState extends State<TimerHomeScreen> {
  static const _kWorkDuration = 'work_duration';
  static const _kTodayFocusMinutes = 'today_focus_minutes';
  static const _kDailyStreak = 'daily_streak';
  static const _pointsPerSession = 50;

  late int _workDurationMinutes;
  late int _remainingSeconds;
  _SessionStatus _status = _SessionStatus.idle;
  Timer? _timer;
  int _cyclesToday = 0;

  @override
  void initState() {
    super.initState();
    _workDurationMinutes = widget.prefs.getInt(_kWorkDuration) ?? 25;
    _remainingSeconds = _workDurationMinutes * 60;
  }

  @override
  void dispose() {
    // Cancel the timer here or it keeps calling setState() on an unmounted
    // widget after navigating away — the memory-leak risk from the
    // midterm journal, section II.
    _timer?.cancel();
    super.dispose();
  }

  int get _todayFocusMinutes => widget.prefs.getInt(_kTodayFocusMinutes) ?? 0;
  int get _dailyStreak => widget.prefs.getInt(_kDailyStreak) ?? 1;

  double get _progress =>
      _status == _SessionStatus.idle ? 1.0 : _remainingSeconds / (_workDurationMinutes * 60);

  int get _plantStage {
    final elapsed = 1 - _progress;
    if (elapsed >= 1.0) return 4;
    if (elapsed >= 0.66) return 3;
    if (elapsed >= 0.33) return 2;
    return 1;
  }

  String get _timeLabel {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _setWorkDuration(int minutes) {
    setState(() {
      _workDurationMinutes = minutes;
      _remainingSeconds = minutes * 60;
    });
    widget.prefs.setInt(_kWorkDuration, minutes);
  }

  void _start() {
    setState(() {
      _status = _SessionStatus.running;
      _remainingSeconds = _workDurationMinutes * 60;
    });
    _tick();
  }

  void _tick() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() => _remainingSeconds = 0);
        _onSessionComplete();
      } else {
        setState(() => _remainingSeconds -= 1);
      }
    });
  }

  void _pauseOrResume() {
    if (_status == _SessionStatus.running) {
      _timer?.cancel();
      setState(() => _status = _SessionStatus.paused);
    } else if (_status == _SessionStatus.paused) {
      setState(() => _status = _SessionStatus.running);
      _tick();
    }
  }

  Future<void> _reset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset session?'),
        content: const Text('This clears the current countdown. Your plant keeps its progress from finished sessions.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Reset', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    _timer?.cancel();
    setState(() {
      _status = _SessionStatus.idle;
      _remainingSeconds = _workDurationMinutes * 60;
    });
  }

  Future<void> _onSessionComplete() async {
    final newPoints = widget.waterPoints + _pointsPerSession;
    widget.onWaterPointsChanged(newPoints);
    await widget.prefs.setInt('water_points', newPoints);
    await widget.prefs.setInt(_kTodayFocusMinutes, _todayFocusMinutes + _workDurationMinutes);

    setState(() => _cyclesToday += 1);

    if (!mounted) return;
    final startBreak = await showSessionCompleteDialog(
      context,
      minutesFocused: _workDurationMinutes,
      pointsEarned: _pointsPerSession,
      plantStage: _plantStage,
      plantSpecies: widget.activePlantId,
    );

    setState(() {
      _status = _SessionStatus.idle;
      _remainingSeconds = _workDurationMinutes * 60;
    });

    if (startBreak == true) {
      // Stretch goal: a shorter break countdown in the secondary colour.
      // Not built yet — see Proposal V2 section III, Stretch Goals.
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = _status == _SessionStatus.idle;
    final isRunning = _status == _SessionStatus.running;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        titleSpacing: AppSpacing.lg,
        title: Row(
          children: [
            const AppLogo(size: 36),
            const SizedBox(width: AppSpacing.sm),
            Text('Focus Oasis', style: OasisTextTheme.headlineSmall),
          ],
        ),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1. Top Plant Status Card
              _PlantProgressCard(
                stage: _plantStage,
                progress: isIdle ? 0 : 1 - _progress,
                species: widget.activePlantId,
              ),
              
              // 2. Middle Timer Ring
              TimerRingDisplay(
                progress: _progress,
                timeLabel: _timeLabel,
                subLabel: 'Focus session',
                stage: _plantStage,
                species: widget.activePlantId,
              ),

              // 3. Cycle Text placed right between Timer and Control Panel
              Text('Cycle ${_cyclesToday + 1} of 4', style: OasisTextTheme.labelSmall),

              // 4. Bottom Controls & Stats Panel
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isIdle) ...[
                    TimerLengthStepper(minutes: _workDurationMinutes, onChanged: _setWorkDuration),
                    const SizedBox(height: 12),
                  ],
                  if (isIdle)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _start,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Session'),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pauseOrResume,
                            icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                            label: Text(isRunning ? 'Pause' : 'Resume'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        OutlinedButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.access_time,
                          iconColor: AppTheme.accentWater,
                          label: "Today's focus",
                          value: '${_todayFocusMinutes ~/ 60} hr ${_todayFocusMinutes % 60} min',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_fire_department,
                          iconColor: AppTheme.accentSun,
                          label: 'Daily streak',
                          value: '$_dailyStreak days',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlantProgressCard extends StatelessWidget {
  final int stage;
  final double progress;
  final String species;
  const _PlantProgressCard({required this.stage, required this.progress, required this.species});

  /// Looks the active plant's display name up in the catalog. Falls back
  /// to the species id (capitalized) if it's ever missing, so a bad or
  /// stale `active_plant_id` can't crash this screen.
  String get _plantName {
    final match = PlantModel.starterCatalog().where((p) => p.id == species);
    if (match.isEmpty) return species[0].toUpperCase() + species.substring(1);
    return match.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: AppTheme.thumbTint, borderRadius: BorderRadius.circular(12)),
              child: Center(child: GardenPlant(stage: stage, species: species, size: 44)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_plantName, style: OasisTextTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  Text(stageLabel(stage.clamp(1, 4)), style: OasisTextTheme.labelSmall),
                  const SizedBox(height: AppSpacing.xs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0, 1),
                      minHeight: 8,
                      backgroundColor: AppTheme.accentWater.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(AppTheme.accentWater),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: OasisTextTheme.labelSmall),
                  Text(value, style: OasisTextTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}