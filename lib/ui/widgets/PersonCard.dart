import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'button.dart';

class PersonCard extends StatelessWidget {
  PersonCard(this.text, this.links);
  final String text;
  final Map<String, String> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ...links.entries.map(
              (link) =>
                  // Button(
                  //   link.key,
                  //   () async {
                  //     if (await canLaunch(link.value)) {
                  //       await launch(link.value);
                  //     }
                  //   },
                  //   isBordered: true,
                  //   isMini: true,
                  // ),

                  InkWell(
                child: Text(link.key),
                onTap: () async {
                  if (await canLaunch(link.value)) {
                    await launch(link.value);
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
