/// Data model representing a Job Posting in the Kidme ecosystem.
///
/// This model is designed to be compatible with Supabase/PostgreSQL tables.
class Job {
  final String id;
  final String company;
  final String role;
  final String location;
  final String salary;
  final int match;
  final String status;
  final String? description;
  final List<String>? requirements;

  const Job({
    required this.id,
    required this.company,
    required this.role,
    required this.location,
    required this.salary,
    required this.match,
    required this.status,
    this.description,
    this.requirements,
  });

  /// Factory constructor to create a [Job] from a JSON map (e.g., from Supabase).
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id']?.toString() ?? '',
      company: json['company_name'] ?? json['company'] ?? 'Unknown Company',
      role: json['job_title'] ?? json['role'] ?? 'Untitled Position',
      location: json['city'] ?? json['location'] ?? 'Chad',
      salary: json['salary_range'] ?? json['salary'] ?? 'Competitive',
      match: json['match_score'] ?? json['match'] ?? 0,
      status: json['status'] ?? 'Active',
      description: json['description'],
      requirements: (json['requirements'] as List?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  /// Converts the [Job] instance to a JSON map for database operations.
  Map<String, dynamic> toJson() {
    return {
      'company_name': company,
      'job_title': role,
      'city': location,
      'salary_range': salary,
      'match_score': match,
      'status': status,
      'description': description,
      'requirements': requirements,
    };
  }
}
