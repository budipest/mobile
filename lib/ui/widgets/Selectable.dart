import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Selectable extends StatelessWidget {
  Selectable(
    this.iconName,
    this.text,
    this.onSelect,
    this.index,
    this.isSelected, {
    this.openChild,
  });

  final String iconName;
  final String text;
  final dynamic index;
  final bool isSelected;
  final Function onSelect;
  final Widget openChild;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Material(
          child: InkWell(
            onTap: () => onSelect(index),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Container(
                          width: 25,
                          child: SvgPicture.asset(
                            "assets/icons/bottom/$iconName",
                            semanticsLabel: '$iconName category icon',
                            width: 25,
                            height: 25,
                            color: isSelected ? Colors.white : Colors.black,
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
                  if (isSelected && openChild != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: openChild,
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
