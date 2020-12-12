import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Button.dart';

class PersonCard extends StatelessWidget {
  PersonCard(
    this.text,
    this.links,
  );

  final String text;
  final Map<String, String> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12, bottom: 8),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ...links.entries.map(
              (link) => Container(
                margin: EdgeInsets.only(right: 8),
                child: Button(
                  link.key,
                  () async {
                    if (await canLaunch(link.value)) {
                      await launch(link.value);
                    }
                  },
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                  isBordered: false,
                  isMini: true,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
