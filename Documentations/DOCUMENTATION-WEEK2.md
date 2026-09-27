# Documentation guide (what your docs must contain)



## 1. Overview

Focus Oasis is a gamified productivity and Pomodoro focus web application built for students and professionals looking to manage study sessions while nurturing a virtual garden. The application combines a customizable focus timer, persistent task tracking, and reward-based user progression to make deep work engaging and rewarding.

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
├── main.dart                 # App root and global theme configuration
├── models/
│   ├── plant_model.dart      # Plant growth stages and data
│   └── task_model.dart       # Task data structure with JSON serialization
├── theme/
│   └── app_theme.dart        # Design System v3 color tokens & typography
└── screens/
    ├── main_navigation_screen.dart # Root bottom navigation wrapper & lifted state
    ├── timer_home_screen.dart      # Pomodoro timer countdown & reward triggers
    ├── tasks_screen.dart           # Task management view & persistent local storage
    └── shop_screen.dart            # Reward shop & inventory placeholder view

## 6. Screenshots

<img width="402" height="821" alt="image" src="https://github.com/user-attachments/assets/9e9e4fcd-c55f-4afd-8cb9-83fd53873080" />
<img width="381" height="811" alt="image" src="https://github.com/user-attachments/assets/a68ac53b-093b-4845-9969-8b894de2908a" />
<img width="387" height="817" alt="image" src="https://github.com/user-attachments/assets/2c02324e-3a67-4187-a170-917dccdacf41" />
  

## 7. Known issues and next steps

What is not finished: Full item redemption logic inside the Shop screen grid, break-period countdown states, and audio notification chimes are still pending future implementation.

Known issues: Timer state resets if the application is hard-refreshed in the browser before an active session is completed.

Next Steps: Implement the full Shop & Inventory item grid, wire timer session completions directly into automatic task progress triggers, and finalize security checklist validations.

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
