import 'dart:math';

import 'package:cash_flow_app/providers/record_provider.dart';
import 'package:cash_flow_app/screens/search_record_screen.dart';
import 'package:cash_flow_app/utils/date_time_util.dart';
import 'package:cash_flow_app/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/search_type.dart';

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

    final thisMonthSummary =
        Provider.of<RecordProvider>(context).getMonthSummary(DateTime.now());
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                child: Text(
                  "${DateTimeUtil.months[DateTime.now().month - 1]}'s Cash Flow: ${thisMonthSummary.cashFlow} ₪",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (noRecords)
                Center(
                  child: Text("No records for this month!",
                      style: Theme.of(context).textTheme.bodyText1),
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
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          "${-1 * thisMonthSummary.expenseSum} ₪",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        Text(
                          "Income",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          "${thisMonthSummary.incomeSum} ₪",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    percent: spentPercent,
                    center: Text(
                      "Spent ${(spentPercent * 100).round()}%",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    progressColor: Theme.of(context).colorScheme.inversePrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
