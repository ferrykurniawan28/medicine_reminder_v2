part of 'models.dart';

class UserGroup {
  final int userId;
  final String userName;
  final UserGroupRole role;

  UserGroup({
    required this.userId,
    required this.userName,
    required this.role,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(
      userId: json['userId'],
      userName: json['userName'],
      role: UserGroupRole.values[json['role']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'role': role.index,
    };
  }

  UserGroup copyWith({
    int? userId,
    String? userName,
    UserGroupRole? role,
  }) {
    return UserGroup(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
    );
  }
}

enum UserGroupRole {
  admin,
  member,
}
