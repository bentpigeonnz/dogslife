import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/donations/models/donation.dart';

void main() {
  test('Donation serializes/deserializes', () {
    final donation = Donation(
      id: 'don1',
      userId: 'u1',
      amount: 100.0,
      date: DateTime(2024, 5, 8),
      message: 'For the dogs!',
    );
    final json = donation.toJson();
    final donation2 = Donation.fromJson(json);
    expect(donation2.amount, 100.0);
  });
}
