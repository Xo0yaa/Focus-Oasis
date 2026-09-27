# Focus Oasis — progress code

**Week 2 update:** added the Daily Tasks screen (screen 4). Garden (screens
1 to 3) and Tasks now share the same lifted `waterPoints` state, so the
balance chip agrees on both tabs — see "What's implemented" below. Shop is
still a stub.

This is a working start on the Flutter app, not the mockup. It implements
**screens 1, 2, 3 and 4** — Home / Garden Timer, the running state, the
Session Complete dialog, and Daily Tasks — matching `docs/02-mockup.png`
and `docs/DESIGN_SYSTEM_V3.pdf`. Shop is a stub screen with a "coming soon"
message so the bottom nav is runnable end to end.

**I could not run `flutter analyze` or `flutter run` in the environment that
wrote this** — no Flutter/Dart SDK was available there. The code follows
the APIs and syntax I know, and the brace/paren counts balance in every
file, but treat it as a first draft: run `flutter pub get` then
`flutter analyze` yourself before you trust it, and read through
`timer_home_screen.dart` since that's where the real logic lives.

## What's implemented

- `lib/theme/app_theme.dart` — the Design System v3 tokens, including the
  restyled `WaterPointBadge` colours and the new tint tokens.
- `lib/models/plant_model.dart` — just enough to grow a plant on Home.
- `lib/widgets/garden_plant.dart` — the potted plant at stages 1 to 4,
  drawn with `CustomPainter` so it doesn't need four image assets yet.
- `lib/widgets/app_logo.dart` — the Ring Sprout mark, also `CustomPainter`
  for the same reason. Swap for `Image.asset` once you export the PNG.
- `lib/widgets/timer_ring_display.dart`, `timer_length_stepper.dart`,
  `session_complete_dialog.dart`, `water_point_badge.dart` — the pieces
  named in Design System v3 section X.
- `lib/screens/timer_home_screen.dart` — the real Home screen:
  `Timer.periodic` countdown, the length stepper (hidden while running),
  pause/resume, a confirm-then-reset flow, and saving `work_duration` and
  `water_points` to `shared_preferences`. The timer is cancelled in
  `dispose()`, which is the memory-leak risk from the midterm journal.
- `lib/screens/main_navigation_screen.dart` — the bottom nav. It owns
  `waterPoints` in its own state and passes it down with a callback, which
  is the state-lifting approach the design system and journal both call
  out — not Provider or Riverpod, since those aren't in the course.
- `lib/main.dart` — the `FutureBuilder` loading guard from the async
  startup risk in the proposal.
- **(Week 2)** `lib/models/task_model.dart` — `TaskModel` with
  `isCompleted` and `isClaimed` as separate flags, JSON (de)serialization,
  and three seed tasks shown the first time the app runs.
- **(Week 2)** `lib/widgets/task_card_tile.dart` — the three states from
  Design System v3: uncompleted, completed-and-claimable, claimed.
- **(Week 2)** `lib/screens/tasks_screen.dart` — the real Tasks screen:
  progress header, `ListView.builder` over the task list, an add-task
  dialog with a title field and a reward chip picker, a claim flow that
  reports the new balance up to `MainNavigationScreen`, and saving
  `user_tasks` to `shared_preferences` on every change.

## What's not implemented yet

- Botanic Shop & Inventory screen (stub only).
- Editing or deleting a task once added.
- A completed session doesn't auto-complete the "Focus for 25 minutes"
  seed task — the person still has to tick it by hand. Wiring that up is
  the obvious next increment, since `TimerHomeScreen` and `TasksScreen`
  don't currently talk to each other at all.
- Session history (`session_history` key) — "Today's focus" currently
  accumulates in a single `today_focus_minutes` key that never resets at
  midnight, and "Daily streak" is read from a key nothing increments yet.
  Both need a real day-boundary check before they're accurate.
- The break countdown after "Start 5 min break".
- `audioplayers` completion chime (stretch goal).

## Fix applied after the first run

`flutter run` surfaced two problems, now fixed:

1. **`Couldn't resolve the package 'google_fonts'`** — not a code bug. Run
   `flutter pub get` before `flutter run` so the dependency in
   `pubspec.yaml` actually gets fetched.
2. **`The argument type 'CardTheme' can't be assigned to the parameter type
   'CardThemeData?'`** — my mistake. Newer Flutter SDKs type
   `ThemeData.cardTheme` as `CardThemeData`, not the older `CardTheme`
   class. Fixed in `lib/theme/app_theme.dart`.

Run `flutter pub get` first, every time you pull in a new dependency or
open the project fresh, then `flutter run -d chrome` again.

## Running it

```
flutter create . --platforms=web,android,ios   # if you haven't already got the platform folders
flutter pub get
flutter analyze
flutter run -d chrome
```
