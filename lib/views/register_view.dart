import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_vandad/constants/routes.dart';
import 'package:flutter_bloc_vandad/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register View'),
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
                final userCredentials = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
              } on FirebaseAuthException catch (e) {
                // throw Exception(e);
                late final String errorMessage;
                if (e.code == 'weak-password') {
                  errorMessage = 'Weak Password';
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
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Login here!'),
          ),
        ],
      ),
    );
  }
}
