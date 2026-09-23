# Reflection Journal (template)

## Week of: (09.23.26)

## My goal this week

To establish the core project repository structure for Focus Oasis, implement the Design System v3 color tokens and typography, configure multi-tab navigation via MainNavigationScreen, and set up the initial Pomodoro timer loop with state-lifted water points.

## What I did

-Created the project base layout and configured lib/theme/app_theme.dart to map out exact custom primary colors (#A22525), secondary accents (#81E4AA), and surface tokens.

-Developed the root MainNavigationScreen implementing state-lifting for waterPoints shared seamlessly across the Timer, Tasks, and Shop views.

-Built out the interactive Pomodoro countdown logic (TimerHomeScreen) using Timer.periodic, complete with play, pause, reset functions, and completion reward triggers.

## What blocked me

-Hit an initial build blocker due to missing local dependency fetches (google_fonts), which required running flutter pub get.
-Encountered Flutter version API incompatibilities where CardTheme vs CardThemeData threw type mismatches, as well as missing the 0xFF opacity prefix on custom hex color initializations.

## What I learned

-I now understand how crucial strict adherence to Flutter's updated widget theme signatures (CardThemeData) and color hex parsing formats is when working across different framework versions.
-I gained a deeper practical understanding of state-lifting up to root navigation controllers to keep data synchronized across distinct tabs without needing complex global state management libraries.
