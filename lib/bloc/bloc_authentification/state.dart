part of 'bloc.dart';

@immutable
abstract class AuthState {
  final User? currentUser = null;
}

class AuthSuccess extends AuthState {
  final User? currentUser;

  AuthSuccess({required this.currentUser});
}

class NoAuth extends AuthState {
  final User? currentUser = null;
}
