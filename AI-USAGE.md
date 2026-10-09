# AI usage

This project was built with AI assistance. This record is reconstructed from
the available Codex conversation and Git history. The dates below use the date
of the related implementation commit; Git does not preserve the date of each
prompt. Keep adding entries as you continue working.

## 1. How I used AI

### 2026-09-27 - Daily tasks and local persistence

- **Tool:** OpenAI Codex
- **What I asked for:** Help build the Daily Tasks screen and save its task data
  locally between app launches.
- **What it gave back:** A task list UI connected to local preferences.
- **What I kept, what I changed, and why:** I kept the screen and local-save
  approach, then continued adjusting the task states and layout to fit the app.
- **Commit:** [Implement Daily Tasks Screen with local persistence](https://github.com/Xo0yaa/Focus-Oasis/commit/70ced5efb5c2032c0cad0f4fbf27954f6a8a2fc5)

### 2026-10-04 - Login and timer layout

- **Tool:** OpenAI Codex
- **What I asked for:** Add an account screen and improve the timer and settings
  layout for the app.
- **What it gave back:** A login screen, settings panel, and revised timer UI.
- **What I kept, what I changed, and why:** I kept the login flow and visual
  direction, then requested follow-up layout changes against mobile screenshots.
- **Commit:** [Add login screen, settings panel, and layout updates](https://github.com/Xo0yaa/Focus-Oasis/commit/5f25c0f43ef03d76a994477e255aa24b1828d48b)

### 2026-10-05 - Responsive screens and device preview

- **Tool:** OpenAI Codex
- **What I asked for:** Make the Flutter screens fit mobile and Chrome, improve
  spacing, and add Device Preview for checking phone-sized layouts.
- **What it gave back:** Changes to the app entry point, screen layouts,
  dependencies, and the widget test.
- **What I kept, what I changed, and why:** I kept the Flutter-native responsive
  layout and preview setup, and continued refining the timer proportions using
  reference screenshots.
- **Commit:** [Update](https://github.com/Xo0yaa/Focus-Oasis/commit/b2aed923beb118a1a1c0ffe796f7bf7e9a41b3ef)

### 2026-10-09 - Supabase account setup

- **Tool:** OpenAI Codex
- **What I asked for:** Connect Supabase authentication, profile data, and
  account access events without putting private credentials in the app.
- **What it gave back:** Account-service code, SQL migrations with row-level
  security, environment templates, and setup documentation.
- **What I kept, what I changed, and why:** I used the publishable client key
  and RLS policies, kept secret/service-role keys out of the Flutter client,
  and made access logging best-effort so it cannot block a successful sign-in.
- **Commit:** [Update Focus Oasis app](https://github.com/Xo0yaa/Focus-Oasis/commit/297bab6a00edd434f4d16ca88042991c8c5a39f5)

### 2026-10-09 - Save and restore user progress

- **Tool:** OpenAI Codex
- **What I asked for:** Let signed-in users resume their points, plant,
  inventory, tasks, and timer state on another session or device.
- **What it gave back:** A progress service that syncs a user's saved state
  between local preferences and a Supabase row protected by RLS.
- **What I kept, what I changed, and why:** I kept local preferences as the
  offline cache and Supabase as the signed-in backup, so the app remains usable
  without a network connection.
- **Commit:** [Update Focus Oasis app](https://github.com/Xo0yaa/Focus-Oasis/commit/297bab6a00edd434f4d16ca88042991c8c5a39f5)

### 2026-10-09 - Daily tasks and reward rules

- **Tool:** OpenAI Codex
- **What I asked for:** Reset daily task completion each day and stop rewards
  from being claimed before a task is completed.
- **What it gave back:** Daily reset logic, claim guards, and timer-based
  completion for focus-duration tasks.
- **What I kept, what I changed, and why:** I kept timer verification for focus
  tasks. For tasks performed outside the app, I accepted that the app cannot
  independently prove completion without an observable signal.
- **Commit:** [Update Focus Oasis app](https://github.com/Xo0yaa/Focus-Oasis/commit/297bab6a00edd434f4d16ca88042991c8c5a39f5)

### 2026-10-09 - Review account sign-in reliability

- **Tool:** OpenAI Codex
- **What I asked for:** Review the application for problems and improvements.
- **What it gave back:** A review found sign-in depended on optional profile
  and audit-log queries, and changed audit logging so those failures do not
  block authentication.
- **What I kept, what I changed, and why:** I kept the reliability fix while
  retaining the profile and log retrieval methods for future account screens.
- **Commit:** The fix is currently uncommitted. Add its GitHub commit link after
  committing the change.

## 2. Where the AI got it wrong

### Case 1 - Timer content disappeared after a layout change

- **What it gave me:** A revised screen layout intended to balance the timer
  and bottom navigation.
- **What was wrong with it:** The result shown in Chrome had a blank main area
  with only the navigation visible, so the primary timer content was missing.
- **What I did instead:** I reported the actual output and asked to restore the
  timer ring and fit the action controls on the screen. The later screen code
  keeps the timer content in a scrollable, size-constrained layout.
- **Commit:** [Update Focus Oasis app](https://github.com/Xo0yaa/Focus-Oasis/commit/297bab6a00edd434f4d16ca88042991c8c5a39f5)

### Case 2 - Focus-task verification did not cover every task

- **What it gave me:** A rule that verifies tasks named like “Focus for 30
  minutes” using completed timer minutes.
- **What was wrong with it:** That rule only verifies focus-duration tasks; a
  checkbox for an external task cannot prove that the real-world task happened.
- **What I did instead:** I clarified that only actions the app can observe can
  be verified automatically. I accepted timer verification for focus tasks and
  the limitation for tasks performed outside the app.
- **Commit:** [Update Focus Oasis app](https://github.com/Xo0yaa/Focus-Oasis/commit/297bab6a00edd434f4d16ca88042991c8c5a39f5)

### Case 3 - Optional database reads could make sign-in look unsuccessful

- **What it gave me:** Account code that fetched the profile and access logs
  immediately after authenticating.
- **What was wrong with it:** If a table was missing or unavailable, the user
  could be authenticated by Supabase but still see an error instead of entering
  the app.
- **What I did instead:** I changed sign-in so audit logging is best-effort and
  no longer waits on unused profile/log reads.
- **Commit:** [Update Focus Oasis app](https://github.com/Xo0yaa/Focus-Oasis/commit/297bab6a00edd434f4d16ca88042991c8c5a39f5)

## 3. Who wrote what

Git lists you as the author of commits, but that alone does not prove which code
you personally wrote. Fill in the first section with work you can honestly
explain and claim; the assignment requires at least 20% of the project code to
be yours.

### Written by me

- **File:** `[Name a file or feature you personally wrote]`
- **Commit:** `[Link the commit that contains your work]`
- **What it does and why it is built this way:** `[Explain this in your own words. Be specific about the parts you wrote.]`

### The AI-written part I understand best

- **File:** `lib/services/progress_service.dart`
- **Commit:** [Update Focus Oasis app](https://github.com/Xo0yaa/Focus-Oasis/commit/297bab6a00edd434f4d16ca88042991c8c5a39f5)
- **What it does and why we kept it:** It copies app progress between the
  device's local preferences and the signed-in user's Supabase row. Local
  preferences keep offline play working, while the cloud copy lets the user
  resume on another session or device. Make sure you can explain this code
  yourself before submitting the file.
