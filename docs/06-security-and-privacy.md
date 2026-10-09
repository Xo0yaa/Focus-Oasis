# Security and privacy

**Last updated:** 2026-10-08

## Data stored

| Data | Location | Access |
| --- | --- | --- |
| Supabase Auth email and password verifier | Supabase Auth | Password is managed by Supabase Auth; the app never reads or stores it |
| Profile email and account creation date | Supabase `public.profiles` | Authenticated owner only, enforced by RLS |
| Successful sign-up and sign-in events | Supabase `public.auth_access_logs` | Owner can read own events and add events for their authenticated identity |
| Timer, task, and garden state | Device `shared_preferences` | Local app installation |

Failed sign-in attempts are handled by Supabase Auth and are not inserted into the client-writable access log. The current log records successful `sign_up` and `sign_in` events only.

## Configuration

- `.env.example` is a JSON template. Copy it to `.env.json` locally and use `flutter run --dart-define-from-file=.env.json`.
- `.env`, `.env.*`, and `env.json` are ignored by Git; `.env.example` is explicitly allowed.
- GitHub Pages reads `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` from repository Actions secrets.
- These two values are compiled into the web client and are public. Supabase's publishable key is safe to expose only with the policies below in place.
- Never place a Supabase secret/service-role key, password, or service account file in Flutter code, a web build, or GitHub Actions build variables.

## Database access controls

The migration in `supabase/migrations/` enables row-level security on both tables. Authenticated users may select their own profile row (`auth.uid() = profiles.id`), select their own log rows (`auth.uid() = auth_access_logs.user_id`), and insert log rows only when both the user id and email match the authenticated JWT. Anonymous users have no table access. A database trigger creates and synchronizes profile emails from `auth.users`; a backfill creates profile rows for existing accounts.

## Public repository checklist

- [x] `.env` variants are ignored and `.env.example` contains placeholders only.
- [x] The Supabase migration enables RLS and defines per-user policies.
- [x] The browser build receives only the Supabase URL and publishable key.
- [ ] Before publishing, check the commit history for credentials that may have been committed previously. Rotate any exposed credential; deleting a file does not remove it from Git history.
- [ ] Apply the migration to the target Supabase project and confirm its Auth email-confirmation and redirect settings.
- [ ] Avoid real user data in screenshots, sample data, and public videos.
