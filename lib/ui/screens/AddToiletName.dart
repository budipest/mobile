import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../widgets/TextInput.dart';

class AddToiletName extends StatelessWidget {
  const AddToiletName(
    this.name,
    this.onNameChanged,
  );

  final String name;
  final Function(String) onNameChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 45, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            FlutterI18n.translate(context, "toiletName"),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: TextInput(
              name,
              FlutterI18n.translate(context, "name"),
              onTextChanged: onNameChanged,
            ),
          )
        ],
      ),
    );
  }
}
