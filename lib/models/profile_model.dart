// lib/models/profile_model.dart
class ProfileModel {
  final String name;
  final String title;
  final String phone;
  final String email;
  final String about;
  final String location;
  final String profileImageUrl;
  final String githubUrl;
  final String linkedinUrl;
  final String resumeUrl;
  final List<String> skills;
  final int yearsOfExperience;
  final int projectsCompleted;
  final int appsPublished;

  ProfileModel({
    required this.name,
    required this.title,
    required this.phone,
    required this.email,
    required this.about,
    required this.location,
    required this.profileImageUrl,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.resumeUrl,
    required this.skills,
    required this.yearsOfExperience,
    required this.projectsCompleted,
    required this.appsPublished,
  });

  factory ProfileModel.fromFirestore(Map<String, dynamic> data) {
    return ProfileModel(
      name: data['name'] ?? 'Your Name',
      title: data['title'] ?? 'Flutter Developer',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      about: data['about'] ?? '',
      location: data['location'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      githubUrl: data['githubUrl'] ?? '',
      linkedinUrl: data['linkedinUrl'] ?? '',
      resumeUrl: data['resumeUrl'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      yearsOfExperience: data['yearsOfExperience'] ?? 0,
      projectsCompleted: data['projectsCompleted'] ?? 0,
      appsPublished: data['appsPublished'] ?? 0,
    );
  }

  // Default data (jab Firebase empty ho)
  static ProfileModel defaultProfile() {
    return ProfileModel(
      name: 'Aapka Naam',
      title: 'Flutter Developer',
      phone: '+91 XXXXXXXXXX',
      email: 'aap@email.com',
      about: 'Passionate Flutter Developer with expertise in building beautiful cross-platform applications.',
      location: 'India',
      profileImageUrl: '',
      githubUrl: 'https://github.com',
      linkedinUrl: 'https://linkedin.com',
      resumeUrl: '',
      skills: ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git'],
      yearsOfExperience: 2,
      projectsCompleted: 20,
      appsPublished: 5,
    );
  }
}
