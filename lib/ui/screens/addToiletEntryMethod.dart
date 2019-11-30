import 'package:flutter/material.dart';

import '../../core/models/toilet.dart';
import '../widgets/selectable.dart';
import '../widgets/textInput.dart';
import '../widgets/button.dart';

class AddToiletEntryMethod extends StatelessWidget {
  const AddToiletEntryMethod(
    this.onEntryMethodSubmitted,
    this.selectedEntryMethod,
    this.price,
    this.onPriceSubmitted,
    this.code,
    this.onCodeSubmitted,
    this.hasEUR,
    this.toggleEUR,
  );
  final Function onEntryMethodSubmitted;
  final Function onPriceSubmitted;
  final Function onCodeSubmitted;
  final Function toggleEUR;
  final EntryMethod selectedEntryMethod;
  final Map price;
  final String code;
  final bool hasEUR;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 200, 30, 30),
      child: ListView(
        children: <Widget>[
          Text(
            "A mosdó jellege",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "tag_key.svg",
              "ingyenes",
              null,
              onEntryMethodSubmitted,
              EntryMethod.FREE,
              selectedEntryMethod == EntryMethod.FREE,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "tag_key.svg",
              "fizetős",
              Column(
                children: <Widget>[
                  TextInput(
                    "Ár",
                    price["HUF"].toString(),
                    (String input) => onPriceSubmitted(input, "HUF"),
                    isDark: true,
                    suffixText: "HUF",
                    keyboardType: TextInputType.number,
                  ),
                  hasEUR
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextInput(
                            "Ár (alternatív valutában)",
                            price["EUR"].toString(),
                            (String input) => onPriceSubmitted(input, "EUR"),
                            isDark: true,
                            suffixText: "EUR",
                            keyboardType: TextInputType.number,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Button(
                            "valuta hozzáadása",
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
              "tag_key.svg",
              "vendégeknek ingyenes",
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
              "kóddal védett",
              TextInput(
                "ABC123",
                "",
                onCodeSubmitted,
                isDark: true,
                prefixText: "KÓD",
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
