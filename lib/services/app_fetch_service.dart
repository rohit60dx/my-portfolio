// lib/services/app_fetch_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rohit_portfolio/models/app_model.dart';

class AppFetchService {
  static const String _functionUrl =
      'https://rohit60dx.vercel.app/api/fetch-app';

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

      debugPrint('Status Code: ${response.statusCode}'); // Debugging
      debugPrint('Response: ${response.body}'); // Debugging

      if (response.statusCode != 200) {
        debugPrint('Error: ${response.body}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return AppModel(
        id: '',
        name: data['name'] ?? '',
        shortDescription: data['shortDescription'] ?? '',
        description: data['description'] ?? '',
        iconUrl: data['iconUrl'] ?? '',
        screenshots: List<String>.from(data['screenshots'] ?? []),
        rating: (data['googleRating'] as num?)?.toDouble() ?? 0.0,
        totalRatings: (data['totalRatings'] as num?)?.toInt() ?? 0,
        downloads: (data['downloads'] as num?)?.toInt() ?? 0,
        version: data['version'] ?? 'Latest',
        size: data['size'] ?? 'Varies with device',
        category: data['category'] ?? 'Mobile App',
        playStoreUrl: playStoreUrl,
        appStoreUrl: appStoreUrl,
        androidApkUrl: null,
        features: List<String>.from(data['features'] ?? []),
      );
    } catch (e) {
      debugPrint('❌ Fetch Service Error: $e');
      return null;
    }
  }
}
