import 'package:flutter/material.dart';

class BlackLayoutContainer extends StatefulWidget {
  BlackLayoutContainer(
      {this.context, this.child, this.title, this.fab, this.inlineTitle});

  BuildContext context;
  Widget child;
  String title;
  String inlineTitle;
  FloatingActionButton fab;

  @override
  _BlackLayoutContainerState createState() => _BlackLayoutContainerState();
}

class _BlackLayoutContainerState extends State<BlackLayoutContainer> {
  GlobalKey headerKey = GlobalKey();

  double _getSizes() {
    print(headerKey.currentContext);
    if (headerKey.currentContext == null) {
      return 0;
    }
    final RenderBox renderBoxRed = headerKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    return size.height - MediaQuery.of(widget.context).padding.top;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.fab,
      body: Column(
        children: <Widget>[
          // SafeArea(
          //   top: false,
          //   bottom: false,
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //       top: _getSizes(),
          //     ),
          //     child: widget.child,
          //   ),
          // ),
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
                    Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Hero(
                          tag: "materialCloseButton",
                          child: RawMaterialButton(
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
                        ),
                        if (widget.inlineTitle != null)
                          Flexible(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 12.0, right: 18.0),
                                    child: Hero(
                                      tag: "inlineTitle",
                                      child: SizedBox(
                                        width: 400,
                                        child: Text(
                                          widget.inlineTitle,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (widget.title != null)
                      Padding(
                        padding: EdgeInsets.only(top: 75, left: 4),
                        child: Hero(
                          tag: "title",
                          child: Text(
                            widget.title,
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
          widget.child
        ],
      ),
    );
  }
}
