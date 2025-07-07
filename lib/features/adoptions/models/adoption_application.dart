// features/adoptions/models/adoption_application.dart

class AdoptionApplication {
  final String id;
  final String applicantName;
  final String email;
  final String phone;
  final String comments;
  final List<String> photoUrls;
  final String status; // e.g. "Pending", "Approved", "Rejected"
  final DateTime submittedAt;

  AdoptionApplication({
    required this.id,
    required this.applicantName,
    required this.email,
    required this.phone,
    required this.comments,
    required this.photoUrls,
    required this.status,
    required this.submittedAt,
  });

// Add .fromMap, .toMap, .fromFirestore as needed for Firestore integration
}
