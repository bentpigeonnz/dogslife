import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/core/services/permission_service.dart';

void main() {
  test('admin can manage dogs', () {
    expect(PermissionService.canManageDogs('admin'), isTrue);
    expect(PermissionService.canManageDogs('guest'), isFalse);
  });

  test('adopter cannot manage users', () {
    expect(PermissionService.canManageUsers('adopter'), isFalse);
  });
}
