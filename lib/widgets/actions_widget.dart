import 'package:cash_flow_app/models/record.dart';
import 'package:cash_flow_app/screens/edit_record_screen.dart';
import 'package:cash_flow_app/screens/month_summary_screen.dart';
import 'package:cash_flow_app/screens/search_record_screen.dart';
import 'package:flutter/material.dart';

import '../models/search_type.dart';

class ActionsWidget extends StatelessWidget {
  const ActionsWidget(
      {Key? key, required this.afterAction, required this.beforeAction})
      : super(key: key);

  final Function beforeAction;
  final Function afterAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            ActionButton(
              icon: const Icon(Icons.add),
              buttonName: "Add Record",
              route: EditRecordScreen.routeName,
              beforeAction: beforeAction,
              afterAction: afterAction,
            ),
            ActionButton(
              icon: const Icon(Icons.search),
              buttonName: "Search Record",
              route: SearchRecordScreen.routeName,
              beforeAction: beforeAction,
              afterAction: afterAction,
              arguments: const [
                SearchType.recordLookup,
              ],
            ),
            ActionButton(
              icon: const Icon(Icons.payment),
              buttonName: "Upcoming Expenses",
              route: SearchRecordScreen.routeName,
              beforeAction: beforeAction,
              afterAction: afterAction,
              arguments: const [
                SearchType.upcomingExpenses,
              ],
            ),
            ActionButton(
              icon: const Icon(Icons.summarize_outlined),
              buttonName: "Monthly Summary",
              route: MonthlySummaryScreen.routeName,
              beforeAction: beforeAction,
              afterAction: afterAction,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ActionButton extends StatelessWidget {
  final Icon icon;
  final String buttonName;
  final String route;
  final Function beforeAction;
  final Function afterAction;
  Object? arguments;

  ActionButton({
    required this.icon,
    required this.buttonName,
    required this.route,
    required this.beforeAction,
    required this.afterAction,
    this.arguments,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (route != "") {
                beforeAction();
                Navigator.of(context)
                    .pushNamed(route, arguments: arguments)
                    .then((_) {
                  afterAction();
                });
              }
            },
            child: icon,
            style: Theme.of(context).elevatedButtonTheme.style,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            buttonName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
