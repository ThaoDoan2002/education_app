import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;
  final String? phone;
  final String? username;


  const UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
    this.phone,
    this.username,
  });

  @override
  List<Object?> get props {
    return [
      id,
      firstName,
      lastName,
      email,
      avatar,
      phone,
      username
    ];
  }
}
