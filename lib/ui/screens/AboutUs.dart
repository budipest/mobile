import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/Button.dart';
import '../widgets/CardTemplate.dart';
import '../widgets/PersonCard.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("aboutUs.title"),
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
                      "title",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'v2.0.2',
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
              "aboutUs.budapest",
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
                    "aboutUs.helpUs",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "aboutUs.helpUs-description",
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
                      Container(width: 20),
                      Button(
                        "website",
                        () async {
                          String url = "https://dnlgrgly.com/budipest";
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      Container(width: 20),
                      Button(
                        "GitHub",
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
                  "aboutUs.team",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PersonCard(
                  "aboutUs.development",
                  {
                    "website": "https://dnlgrgly.com",
                    "LinkedIn": "https://www.linkedin.com/in/dnlgrgly/",
                    "email": "mailto:dnlgrgly@gmail.com"
                  },
                ),
                PersonCard(
                  "aboutUs.design",
                  {
                    "email": "mailto:davidjobbagy07@gmail.com",
                  },
                ),
                Container(height: 20),
                Text(
                  "aboutUs.betaTitle",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "aboutUs.betaNames",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Container(height: 8),
                Text(
                  "aboutUs.opensource",
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
