import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/base_auth_repository.dart';

class SignInWithCredentialUseCase
    implements BaseUseCase<Either<Failure, AuthUser>, AuthCredential> {
  final BaseAuthRepository baseAuthRepository;
  SignInWithCredentialUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, AuthUser>> call(AuthCredential authCredential) =>
      baseAuthRepository.signInWithCredential(authCredential);
}
