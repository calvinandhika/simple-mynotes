import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_bloc_vandad/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login View'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  notesRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                // throw Exception(e);
                late final String errorMessage;
                if (e.code == 'user-not-found') {
                  errorMessage = 'User not found';
                } else if (e.code == 'wrong-password') {
                  errorMessage = 'Wrong Password';
                } else {
                  errorMessage = e.toString();
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      errorMessage,
                    ),
                  ),
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
