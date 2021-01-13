import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        child: Padding(
            child: Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Icon(Icons.menu))),
                Expanded(
                    child: Text(
                  FlutterI18n.translate(context, "title"),
                  style: TextStyle(color: Colors.black87, fontSize: 24),
                )),
                Icon(Icons.add, color: Colors.black45),
              ],
            ),
            padding: const EdgeInsets.all(15)),
        margin: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}
