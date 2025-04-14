import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';


abstract class ResetPasswordState extends Equatable{
  final DioException ? error;

  const ResetPasswordState({this.error});

  @override
  List<Object?> get props => [error];
}

class ResetPasswordInit extends ResetPasswordState{
  const ResetPasswordInit();
}

class ResetPasswordLoading extends ResetPasswordState{
  const ResetPasswordLoading();
}

class ResetPasswordDone extends ResetPasswordState{
  const ResetPasswordDone();
}



class ResetPasswordError extends ResetPasswordState{
  const ResetPasswordError(DioException error) : super(error: error);
}
