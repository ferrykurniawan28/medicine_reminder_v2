// class DoctorModel {
//   final int? id;
//   final String name;
//   final String? speciality;
//   final String? street;
//   final String? zipCode;
//   final String? city;
//   final String? phone;
//   final String? email;
//   final String? website;

//   const DoctorModel({
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

//   factory DoctorModel.fromJson(Map<String, dynamic> json) {
//     return DoctorModel(
//       id: json['id'],
//       name: json['name'] ?? '',
//       speciality: json['speciality'],
//       street: json['street'],
//       zipCode: json['zip_code'],
//       city: json['city'],
//       phone: json['phone'],
//       email: json['email'],
//       website: json['website'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'speciality': speciality,
//       'street': street,
//       'zip_code': zipCode,
//       'city': city,
//       'phone': phone,
//       'email': email,
//       'website': website,
//     };
//   }

//   DoctorModel copyWith({
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
//     return DoctorModel(
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
// }
