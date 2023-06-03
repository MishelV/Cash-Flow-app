import 'package:cash_flow_app/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/shared_preferences_model.dart';

Future<void> currencySelectionDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Settings"),
      content: Text(
        "Select your preferred currency Icon!",
        style: Theme.of(context).textTheme.displaySmall,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          style: currencyTextButtonStyle(context),
          onPressed: () {
            Navigator.of(ctx).pop();
            Provider.of<SharedPreferencesProvider>(context, listen: false)
                .setCurrency(Currency.dollar);
          },
          child: Text(
            dollarString,
            style: currencySelectionTextStyle(context),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            Provider.of<SharedPreferencesProvider>(context, listen: false)
                .setCurrency(Currency.shekel);
          },
          style: currencyTextButtonStyle(context),
          child: Text(
            shekelString,
            style: currencySelectionTextStyle(context),
          ),
        ),
        TextButton(
          style: currencyTextButtonStyle(context),
          onPressed: () {
            Navigator.of(ctx).pop();
            Provider.of<SharedPreferencesProvider>(context, listen: false)
                .setCurrency(Currency.euro);
          },
          child: Text(
            euroString,
            style: currencySelectionTextStyle(context),
          ),
        ),
      ],
    ),
  );
}

TextStyle? currencySelectionTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.headlineSmall;
}

ButtonStyle currencyTextButtonStyle(BuildContext context) {
  return TextButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
  );
}
