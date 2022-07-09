import 'package:cash_flow_app/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

import '../models/cash_flow_summary.dart';

class CashFlowSummaryWidget extends StatelessWidget {
  final CashFlowSummary cashFlow;

  const CashFlowSummaryWidget({Key? key, required this.cashFlow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ButtonWrapper(
        inverse: cashFlow.cashFlow < 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Cash Flow: ${cashFlow.cashFlow} ₪",
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
                    "Expenses: ${cashFlow.expenseSum} ₪",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                FittedBox(
                  child: Text(
                    "Income: ${cashFlow.incomeSum} ₪",
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
