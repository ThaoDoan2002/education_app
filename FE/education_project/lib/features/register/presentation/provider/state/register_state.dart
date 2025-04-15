import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';


abstract class RegisterState extends Equatable{
  final DioException ? error;

  const RegisterState({this.error});

  @override
  List<Object?> get props => [error];
}

class RegisterInit extends RegisterState{
  const RegisterInit();
}

class RegisterLoading extends RegisterState{
  const RegisterLoading();
}

class RegisterDone extends RegisterState{
  const RegisterDone();
}



class RegisterError extends RegisterState{
  const RegisterError(DioException error) : super(error: error);
}
