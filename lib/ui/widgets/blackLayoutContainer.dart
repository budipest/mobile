import 'package:flutter/material.dart';

class BlackLayoutContainer extends StatelessWidget {
  BlackLayoutContainer({
    this.context,
    this.child,
    this.title,
    this.fab,
  });

  BuildContext context;
  Widget child;
  String title;
  FloatingActionButton fab;
  GlobalKey headerKey = GlobalKey();

  double _getSizes() {
    if (headerKey.currentContext == null) {
      return 0;
    }
    final RenderBox renderBoxRed = headerKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    return size.height - MediaQuery.of(context).padding.top;
  }

  @override
  Widget build(BuildContext context) {
    print(title);
    return Scaffold(
      floatingActionButton: fab,
      body: Stack(
        children: <Widget>[
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(
                top: _getSizes(),
              ),
              child: child,
            ),
          ),
          Container(
            key: headerKey,
            decoration: BoxDecoration(color: Colors.black),
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 30, 30, 30),
                child: Stack(
                  children: <Widget>[
                    RawMaterialButton(
                      shape: CircleBorder(),
                      fillColor: Colors.white,
                      elevation: 5.0,
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 75, left: 4),
                      child: Hero(
                        tag: "title",
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
