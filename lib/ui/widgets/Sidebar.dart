import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Sidebar extends StatelessWidget {
  const Sidebar();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: (MediaQuery.of(context).padding.top + 60),
              right: 20,
              bottom: 30,
              left: 25,
            ),
            margin: const EdgeInsets.only(bottom: 20),
            color: Colors.black,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(context, "title"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'v2.0.0',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  title: Text(FlutterI18n.translate(context, "addToilet")),
                  onTap: () {
                    Navigator.pushNamed(context, '/addToilet');
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
                ListTile(
                  title: Text(FlutterI18n.translate(context, "aboutUs.title")),
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 20,
              bottom: (MediaQuery.of(context).padding.bottom + 15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/logo-white.svg",
                  width: 25,
                  color: Colors.grey,
                ),
                Container(width: 10),
                Text(
                  "since 2018",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
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
