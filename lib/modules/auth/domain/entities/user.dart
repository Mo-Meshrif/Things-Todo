import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id, name, email;
  final String? password;
  final String? pic;
  final String deviceToken;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.pic,
    required this.deviceToken,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
        pic,
        deviceToken,
      ];
}
