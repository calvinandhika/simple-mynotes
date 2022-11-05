import 'package:flutter/material.dart';
import 'package:flutter_bloc_vandad/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An error occurred',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
