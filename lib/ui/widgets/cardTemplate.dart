import 'package:flutter/material.dart';

class CardTemplate extends StatelessWidget {
  const CardTemplate(
    this.child, {
    this.gradient,
    this.horizontalPadding = 25.0,
    this.verticalPadding = 15.0,
  });
  final Widget child;
  final LinearGradient gradient;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(3.0),
        ),
        gradient: gradient,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: child,
      ),
    );
  }
}
