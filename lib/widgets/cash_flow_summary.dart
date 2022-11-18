import 'package:cash_flow_app/providers/shared_preferences_provider.dart';
import 'package:cash_flow_app/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cash_flow_summary.dart';
import '../models/shared_preferences_model.dart';

class CashFlowSummaryWidget extends StatelessWidget {
  final CashFlowSummary cashFlow;

  const CashFlowSummaryWidget({Key? key, required this.cashFlow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currency = currencyToString(
        Provider.of<SharedPreferencesProvider>(context).getCurrency());
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: ButtonWrapper(
        inverse: cashFlow.cashFlow < 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Cash Flow: ${cashFlow.cashFlow} $currency",
              style: Theme.of(context).textTheme.headline6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  width: 10,
                ),
                FittedBox(
                  child: Text(
                    "Expenses: ${cashFlow.expenseSum} $currency",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                FittedBox(
                  child: Text(
                    "Income: ${cashFlow.incomeSum} $currency",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        height: 100,
        width: 350,
      ),
    );
  }
}
