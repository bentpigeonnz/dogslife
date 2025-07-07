// features/adoptions/models/adoption.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Adoption {
  final String id;
  final String applicantName;
  final String email;
  final String phone;
  final String comments;
  final List<String> photoUrls;
  final String status;
  final DateTime submittedAt;

  Adoption({
    required this.id,
    required this.applicantName,
    required this.email,
    required this.phone,
    required this.comments,
    required this.photoUrls,
    required this.status,
    required this.submittedAt,
  });

  // Firestore serialization
  factory Adoption.fromFirestore(doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Adoption(
      id: doc.id,
      applicantName: data['applicantName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      comments: data['comments'] ?? '',
      photoUrls: List<String>.from(data['photoUrls'] ?? []),
      status: data['status'] ?? 'Pending',
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'applicantName': applicantName,
    'email': email,
    'phone': phone,
    'comments': comments,
    'photoUrls': photoUrls,
    'status': status,
    'submittedAt': submittedAt,
  };
}
