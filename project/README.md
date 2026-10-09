# Final Project

## My project repository

Public repository: [https://github.com/Xo0yaa/Focus-Oasis](https://github.com/Xo0yaa/Focus-Oasis)

Live app (if deployed): Not confirmed yet. The repository includes a GitHub Pages workflow; add the published URL here after a successful deployment.

## What it is

Focus Oasis is a Flutter focus timer that turns completed focus sessions into progress for a virtual garden. Users can also complete daily tasks, earn water points, and unlock and choose plants in the shop.

## How to run it

1. Install the Flutter SDK and Google Chrome.
2. Clone the repository and open its folder in VS Code:

   ```sh
   git clone https://github.com/Xo0yaa/Focus-Oasis.git
   cd Focus-Oasis
   ```

3. Install the Flutter packages:

   ```sh
   flutter pub get
   ```

4. Run the app in Chrome:

   ```sh
   flutter run -d chrome
   ```

   This starts the app in offline mode. To use Supabase, create a local `.env.json` from `.env.example`, fill in `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY`, and apply the SQL migrations in `supabase/migrations/` to your Supabase project. Then run:

   ```sh
   flutter run -d chrome --dart-define-from-file=.env.json
   ```

   Do not put a Supabase secret or service-role key in the Flutter app.

## Presentation

- Video (public Google Drive link): [Focus Oasis demo video](https://drive.google.com/drive/folders/1bH7zUf2CQb-9nVOy5aIMnc5v06EyoKqN)
- Slides (link or PDF): [Focus Oasis PowerPoint](https://drive.google.com/drive/folders/18CuaK9sPlZRPWI078m1i8FVSpafrArQr)
- Square image: [Focus Oasis square image](https://drive.google.com/drive/folders/1NyGkUpNFB7lWhAAfPsU2H9IF7CQ9vohi)

## AI usage

Link to the `AI-USAGE.md` in my project repository:
[AI-USAGE.md](https://github.com/Xo0yaa/Focus-Oasis/blob/main/AI-USAGE.md)
