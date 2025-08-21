import 'package:medicine_reminder/features/parental/domain/entities/parental.dart';
import 'package:medicine_reminder/features/user/domain/entities/user.dart';
import 'package:medicine_reminder/features/user/data/models/user_model.dart';

class ParentalModel extends Parental {
  ParentalModel({
    super.id,
    required super.user,
    super.createdAt,
    super.isDeleted = false,
  });

  factory ParentalModel.fromJson(Map<String, dynamic> json) {
    return ParentalModel(
      id: json['id'] as int?,
      user: UserModel.fromJson(json['user']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      isDeleted: (json['is_deleted'] as int? ?? 0) == 1,
    );
  }

  /// Factory method specifically for API response format
  /// API Response: {"id": 1, "user": {"id": 2, "username": "tester 2", "email": "test2@test.com"}}
  factory ParentalModel.fromApiResponse(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final user = UserModel.fromJson(userJson);

    return ParentalModel(
      id: json['id'] as int?,
      user: user,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      isDeleted: false, // API data is not deleted
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  factory ParentalModel.fromEntity(Parental parental) {
    return ParentalModel(
      id: parental.id,
      user: parental.user,
      createdAt: parental.createdAt,
      isDeleted: parental.isDeleted,
    );
  }

  // For database insert - includes server ID if available
  Map<String, dynamic> toJsonForInsert() {
    final json = toJson();
    final data = {
      'parental_id': json['user']['id'],
      'created_at': json['created_at'],
      'is_deleted': json['is_deleted'],
    };

    // Include server ID if it exists (from remote data)
    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  @override
  ParentalModel copyWith({
    int? id,
    User? user,
    DateTime? createdAt,
    bool? isDeleted,
  }) {
    return ParentalModel(
      id: id ?? this.id,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
