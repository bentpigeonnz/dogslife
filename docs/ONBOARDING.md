🏁 Getting Started with dogsLife

Welcome! This guide will get you set up with the **Riverpod-powered** dogsLife project, step by step.

## 1. Requirements

- Flutter 3.32+ (run `flutter doctor`)
- Dart 3.8+
- Android Studio or VSCode
- Firebase project set up

---

## 2. Clone and Install

git clone https://github.com/your-org/dogslife.git
cd dogslife
flutter pub get

---

## 3. Environment
Copy .env.example to .env and fill in your Firebase/Stripe keys

Download/generate firebase_options.dart with the Firebase CLI

---

## 4. Firebase Setup
Create your Firebase project

Enable Firestore, Auth, and Storage

Download google-services.json and firebase_options.dart

---

## 5. Run the App
Android: flutter run -d android

Web: flutter run -d chrome

Windows: flutter run -d windows

---

## 6. Riverpod & ProviderScope
App wraps everything in ProviderScope

See /core/providers/ for app-wide providers

---

## 7. Troubleshooting
Common issues? See SUPPORT.md or open an Issue

---

## 8. Optional
Try running the full test suite: flutter test

Set up a new feature branch and make your first PR!