# 🏗 dogsLife — Architecture

**Modular. Clean. Riverpod-powered.**

---

## Overview

dogsLife is a modern, scalable, role-based Flutter app with a feature-first folder structure.  
All state and dependency management uses **Riverpod** (no Provider at all).

---

## 🌳 High-Level Structure

lib/
features/
dog_management/
adoption/
events/
merchandise/
user_profiles/
admin/
core/
providers/ # Riverpod providers (e.g. auth, theme, role)
themes/
constants/
widgets/ # Shared UI components
services/ # Firebase helpers, REST, image, auth (all via Riverpod)
shared/ # Utilities, extensions, validators
router.dart # Centralized GoRouter + guards (RBAC via Riverpod)
main.dart

---

## 🔗 State Management

**All app-wide and feature state uses [Riverpod](https://riverpod.dev/) (v2+)**

- `Provider` for constants/config
- `StateNotifierProvider` for models/services with logic
- `FutureProvider` / `StreamProvider` for async/Firestore queries
- No global `Provider` package anywhere

**RBAC**  
Role state and guards live in `role_provider.dart` (using `StateNotifierProvider`).  
Screens and widgets read roles via Riverpod.

---

## 🔄 Routing

- **GoRouter** for all navigation and route guards
- Auth and RBAC checks powered by Riverpod providers

---

## 🔥 Firebase Integration

- All Firebase access via Riverpod services (`auth_service.dart`, `dog_service.dart`, etc)
- No direct Firestore/Auth calls in UI/widgets

---

## 📱 Theming

- Material 3, dark/light toggle
- Theme managed via Riverpod `theme_provider.dart`

---

## 🧩 Feature Example: Dogs

- `dog_service.dart` — Firestore and storage helper (CRUD, gallery, etc)
- `dog_list_screen.dart` — Reads list from `dogListProvider`
- `dog_detail_screen.dart` — Reads via `dogProvider(id)`
- `dog_form_screen.dart` — Uses `dogFormProvider` for state, `dog_service` for save/update

---

## 🔐 RBAC Flow

- User role loaded via `role_provider.dart` on login
- All screens/widgets read `roleProvider` from Riverpod
- GoRouter guards use Riverpod role logic for access control

---

## 🔬 Testing

- All business logic in Riverpod providers/services
- Widget tests use `ProviderScope` for overrides/mocking

---

## 🏷️ Optional/Advanced

- **Hydrated state**: Use `shared_preferences` via Riverpod for persistence
- **Background tasks**: Integrate with Riverpod + isolates
- **CI/CD**: All Riverpod providers have mockable interfaces for easy testing

---

## 📐 Architecture Diagram

[ UI Screens/Widgets ]
|
[GoRouter]
|
[Riverpod Providers]
|
[Services/Helpers]
|
[Firebase/API/DB]
