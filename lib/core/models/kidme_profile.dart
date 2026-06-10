class KidmeProfile {
  const KidmeProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.recruiterType,
    this.nationalIdentityNumber,
    this.headline,
    this.phone,
    this.location,
    this.avatarUrl,
    this.avatarPath,
    this.profileSnapshotPath,
  });

  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? recruiterType;
  final String? nationalIdentityNumber;
  final String? headline;
  final String? phone;
  final String? location;
  final String? avatarUrl;
  final String? avatarPath;
  final String? profileSnapshotPath;

  String get displayName => fullName.trim().isEmpty ? email : fullName;

  bool get isJobSeeker => role == 'Job Seeker';

  bool get isCompany =>
      recruiterType == 'Company' || recruiterType == 'Enterprise & Corporate';

  bool get isPrivateEmployer =>
      recruiterType == 'Private Employer' ||
      recruiterType == 'Small Gigs & Individuals';

  String get accountType {
    if (isCompany) {
      return 'Company';
    }
    if (isPrivateEmployer) {
      return 'Private Employer';
    }
    return 'Job Seeker';
  }

  String get displayHeadline {
    final custom = headline?.trim();
    if (custom != null && custom.isNotEmpty) {
      return custom;
    }
    if (isCompany) {
      return 'Company HR team - Verified hiring';
    }
    if (isPrivateEmployer) {
      return 'Private employer - Hiring locally';
    }
    return 'Verified graduate - Open to work';
  }

  factory KidmeProfile.fromMap(Map<String, dynamic> map) {
    return KidmeProfile(
      id: map['id']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      role: map['role']?.toString() ?? 'Job Seeker',
      recruiterType: map['recruiter_type']?.toString(),
      nationalIdentityNumber: map['national_identity_number']?.toString(),
      headline: map['headline']?.toString(),
      phone: map['phone']?.toString(),
      location: map['location']?.toString(),
      avatarUrl: map['avatar_url']?.toString(),
      avatarPath: map['avatar_path']?.toString(),
      profileSnapshotPath: map['profile_snapshot_path']?.toString(),
    );
  }

  Map<String, dynamic> toUpsertMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      'recruiter_type': recruiterType,
      'national_identity_number': nationalIdentityNumber,
      'headline': headline,
      'phone': phone,
      'location': location,
      'avatar_url': avatarUrl,
      'avatar_path': avatarPath,
      'profile_snapshot_path': profileSnapshotPath,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
  }

  KidmeProfile copyWith({
    String? email,
    String? fullName,
    String? role,
    String? recruiterType,
    String? nationalIdentityNumber,
    String? headline,
    String? phone,
    String? location,
    String? avatarUrl,
    String? avatarPath,
    String? profileSnapshotPath,
  }) {
    return KidmeProfile(
      id: id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      recruiterType: recruiterType ?? this.recruiterType,
      nationalIdentityNumber:
          nationalIdentityNumber ?? this.nationalIdentityNumber,
      headline: headline ?? this.headline,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarPath: avatarPath ?? this.avatarPath,
      profileSnapshotPath: profileSnapshotPath ?? this.profileSnapshotPath,
    );
  }
}
