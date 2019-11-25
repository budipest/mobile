import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Budipest',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
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
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Mosdó hozzáadása'),
                    onTap: () {
                      Navigator.pushNamed(context, "/add");
                    },
                  ),
                  ListTile(
                    title: Text('Értékeléseim'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Rólunk'),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => About()),
                      // );
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
