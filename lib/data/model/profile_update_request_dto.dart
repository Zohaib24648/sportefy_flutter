// class ProfileUpdateRequest {
//   final String? fullName;
//   final String? avatarUrl;
//   final String? email;
//   final String? userName;
//   final String? gender;
//   final int? age;
//   final String? address;
//   final String? organization;
//   final String? phoneNumber;

//   const ProfileUpdateRequest({
//     this.fullName,
//     this.avatarUrl,
//     this.email,
//     this.userName,
//     this.gender,
//     this.age,
//     this.address,
//     this.organization,
//     this.phoneNumber,
//   });

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};

//     if (fullName != null) data['full_name'] = fullName;
//     if (avatarUrl != null) data['avatar_url'] = avatarUrl;
//     if (email != null) data['email'] = email;
//     if (userName != null) data['user_name'] = userName;
//     if (gender != null) data['gender'] = gender;
//     if (age != null) data['age'] = age;
//     if (address != null) data['address'] = address;
//     if (organization != null) data['organization'] = organization;
//     if (phoneNumber != null) data['phone_number'] = phoneNumber;

//     // Always update the timestamp when making changes
//     data['updated_at'] = DateTime.now().toIso8601String();

//     return data;
//   }

//   factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) {
//     return ProfileUpdateRequest(
//       fullName: json['fullName'] as String?,
//       avatarUrl: json['avatarUrl'] as String?,
//       email: json['email'] as String?,
//       userName: json['userName'] as String?,
//       gender: json['gender'] as String?,
//       age: json['age'] as int?,
//       address: json['address'] as String?,
//       organization: json['organization'] as String?,
//       phoneNumber: json['phoneNumber'] as String?,
//     );
//   }

//   @override
//   String toString() {
//     return 'ProfileUpdateRequest(fullName: $fullName, email: $email, userName: $userName, gender: $gender, age: $age, address: $address, organization: $organization, phoneNumber: $phoneNumber, avatarUrl: $avatarUrl)';
//   }
// }
