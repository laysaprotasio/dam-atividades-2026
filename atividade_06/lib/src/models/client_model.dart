import 'package:uuid/uuid.dart';

class ClientModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime? birthDate;

  ClientModel({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    this.birthDate,
  }) : id = id ?? const Uuid().v4();

  ClientModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? birthDate,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  int? get age {
    if (birthDate == null) return null;

    final today = DateTime.now();
    var age = today.year - birthDate!.year;
    final hasNotHadBirthdayThisYear =
        today.month < birthDate!.month || (today.month == birthDate!.month && today.day < birthDate!.day);
    if (hasNotHadBirthdayThisYear) age--;

    return age;
  }
}
