import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client operations for account identity and its private access log.
/// The publishable key is intended for client use; database RLS is the access
/// boundary. Never put a Supabase secret/service_role key in this app.
class AccountService {
  AccountService(this._client);

  final SupabaseClient _client;

  Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
    // Authentication must not fail just because optional profile/audit
    // queries are unavailable (for example, before migrations are applied).
    unawaited(_recordAccessSafely('sign_in'));
  }

  Future<AuthResponse> signUp(String email, String password) async {
    final response = await _client.auth.signUp(email: email, password: password);
    if (response.session != null) {
      unawaited(_recordAccessSafely('sign_up'));
    }
    return response;
  }

  Future<Map<String, dynamic>> fetchMyProfile() async {
    final user = _requireUser();
    final profile = await _client
        .from('profiles')
        .select('id, email, created_at')
        .eq('id', user.id)
        .single();
    return profile;
  }

  Future<List<Map<String, dynamic>>> fetchMyAccessLogs() async {
    final user = _requireUser();
    final rows = await _client
        .from('auth_access_logs')
        .select('id, event_type, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> _recordAccess(String eventType) async {
    final user = _requireUser();
    await _client.from('auth_access_logs').insert({
      'user_id': user.id,
      'email': user.email,
      'event_type': eventType,
    });
  }

  Future<void> _recordAccessSafely(String eventType) async {
    try {
      await _recordAccess(eventType);
    } catch (_) {
      // Access logs are useful for auditing, but must not block account use.
    }
  }

  User _requireUser() {
    final user = _client.auth.currentUser;
    if (user == null) throw const AuthException('Please sign in again.');
    return user;
  }
}
