import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  TextInput(this.placeholder, this.text, this.onTextSubmitted);
  TextEditingController textEditingController = TextEditingController();
  final Function(String) onTextSubmitted;
  final String placeholder;
  final String text;

  @override
  Widget build(BuildContext context) {
    textEditingController.text = text;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0),
        child: TextField(
          controller: textEditingController,
          style: TextStyle(fontSize: 18.0),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: placeholder,
          ),
          onSubmitted: onTextSubmitted,
        ),
      ),
    );
  }
}
