// lib/models/project_model.dart
class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> technologies;
  final List<String> screenshots;
  final String? githubUrl;
  final String? liveUrl;
  final bool isFeatured;
  final int order;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.technologies,
    required this.screenshots,
    this.githubUrl,
    this.liveUrl,
    required this.isFeatured,
    required this.order,
  });

  factory ProjectModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProjectModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'Mobile App',
      technologies: List<String>.from(data['technologies'] ?? []),
      screenshots: List<String>.from(data['screenshots'] ?? []),
      githubUrl: data['githubUrl'],
      liveUrl: data['liveUrl'],
      isFeatured: data['isFeatured'] ?? false,
      order: data['order'] ?? 0,
    );
  }
}

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
    required this.isPublished,
    required this.order,
  });

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
      playStoreUrl: data['playStoreUrl'],
      appStoreUrl: data['appStoreUrl'],
      androidApkUrl: data['androidApkUrl'],
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
