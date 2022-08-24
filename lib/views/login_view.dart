import 'package:demo/helpers/if_debugging.dart';
import 'package:demo/type_definitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  const LoginView({
    Key? key,
    required this.loginFunction,
    required this.goToRegisterView,
  }) : super(key: key);

  final LoginFunction loginFunction;
  final VoidCallback goToRegisterView;

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: 'demo@gmail.com'.ifDebugging);
    final passwordController = useTextEditingController(text: '123456'.ifDebugging);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Enter your email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(hintText: 'Enter your email'),
            obscureText: true,
          ),
          TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                loginFunction(email: email, password: password);
              },
              child: const Text('Log in')),
          TextButton(
            onPressed: goToRegisterView,
            child: const Text('Register here'),
          ),
        ]),
      ),
    );
  }
}
