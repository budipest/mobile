import 'package:flutter/material.dart';

import '../../core/models/toilet.dart';
import '../../core/common/determineIcon.dart';

class ToiletCard extends StatelessWidget {
  const ToiletCard(this.toilet);
  final Toilet toilet;

  @override
  Widget build(BuildContext context) {
    print("toiletCard build ${toilet.title}");
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.02, 0.02],
          colors: [coloredOpenState(toilet.openHours), Colors.grey[200]],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(3.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.60),
                  child: Text(
                    toilet.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "${toilet.distance} m",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Spacer(),
            ...describeToiletIcons(toilet, "dark"),
          ],
        ),
      ),
    );
  }
}
