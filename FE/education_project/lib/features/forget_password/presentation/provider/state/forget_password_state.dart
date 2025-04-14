import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';


abstract class ForgetPasswordState extends Equatable{
  final DioException ? error;

  const ForgetPasswordState({this.error});

  @override
  List<Object?> get props => [error];
}

class ForgetPasswordInit extends ForgetPasswordState{
  const ForgetPasswordInit();
}

class ForgetPasswordLoading extends ForgetPasswordState{
  const ForgetPasswordLoading();
}

class ForgetPasswordDone extends ForgetPasswordState{
  const ForgetPasswordDone();
}



class ForgetPasswordError extends ForgetPasswordState{
  const ForgetPasswordError(DioException error) : super(error: error);
}
