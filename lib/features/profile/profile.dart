import 'package:cached_network_image/cached_network_image.dart';
import '/bloc/bloc_authentification/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_builder.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      body: Center(child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          '${state.currentUser?.photoURL}'),
                    ),
                    borderRadius: BorderRadius.circular(180),
                    color: Colors.white38),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                '${state.currentUser?.displayName}',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 100,
              ),
              SignInButtonBuilder(
                text: 'Log Out',
                icon: Icons.logout,
                onPressed: () {
                  _authBloc.add(LogOutEvent());
                },
                backgroundColor: Colors.blue,
              )
            ],
          );
        },
      )),
    );
  }
}
