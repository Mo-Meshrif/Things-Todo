part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthPopUpLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess({required this.user});
}

class AuthRestSuccess extends AuthState {
  final bool isRested;
  const AuthRestSuccess({required this.isRested});
}

class AuthFailure extends AuthState {
  final String msg;
  const AuthFailure({required this.msg});
}