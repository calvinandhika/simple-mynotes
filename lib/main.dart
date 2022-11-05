import 'package:flutter/material.dart';
import 'package:flutter_bloc_vandad/constants/routes.dart';
import 'package:flutter_bloc_vandad/services/auth/auth_service.dart';
import 'package:flutter_bloc_vandad/views/login_view.dart';
import 'package:flutter_bloc_vandad/views/notes/new_note_view.dart';
import 'package:flutter_bloc_vandad/views/notes/notes_view.dart';
import 'package:flutter_bloc_vandad/views/register_view.dart';
import 'package:flutter_bloc_vandad/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
        ),
      ),
      title: 'Vandad Tutorial',
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
