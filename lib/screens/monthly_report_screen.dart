import 'package:cash_flow_app/models/cash_flow_summary.dart';
import 'package:cash_flow_app/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/month_report_card.dart';
import '../models/search_type.dart';
import '../providers/record_provider.dart';
import 'search_record_screen.dart';

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
        body: Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: null, child: Text("Choose month")),
                  TextButton(onPressed: null, child: Text("Choose year"))
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 8 / 9,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: orderedMonthReportCards.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return MonthReportCard(
                          report: orderedMonthReportCards[index]);
                    }),
              ),
            ),
            SizedBox(
                height: 60,
                child: TextButton(
                    onPressed: add4Months, child: Text("Load more!")))
          ],
        ));
  }
}

class MonthReportCard extends StatelessWidget {
  MonthReportModel report;

  MonthReportCard({Key? key, required this.report}) : super(key: key);

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
          child: Text(report.date.toString()),
        ),
      ),
    );
  }
}
