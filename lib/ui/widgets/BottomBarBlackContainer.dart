import 'dart:ui';

import 'package:flutter/material.dart';

class BottomBarBlackContainer extends StatelessWidget {
  const BottomBarBlackContainer(
    this.scrollProgress,
    this.onTapHandler,
    this.child,
  );

  final double scrollProgress;
  final Function onTapHandler;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTapHandler,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Opacity(
                opacity: 1 - scrollProgress,
                child: Center(
                  child: Container(
                    height: 4,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  ((MediaQueryData.fromWindow(window).padding.top + 60) *
                          scrollProgress) +
                      15.0,
                  0,
                  7.5,
                ),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
