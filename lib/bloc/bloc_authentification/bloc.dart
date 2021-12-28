import 'dart:async';

import 'package:cat_api/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

part 'event.dart';
part 'state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authService = AuthService();
  final fb = FacebookAuth.instance;
  final google = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

  AuthBloc()
      : super(AuthService().user != null
            ? AuthSuccess(currentUser: AuthService().user)
            : NoAuth());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is FacebookLoginEvent) {
      final res =
          await fb.login(permissions: ['public_profile', 'user_photos']);

      if (res.status == LoginStatus.success) {
        final credentials =
            FacebookAuthProvider.credential(res.accessToken!.token);
        final user = await authService.signInWithCredentials(credentials);

        yield AuthSuccess(currentUser: user.user);
      } else {
        yield (NoAuth());
      }
    } else if (event is LogOutEvent) {
      await fb.logOut();
      await google.signOut();
      yield NoAuth();
    } else if (event is GoogleLoginEvent) {
      try {
        final googleUser = await google.signIn();
        final googleAuth = await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
            idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
        final user = await authService.signInWithCredentials(credential);

        yield AuthSuccess(currentUser: user.user);
      } catch (error) {}
    }
  }
}
