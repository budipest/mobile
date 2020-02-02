import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../core/models/toilet.dart';
import '../widgets/selectable.dart';
import '../widgets/textInput.dart';
import '../widgets/button.dart';

class AddToiletEntryMethod extends StatelessWidget {
  const AddToiletEntryMethod(
    this.onEntryMethodSubmitted,
    this.selectedEntryMethod,
    this.price,
    this.onPriceChanged,
    this.onCodeSubmitted,
    this.hasEUR,
    this.toggleEUR,
  );
  final Function onEntryMethodSubmitted;
  final Function onPriceChanged;
  final Function onCodeSubmitted;
  final Function toggleEUR;
  final EntryMethod selectedEntryMethod;
  final Map price;
  final bool hasEUR;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: ListView(
        children: <Widget>[
          Text(
            FlutterI18n.translate(context, "toiletEntryMethod"),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "tag_free.svg",
              FlutterI18n.translate(context, "free"),
              null,
              onEntryMethodSubmitted,
              EntryMethod.FREE,
              selectedEntryMethod == EntryMethod.FREE,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "tag_paid.svg",
              FlutterI18n.translate(context, "paid"),
              Column(
                children: <Widget>[
                  TextInput(
                    FlutterI18n.translate(context, "price"),
                    onTextChanged: (String input) => onPriceChanged(input, "HUF"),
                    isDark: true,
                    suffixText: "HUF",
                    keyboardType: TextInputType.number,
                  ),
                  hasEUR
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: 
                              TextInput(
                                FlutterI18n.translate(context, "priceAlternative"),
                                onTextChanged: (String input) => onPriceChanged(input, "EUR"),
                                isDark: true,
                                suffixText: "EUR",
                                keyboardType: TextInputType.number,
                              ),
                            
                          )
                      : Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Button(
                            FlutterI18n.translate(context, "addCurrency"),
                            toggleEUR,
                            backgroundColor: Colors.grey[900],
                            foregroundColor: Colors.white,
                          ),
                        ),
                ],
              ),
              onEntryMethodSubmitted,
              EntryMethod.PRICE,
              selectedEntryMethod == EntryMethod.PRICE,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "tag_guests.svg",
              FlutterI18n.translate(context, "guests"),
              null,
              onEntryMethodSubmitted,
              EntryMethod.CONSUMERS,
              selectedEntryMethod == EntryMethod.CONSUMERS,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "tag_key.svg",
              FlutterI18n.translate(context, "key"),
              TextInput(
                "",
                onTextChanged: onCodeSubmitted,
                isDark: true,
                prefixText: FlutterI18n.translate(context, "code"),
              ),
              onEntryMethodSubmitted,
              EntryMethod.CODE,
              selectedEntryMethod == EntryMethod.CODE,
            ),
          ),
        ],
      ),
    );
  }
}
