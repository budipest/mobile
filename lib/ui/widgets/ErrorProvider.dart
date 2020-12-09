import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../core/providers/ToiletModel.dart';

class ErrorProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToiletModel>(context);
    provider.globalContext = context;

    return Container();
  }
}
