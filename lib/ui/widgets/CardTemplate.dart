import 'package:flutter/material.dart';

class CardTemplate extends StatelessWidget {
  const CardTemplate(
    this.child, {
    this.gradient,
    this.padding = const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
  });

  final Widget child;
  final LinearGradient gradient;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        gradient: gradient,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
