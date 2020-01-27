import 'package:flutter/material.dart';

class CardTemplate extends StatelessWidget {
  const CardTemplate(this.child, {this.gradient});
  final Widget child;
  final LinearGradient gradient;

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
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        child: child,
      ),
    );
  }
}
