import 'package:cash_flow_app/helpers/sqlite_db_helper.dart';
import 'package:cash_flow_app/widgets/general/information_dialog.dart';
import 'package:cash_flow_app/widgets/home_screen/currency_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:restart_app/restart_app.dart';

import '../../helpers/google_drive_helper.dart';
import '../../models/import_records_models.dart';

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
          const Divider(),
          const ImportButton(),
          const Divider(),
          const ExportButton(),
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

class ImportButton extends StatelessWidget {
  const ImportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text('Import Records'),
        onTap: () {
          try {
            downloadFileFromDrive().then((filePath) {
              if (filePath.isNotEmpty) {
                SQFLiteDBHelper()
                    .importTableFromCSV(ImportOption.overrideTable,
                        fileDownloadPath: filePath)
                    .then((result) {
                  if (result == ImportStatus.success) {
                    showInformationDialog(
                        context,
                        "Records were imported successfully!"
                        "Please restart the app for it to work properly.",
                        buttonText: "Let's restart the App!", onDismiss: () {
                      Restart.restartApp();
                    });
                  } else {
                    showErrorDialog(
                        context,
                        "An error has occurred while importing the file."
                        "Please try again or contact us if the error persists.");
                  }
                });
              } else {}
            });
          } catch (e) {
            showErrorDialog(context, e.toString());
          }
        });
  }
}

class ExportButton extends StatelessWidget {
  const ExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Export Records'),
      onTap: () {
        SQFLiteDBHelper().exportTableToCSV().then((filePath) {
          if (filePath.isNotEmpty) {
            try {
              backupFileToDrive(filePath).then((sucess) {
                showInformationDialog(
                    context, "Records were exported successfully!");
              });
            } catch (e) {
              showErrorDialog(context, e.toString());
            }
          } else {
            showErrorDialog(
                context,
                "An error has occurred while exporting the records to a file."
                "Please try again or contact us if the error persists.");
          }
        });
      },
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
