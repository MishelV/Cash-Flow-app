import 'package:cash_flow_app/models/cash_flow_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/month_report_card.dart';
import '../providers/record_provider.dart';

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({Key? key}) : super(key: key);

  static const routeName = "/monthly_summary_screen";

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  List<MonthReportCard> orderedMonthReportCards = [];
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      orderedMonthReportCards =
          Provider.of<RecordProvider>(context, listen: false)
              .getMonthReportList(from: DateTime.now(), numberOfMonths: 6);
      _isInit = false;
    }
  }

  void add4Months() {
    setState(() {
      orderedMonthReportCards.addAll(
          Provider.of<RecordProvider>(context, listen: false)
              .getMonthReportList(
                  from: orderedMonthReportCards.last.date, numberOfMonths: 4));
    });
  }

  @override
  Widget build(BuildContext context) {
    print("AAAA Rebuilding!");
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Previous Months Report",
          ),
        ),
        body: Column(
          children: [
            Center(
              child: Text(
                """
Here you'll see a grid of 12 months,
each with its cash flow. each tile is clickable,
and will lead to the search record screen
with the correct start and end dates
                  """,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            TextButton(onPressed: add4Months, child: Text("add 4 months"))
          ],
        ));
  }
}
