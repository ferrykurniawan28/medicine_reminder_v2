import '../../domain/entities/user.dart';

class UserModel extends User {
  final int isSynced;

  UserModel({
    required super.userId,
    required super.userName,
    required super.email,
    this.isSynced = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'],
      userName: json['username'],
      email: json['email'] ?? '',
      isSynced: json['is_synced'] is int
          ? json['is_synced'] ?? 0
          : int.tryParse(json['is_synced']?.toString() ?? '0') ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'username': userName,
      'email': email,
      'is_synced': isSynced,
    };
  }

  @override
  UserModel copyWith({
    int? userId,
    String? userName,
    String? email,
    int? isSynced,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
