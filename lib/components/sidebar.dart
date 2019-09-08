import 'package:flutter/material.dart';
import '../pages/about.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Text(
                  'Budipest',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  'v 0.1.0',
                  style: TextStyle(color: Colors.white),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          ListTile(
            title: Text('Beállítások'),
            leading: Icon(Icons.settings),
            onTap: () {},
          ),
          ListTile(
            title: Text('Saját értékeléseim'),
            leading: Icon(Icons.star),
            onTap: () {},
          ),
          ListTile(
            title: Text('Visszajelzés a fejlesztőnek'),
            leading: Icon(Icons.message),
            onTap: () {},
          ),
          ListTile(
            title: Text('Rólunk'),
            leading: Icon(Icons.info),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => About()),
              );
            },
          ),
        ],
      ),
    );
  }
}
