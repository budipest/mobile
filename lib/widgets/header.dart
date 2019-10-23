import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        child: Padding(
            child: Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Icon(Icons.menu))),
                Expanded(
                    child: Text(
                  'Budipest',
                  style: TextStyle(color: Colors.black87, fontSize: 24),
                )),
                Icon(Icons.add, color: Colors.black45),
              ],
            ),
            padding: EdgeInsets.all(15)),
        margin: EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}
