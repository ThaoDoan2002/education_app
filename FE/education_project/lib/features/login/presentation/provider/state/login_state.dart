import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';


abstract class LoginState extends Equatable{
  final DioException ? error;

   const LoginState({this.error});

  @override
  List<Object?> get props => [error];
}

class LoginInit extends LoginState{
  const LoginInit();
}

class LoginLoading extends LoginState{
  const LoginLoading();
}

class LoginDone extends LoginState{
  const LoginDone();
}



class LoginError extends LoginState{
  const LoginError(DioException error) : super(error: error);
}