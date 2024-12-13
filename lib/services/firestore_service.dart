import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a study plan to Firestore
  Future<void> addStudyPlan({
    required String userId,
    required String subject,
    required String studyMaterial,
    required String targetDate,
    required String duration,
  }) async {
    await _firestore.collection('study_plans').add({
      'userId': userId,
      'subject': subject,
      'studyMaterial': studyMaterial,
      'targetDate': targetDate,
      'duration': duration,
    });
  }

  // Stream study plans for a specific user
  Stream<QuerySnapshot> getStudyPlans(String userId) {
    return _firestore
        .collection('study_plans')
        .where('userId', isEqualTo: userId) // Filter by userId
        .orderBy('targetDate') // Sort by targetDate
        .snapshots(); // Return the QuerySnapshot stream
  }
}
