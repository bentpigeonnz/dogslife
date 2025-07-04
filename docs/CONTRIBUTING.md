🛠 Contributing to dogsLife

Thank you for making dogsLife better!  
We follow best practices for modular Flutter + Riverpod projects.

---

## 🤝 Code of Conduct

- All contributors agree to [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

---

## 📥 Getting Started

1. **Read [ONBOARDING.md](ONBOARDING.md)** — get the app running locally
2. **Review open issues** — assign yourself before working on a task
3. **Ask questions in Discussions/Discord**

---

## 🧩 Branching & Workflow

- Use feature branches: `feature/your-task-name`
- Keep PRs focused, modular, and atomic
- Run all tests and `flutter analyze` before PR
- Use clear commit messages (`feat:`, `fix:`, `chore:`)

---

## 🏷 Code Style

- **Follow Flutter and Riverpod style** (`dart format`)
- Use feature folders, keep logic out of UI
- Always access state via Riverpod providers
- Use constants from `roles.dart`, `firebase_paths.dart`, etc

---

## 🐦 Riverpod Best Practices

- Use `Provider` for configs/constants
- Use `StateNotifierProvider` for mutable state
- Use `FutureProvider`/`StreamProvider` for async calls
- Never use Provider package

**Testing:**  
- Use `ProviderContainer` and overrides for tests

---

## 🧪 Tests

- Write unit, widget, and integration tests for all new features
- Test RBAC logic (roles, guards)
- Cover all Riverpod providers and business logic

---

## 🚦 Pull Requests

- Fill out [PULL_REQUEST_TEMPLATE.md](PULL_REQUEST_TEMPLATE.md)
- Add/Update [CHANGELOG.md](CHANGELOG.md) for user-facing changes
- PR must pass all tests & CI

---

## 📝 Docs

- Update relevant docs for new features (`README.md`, `ARCHITECTURE.md`, etc)
- Add screenshots if UI changes

---

## 🔒 Security

- Report vulnerabilities as per [SECURITY.md](SECURITY.md)

---

## 💬 Help & Support

- Ask questions in Issues/Discussions
- See [SUPPORT.md](SUPPORT.md) for more ways to get help

---