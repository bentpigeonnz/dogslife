🟧 TESTING.md

# 🧪 Testing dogsLife

We use Flutter’s testing suite, with **Riverpod** for state mocking and provider overrides.

---

## 1. Types of Tests

- **Unit Tests:** Logic, models, helpers, Riverpod Notifiers
- **Widget Tests:** UI widgets (ProviderScope, overrides)
- **Integration Tests:** Full app flows

---

## 2. How to Run Tests

flutter test

## 3. Riverpod Testing
Use ProviderContainer for unit tests

Use ProviderScope(overrides: [...]) in widget tests to mock providers

Mock Firebase/services using mocktail or Mockito

## 4. Structure
bash
Copy code
test/
  features/
  services/
  core/
  shared/

##5. Coverage
Cover all providers/services with unit tests

Test RBAC (roles, permissions) logic with mocks/overrides

##6. Example (Riverpod Provider)
dart
Copy code
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  test('dogListProvider returns dog list', () async {
    final container = ProviderContainer();
    final dogs = container.read(dogListProvider.future);
    expect(await dogs, isA<List<Dog>>());
  });
}

##7. CI Integration
Add flutter test to CI workflows

Use provider overrides to inject test data/services