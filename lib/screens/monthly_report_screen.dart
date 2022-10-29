import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/month_report_card.dart';
import '../providers/record_provider.dart';
import '../widgets/month_report_widget.dart';

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({Key? key}) : super(key: key);

  static const routeName = "/monthly_summary_screen";

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  List<MonthReportModel> orderedMonthReportCards = [];
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
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Previous Months",
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: add4Months,
          child: Icon(
            Icons.arrow_downward,
            color: Theme.of(context).colorScheme.background,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 8 / 8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: orderedMonthReportCards.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return MonthReportCard(
                        report: orderedMonthReportCards[index]);
                  }),
            ),
          ],
        ));
  }
}
