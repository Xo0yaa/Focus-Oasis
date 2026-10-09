import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  final hasSupabaseConfig =
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;
  if (hasSupabaseConfig) {
    await Supabase.initialize(
        url: supabaseUrl, publishableKey: supabasePublishableKey);
  }

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (_) => FocusOasisApp(
        prefs: prefs,
        hasSupabaseConfig: hasSupabaseConfig,
      ),
    ),
  );
}

class FocusOasisApp extends StatelessWidget {
  final SharedPreferences prefs;
  final bool hasSupabaseConfig;

  const FocusOasisApp(
      {super.key, required this.prefs, required this.hasSupabaseConfig});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Oasis',
      debugShowCheckedModeBanner: false,
      // Device Preview 1.x checks for this flag, even though current Flutter
      // versions inherit MediaQuery directly from the View.
      // ignore: deprecated_member_use
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AppTheme.lightTheme,
      home: LoginScreen(prefs: prefs, hasSupabaseConfig: hasSupabaseConfig),
    );
  }
}
