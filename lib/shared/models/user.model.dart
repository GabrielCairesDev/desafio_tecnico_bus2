import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';

class UserModel {
  final String gender;
  final Name name;
  final Location location;
  final String email;
  final Login login;
  final Dob dob;
  final Registered registered;
  final String phone;
  final String cell;
  final Id id;
  final Picture picture;
  final String nat;

  UserModel({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.login,
    required this.dob,
    required this.registered,
    required this.phone,
    required this.cell,
    required this.id,
    required this.picture,
    required this.nat,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      gender: json['gender'] ?? '',
      name: Name.fromJson(json['name'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      email: json['email'] ?? '',
      login: Login.fromJson(json['login'] ?? {}),
      dob: Dob.fromJson(json['dob'] ?? {}),
      registered: Registered.fromJson(json['registered'] ?? {}),
      phone: json['phone'] ?? '',
      cell: json['cell'] ?? '',
      id: Id.fromJson(json['id'] ?? {}),
      picture: Picture.fromJson(json['picture'] ?? {}),
      nat: json['nat'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': name.toJson(),
      'location': location.toJson(),
      'email': email,
      'login': login.toJson(),
      'dob': dob.toJson(),
      'registered': registered.toJson(),
      'phone': phone,
      'cell': cell,
      'id': id.toJson(),
      'picture': picture.toJson(),
      'nat': nat,
    };
  }
}
