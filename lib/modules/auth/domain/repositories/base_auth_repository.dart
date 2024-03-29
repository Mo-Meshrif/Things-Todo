import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../app/errors/failure.dart';
import '../entities/user.dart';
import '../usecases/login_use_case.dart';
import '../usecases/signup_use_case.dart';

abstract class BaseAuthRepository {
  Future<Either<Failure, AuthUser>> signIn(LoginInputs userInputs);
  Future<Either<Failure, AuthUser>> signUp(SignUpInputs userInputs);
  Future<Either<Failure, bool>> forgetPassword(String email);
  Future<Either<Failure, AuthUser>> signInWithCredential(AuthCredential authCredential);
  Future<Either<Failure, AuthCredential>> facebook();
  Future<Either<Failure, AuthCredential>> twitter();
  Future<Either<Failure, AuthCredential>> google();
  Future<Either<Failure, void>> logout(String uid);
  Future<Either<Failure, void>> delete(AuthUser user);
}
