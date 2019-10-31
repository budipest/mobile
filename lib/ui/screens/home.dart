import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';

import '../widgets/map.dart';
import '../widgets/sidebar.dart';
import '../widgets/bottomBar.dart';
import '../../core/viewmodels/ToiletModel.dart';
import '../../core/models/toilet.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Animation<double> animation;
  AnimationController controller;
  List<Toilet> data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final toiletProvider = Provider.of<ToiletModel>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(),
      body: StreamBuilder(
          stream: toiletProvider.fetchQueriedData(2.0),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = snapshot.data
                  .map((doc) => Toilet.fromMap(doc.data, doc.documentID))
                  .toList()
                  .cast<Toilet>();

              return SlidingUpPanel(
                parallaxEnabled: true,
                parallaxOffset: 0.5,
                minHeight: 200,
                maxHeight: MediaQuery.of(context).size.height,
                panel: BottomBar(data),
                body: Center(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        MapWidget(data),
                        SafeArea(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          child: FloatingActionButton(
                              child: Icon(
                                Icons.menu,
                                color: Colors.black,
                              ),
                              mini: true,
                              onPressed: () =>
                                  _scaffoldKey.currentState.openDrawer(),
                              backgroundColor: Colors.white),
                        )),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Haha el van succolva xdddd :)))"));
            }
            else {
              return Center(child: Text("Data is fetching xdddd asasa"));
            }
          }),
    );
  }
}
