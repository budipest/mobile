import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            AppLocalizations.of(context).toiletName,
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
              AppLocalizations.of(context).name,
              onTextChanged: onNameChanged,
            ),
          )
        ],
      ),
    );
  }
}
