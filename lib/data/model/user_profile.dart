class UserProfile {
  final String id;
  final String fullName;
  final String role;
  final String? avatarUrl;
  final String? userName;
  final String? gender;
  final int? age;
  final String? address;
  final String? organization;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? phoneNumber;
  final String email;
  final int? credits;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.role,
    this.avatarUrl,
    this.userName,
    this.gender,
    this.age,
    this.address,
    this.organization,
    this.createdAt,
    this.updatedAt,
    this.phoneNumber,
    required this.email,
    this.credits,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      userName: json['userName'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      address: json['address'] as String?,
      organization: json['organization'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String,
      credits: json['credits'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'role': role,
      'avatarUrl': avatarUrl,
      'userName': userName,
      'gender': gender,
      'age': age,
      'address': address,
      'organization': organization,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'email': email,
      'credits': credits,
    };
  }

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? role,
    String? avatarUrl,
    String? userName,
    String? gender,
    int? age,
    String? address,
    String? organization,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? phoneNumber,
    String? email,
    int? credits,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userName: userName ?? this.userName,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      address: address ?? this.address,
      organization: organization ?? this.organization,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      credits: credits ?? this.credits,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, fullName: $fullName, email: $email, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode {
    return Object.hash(id, fullName, email, avatarUrl);
  }
}
