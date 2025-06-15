class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? address;
  final String? city;
  final String? country;
  final String? zipCode;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? authToken;
  final DateTime? tokenExpiresAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.dateOfBirth,
    this.address,
    this.city,
    this.country,
    this.zipCode,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.role = UserRole.customer,
    required this.createdAt,
    required this.updatedAt,
    this.authToken,
    this.tokenExpiresAt,
  });

  // Get full name
  String get fullName => '$firstName $lastName';

  // Get display name (first name or email if no first name)
  String get displayName => firstName.isNotEmpty ? firstName : email;

  // Check if user is authenticated
  bool get isAuthenticated {
    if (authToken == null || tokenExpiresAt == null) return false;
    return DateTime.now().isBefore(tokenExpiresAt!);
  }

  // Check if profile is complete
  bool get isProfileComplete {
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        phoneNumber != null &&
        dateOfBirth != null;
  }

  // Get initials for avatar
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  // JSON serialization
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      zipCode: json['zipCode'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.customer,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      authToken: json['authToken'] as String?,
      tokenExpiresAt: json['tokenExpiresAt'] != null
          ? DateTime.parse(json['tokenExpiresAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'address': address,
      'city': city,
      'country': country,
      'zipCode': zipCode,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'authToken': authToken,
      'tokenExpiresAt': tokenExpiresAt?.toIso8601String(),
    };
  }

  // Copy with method for immutable updates
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? address,
    String? city,
    String? country,
    String? zipCode,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? authToken,
    DateTime? tokenExpiresAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authToken: authToken ?? this.authToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, fullName: $fullName, role: ${role.name})';
  }
}

enum UserRole {
  customer,
  admin,
  moderator,
  vendor,
}
