import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/models/Toilet.dart';
import '../widgets/Selectable.dart';
import '../widgets/TextInput.dart';
import '../widgets/Button.dart';

class AddToiletEntryMethod extends StatelessWidget {
  const AddToiletEntryMethod(
    this.onEntryMethodSubmitted,
    this.selectedEntryMethod,
    this.price,
    this.onPriceChanged,
    this.code,
    this.onCodeSubmitted,
    this.hasEUR,
    this.toggleEUR,
  );

  final EntryMethod selectedEntryMethod;
  final Function onEntryMethodSubmitted;
  final Map price;
  final Function onPriceChanged;
  final String code;
  final Function onCodeSubmitted;
  final Function toggleEUR;
  final bool hasEUR;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
      children: <Widget>[
        Text(
          AppLocalizations.of(context).toiletEntryMethod,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "tag_free.svg",
            AppLocalizations.of(context).free,
            onEntryMethodSubmitted,
            EntryMethod.FREE,
            selectedEntryMethod == EntryMethod.FREE,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "tag_paid.svg",
            AppLocalizations.of(context).paid,
            onEntryMethodSubmitted,
            EntryMethod.PRICE,
            selectedEntryMethod == EntryMethod.PRICE,
            openChild: Column(
              children: <Widget>[
                TextInput(
                  price["HUF"] != null ? price["HUF"].toString() : null,
                  AppLocalizations.of(context).price,
                  onTextChanged: (String input) => onPriceChanged(input, "HUF"),
                  isDark: true,
                  suffixText: "HUF",
                  keyboardType: TextInputType.number,
                ),
                hasEUR
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextInput(
                                price["EUR"] != null
                                    ? price["EUR"].toString()
                                    : null,
                                AppLocalizations.of(context).priceAlternative,
                                onTextChanged: (String input) =>
                                    onPriceChanged(input, "EUR"),
                                isDark: true,
                                suffixText: "EUR",
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: InkWell(
                                onTap: toggleEUR,
                                child: Container(
                                  width: 51,
                                  height: 51,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Button(
                          AppLocalizations.of(context).addCurrency,
                          toggleEUR,
                          backgroundColor: Colors.grey[900],
                          foregroundColor: Colors.white,
                        ),
                      ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "tag_guests.svg",
            AppLocalizations.of(context).guests,
            onEntryMethodSubmitted,
            EntryMethod.CONSUMERS,
            selectedEntryMethod == EntryMethod.CONSUMERS,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "tag_key.svg",
            AppLocalizations.of(context).key,
            onEntryMethodSubmitted,
            EntryMethod.CODE,
            selectedEntryMethod == EntryMethod.CODE,
            openChild: TextInput(
              code,
              "",
              onTextChanged: onCodeSubmitted,
              isDark: true,
              prefixText: AppLocalizations.of(context).code,
            ),
          ),
        ),
      ],
    );
  }
}
