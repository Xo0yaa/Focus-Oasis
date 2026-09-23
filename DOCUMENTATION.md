# Documentation guide (what your docs must contain)

## 1. Overview

Focus Oasis is a gamified Pomodoro focus application designed to help students and productivity-driven individuals manage their study sessions and maintain high focus. The app combines a clean distraction-free countdown timer with a virtual garden ecosystem where users earn Water Points to grow virtual plants and unlock items in the shop.

## 2. Setup and installation

Follow these steps to run the application from scratch on your local machine:

-Flutter & Dart Versions: Built using Flutter 3.x and Dart 3.x.

STEP 1 (Clone the Repository):
git clone <repository_url>

STEP 2 (Install Dependencies):
flutter pub get


## 3. How to run it

flutter run -d chrome

## 4. Features and usage

-Oasis Timer: Set your focus duration, start the countdown ring, and earn Water Points upon session completion.
-Tasks Screen: Manage daily goals and academic milestones alongside your focus sessions.
-Shop & Inventory: Spend your earned Water Points to acquire virtual items and items for your oasis.
-Shared State Management: Water balances sync instantly across all tabs using a clean state-lifting architecture.

## 5. Project structure

lib/
├── main.dart                 # App root and DevicePreview setup
├── theme/
│   └── app_theme.dart        # Design System v3 color tokens & typography
└── screens/
    ├── main_navigation_screen.dart # Root bottom navigation wrapper & lifted state
    ├── timer_home_screen.dart      # Pomodoro timer countdown & reward triggers
    ├── tasks_screen.dart           # Task management view
    └── shop_screen.dart            # Reward shop & inventory view

## 6. Screenshots
<img width="452" height="836" alt="image" src="https://github.com/user-attachments/assets/0e49dca4-f14e-4b36-86be-6a3f17894d69" />
<img width="475" height="856" alt="image" src="https://github.com/user-attachments/assets/df2aa8ba-7cc4-4835-82aa-1c8a840a0e90" />
<img width="506" height="842" alt="image" src="https://github.com/user-attachments/assets/dbe93dd3-611f-4b27-be3e-979c0ce5daa9" />

## 7. Known issues and next steps

What is not finished: Persistence using shared_preferences across app reloads, break-period countdown states, and sound chimes are still pending full implementation.
Known issues: Timer state resets if the application is hard-refreshed in the browser before session completion.
Next Steps: Implement local caching for point balances, refine custom plant growth tiers, and finalize security checklist validations.

## How it is graded

See `rubrics.md` in this unit for the exact point breakdown. In short: your setup
and run steps must actually work (that is the largest share), your feature and
usage docs must match what the app really does, and screenshots plus clear
writing carry the rest.

## Security checklist (from week 2)

From week 2 your documentation also includes a completed `SECURITY-CHECKLIST.md`
in your workspace `project/` folder. Copy `security-checklist-template.md` from
this unit and fill it in.

Every row is answered Yes, No or N/A, with one line of evidence in your own
words. "N/A" is a correct answer when it is true, and it needs its reason
written next to it. Fill it in **before** you make your repository public, not
after, because that is the point of it. It is worth 3 of the 15 points in
week 2.

## AI usage

Your repository must also carry an `AI-USAGE.md` and a credit line in the
README. That file is graded separately, as your finals badge, and it is worth
100 points; see the `finals-badge` unit for what goes in it. For your weekly
Documentation Update all that is checked is that the file **exists and is
current**, so start it in week 1 and keep it up as you go.
