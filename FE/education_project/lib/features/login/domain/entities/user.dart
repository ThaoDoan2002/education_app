import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;
  final String? phone;

  const UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
    this.phone,
  });

  @override
  List<Object?> get props {
    return [
      id,
      firstName,
      lastName,
      email,
      avatar,
      phone
    ];
  }
}
