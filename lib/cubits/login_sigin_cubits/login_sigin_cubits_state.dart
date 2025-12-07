import 'package:firebase_auth/firebase_auth.dart';

class LoginSiginCubitsState {}

class LoginSiginCubitsInitial extends LoginSiginCubitsState {}

class LoginSiginCubitsLoading extends LoginSiginCubitsState {}

class LoginSiginCubitsSuccess extends LoginSiginCubitsState {
  final User? user;
  final String role;

  LoginSiginCubitsSuccess(this.user, this.role);
}

class LoginSiginCubitsFailure extends LoginSiginCubitsState {
  final String errorMessage;
  LoginSiginCubitsFailure(this.errorMessage);
}
