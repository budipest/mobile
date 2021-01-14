import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/Button.dart';
import '../widgets/CardTemplate.dart';
import '../widgets/PersonCard.dart';

class AboutUs extends StatelessWidget {
  void setClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          FlutterI18n.translate(
            context,
            FlutterI18n.translate(context, "copied"),
          ),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "aboutUs.title")),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black),
            padding: const EdgeInsets.all(40),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/logo-white.svg",
                  width: 75,
                ),
                Container(width: 35),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      FlutterI18n.translate(context, "title"),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'v2.0.0',
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Text(
                FlutterI18n.translate(context, "aboutUs.budapest"),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Builder(
            builder: (BuildContext context) => CardTemplate(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FlutterI18n.translate(context, "aboutUs.toiletPaper"),
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    FlutterI18n.translate(
                        context, "aboutUs.toiletPaper-description"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Container(height: 12),
                  GestureDetector(
                    child: Text(
                      "IBAN: HU80 1040 2764 8676 7651 7452 1001",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () => setClipboard(
                        context, "HU80 1040 2764 8676 7651 7452 1001"),
                  ),
                  Container(height: 8),
                  GestureDetector(
                    child: Text(
                      "SWIFT: OKHB HUHB",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () => setClipboard(context, "OKHB HUHB"),
                  ),
                  Container(height: 8),
                  GestureDetector(
                    child: Text(
                      FlutterI18n.translate(context, "aboutUs.accountNumber"),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () =>
                        setClipboard(context, "10402764-86767651-74521001"),
                  ),
                  Container(height: 8),
                  GestureDetector(
                    child: Text(
                      FlutterI18n.translate(context, "aboutUs.recipient"),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () => setClipboard(context, "Gergely Dániel"),
                  ),
                ],
              ),
              gradient: LinearGradient(
                stops: [0],
                colors: [Colors.grey[100]],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  FlutterI18n.translate(context, "aboutUs.team"),
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PersonCard(
                  FlutterI18n.translate(context, "aboutUs.development"),
                  {
                    "LinkedIn": "https://www.linkedin.com/in/dnlgrgly/",
                    "Telegram": "https://t.me/dnlgrgly",
                    "email": "mailto:dnlgrgly@gmail.com"
                  },
                ),
                PersonCard(
                  FlutterI18n.translate(context, "aboutUs.design"),
                  {
                    "LinkedIn":
                        "https://www.linkedin.com/in/dávid-jobbágy-18939215a/",
                  },
                ),
                PersonCard(
                  FlutterI18n.translate(context, "aboutUs.beta"),
                  {},
                ),
                Container(height: 24),
                Text(
                  FlutterI18n.translate(context, "aboutUs.feedback"),
                  style: TextStyle(fontSize: 18),
                ),
                Container(height: 8),
                Text(
                  FlutterI18n.translate(context, "aboutUs.opensource"),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Button(
                    FlutterI18n.translate(context, "aboutUs.github"),
                    () async {
                      String url =
                          "https://github.com/dnlgrgly/budipest-mobile";
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
