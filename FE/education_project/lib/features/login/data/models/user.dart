import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? avatar,
    String? phone,
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    avatar: avatar,
    phone: phone,
  );

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0, // Dùng giá trị số 0 cho id thay vì chuỗi rỗng
      firstName: map['first_name'] ?? "", // Chuỗi rỗng cho String nếu null
      lastName: map['last_name'] ?? "",
      email: map['email'] ?? "",
      avatar: map['avatar'] ?? "",
      phone: map['phone'] ?? "",
    );
  }
}