class Project {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final List<String> technologies;
  final String? githubLink;
  final String? liveLink;

  Project({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.technologies,
    this.githubLink,
    this.liveLink,
  });
}
