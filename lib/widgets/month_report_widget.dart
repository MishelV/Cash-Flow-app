import 'package:flutter/material.dart';

import '../models/month_report_card.dart';
import '../models/search_type.dart';
import '../screens/search_record_screen.dart';
import 'button_wrapper.dart';

class MonthReportCard extends StatelessWidget {
  MonthReportModel report;

  MonthReportCard({Key? key, required this.report}) : super(key: key);

  String get title {
    return "${report.date.month} / ${report.date.year}";
  }

  String get cashFlow {
    final posiviteSign = report.summary.cashFlow > 0 ? "+" : "";
    return "$posiviteSign${report.summary.cashFlow} \$";
  }

  String get cashFlowDetails {
    return """
Income: ${report.summary.incomeSum}
Expense: ${report.summary.expenseSum}
""";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ButtonWrapper(
        inverse: report.summary.cashFlow < 0,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              SearchRecordScreen.routeName,
              arguments: [
                SearchType.monthSummary,
                report.date,
              ],
            );
          },
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  cashFlow,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: report.summary.cashFlow < 0
                            ? Theme.of(context).colorScheme.inversePrimary
                            : report.summary.cashFlow > 0
                                ? Theme.of(context).colorScheme.primary
                                : null,
                      ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  cashFlowDetails,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
