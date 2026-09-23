import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'main_navigation_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const FocusOasisApp(),
    ),
  );
}

class FocusOasisApp extends StatelessWidget {
  const FocusOasisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Oasis',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}