import 'package:flutter/material.dart';

import 'ErrorProvider.dart';

class BlackLayoutContainer extends StatefulWidget {
  BlackLayoutContainer({
    this.context,
    this.child,
    this.title,
    this.fab,
    this.inlineTitle,
  });

  final BuildContext context;
  final Widget child;
  final String title;
  final String inlineTitle;
  final FloatingActionButton fab;

  @override
  _BlackLayoutContainerState createState() => _BlackLayoutContainerState();
}

class _BlackLayoutContainerState extends State<BlackLayoutContainer> {
  GlobalKey headerKey = GlobalKey();
  double height = 0;

  @override
  initState() {
    //calling the getHeight Function after the Layout is Rendered
    WidgetsBinding.instance.addPostFrameCallback((_) => _getSizes());

    super.initState();
  }

  void _getSizes() {
    final RenderBox renderBoxRed = headerKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    setState(() {
      height = size.height;
    });
    // return size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.fab,
      body: Stack(
        children: <Widget>[
          ErrorProvider(),
          Padding(
            padding: EdgeInsets.only(
              top: height,
            ),
            child: widget.child,
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
                            padding: const EdgeInsets.all(0),
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
                              constraints: BoxConstraints(maxHeight: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 18.0),
                                    child: Hero(
                                      tag: "inlineTitle",
                                      flightShuttleBuilder: (
                                        BuildContext flightContext,
                                        Animation<double> animation,
                                        HeroFlightDirection flightDirection,
                                        BuildContext fromHeroContext,
                                        BuildContext toHeroContext,
                                      ) =>
                                          Material(
                                        color: Colors.transparent,
                                        child: toHeroContext.widget,
                                      ),
                                      child: SizedBox(
                                        child: Text(
                                          widget.inlineTitle,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: "Muli",
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
                        padding: const EdgeInsets.only(top: 75, left: 4),
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
        ],
      ),
    );
  }
}
