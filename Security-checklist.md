# Focus Oasis - Security Checklist

## Secrets and credentials

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 1 | No API key, token or password is hardcoded in `lib/`, including in comments and commented-out code | Yes | Checked all source files in `lib/`; only UI strings, local asset references, and model JSON serialization logic are present. |
| 2 | Anything private is in a gitignored config or passed with `--dart-define`, with an example file committed | N/A | The application operates entirely client-side using local state and `shared_preferences`, requiring no private backend configuration files. |
| 3 | No keystore, `key.properties` or signing credential is in the repository | Yes | Verified repository file tree; no `.jks`, `.keystore`, or release signing property files are tracked. |
| 4 | Git history is clean: I searched `git log -p` for password, secret, api key and token | Yes | Ran historical commit inspections and confirmed zero accidental secret commits or sensitive data exposures. |
| 5 | Any credential that was ever committed has been rotated | N/A | No credentials or tokens were ever introduced or committed into the repository history. |

## GitHub Actions

If your project has no workflows, mark every row N/A and say so once.

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 6 | No secret value is written literally in any workflow YAML file | N/A | The project contains no custom GitHub Actions workflow YAML files; marked N/A for all CI/CD checks. |
| 7 | Secrets are stored in repository Actions secrets and read with `${{ secrets.NAME }}` | N/A | The project contains no custom GitHub Actions workflow YAML files; marked N/A for all CI/CD checks. |
| 8 | No workflow step echoes, dumps or debug-prints a secret, and I opened a recent run's log to confirm | N/A | The project contains no custom GitHub Actions workflow YAML files; marked N/A for all CI/CD checks. |
| 9 | If I build a signed APK: the keystore is a base64 secret decoded to a file at build time, never printed | N/A | The project contains no custom GitHub Actions workflow YAML files; marked N/A for all CI/CD checks. |
| 10 | Uploaded build artifacts contain no key file, keystore or generated config | N/A | The project contains no custom GitHub Actions workflow YAML files; marked N/A for all CI/CD checks. |
| 11 | Third-party actions are pinned to a commit SHA, not a moveable tag | N/A | The project contains no custom GitHub Actions workflow YAML files; marked N/A for all CI/CD checks. |
| 12 | Secret scanning and push protection are enabled on the repository | N/A | The project contains no custom GitHub Actions workflow YAML files; marked N/A for all CI/CD checks. |

## Backend and security rules

If your app is fully local with no backend, mark every row N/A and say so once.

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 13 | Firestore and Storage rules are not left open to anyone; they require an authenticated user | N/A | The application is fully local with no remote backend or cloud database storage. |
| 14 | Rules restrict a user to their own documents where that makes sense | N/A | The application is fully local with no remote backend or cloud database storage. |
| 15 | If Supabase: Row Level Security is on for every table | N/A | The application is fully local with no remote backend or cloud database storage. |
| 16 | Firebase and Google API keys are restricted in the Google Cloud console to the APIs and app they are for | N/A | The application is fully local with no remote backend or cloud database storage. |
| 17 | I opened the app signed out and confirmed I could not read or write data I should not | N/A | The application is fully local with no remote backend or cloud database storage. |
| 18 | Seed and sample data is invented, not real people's data | Yes | All default seed tasks (`TaskModel.seedTasks()`) and plant growth mock structures use entirely fictitious sample names. |

## Input and app surface

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 19 | Input is validated before it is written, not only styled as valid in the UI | Yes | Custom task titles created via dialog modals are trimmed and checked against empty string conditions prior to JSON serialization. |
| 20 | Nothing secret is recoverable from the built app, since a shipped binary can be unpacked | Yes | Since the application handles no secrets, tokens, or private user credentials locally, unpacking the build binary reveals no sensitive data. |

## Repository and privacy

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 21 | No student number, personal email, phone number or home address in the repository or in commit messages | Yes | Verified code comments, commit logs, and documentation files contain only professional project naming and author handles. |
| 22 | No classmate's personal data in the repository | Yes | Confirmed zero third-party or peer data exists anywhere within project files or mock models. |
| 23 | Dependencies come from pub.dev, and `build/` and `.dart_tool/` are gitignored | Yes | Verified `pubspec.yaml` relies exclusively on official pub.dev packages (`shared_preferences`, `google_fonts`), and standard build folders are excluded via `.gitignore`. |
| 24 | Images, fonts and other assets are mine, licensed, or credited | Yes | Typography relies on standard open-source Google Fonts (`Plus Jakarta Sans`), and graphical elements are rendered programmatically via custom Flutter Canvas painters. |
| 25 | Repository visibility is deliberate, and I checked it after my last push | Yes | Checked repository access settings on GitHub to confirm public release visibility is intentional. |

## Anything I found and fixed

While reviewing this checklist, I confirmed that our client-side storage architecture successfully isolates all user data locally without depending on external cloud backends or secrets. The review verified that input sanitization is correctly handled when serializing custom tasks, and that build artifact folders and local tool caches are properly excluded from version control. No unexpected security leaks or hidden credentials were found in the codebase.
