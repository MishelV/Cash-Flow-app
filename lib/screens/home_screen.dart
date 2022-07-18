import 'package:cash_flow_app/widgets/actions_widget.dart';
import 'package:cash_flow_app/widgets/hello_widget.dart';
import 'package:cash_flow_app/widgets/rotating_app_logo.dart';
import 'package:cash_flow_app/widgets/this_month_summary.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    final rotatingLogo = RotatingAppLogo();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 220,
            child: rotatingLogo,
          ),
          Text(
            "Cash Flow.",
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(
            height: 10,
          ),
          // const HelloWidget(userName: "There"),
          Center(
            child: ActionsWidget(beforeAction: () {
              rotatingLogo.stopAnimation();
            }, afterAction: () {
              rotatingLogo.continueAnimation();
            }),
          ),

          const Center(
            child: ThisMonthSummary(),
          ),
          const SizedBox(
            height: 1,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
