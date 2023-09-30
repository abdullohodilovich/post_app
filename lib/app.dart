import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app/src/blocs/auth/auth_bloc.dart';
import 'package:post_app/src/pages/home_page.dart';
import 'package:post_app/src/pages/sign_in_page.dart';
import 'package:post_app/src/services/database/auth_services.dart';

class PostApp extends StatelessWidget {
  const PostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        theme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          initialData: null,
          stream: AuthService.auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return const HomePage();
            } else {
              return SignInPage();
            }
          },
        ),
      ),
    );
  }
}
