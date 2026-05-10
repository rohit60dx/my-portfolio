// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rohit_portfolio/models/app_model.dart';
import 'package:rohit_portfolio/models/profile_model.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── PROFILE ────────────────────────────────────────────────
  static Future<ProfileModel> getProfile() async {
    try {
      final doc = await _db.collection('portfolio').doc('profile').get();
      if (doc.exists && doc.data() != null) {
        return ProfileModel.fromFirestore(doc.data()!);
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
    return ProfileModel.defaultProfile();
  }

  // ─── PROJECTS ───────────────────────────────────────────────
  static Future<List<ProjectModel>> getProjects() async {
    try {
      final snapshot = await _db.collection('projects').orderBy('order').get();
      return snapshot.docs
          .map((doc) => ProjectModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }

  // ─── APPS ───────────────────────────────────────────────────
  static Future<List<AppModel>> getApps() async {
    try {
      final snapshot = await _db
          .collection('apps')
          .where('isPublished', isEqualTo: true)
          .orderBy('order')
          .get();
      return snapshot.docs
          .map((doc) => AppModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching apps: $e');
      return [];
    }
  }

  // ─── CONTACT FORM SUBMIT ─────────────────────────────────────
  static Future<bool> submitContact({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      await _db.collection('contacts').add({
        'name': name,
        'email': email,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });
      return true;
    } catch (e) {
      print('Error submitting contact: $e');
      return false;
    }
  }
}
