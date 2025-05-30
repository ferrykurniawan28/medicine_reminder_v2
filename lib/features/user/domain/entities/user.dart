class User {
  final int userId;
  final String userName;
  final String email;

  User({
    required this.userId,
    required this.userName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      userName: json['username'],
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'username': userName,
      'email': email,
    };
  }

  User copyWith({
    int? userId,
    String? userName,
    String? email,
  }) {
    return User(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
    );
  }
}
