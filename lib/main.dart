import './bloc/bloc_authentification/bloc.dart';
import './bloc/cat_facts/bloc.dart';
import './bloc/cat_images/bloc.dart';
import './bloc/cat_like/bloc.dart';
import './features/home/home_1.dart';
import './features/home/home_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(home: Text('Error connecting to firebase'));
          } else if (snapshot.connectionState == ConnectionState.done) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<CatsBloc>(
                    create: (context) => CatsBloc()..add(InitialCats())),
                BlocProvider<CatFactsBloc>(
                    create: (context) => CatFactsBloc()..add(FactsLoaded())),
                BlocProvider<LikeBloc>(create: (context) => LikeBloc()),
                BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
              ],
              child: BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) {
                return true;
              }, builder: (context, state) {
                if (state is AuthSuccess) {
                  if (state.currentUser != null) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Cats App',
                      home: HomeScreenUser(),
                    );
                  } else {
                    return Login();
                  }
                } else {
                  return Login();
                }
              }),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
