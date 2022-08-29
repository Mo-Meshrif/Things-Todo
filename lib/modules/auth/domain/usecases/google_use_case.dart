import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../app/errors/failure.dart';
import '../../../../app/usecase/base_use_case.dart';
import '../repositories/base_auth_repository.dart';

class GoogleUseCase implements BaseUseCase<Either<Failure, AuthCredential>, NoParameters> {
  final BaseAuthRepository baseAuthRepository;

  GoogleUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, AuthCredential>> call(NoParameters parameters) => baseAuthRepository.google();
}
