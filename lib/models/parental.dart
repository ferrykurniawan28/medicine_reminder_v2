part of 'models.dart';

class Parental {
  final int? id;
  final User user;

  Parental({
    this.id,
    required this.user,
  });

  factory Parental.fromJson(Map<String, dynamic> json) {
    return Parental(
      id: json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
    };
  }

  Parental copyWith({
    int? id,
    User? user,
  }) {
    return Parental(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

List<Parental> dummyParental = [
  Parental(
    id: 1,
    user: User(userId: 1, userName: 'Jude', email: "jude@jude.com"),
  ),
  Parental(
    id: 2,
    user: User(userId: 2, userName: 'Mbappe', email: "mbappe@mbappe.com"),
  ),
  Parental(
    id: 3,
    user: User(userId: 3, userName: 'Vini', email: "vini@vini.com"),
  ),
];
