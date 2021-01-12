import 'package:flutter/material.dart';

Widget affix(
  String text,
  bool isPrefix, {
  Color backgroundColor,
  Color foregroundColor,
}) {
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

class TextInput extends StatefulWidget {
  TextInput(
    this.text,
    this.placeholder, {
    this.onTextChanged,
    this.isDark = false,
    this.prefixText,
    this.suffixText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1
  });

  final String text;
  final Function onTextChanged;
  final String placeholder;
  final bool isDark;
  final String prefixText;
  final String suffixText;
  final TextInputType keyboardType;
  final int maxLines;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final TextEditingController _textEditingController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();

    TextSelection cursorPos = _textEditingController.selection;

    _textEditingController.text = widget.text ?? '';

    if (cursorPos.start > _textEditingController.text.length) {
      cursorPos = TextSelection.fromPosition(
        TextPosition(offset: _textEditingController.text.length),
      );
    }

    _textEditingController.selection = cursorPos;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.grey[900] : Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Row(
        children: <Widget>[
          if (widget.prefixText != null) affix(widget.prefixText, true),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0),
              child: TextField(
                maxLines: widget.maxLines,
                keyboardType: widget.keyboardType,
                style: TextStyle(
                  fontSize: 18.0,
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.placeholder,
                  hintStyle: TextStyle(
                    color: widget.isDark ? Colors.grey[600] : Colors.grey[700],
                  ),
                ),
                autocorrect: false,
                onChanged: widget.onTextChanged,
                controller: _textEditingController,
              ),
            ),
          ),
          if (widget.suffixText != null) affix(widget.suffixText, false),
        ],
      ),
    );
  }
}
