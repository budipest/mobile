import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/Button.dart';
import '../widgets/CardTemplate.dart';
import '../widgets/PersonCard.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).aboutUs),
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
                      AppLocalizations.of(context).title,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'v2.2.2',
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            child: Text(
              AppLocalizations.of(context).aboutUsBudapest,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Builder(
            builder: (BuildContext context) => CardTemplate(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).aboutUsHelpUs,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).aboutUsHelpUsDescription,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Container(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Button(
                        "Facebook",
                        () async {
                          String url = "https://facebook.com/budipestapp";
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      Spacer(),
                      Button(
                        "website",
                        () async {
                          String url = "https://budipest.com";
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      Spacer(),
                      Button(
                        "GitHub",
                        () async {
                          String url = "https://github.com/budipest";
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                    ],
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
                  AppLocalizations.of(context).aboutUsTeam,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PersonCard(
                  AppLocalizations.of(context).aboutUsDevelopment,
                  {
                    "LinkedIn": "https://www.linkedin.com/in/dnlgrgly/",
                    "email": "mailto:dnlgrgly@icloud.com"
                  },
                ),
                PersonCard(
                  AppLocalizations.of(context).aboutUsDesign,
                  {
                    "LinkedIn": "https://www.linkedin.com/in/davidjobbagy/",
                    "email": "mailto:davidjobbagy07@gmail.com",
                  },
                ),
                Container(height: 20),
                Text(
                  AppLocalizations.of(context).aboutUsBetaTitle,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).aboutUsBetaNames,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Container(height: 8),
                Text(
                  AppLocalizations.of(context).aboutUsOpenSource,
                  style: TextStyle(
                    fontSize: 18,
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
