import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app/src/blocs/auth/auth_bloc.dart';
import 'package:post_app/src/pages/sign_in_page.dart';
import 'package:post_app/src/services/constants/string_constants.dart';
import 'package:post_app/src/views/custom_text_field_view.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final prePasswordController = TextEditingController();

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
          if (state is SignUpSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SignInPage(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// text signUp
              Text(
                I18N.signup,
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              CustomTextField(controller: nameController, title: I18N.username),
              CustomTextField(controller: emailController, title: I18N.email),
              CustomTextField(
                  controller: passwordController, title: I18N.password),
              CustomTextField(
                  controller: prePasswordController, title: I18N.prePassword),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.sizeOf(context).width * 0.8, 70),
                  backgroundColor: Colors.deepPurpleAccent.shade200,
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(
                        SignUpEvent(
                          username: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          prePassword: prePasswordController.text.trim(),
                        ),
                      );
                },
                child: const Text(I18N.signup),
              ),
              const SizedBox(height: 30),

              ///Already have an account sign in
              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                    text: I18N.alreadyHaveAccount,
                    style: TextStyle(color: Colors.white)),
                TextSpan(
                    text: I18N.signin,
                    style: const TextStyle(color: Colors.lightBlueAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()));
                      }),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
