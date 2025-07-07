import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/core/providers/role_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('roleProvider defaults to guest', () async {
    final container = ProviderContainer();
    final role = await container.read(roleProvider.future);
    expect(role, 'guest');
  });

  test('can set and clear dev role override', () async {
    final container = ProviderContainer();
    final notifier = container.read(roleProvider.notifier);
    await notifier.setRole('admin');
    expect(await container.read(roleProvider.future), 'admin');

    await notifier.clearDevOverride();
    expect(await container.read(roleProvider.future), 'guest');
  });
}
