import 'package:cash_flow_app/widgets/currency_selection_dialog.dart';
import 'package:flutter/material.dart';

class AppSideDrawer extends StatelessWidget {
  const AppSideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Settings'),
            automaticallyImplyLeading:
                false, // this will hide Drawer hamburger icon
            actions: <Widget>[
              Container()
            ], // this will hide endDrawer hamburger icon
          ),
          const Divider(),
          ListTile(
            title: const Text('Preferred Currency Icon'),
            onTap: () {
              currencySelectionDialog(context);
            },
          ),
          const Expanded(
            child: SizedBox(
              height: 100,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Check out the app\'s code! 👨🏻‍💻'),
            onTap: () {
              //TODO: implement a referal link to github repo
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Buy the developer a coffee! ☕'),
            onTap: () {
              //TODO: implement a referal link to "buy me coffee" donation.
            },
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
