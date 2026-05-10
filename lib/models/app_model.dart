// lib/models/app_model.dart
class AppModel {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final String iconUrl;
  final List<String> screenshots;
  final double rating;
  final int totalRatings;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? androidApkUrl;
  final String version;
  final String size;
  final String category;
  final List<String> features;
  final int downloads;
  final bool isPublished;
  final int order;

  AppModel({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.iconUrl,
    required this.screenshots,
    required this.rating,
    required this.totalRatings,
    this.playStoreUrl,
    this.appStoreUrl,
    this.androidApkUrl,
    required this.version,
    required this.size,
    required this.category,
    required this.features,
    required this.downloads,
    this.isPublished = false,
    this.order = 0,
  });

  // Empty string ko null treat karo
  static String? _nullIfEmpty(dynamic val) {
    if (val == null) return null;
    final s = val.toString().trim();
    return s.isEmpty ? null : s;
  }

  factory AppModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AppModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      iconUrl: data['iconUrl'] ?? '',
      screenshots: List<String>.from(data['screenshots'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalRatings: data['totalRatings'] ?? 0,
      playStoreUrl: _nullIfEmpty(data['playStoreUrl']),
      appStoreUrl: _nullIfEmpty(data['appStoreUrl']),
      androidApkUrl: _nullIfEmpty(data['androidApkUrl']),
      version: data['version'] ?? '1.0.0',
      size: data['size'] ?? '',
      category: data['category'] ?? 'Productivity',
      features: List<String>.from(data['features'] ?? []),
      downloads: data['downloads'] ?? 0,
      isPublished: data['isPublished'] ?? true,
      order: data['order'] ?? 0,
    );
  }
}
