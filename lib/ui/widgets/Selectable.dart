import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Selectable extends StatelessWidget {
  Selectable(this.iconName, this.text, this.openChildren, this.onSelect,
      this.index, this.isSelected);
  final String iconName;
  final String text;
  final Widget openChildren;
  final dynamic index;
  final bool isSelected;
  final Function onSelect;

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
                        padding: EdgeInsets.only(right: 20.0),
                        child: Container(
                          width: 25,
                          child: SvgPicture.asset(
                            "assets/icons/bottom/${isSelected ? "light" : "dark"}/$iconName",
                            semanticsLabel: '$iconName category icon',
                            width: 25,
                            height: 25,
                          ),
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
                  if (isSelected && openChildren != null)
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: openChildren,
                    )
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
