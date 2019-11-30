import 'package:flutter/material.dart';

Widget affix(String text, bool isPrefix,
    {Color backgroundColor, Color foregroundColor}) {
  return Container(
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.grey[400],
      borderRadius: isPrefix
          ? BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            )
          : BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
      child: Text(
        text,
        style: TextStyle(
          color: foregroundColor ?? Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    ),
  );
}

class TextInput extends StatelessWidget {
  TextInput(
    this.placeholder,
    this.text,
    this.onTextSubmitted, {
    this.isDark = false,
    this.prefixText,
    this.suffixText,
    this.keyboardType = TextInputType.text,
  });
  TextEditingController textEditingController = TextEditingController();
  final Function onTextSubmitted;
  final String placeholder;
  final String text;
  final bool isDark;
  final String prefixText;
  final String suffixText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    textEditingController.text = text;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Row(
        children: <Widget>[
          if (prefixText != null) affix(prefixText, true),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0),
              child: TextField(
                controller: textEditingController,
                keyboardType: keyboardType,
                style: TextStyle(
                  fontSize: 18.0,
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: placeholder,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                onSubmitted: onTextSubmitted,
              ),
            ),
          ),
          if (suffixText != null) affix(suffixText, false),
        ],
      ),
    );
  }
}
