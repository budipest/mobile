import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/button.dart';
import '../widgets/personCard.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "aboutUs.title")),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              FlutterI18n.translate(context, "title"),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'v2.0.0',
              style: TextStyle(color: Colors.grey),
            ),
            Text(FlutterI18n.translate(context, "aboutUs.budapest")),
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PersonCard(
                      FlutterI18n.translate(context, "aboutUs.development"), {
                    "LinkedIn": "https://www.linkedin.com/in/dandesz198/",
                    "Telegram": "https://t.me/danielgrgly",
                    "email": "mailto:danielgrgly@gmail.com"
                  }),
                  PersonCard(
                      FlutterI18n.translate(context, "aboutUs.design"), {
                    "LinkedIn": "https://www.linkedin.com/in/dávid-jobbágy-18939215a/",
                  }),
                  PersonCard(
                      FlutterI18n.translate(context, "aboutUs.qa"), {
                    "website": "http://sites.google.com/view/b95/",
                    "Telegram": "https://t.me/bala7s",
                    "email": "mailto:usbee@pm.me"
                  }),
                ],
              ),
            ),
            Text(FlutterI18n.translate(context, "aboutUs.feedback")),
            Text(
              FlutterI18n.translate(context, "aboutUs.opensource"),
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Button(
                FlutterI18n.translate(context, "aboutUs.github"),
                () async {
                  String url = "https://github.com/danielgrgly/budipest";
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                FlutterI18n.translate(context, "aboutUs.toiletPaper"),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Button(
              FlutterI18n.translate(context, "aboutUs.paypal"),
              () async {
                String url = "https://paypal.me/danielgrgly";
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              backgroundColor: Color.fromRGBO(59, 123, 191, 1),
              foregroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
