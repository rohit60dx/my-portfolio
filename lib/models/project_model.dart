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
  final bool isProduction; // true = Live, false = Upcoming
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
    required this.isProduction,
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
      isProduction: data['isProduction'] ?? true,
      isFeatured: data['isFeatured'] ?? false,
      order: data['order'] ?? 0,
    );
  }
}
