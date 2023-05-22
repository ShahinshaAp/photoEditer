import 'package:flutter/material.dart';
import 'package:flutter_crud/widgets/card_view.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<Auth>();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CardView(
              elevation: true,
              child: Column(
                children: [
                  CustomFormField(
                    controller: emailController,
                    hintText: "email",
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomFormField(
                    controller: passwordController,
                    hintText: "password",
                    maxLines: 1,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      auth.loginUser(
                          emailController.text, passwordController.text);
                    },
                  )
                ],
              ))
        ],
      ),
    );
  }
}
