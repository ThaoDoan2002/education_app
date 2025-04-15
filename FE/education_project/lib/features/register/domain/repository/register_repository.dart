
import 'package:education_project/features/register/domain/usecases/params/register_param.dart';

abstract class RegisterRepository {
  Future<void> register(RegisterBodyParams params);
}