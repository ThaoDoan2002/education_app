import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? avatar,
    String? phone,
    String? username,
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    avatar: avatar,
    phone: phone,
    username: username
  );

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0, // Dùng giá trị số 0 cho id thay vì chuỗi rỗng
      firstName: map['first_name'] ?? "", // Chuỗi rỗng cho String nếu null
      lastName: map['last_name'] ?? "",
      email: map['email'] ?? "",
      avatar: map['avatar'] ?? "image/upload/v1745475427/avatar_xsvz3c.png",//lấy từ server
      phone: map['phone'] ?? "",
      username: map['username'] ?? "",

    );
  }
}