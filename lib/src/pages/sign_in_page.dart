import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app/src/blocs/auth/auth_bloc.dart';
import 'package:post_app/src/pages/home_page.dart';
import 'package:post_app/src/pages/sign_up_page.dart';
import 'package:post_app/src/services/constants/string_constants.dart';
import 'package:post_app/src/views/custom_text_field_view.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
          if (state is SignInSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Icon profile
                    const Icon(
                      CupertinoIcons.profile_circled,
                      size: 200,
                    ),

                    /// text sign in
                    Text(
                      I18N.signin,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    /// text fields:: email and password
                    CustomTextField(
                        controller: emailController, title: I18N.email),
                    CustomTextField(
                        controller: passwordController, title: I18N.password),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.sizeOf(context).width * 0.8, 70),
                        backgroundColor: Colors.deepPurpleAccent.shade200,
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(SignInEvent(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim()));
                      },
                      child: const Text(I18N.signin),
                    ),
                    const SizedBox(height: 30),

                    ///Don't have an account sign in
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                        text: I18N.dontHaveAccount,
                        style: TextStyle(color: Colors.white)
                      ),

                      TextSpan(
                          text: I18N.signup,
                          style: const TextStyle(color: Colors.lightBlueAccent),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()));
                            }),
                    ]))
                  ],
                ),
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is AuthLoading) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            })
          ],
        ),
      ),
    );
  }
}
