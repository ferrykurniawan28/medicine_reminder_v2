part of 'models.dart';

class User {
  final int userId;
  final String userName;
  final UserRole? role;

  User({
    required this.userId,
    required this.userName,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      userName: json['userName'],
      role: UserRole.values[json['role']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'role': role?.index,
    };
  }

  User copyWith({
    int? userId,
    String? userName,
    UserRole? role,
  }) {
    return User(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role,
    );
  }
}

enum UserRole {
  admin,
  member,
}
