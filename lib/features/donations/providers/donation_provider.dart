import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/donation.dart';
import '../services/donation_service.dart';

// AsyncNotifierProvider.family for a single donation by ID
final donationProvider =
AsyncNotifierProvider.family<DonationAsyncNotifier, Donation?, String>(
  DonationAsyncNotifier.new,
);

class DonationAsyncNotifier extends FamilyAsyncNotifier<Donation?, String> {
  @override
  Future<Donation?> build(String id) {
    return DonationService.getDonationById(id);
  }
}

// StreamProvider.family for live updates of a donation by ID
final donationStreamProvider = StreamProvider.family<Donation?, String>(
      (ref, id) => DonationService.streamDonationById(id),
);

// StreamProvider for all donations
final allDonationsStreamProvider = StreamProvider<List<Donation>>(
      (ref) => DonationService.streamAllDonations(),
);
