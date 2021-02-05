import 'package:flutter/material.dart';

import 'CardTemplate.dart';
import '../../core/models/Toilet.dart';
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
                  maxWidth: MediaQuery.of(context).size.width * 0.49,
                ),
                child: Text(
                  toilet.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                toilet.distanceString,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
              if (icons.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 7.5),
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
        colors: [toilet.openState.color, Colors.grey[200]],
      ),
      padding: const EdgeInsets.fromLTRB(25, 15, 17.5, 15),
    );
  }
}
