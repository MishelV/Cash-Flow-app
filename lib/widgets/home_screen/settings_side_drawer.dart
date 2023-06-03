import 'package:cash_flow_app/widgets/home_screen/currency_selection_dialog.dart';
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
            actions: <Widget>[Container()],
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
            title: Text('Check out the app\'s code! 👨🏻‍💻'),
            onTap: openGitHubProject,
          ),
          const Divider(),
          const ListTile(
            title: Text('Buy the developer a coffee! ☕'),
            onTap: openBuyMeCoffee,
          ),
          const Divider(),
          const ListTile(
            title: Text('Privacy Policy 🔒'),
            onTap: openPrivacyPolicy,
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
    throw "Could not launch $url";
  }
}

void openBuyMeCoffee() async {
  const url = "https://www.buymeacoffee.com/VeksApps";
  final Uri _url = Uri.parse(url);

  if (await canLaunchUrl(_url)) {
    await launchUrl(_url, mode: LaunchMode.externalApplication);
  } else {
    throw "Could not launch $url";
  }
}

void openPrivacyPolicy() async {
  const url =
      "https://github.com/MishelV/Cash-Flow-app/blob/main/privacy_policy.txt";
  final Uri _url = Uri.parse(url);

  if (await canLaunchUrl(_url)) {
    await launchUrl(_url, mode: LaunchMode.externalApplication);
  } else {
    throw "Could not launch $url";
  }
}
