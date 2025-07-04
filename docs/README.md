# 🐶 dogsLife

A modern, modular, and scalable Flutter app for NZ Dog Shelters and pet lovers, built using **Flutter 3.32+** and **Riverpod** for state management.  
Supports Android, Web, and Windows (no iOS/macOS).

## 🚀 Features

- 🏠 Home: Beautiful dashboard and navigation
- 🐕 Dog Management: Add, edit, gallery (multi-photo), medical & adoption info
- 📝 Adoption Applications: Multi-step form, status, photo uploads, review workflow
- 🛍 Merchandise: Listings, stock, order flow (Stripe-ready)
- 📅 Events: RSVP, status, role-based actions
- 👤 User Profiles: Role badges, profile photos, Google Places autocomplete
- 🔒 RBAC: Role-Based Access Control (all screens, actions)
- 🌈 Theming: Modern Material 3, dark/light, responsive
- 🌐 Firebase (Firestore, Auth, Storage)
- 🧩 **Riverpod** for all state & dependency management
- 🛠️ Easy extension for more features (donations, merch, audit, admin dashboard)

## 🧑‍💻 Tech Stack

- **Flutter** 3.32+ (Android Studio/VSCode supported)
- **Riverpod** (state management)
- **Firebase** (auth, Firestore, storage)
- **GoRouter** (navigation/routing)
- **shared_preferences** (local key/value)
- **Freezed, JsonSerializable** (model classes, serialization)
- **shadcn/ui** (design system inspiration)
- **Modern folder structure** (feature-first + core/services/utils/shared)

---

## 🏁 Quickstart

1. **Clone the repo**

git clone https://github.com/your-org/dogslife.git
cd dogslife

2. **Setup Flutter, Dart, Firebase CLI, and required tools**

- Flutter: https://docs.flutter.dev/get-started/install
- Dart: https://dart.dev/get-dart
- Firebase CLI: https://firebase.google.com/docs/cli

3. **Install dependencies**

flutter pub get

4. **Add your `.env` and `firebase_options.dart` (see ONBOARDING.md)**

5. **Run the app**

flutter run -d windows
flutter run -d chrome
flutter run -d android

6. **Login/Register and try it out!**

---

## 📁 Folder Structure

lib/
features/ # Feature-first structure (dogs, adoption, users, merch, events)
core/ # Core logic, base widgets, constants, themes, providers
services/ # Riverpod-based services (auth, dog_service, image_service, etc)
shared/ # Shared widgets, utils, extensions
router.dart # GoRouter configuration and guards
main.dart # Entry point, MultiProvider/Riverpod, theming

---

## 📚 Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [TESTING.md](TESTING.md)
- [ONBOARDING.md](ONBOARDING.md)
- [API.md](API.md)
- [SECURITY.md](SECURITY.md)
- [CHANGELOG.md](CHANGELOG.md)
- [GOVERNANCE.md](GOVERNANCE.md)
- [LICENSE](LICENSE)

---

## ❤️ Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for workflow, code style, PR process, and Riverpod tips.

---

## ⚡ Credits

- Built with [Flutter](https://flutter.dev/) and [Riverpod](https://riverpod.dev/).
- Inspired by best practices in OSS, NZ legal compliance, and animal welfare.

---
