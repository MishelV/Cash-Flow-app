import 'package:flutter/material.dart';

import '../models/month_report_card.dart';
import '../models/search_type.dart';
import '../screens/search_record_screen.dart';
import 'button_wrapper.dart';

class MonthReportCard extends StatelessWidget {
  MonthReportModel report;

  MonthReportCard({Key? key, required this.report}) : super(key: key);

  Widget titleText(BuildContext context) {
    final title = "${report.date.month} / ${report.date.year}";
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(color: Colors.black, fontSize: 20));
  }

  Widget NoRecrdsText(BuildContext context) {
    return Text("No records!", style: Theme.of(context).textTheme.headline3);
  }

  Widget cashFlowText(BuildContext context) {
    if (report.summary == null) return NoRecrdsText(context);

    final posiviteSign = report.summary!.cashFlow > 0 ? "+" : "";
    final cashFlowText = "$posiviteSign${report.summary!.cashFlow} \$";

    return Text(
      cashFlowText,
      style: Theme.of(context).textTheme.headline4?.copyWith(
            color: report.summary!.cashFlow < 0
                ? Theme.of(context).colorScheme.inversePrimary
                : report.summary!.cashFlow > 0
                    ? Theme.of(context).colorScheme.primary
                    : null,
          ),
    );
  }

  Widget cashFlowDetailsText(BuildContext context) {
    final cashFlowDetails = report.summary == null
        ? ""
        : """
Income: ${report.summary!.incomeSum}
Expense: ${report.summary!.expenseSum}
""";
    return Text(
      cashFlowDetails,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ButtonWrapper(
        inverse: report.summary != null && report.summary!.cashFlow < 0,
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
                titleText(context),
                SizedBox(
                  height: 5,
                ),
                cashFlowText(context),
                SizedBox(
                  height: 5,
                ),
                cashFlowDetailsText(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
