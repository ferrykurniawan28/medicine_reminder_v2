import 'package:medicine_reminder/features/user/domain/entities/user.dart';

class Parental {
  final int? id;
  final User user;
  final DateTime? createdAt;
  final bool isDeleted;

  Parental({
    this.id,
    required this.user,
    this.createdAt,
    this.isDeleted = false,
  });

  /// Factory method for API response format
  /// API Response: {"id": 1, "user": {"id": 2, "username": "tester 2", "email": "test2@test.com"}}
  factory Parental.fromApiResponse(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final user = User.fromJson(userJson);

    return Parental(
      id: json['id'] as int?,
      user: user,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      isDeleted: false, // API data is not deleted
    );
  }

  /// Factory method for standard JSON format (database)
  factory Parental.fromJson(Map<String, dynamic> json) {
    return Parental(
      id: json['id'] as int?,
      user: User.fromJson(json['user']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      isDeleted: (json['is_deleted'] as int? ?? 0) == 1,
    );
  }

  /// Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  Parental copyWith({
    int? id,
    User? user,
    DateTime? createdAt,
    bool? isDeleted,
  }) {
    return Parental(
      id: id ?? this.id,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Parental &&
        other.id == id &&
        other.user == user &&
        other.createdAt == createdAt &&
        other.isDeleted == isDeleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        createdAt.hashCode ^
        isDeleted.hashCode;
  }

  @override
  String toString() {
    return 'Parental(id: $id, user: $user, createdAt: $createdAt, isDeleted: $isDeleted)';
  }
}
