import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error(this.errorCode);

  final String errorCode;

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
              "error.title",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Text(
            errorCode,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
