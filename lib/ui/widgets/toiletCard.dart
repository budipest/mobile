import 'package:flutter/material.dart';

import './cardTemplate.dart';
import '../../core/models/toilet.dart';
import '../../core/common/openHourUtils.dart';

class ToiletCard extends StatelessWidget {
  const ToiletCard(this.toilet);
  final Toilet toilet;

  @override
  Widget build(BuildContext context) {
    final List<Widget> icons =
        describeToiletIcons(toilet, "light", false, false);
    return CardTemplate(
      Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.50,
                ),
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
              if (icons.length > 2)
                Padding(
                  padding: EdgeInsets.only(top: 7.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...describeToiletIcons(
                        toilet,
                        "light",
                        false,
                        false,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (icons.length <= 2) Spacer(),
          if (icons.length <= 2)
            ...describeToiletIcons(
              toilet,
              "light",
              false,
              false,
            ),
        ],
      ),
      gradient: LinearGradient(
        stops: [0.02, 0.02],
        colors: [coloredOpenState(toilet.openHours), Colors.grey[200]],
      ),
    );
  }
}
