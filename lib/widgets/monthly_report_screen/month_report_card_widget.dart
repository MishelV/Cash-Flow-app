import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/month_report_card.dart';
import '../../models/search_type.dart';
import '../../models/shared_preferences_model.dart';
import '../../providers/shared_preferences_provider.dart';
import '../../screens/search_record_screen.dart';
import '../general/button_wrapper.dart';

class MonthReportCard extends StatelessWidget {
  final MonthReportModel report;
  final Function tapCallback;

  const MonthReportCard(
      {Key? key, required this.report, required this.tapCallback})
      : super(key: key);

  Widget titleText(BuildContext context) {
    final title = "${report.date.month} / ${report.date.year}";
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.black, fontSize: 20));
  }

  Widget noRecrdsText(BuildContext context) {
    return Text("No records!", style: Theme.of(context).textTheme.displaySmall);
  }

  Widget cashFlowText(BuildContext context) {
    if (report.summary == null) return noRecrdsText(context);

    final String? currency = currencyToString(
        Provider.of<SharedPreferencesProvider>(context).getCurrency());

    final posiviteSign = report.summary!.cashFlow > 0 ? "+" : "";
    final cashFlowText = "$posiviteSign${report.summary!.cashFlow} $currency";

    return Text(
      cashFlowText,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 13),
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
            ).then((_) {
              tapCallback();
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: titleText(context)),
              const SizedBox(
                height: 5,
              ),
              Flexible(child: cashFlowText(context)),
              const SizedBox(
                height: 5,
              ),
              Flexible(child: cashFlowDetailsText(context))
            ],
          ),
        ),
      ),
    );
  }
}
