import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Error extends StatelessWidget {
  const Error(this.text);
  final String text;

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
              FlutterI18n.translate(context, "error.title"),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
