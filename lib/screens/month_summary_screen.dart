import 'package:flutter/material.dart';

class MonthlySummaryScreen extends StatelessWidget {
  const MonthlySummaryScreen({Key? key}) : super(key: key);

  static const routeName = "/monthly_summary_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Monthly Summary",
          ),
        ),
        body: Center(
          child: Text(
            """
Here you'll see a grid of 12 months,
each with its cash flow. each tile is clickable,
and will lead to the search record screen
with the correct start and end dates
              """,
            style: Theme.of(context).textTheme.headline3,
          ),
        ));
  }
}
