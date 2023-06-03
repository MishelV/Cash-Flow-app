import 'dart:math';

import 'package:cash_flow_app/models/cash_flow_summary.dart';
import 'package:cash_flow_app/providers/record_provider.dart';
import 'package:cash_flow_app/providers/shared_preferences_provider.dart';
import 'package:cash_flow_app/screens/search_record_screen.dart';
import 'package:cash_flow_app/utils/date_time_util.dart';
import 'package:cash_flow_app/widgets/general/button_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../models/search_type.dart';
import '../../models/shared_preferences_model.dart';

class ThisMonthSummary extends StatefulWidget {
  const ThisMonthSummary({Key? key}) : super(key: key);

  @override
  State<ThisMonthSummary> createState() => _ThisMonthSummaryState();
}

class _ThisMonthSummaryState extends State<ThisMonthSummary> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isInit = false;
        _isLoading = true;
      });
      Provider.of<RecordProvider>(context, listen: false)
          .fetchAndSetRecords()
          .then(
        (_) {
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final String? currency = currencyToString(
        Provider.of<SharedPreferencesProvider>(context).getCurrency());

    final thisMonthSummary =
        Provider.of<RecordProvider>(context).getMonthSummary(DateTime.now()) ??
            CashFlowSummary(incomeSum: 0, cashFlow: 0, expenseSum: 0);

    final spentPercent = thisMonthSummary.incomeSum == 0
        ? 1.0
        : min(
            -1 * thisMonthSummary.expenseSum / thisMonthSummary.incomeSum, 1.0);

    final bool noRecords = thisMonthSummary.cashFlow == 0 &&
        thisMonthSummary.expenseSum == 0 &&
        thisMonthSummary.incomeSum == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ButtonWrapper(
        inverse: thisMonthSummary.cashFlow < 0,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              SearchRecordScreen.routeName,
              arguments: [
                SearchType.monthSummary,
                DateTime.now(),
              ],
            );
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FittedBox(
                  child: Text(
                    "${DateTimeUtil.months[DateTime.now().month]}'s Cash Flow: ${thisMonthSummary.cashFlow} $currency",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (noRecords)
                  Center(
                    child: Text("No records for this month!",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                if (!noRecords)
                  FittedBox(
                    child: LinearPercentIndicator(
                      width: 150.0,
                      animation: true,
                      barRadius: const Radius.circular(20),
                      animationDuration: 1000,
                      lineHeight: 20.0,
                      leading: Column(
                        children: [
                          Text(
                            "Expenses",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "${-1 * thisMonthSummary.expenseSum} $currency",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      trailing: Column(
                        children: [
                          Text(
                            "Income",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "${thisMonthSummary.incomeSum} $currency",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      percent: spentPercent,
                      center: Text(
                        "Spent ${(spentPercent * 100).round()}%",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      progressColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
