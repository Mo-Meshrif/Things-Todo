import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/app/errors/failure.dart';
import '/modules/auth/domain/entities/user.dart';
import '/modules/auth/domain/usecases/facebook_use_case.dart';
import '/modules/auth/domain/usecases/forget_passwod_use_case.dart';
import '/modules/auth/domain/usecases/google_use_case.dart';
import '/modules/auth/domain/usecases/sign_in_with_credential.dart';
import '/modules/auth/domain/usecases/twitter_use_case.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../domain/usecases/delete_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final SignInWithCredentialUseCase signInWithCredentialUseCase;
  final FacebookUseCase facebookUseCase;
  final TwitterUseCase twitterUseCase;
  final GoogleUseCase googleUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteUseCase deleteUseCase;
  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.forgetPasswordUseCase,
    required this.signInWithCredentialUseCase,
    required this.facebookUseCase,
    required this.twitterUseCase,
    required this.googleUseCase,
    required this.logoutUseCase,
    required this.deleteUseCase,
  }) : super(AuthInitial()) {
    on<AuthToggleEvent>(_toggle);
    on<LoginEvent>(_login);
    on<SignUpEvent>(_signUp);
    on<ForgetPasswordEvent>(_forgetPassword);
    on<SignInWithCredentialEvent>(_signInWithCredential);
    on<FacebookLoginEvent>(_facebookLogin);
    on<TwitterLoginEvent>(_twitterLogin);
    on<GoogleLoginEvent>(_googleLogin);
    on<LogoutEvent>(_logout);
    on<DeleteEvent>(_delete);
  }

  FutureOr<void> _toggle(AuthToggleEvent event, Emitter<AuthState> emit) {
    emit(AuthTranstion());
    emit(AuthChanged(currentState: !event.prevState));
  }

  FutureOr<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, dynamic> result =
        await loginUseCase(event.loginInputs);
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, AuthUser> result =
        await signUpUseCase(event.signUpInputs);
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _forgetPassword(
      ForgetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthPopUpLoading());
    final Either<Failure, bool> result =
        await forgetPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(
        AuthFailure(
          isPopup: true,
          msg: _handleAuthExceptions(failure.msg),
        ),
      ),
      (isRested) => emit(AuthRestSuccess(isRested: isRested)),
    );
  }

  FutureOr<void> _signInWithCredential(
      SignInWithCredentialEvent event, Emitter<AuthState> emit) async {
    emit(AuthPopUpLoading());
    final Either<Failure, AuthUser> authResult =
        await signInWithCredentialUseCase(event.authCredential);
    authResult.fold(
      (failure) => emit(
        AuthFailure(
          isPopup: true,
          msg: _handleAuthExceptions(failure.msg),
        ),
      ),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _facebookLogin(
      FacebookLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthTranstion());
    final Either<Failure, AuthCredential> result =
        await facebookUseCase(const NoParameters());
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (authCredential) => emit(AuthSocialPass(authCredential: authCredential)),
    );
  }

  FutureOr<void> _twitterLogin(
      TwitterLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthTranstion());
    final Either<Failure, AuthCredential> result =
        await twitterUseCase(const NoParameters());
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (authCredential) => emit(AuthSocialPass(authCredential: authCredential)),
    );
  }

  FutureOr<void> _googleLogin(
      GoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthTranstion());
    final Either<Failure, AuthCredential> result =
        await googleUseCase(const NoParameters());
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (authCredential) => emit(AuthSocialPass(authCredential: authCredential)),
    );
  }

  FutureOr<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthPopUpLoading());
    final Either<Failure, dynamic> result = await logoutUseCase(event.uid);
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (_) => emit(const AuthLogoutSuccess()),
    );
  }

  FutureOr<void> _delete(DeleteEvent event, Emitter<AuthState> emit) async {
    emit(AuthPopUpLoading());
    final Either<Failure, dynamic> result = await deleteUseCase(event.user);
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (_) => emit(const AuthDeleteSuccess()),
    );
  }

  String _handleAuthExceptions(String msg) {
    if (msg.contains(AppConstants.invaildEmail)) {
      return AppStrings.invaildEmail;
    } else if (msg.contains(AppConstants.userDisabled)) {
      return AppStrings.userDisabled;
    } else if (msg.contains(AppConstants.userNotFound)) {
      return AppStrings.userNotFound;
    } else if (msg.contains(AppConstants.wrongPassword)) {
      return AppStrings.wrongPassword;
    } else if (msg.contains(AppConstants.emailUsed)) {
      return AppStrings.emailUsed;
    } else if (msg.contains(AppConstants.opNotAllowed)) {
      return AppStrings.opNotAllowed;
    } else if (msg == AppConstants.noConnection) {
      return AppStrings.noConnection;
    } else if (msg.contains(AppConstants.nullError)) {
      return AppConstants.emptyVal;
    } else {
      return AppStrings.operationFailed;
    }
  }
}
