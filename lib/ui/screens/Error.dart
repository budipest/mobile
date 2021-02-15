import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Error extends StatelessWidget {
  const Error(this.error);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.warning, size: 80),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              AppLocalizations.of(context).errorTitle,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Text(
            error,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
