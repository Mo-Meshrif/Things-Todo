import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../repositories/base_auth_repository.dart';

class FacebookUseCase
    implements BaseUseCase<Either<Failure, AuthCredential>, NoParameters> {
  final BaseAuthRepository baseAuthRepository;

  FacebookUseCase(this.baseAuthRepository);
  @override
  Future<Either<Failure, AuthCredential>> call(NoParameters parameters) => baseAuthRepository.facebook();
}
