import 'package:flutter/material.dart';

import '../widgets/textInput.dart';

class AddToiletTitle extends StatelessWidget {
  const AddToiletTitle(this.onTitleSubmitted, this.controller, this.title);
  final Function(String) onTitleSubmitted;
  final PageController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 200, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "A mosdó neve",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: TextInput("Kreatív név", title, (String title) {
              print('henlo');
              controller.nextPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
              onTitleSubmitted(title);
            }),
          )
        ],
      ),
    );
  }
}
