// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rohit_portfolio/models/app_model.dart';
import 'package:rohit_portfolio/models/profile_model.dart';
import 'package:rohit_portfolio/models/project_model.dart';

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

  // ─── SAVE APP ────────────────────────────────────────────────
  static Future<bool> saveApp(AppModel app) async {
    try {
      // Get current apps count for order
      final snapshot = await _db.collection('apps').get();
      final order = snapshot.docs.length;

      await _db.collection('apps').add({
        'name': app.name,
        'shortDescription': app.shortDescription,
        'description': app.description,
        'iconUrl': app.iconUrl,
        'screenshots': app.screenshots,
        'rating': app.rating,
        'totalRatings': app.totalRatings,
        'downloads': app.downloads,
        'version': app.version,
        'size': app.size,
        'category': app.category,
        'features': app.features,
        'playStoreUrl': app.playStoreUrl?.isNotEmpty == true
            ? app.playStoreUrl
            : null,
        'appStoreUrl': app.appStoreUrl?.isNotEmpty == true
            ? app.appStoreUrl
            : null,
        'androidApkUrl': app.androidApkUrl?.isNotEmpty == true
            ? app.androidApkUrl
            : null,
        'isPublished': true,
        'order': order,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error saving app: $e');
      return false;
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
