import 'package:cash_flow_app/helpers/sqlite_db_helper.dart';
import 'package:cash_flow_app/widgets/general/information_dialog.dart';
import 'package:cash_flow_app/widgets/home_screen/currency_selection_dialog.dart';
import 'package:flutter/material.dart';
// import 'package:googleapis/people/v1.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:restart_app/restart_app.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:googleapis/drive/v3.dart' as drive;
// import "package:googleapis_auth/auth_io.dart" as google_auth;

import '../../models/import_records_models.dart';

final googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/drive.file',
  ],
);

// Future<void> backupFileToDrive(String filePath) async {
//   try {
//     final GoogleSignInAccount? account = await googleSignIn.signIn();
//     final authHeaders = await account!.authHeaders;
//     final authenticateClient = google_auth.authenticatedClient(baseClient, credentials)
//     final driveApi = drive.DriveApi(authenticateClient);

//     final file = drive.File();
//     file.name = 'backup.csv'; // Specify the desired file name

//     final uploadMedia = drive.Media(
//       http.StreamedMedia(
//         http.ByteStream(file.openRead()),
//         await file.length(),
//         contentType: drive.FileImageMediaType,
//       ),
//     );

//     final result = await driveApi.files.create(file, uploadMedia: uploadMedia);
//     print('File uploaded successfully. File ID: ${result.id}');
//   } catch (e) {
//     print('Error uploading file to Google Drive: $e');
//   }
// }

String ACCESS_TOKEN =
    '<YOUR_ACCESS_TOKEN>'; // Replace with the obtained access token
String FILE_PATH =
    '<YOUR_FILE_PATH>'; // Replace with the local path to the file
const String fileName =
    'CashFlowBackup.csv'; // Replace with the desired name for the file

Future<void> backupFileToDrive() async {
  try {
    final file = File(FILE_PATH);
    final fileContent = await file.readAsBytes();

    final uploadUrl =
        'https://www.googleapis.com/upload/drive/v3/files?uploadType=media&name=${Uri.encodeQueryComponent(fileName)}';

    final headers = {
      'Authorization': 'Bearer $ACCESS_TOKEN',
      'Content-Type': 'application/octet-stream',
      'Content-Length': fileContent.length.toString(),
    };

    final request = Uri.parse(uploadUrl);
    final response = await http.post(
      request.replace(queryParameters: {'name': fileName}),
      headers: headers,
      body: fileContent,
    );

    if (response.statusCode == 200) {
      print('--- File uploaded successfully.');
    } else {
      print(
          '--- Error uploading file to Google Drive. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('--- Error uploading file to Google Drive: $e');
  }
}

Future<String> authenticateWithGoogle() async {
  try {
    // Prompt the user to select a Google account
    final GoogleSignInAccount? account = await googleSignIn.signIn();

    // Retrieve the authentication token
    final GoogleSignInAuthentication authentication =
        await account!.authentication;
    final String accessToken = authentication.accessToken ?? '';

    return accessToken;
  } catch (error) {
    print('--- Google authentication error: $error');
    return '';
  }
}

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
          const Divider(),
          ElevatedButton(
            onPressed: () async {
              authenticateWithGoogle().then((accessToken) {
                if (accessToken.isNotEmpty) {
                  // Access token obtained successfully, proceed with API calls
                  // Save the access token securely or use it as needed
                  ACCESS_TOKEN = accessToken;
                  print('--- Access token: $accessToken');
                } else {
                  // Handle authentication error
                  print('--- Authentication failed.');
                }
              });
            },
            child: const Text('Sync with Google Drive'),
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

class ImportButton extends StatelessWidget {
  const ImportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Import Records'),
      onTap: () {
        SQFLiteDBHelper()
            .importTableFromCSV(ImportOption.overrideTable)
            .then((result) {
          if (result == ImportStatus.success) {
            showInformationDialog(context,
                "Records were imported successfully! Please restart the app for it to work properly.",
                buttonText: "Let's restart the App!", onDismiss: () {
              Restart.restartApp();
            });
          } else {
            showErrorDialog(context,
                "An error has occurred while importing the file. Please try again or contact us if the error persists.");
          }
        });
      },
    );
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
            FILE_PATH = filePath;
            backupFileToDrive();
            showInformationDialog(
                context, "Records were exported successfully!");
          } else {
            showErrorDialog(context,
                "An error has occurred while exporting the records to a file. Please try again or contact us if the error persists.");
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
