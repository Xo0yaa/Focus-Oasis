import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const FocusOasisApp());
}

class FocusOasisApp extends StatefulWidget {
  const FocusOasisApp({super.key});

  @override
  State<FocusOasisApp> createState() => _FocusOasisAppState();
}

class _FocusOasisAppState extends State<FocusOasisApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Oasis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFE74C3C),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFE74C3C),
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: const LoginScreen(),
    );
  }
}