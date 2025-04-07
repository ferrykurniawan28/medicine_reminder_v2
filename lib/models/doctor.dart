class Doctor {
  final int? id;
  final String name;
  final String? speciality;
  final String? street;
  final String? zipCode;
  final String? city;
  final String? phone;
  final String? email;
  final String? website;

  Doctor({
    this.id,
    required this.name,
    this.speciality,
    this.street,
    this.zipCode,
    this.city,
    this.phone,
    this.email,
    this.website,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      speciality: json['speciality'],
      street: json['street'],
      zipCode: json['zip_code'],
      city: json['city'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'speciality': speciality,
      'street': street,
      'zip_code': zipCode,
      'city': city,
      'phone': phone,
      'email': email,
      'website': website,
    };
  }

  Doctor copyWith({
    int? id,
    String? name,
    String? speciality,
    String? street,
    String? zipCode,
    String? city,
    String? phone,
    String? email,
    String? website,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      speciality: speciality,
      street: street,
      zipCode: zipCode,
      city: city,
      phone: phone,
      email: email,
      website: website,
    );
  }
}
