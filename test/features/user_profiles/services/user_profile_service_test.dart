import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/user_profiles/services/user_profile_service.dart';
import 'package:dogsLife/features/user_profiles/models/user_profile.dart';

void main() {
  test('getUserProfileById returns null for unknown', () async {
    final profile = await UserProfileService.getUserProfileById('notfound');
    expect(profile, isNull);
  });

  test('addUserProfile returns without error', () async {
    final profile = UserProfile(
      id: 'test',
      email: 'test@unit.test',
      name: 'Unit Test',
      photoUrl: '',
      phone: '021000000',
      address: 'Test Ave',
      role: 'guest',
    );
    await UserProfileService.addUserProfile(profile);
  });
}
