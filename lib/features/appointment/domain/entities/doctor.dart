// import 'package:equatable/equatable.dart';

// class Doctor extends Equatable {
//   final int? id;
//   final String name;
//   final String? speciality;
//   final String? street;
//   final String? zipCode;
//   final String? city;
//   final String? phone;
//   final String? email;
//   final String? website;

//   const Doctor({
//     this.id,
//     required this.name,
//     this.speciality,
//     this.street,
//     this.zipCode,
//     this.city,
//     this.phone,
//     this.email,
//     this.website,
//   });

//   @override
//   List<Object?> get props =>
//       [id, name, speciality, street, zipCode, city, phone, email, website];

//   Doctor copyWith({
//     int? id,
//     String? name,
//     String? speciality,
//     String? street,
//     String? zipCode,
//     String? city,
//     String? phone,
//     String? email,
//     String? website,
//   }) {
//     return Doctor(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       speciality: speciality ?? this.speciality,
//       street: street ?? this.street,
//       zipCode: zipCode ?? this.zipCode,
//       city: city ?? this.city,
//       phone: phone ?? this.phone,
//       email: email ?? this.email,
//       website: website ?? this.website,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'speciality': speciality,
//       'street': street,
//       'zipCode': zipCode,
//       'city': city,
//       'phone': phone,
//       'email': email,
//       'website': website,
//     };
//   }
// }
