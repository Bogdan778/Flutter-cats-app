part of 'bloc.dart';

@immutable
abstract class AuthEvent {}

class FacebookLoginEvent extends AuthEvent {}

class GoogleLoginEvent extends AuthEvent {}

class LogOutEvent extends AuthEvent {}
