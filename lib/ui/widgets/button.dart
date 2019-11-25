import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(this.icon, this.text, this.onTap, this.backgroundColor,
      this.foregroundColor, this.isBordered, this.isMini);
  final IconData icon;
  final String text;
  final Function onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isBordered;
  final bool isMini;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: isBordered ? Colors.transparent : backgroundColor,
          border: Border.all(
            color: isBordered ? foregroundColor : backgroundColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(40.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) Icon(icon, color: foregroundColor, size: isMini ? 20 : 25,),
            if (text != null)
              Padding(
                padding:
                    EdgeInsets.only(left: text != "" && icon != null ? 8.0 : 0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: isMini ? FontWeight.normal : FontWeight.bold,
                    fontSize: isMini ? 14 : 16
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
