import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FocusOasisApp());
}

class FocusOasisApp extends StatelessWidget {
  const FocusOasisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Oasis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Reading shared_preferences inside initState() can flicker the UI
      // before the Future completes — see Proposal V2 section IX, "New Risk
      // Identified: Asynchronous state loading latency during startup".
      // This FutureBuilder is the mitigation: it holds a simple loading
      // screen until SharedPreferences finishes loading.
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              backgroundColor: AppTheme.backgroundColor,
              body: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
            );
          }
          return MainNavigationScreen(prefs: snapshot.data!);
        },
      ),
    );
  }
}
