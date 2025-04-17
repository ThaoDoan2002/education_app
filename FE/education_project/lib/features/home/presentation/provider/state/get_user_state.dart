import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';


abstract class GetUserState extends Equatable{
  final DioException ? error;

  const GetUserState({this.error});

  @override
  List<Object?> get props => [error];
}

class GetUserInit extends GetUserState{
  const GetUserInit();
}

class GetUserLoading extends GetUserState{
  const GetUserLoading();
}

class GetUserDone extends GetUserState{
  const GetUserDone();
}



class GetUserError extends GetUserState{
  const GetUserError(DioException error) : super(error: error);
}
