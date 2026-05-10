// lib/services/app_fetch_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rohit_portfolio/models/app_model.dart';

class AppFetchService {
  // ✅ Apni deployed Cloud Function ka URL yahan daalo
  static const String _functionUrl =
      'https://my-portfolio-57yr.onrender.com/fetch-app';

  /// Sirf Play Store URL, ya Apple URL, ya dono de sakte ho
  static Future<AppModel?> fetchFromStores({
    String? playStoreUrl,
    String? appStoreUrl,
  }) async {
    if (playStoreUrl == null && appStoreUrl == null) return null;

    try {
      final response = await http.post(
        Uri.parse(_functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          if (playStoreUrl != null) 'playUrl': playStoreUrl,
          if (appStoreUrl != null) 'appleUrl': appStoreUrl,
        }),
      );

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return AppModel(
        id: '', // Firebase mein save karte waqt set hoga
        name: data['name'] ?? '',
        shortDescription: data['shortDescription'] ?? '',
        description: data['description'] ?? '',
        iconUrl: data['iconUrl'] ?? '',
        screenshots: List<String>.from(data['screenshots'] ?? []),
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
        totalRatings: (data['totalRatings'] as num?)?.toInt() ?? 0,
        downloads: (data['downloads'] as num?)?.toInt() ?? 0,
        version: data['version'] ?? '',
        size: data['size'] ?? '',
        category: data['category'] ?? '',
        // developer: data['developer'] ?? '',
        playStoreUrl: playStoreUrl,
        appStoreUrl: appStoreUrl,
        androidApkUrl: null,
        features: [],
      );
    } catch (e) {
      return null;
    }
  }
}
