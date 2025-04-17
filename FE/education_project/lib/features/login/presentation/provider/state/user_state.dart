import 'package:dio/dio.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable{
  final UserEntity ? user;
  final DioException ? error;

  const UserState({this.user, this.error});

  @override
  List<Object?> get props => [user!, error!];
}

class UserInit extends UserState{
  const UserInit();
}

class UserLoading extends UserState{
  const UserLoading();
}

class UserDone extends UserState{
  const UserDone(UserEntity user): super(user: user);
}

class UserError extends UserState{
  const UserError(DioException error) : super(error: error);
}