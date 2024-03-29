import 'package:cash_flow_app/widgets/home_screen/actions_widget.dart';
import 'package:cash_flow_app/widgets/home_screen/rotating_app_logo.dart';
import 'package:cash_flow_app/widgets/home_screen/this_month_summary.dart';
import 'package:flutter/material.dart';

import '../widgets/home_screen/settings_side_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    final rotatingLogo = RotatingAppLogo();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppSideDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black12,
                ),
                child: IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(Icons.settings),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 210,
                      width: 210,
                      child: rotatingLogo,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 60,
              ),
            ],
          ),
          Text(
            "Cash Flow.",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(
            height: 10,
          ),
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
