import 'package:flutter/material.dart';

class Selectable extends StatelessWidget {
  Selectable(this.icon, this.text, this.openChildren, this.onSelect, this.index,
      this.isSelected);
  final IconData icon;
  final String text;
  final Widget openChildren;
  final int index;
  final bool isSelected;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Material(
          child: InkWell(
            onTap: () => onSelect(index),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(
                          icon,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          color: Colors.transparent,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.grey[400] : Colors.transparent,
              offset: Offset(0.0, 5.0),
              blurRadius: 10.0,
            )
          ],
        ),
      ),
    );
  }
}
