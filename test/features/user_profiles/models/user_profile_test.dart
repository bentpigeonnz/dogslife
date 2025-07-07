import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/user_profiles/models/user_profile.dart';

void main() {
  test('UserProfile serializes/deserializes', () {
    final profile = UserProfile(
      id: 'u1',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: 'pic.png',
      phone: '0210000000',
      address: '1 Main St',
      role: 'guest',
    );
    final json = profile.toJson();
    final profile2 = UserProfile.fromJson(json);
    expect(profile2.email, 'test@example.com');
  });
}
