import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  child: Icon(Icons.menu),
                ),
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).title,
                  style: TextStyle(color: Colors.black87, fontSize: 24),
                ),
              ),
              Icon(Icons.add, color: Colors.black45),
            ],
          ),
          padding: const EdgeInsets.all(15),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}
