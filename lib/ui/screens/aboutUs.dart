import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About us"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Made with ❤️ in Budapest"),
            Text(
                "Development: Gergely Dániel és Tsai Szövetkezet Nonprofit Nyrt."),
            Text("Contact: daniel.gergely@risingstack.com")
          ],
        ),
      ),
    );
  }
}
