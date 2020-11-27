import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class StatusBarObserver extends RouteObserver<PageRoute<dynamic>> {
  StatusBarObserver();

  void recolor(PageRoute<dynamic> route) {
    switch (route.settings.name) {
      case "/":
        {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
          break;
        }
      case "/addToilet":
      case "/addNote":
      case "/about":
        {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
          break;
        }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      recolor(route);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      recolor(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      recolor(previousRoute);
    }
  }
}
