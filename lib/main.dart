import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(FocusOasisApp(prefs: prefs));
}

class FocusOasisApp extends StatelessWidget {
  final SharedPreferences prefs;

  const FocusOasisApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Oasis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Will adapt to your theme setup
      home: LoginScreen(prefs: prefs),
    );
  }
}