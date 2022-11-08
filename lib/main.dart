// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc_vandad/constants/routes.dart';
import 'package:flutter_bloc_vandad/services/auth/auth_service.dart';
import 'package:flutter_bloc_vandad/views/login_view.dart';
import 'package:flutter_bloc_vandad/views/notes/create_update_note_view.dart';
import 'package:flutter_bloc_vandad/views/notes/notes_view.dart';
import 'package:flutter_bloc_vandad/views/register_view.dart';
import 'package:flutter_bloc_vandad/views/verify_email_view.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     MaterialApp(
//       theme: ThemeData(
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.orange,
//         ),
//       ),
//       title: 'Vandad Tutorial',
//       home: const HomePage(),
//       routes: {
//         loginRoute: (context) => const LoginView(),
//         registerRoute: (context) => const RegisterView(),
//         notesRoute: (context) => const NotesView(),
//         verifyEmailRoute: (context) => const VerifyEmailView(),
//         createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
//       },
//     ),
//   );
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return const VerifyEmailView();
//               }
//             } else {
//               return const LoginView();
//             }
//           default:
//             return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

void main() {
  runApp(const BlocTesting());
}

abstract class CounterEvent {
  final String value;
  CounterEvent(this.value);
}

class IncrementCounter extends CounterEvent {
  IncrementCounter(super.value);
}

class DecrementCounter extends CounterEvent {
  DecrementCounter(super.value);
}

abstract class CounterState {
  final int value;

  CounterState(this.value);
}

class ValidCounterState extends CounterState {
  ValidCounterState(super.value);
}

class InvalidCounterState extends CounterState {
  final String invalidValue;
  InvalidCounterState({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(ValidCounterState(0)) {
    on<IncrementCounter>((event, emit) {
      final parsedNumber = int.tryParse(event.value);
      if (parsedNumber != null) {
        return emit(ValidCounterState(state.value + parsedNumber));
      } else {
        return emit(InvalidCounterState(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      }
    });
    on<DecrementCounter>((event, emit) {
      final parsedNumber = int.tryParse(event.value);
      if (parsedNumber != null) {
        return emit(ValidCounterState(state.value - parsedNumber));
      } else {
        return emit(InvalidCounterState(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      }
    });
  }
}

class BlocTesting extends StatefulWidget {
  const BlocTesting({Key? key}) : super(key: key);

  @override
  State<BlocTesting> createState() => _BlocTestingState();
}

class _BlocTestingState extends State<BlocTesting> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Bloc Testing'),
          ),
          body: BlocConsumer<CounterBloc, CounterState>(
            listener: (context, state) {
              _controller.clear();
            },
            builder: (context, state) {
              final invalidValue =
                  (state is InvalidCounterState) ? state.invalidValue : '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Current State => ${state.value}'),
                  Visibility(
                    visible: state is InvalidCounterState,
                    child: Text('invalid number: $invalidValue'),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Masukan Angka',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(DecrementCounter(_controller.text));
                        },
                        child: const Text('-'),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(IncrementCounter(_controller.text));
                        },
                        child: const Text('+'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
