import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/month_report_card.dart';
import '../providers/record_provider.dart';
import '../widgets/monthly_report_screen/month_report_card_widget.dart';

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({Key? key}) : super(key: key);

  static const routeName = "/monthly_summary_screen";

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  List<MonthReportModel> orderedMonthReportCards = [];
  var _isInit = true;
  var _isLoading = false;

  void setReportCard(int numberOfMonths) async {
    orderedMonthReportCards =
        await Provider.of<RecordProvider>(context, listen: false)
            .getMonthReportList(
                from: DateTime.now(), numberOfMonths: numberOfMonths)
            .whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void updateReportCards() {
    setReportCard(orderedMonthReportCards.length);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      _isInit = false;
      setReportCard(6);
    }
  }

  void add4Months() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<RecordProvider>(context, listen: false)
        .getMonthReportList(
            from: orderedMonthReportCards.last.date, numberOfMonths: 4)
        .then((newReports) {
      setState(() {
        _isLoading = false;
        orderedMonthReportCards.addAll(newReports);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            child: Text(
              "Previous Months",
            ),
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
        body: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 8 / 8,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: orderedMonthReportCards.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return MonthReportCard(
                                report: orderedMonthReportCards[index],
                                tapCallback: updateReportCards);
                          }),
                    ),
                  ),
                ],
              ));
  }
}
