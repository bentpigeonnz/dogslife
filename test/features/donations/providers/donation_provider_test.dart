import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogsLife/features/donations/providers/donation_provider.dart';
import 'package:dogsLife/features/donations/models/donation.dart';

class FakeDonationService {
  static Donation fakeDonation = Donation(
    id: 'd1',
    userId: 'u1',
    amount: 25.0,
    date: DateTime.now(),
    message: 'Best wishes!',
  );
  static Future<Donation?> getDonationById(String id) async => fakeDonation;
}

void main() {
  test('donationProvider returns fake donation', () async {
    final container = ProviderContainer(overrides: [
      donationProvider.overrideWithProvider((id) => AsyncValue.data(FakeDonationService.fakeDonation)),
    ]);
    final donation = await container.read(donationProvider('d1').future);
    expect(donation?.amount, 25.0);
  });

  test('allDonationsStreamProvider returns list with fake donation', () async {
    final container = ProviderContainer(overrides: [
      allDonationsStreamProvider.overrideWith((ref) => Stream.value([FakeDonationService.fakeDonation])),
    ]);
    final list = await container.read(allDonationsStreamProvider.future);
    expect(list.first.userId, 'u1');
  });
}
