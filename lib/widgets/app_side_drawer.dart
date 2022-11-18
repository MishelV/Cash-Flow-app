import 'package:cash_flow_app/widgets/currency_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          const ListTile(
            title: const Text('Check out the app\'s code! 👨🏻‍💻'),
            onTap: openGitHubProject,
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

void openGitHubProject() async {
  const url = "https://github.com/MishelV/Cash-Flow-app";
  final Uri _url = Uri.parse(url);

  if (await canLaunchUrl(_url)) {
    await launchUrl(_url, mode: LaunchMode.externalApplication);
  } else {
    print("pp AAAAAAA");
  }
}
