# Focus Oasis

Focus Oasis is a Flutter Pomodoro app where focused work grows a small garden. It includes a focus timer, daily tasks, water points, and a plant shop. The app supports local offline use and optional email accounts backed by Supabase.

## Tech stack

- Flutter and Dart
- SharedPreferences for local timer, task, and game state
- Supabase Auth and Postgres for email accounts, access logs, and per-user progress sync
- GitHub Actions and GitHub Pages for free static web hosting

## Run locally

Install the stable Flutter SDK, then:

```sh
flutter pub get
flutter run -d chrome
```

In debug mode, Device Preview adds a device selector and frame to the app in Chrome so you can check the mobile layouts at different screen sizes. It is disabled in release builds.

Without Supabase configuration, the app opens in offline mode. To enable email accounts and cross-device progress sync, create a Supabase project and apply both SQL migrations in `supabase/migrations/` using the Supabase SQL Editor.

Copy `.env.example` to `.env.json`, then set your Supabase project URL and **publishable** key (formerly called the anon key). Locally, run:

```sh
flutter run -d chrome --dart-define-from-file=.env.json
```

Flutter compiles these values into the client bundle. The URL and publishable key are intended to be public; row-level security protects user data. Never put a Supabase secret/service-role key in `.env.json`, source code, or a web build. `.env.json` is ignored by Git. Authentication passwords are handled by Supabase Auth and are not stored in this app's tables.

The `profiles` table keeps each account's email. `auth_access_logs` stores sign-up/sign-in events. `user_progress` stores the account's points, active plant, timer state, tasks, inventory, and focus totals. Row-level security restricts every account to its own profile, access logs, and progress row. Progress is restored after login and saved when app state changes; active timer state is checkpointed every 15 seconds so another device can resume the remaining time.

## Deploy to a public URL with GitHub Pages

The repository includes a GitHub Actions workflow that builds Flutter Web and publishes it to GitHub Pages on pushes to `main`.

1. Push this repository to GitHub and make it public (GitHub Pages is free for public repositories).
2. In the repository, open **Settings → Secrets and variables → Actions** and add `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY`. Use the project URL and publishable key from Supabase's project API settings. These are public client configuration values; do not add a secret/service-role key.
3. In **Settings → Pages**, choose **GitHub Actions** as the build and deployment source.
4. Push to `main`, or open **Actions → Deploy web demo → Run workflow**. The workflow builds the web app and deploys it.
5. Open **Settings → Pages** to find the published URL, usually `https://<username>.github.io/<repository>/`.
6. In Supabase **Authentication → URL Configuration**, add the published URL to the allowed redirect URLs. Configure email confirmation and SMTP settings to match your account policy.

If the Supabase secrets are omitted, the deployment still works in offline mode. Changes to web source require a new Pages build. Local and GitHub Actions builds use the same `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` names.

## Database setup and schema updates

Apply every SQL file in `supabase/migrations/` in timestamp order in the Supabase SQL Editor, or use the Supabase CLI (`supabase db push`) after linking your project. Keep database schema changes in `supabase/migrations/`. Supabase Auth manages credentials and sessions; the app never stores raw passwords or a service-role key.

## Project layout

- `lib/screens/` — login, garden timer, tasks, and shop screens
- `lib/services/account_service.dart` — sign-in, profile retrieval, and access-log operations
- `supabase/migrations/` — database schema and row-level security policies
- `.github/workflows/deploy-web.yml` — GitHub Pages build and deployment
- `.env.example` — local configuration template (contains placeholders only)
