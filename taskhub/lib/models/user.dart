class User {
  final int? id;
  final String email;
  final String userType; // 'citizen', 'professional', 'company'
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? phone;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.email,
    required this.userType,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.phone,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  String get typeLabel {
    switch (userType) {
      case 'citizen':
        return 'Cidadão';
      case 'professional':
        return 'Profissional Autônomo';
      case 'company':
        return 'Empresa Prestadora';
      default:
        return userType;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      userType: json['user_type'] ?? 'citizen',
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatarUrl: json['avatar_url'],
      phone: json['phone'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'user_type': userType,
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': avatarUrl,
      'phone': phone,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
