import 'package:cash_flow_app/models/record.dart';
import 'package:cash_flow_app/screens/edit_record_screen.dart';
import 'package:cash_flow_app/screens/search_record_screen.dart';
import 'package:flutter/material.dart';

import '../models/search_type.dart';

class ActionsWidget extends StatelessWidget {
  const ActionsWidget({Key? key}) : super(key: key);

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
            ),
            ActionButton(
              icon: const Icon(Icons.search),
              buttonName: "Lookup Record",
              route: SearchRecordScreen.routeName,
              arguments: const [
                SearchType.recordLookup,
              ],
            ),
            ActionButton(
              icon: const Icon(Icons.payment),
              buttonName: "Upcoming Expenses",
              route: SearchRecordScreen.routeName,
              arguments: const [
                SearchType.upcomingExpenses,
              ],
            ),
            ActionButton(
              icon: const Icon(Icons.summarize_outlined),
              buttonName: "Monthly Summary",
              route: SearchRecordScreen.routeName,
              arguments: const [
                SearchType.thisMonthSummary,
              ],
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
  Object? arguments;

  ActionButton({
    required this.icon,
    required this.buttonName,
    required this.route,
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
                Navigator.of(context).pushNamed(route, arguments: arguments);
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
