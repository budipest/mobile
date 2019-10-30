import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/viewmodels/ToiletModel.dart';
import '../../core/models/toilet.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final toiletProvider = Provider.of<ToiletModel>(context);

    return FutureBuilder(
        future: toiletProvider.fetchData(),
        builder: (BuildContext context, AsyncSnapshot<List<Toilet>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 4,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15.0, 0, 7.5),
                          child: Text(
                            "Ajánlott mosdó",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "Őrültlegény Bisztró",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "300 m",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Padding(padding: EdgeInsets.all(25.0), child: Expanded(child: ,),)
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
                  child: Text(
                    "További mosdók",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[index].title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "590 m",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Text("Fetching...");
          }
        });
  }
}
