// A widget test: it builds your app in memory and checks what is on screen.
// Run them all with: flutter test
//
// You are not required to write more of these, but a project with a few real
// tests reads very differently from one with none.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:focus_oasis/main.dart';

void main() {
  testWidgets('login screen shows the app title and offline option',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build the app directly so the test does not display the preview frame.
    await tester.pumpWidget(
      FocusOasisApp(prefs: prefs, hasSupabaseConfig: false),
    );

    expect(find.text('Focus Oasis'), findsOneWidget);
    expect(find.text('Continue Offline'), findsOneWidget);
  });
}
