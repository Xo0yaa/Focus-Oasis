import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/plant_model.dart';
import '../models/task_model.dart';

/// Stores a user's complete app progress in a row protected by Supabase RLS.
/// Local preferences remain the offline cache and are refreshed after sign-in.
class ProgressService {
  ProgressService(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>?> fetch() async {
    final user = _client.auth.currentUser;
    if (user == null) throw const AuthException('Please sign in again.');

    final row = await _client
        .from('user_progress')
        .select('state')
        .eq('user_id', user.id)
        .maybeSingle();
    if (row == null) return null;
    return Map<String, dynamic>.from(row['state'] as Map);
  }

  Future<void> save(Map<String, dynamic> state) async {
    final user = _client.auth.currentUser;
    if (user == null) throw const AuthException('Please sign in again.');

    await _client.from('user_progress').upsert({
      'user_id': user.id,
      'state': state,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Map<String, dynamic> readLocal(SharedPreferences prefs) => {
        'water_points': prefs.getInt('water_points') ?? 150,
        'active_plant_id': prefs.getString('active_plant_id') ?? 'sampaguita',
        'work_duration': prefs.getInt('work_duration') ?? 25,
        'today_focus_minutes': prefs.getString('tasks_reset_date') == null
            ? 0
            : prefs.getInt('today_focus_minutes') ?? 0,
        'daily_streak': prefs.getInt('daily_streak') ?? 1,
        'cycles_today': prefs.getInt('cycles_today') ?? 0,
        'tasks_reset_date': prefs.getString('tasks_reset_date') ??
            _dateKey(DateTime.now()),
        'user_tasks': _decodeList(
          prefs.getString('user_tasks'),
          TaskModel.seedTasks().map((task) => task.toJson()).toList(),
        ),
        'user_inventory': _decodeList(
          prefs.getString('user_inventory'),
          PlantModel.starterCatalog().map((plant) => plant.toJson()).toList(),
        ),
        'timer_status': prefs.getString('timer_status') ?? 'idle',
        'timer_remaining_seconds': prefs.getInt('timer_remaining_seconds') ??
            (prefs.getInt('work_duration') ?? 25) * 60,
        'timer_updated_at_ms': prefs.getInt('timer_updated_at_ms') ??
            DateTime.now().millisecondsSinceEpoch,
      };

  Map<String, dynamic> freshState() => {
        'water_points': 150,
        'active_plant_id': 'sampaguita',
        'work_duration': 25,
        'today_focus_minutes': 0,
        'daily_streak': 1,
        'cycles_today': 0,
        'tasks_reset_date': _dateKey(DateTime.now()),
        'user_tasks':
            TaskModel.seedTasks().map((task) => task.toJson()).toList(),
        'user_inventory': PlantModel.starterCatalog()
            .map((plant) => plant.toJson())
            .toList(),
        'timer_status': 'idle',
        'timer_remaining_seconds': 25 * 60,
        'timer_updated_at_ms': DateTime.now().millisecondsSinceEpoch,
      };

  Future<void> apply(Map<String, dynamic> state, SharedPreferences prefs) async {
    await prefs.setInt('water_points', _asInt(state['water_points'], 150));
    await prefs.setString(
        'active_plant_id', state['active_plant_id'] as String? ?? 'sampaguita');
    await prefs.setInt('work_duration', _asInt(state['work_duration'], 25));
    await prefs.setInt(
      'today_focus_minutes',
      state['tasks_reset_date'] is String
          ? _asInt(state['today_focus_minutes'], 0)
          : 0,
    );
    await prefs.setInt('daily_streak', _asInt(state['daily_streak'], 1));
    await prefs.setInt('cycles_today', _asInt(state['cycles_today'], 0));
    await prefs.setString(
      'tasks_reset_date',
      state['tasks_reset_date'] as String? ?? _dateKey(DateTime.now()),
    );
    await prefs.setString(
      'user_tasks',
      jsonEncode(state['user_tasks'] ?? freshState()['user_tasks']),
    );
    await prefs.setString(
      'user_inventory',
      jsonEncode(state['user_inventory'] ?? freshState()['user_inventory']),
    );
    await prefs.setString(
        'timer_status', state['timer_status'] as String? ?? 'idle');
    await prefs.setInt('timer_remaining_seconds',
        _asInt(state['timer_remaining_seconds'], 25 * 60));
    await prefs.setInt('timer_updated_at_ms',
        _asInt(state['timer_updated_at_ms'], DateTime.now().millisecondsSinceEpoch));
  }

  List<dynamic> _decodeList(String? raw, List<dynamic> fallback) {
    if (raw == null || raw.isEmpty) return fallback;
    try {
      return jsonDecode(raw) as List<dynamic>;
    } catch (_) {
      return fallback;
    }
  }

  int _asInt(dynamic value, int fallback) =>
      value is num ? value.toInt() : fallback;

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
