import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/donations/services/donation_service.dart';
import 'package:dogsLife/features/donations/models/donation.dart';

void main() {
  test('getDonationById returns null for unknown', () async {
    final donation = await DonationService.getDonationById('notfound');
    expect(donation, isNull);
  });

  test('addDonation returns without error', () async {
    final donation = Donation(
      id: 'test',
      userId: 'user',
      amount: 10.0,
      date: DateTime.now(),
      message: 'Sample',
    );
    await DonationService.addDonation(donation);
  });
}
