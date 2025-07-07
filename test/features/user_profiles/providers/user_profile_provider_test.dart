import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogsLife/features/user_profiles/providers/user_profile_provider.dart';
import 'package:dogsLife/features/user_profiles/models/user_profile.dart';

class FakeUserProfileService {
  static UserProfile fakeProfile = UserProfile(
    id: 'u1',
    email: 'test@user.com',
    name: 'Fake User',
    photoUrl: '',
    phone: '0212345678',
    address: 'NZ',
    role: 'guest',
  );
  static Future<UserProfile?> getUserProfileById(String id) async => fakeProfile;
}

void main() {
  test('userProfileProvider returns fake profile', () async {
    final container = ProviderContainer(overrides: [
      userProfileProvider.overrideWithProvider((id) => AsyncValue.data(FakeUserProfileService.fakeProfile)),
    ]);
    final profile = await container.read(userProfileProvider('u1').future);
    expect(profile?.name, 'Fake User');
  });

  test('allUserProfilesStreamProvider returns list with fake profile', () async {
    final container = ProviderContainer(overrides: [
      allUserProfilesStreamProvider.overrideWith((ref) => Stream.value([FakeUserProfileService.fakeProfile])),
    ]);
    final list = await container.read(allUserProfilesStreamProvider.future);
    expect(list.first.email, 'test@user.com');
  });
}
