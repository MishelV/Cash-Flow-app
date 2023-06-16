import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:io';
import 'dart:convert';

const String googleDriveFileName = 'CashFlowBackup.csv';

final googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/drive.file',
  ],
);

Future<bool> backupFileToDrive(String filePath) async {
  final accessToken = await authenticateWithGoogle();
  if (accessToken.isNotEmpty) {
    // Access token obtained successfully, proceed with API calls
    // Save the access token securely or use it as needed
    print('--- Access token: $accessToken');
  } else {
    // Handle authentication error
    print('--- Authentication failed.');
    return false;
  }

  try {
    final file = File(filePath);
    final fileContent = await file.readAsBytes();

    final uploadUrl =
        'https://www.googleapis.com/upload/drive/v3/files?uploadType=media'
        '&name=${Uri.encodeQueryComponent(googleDriveFileName)}';

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/octet-stream',
      'Content-Length': fileContent.length.toString(),
    };

    final request = Uri.parse(uploadUrl);
    final response = await http.post(
      request.replace(queryParameters: {'name': googleDriveFileName}),
      headers: headers,
      body: fileContent,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final fileId = responseBody['id'];

      // Update the file metadata to set the desired filename
      final updateUrl = 'https://www.googleapis.com/drive/v3/files/$fileId';
      final updateHeaders = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      final updateBody = jsonEncode({'name': googleDriveFileName});

      final updateResponse = await http.patch(Uri.parse(updateUrl),
          headers: updateHeaders, body: updateBody);

      if (updateResponse.statusCode == 200) {
        print(
            '--- File uploaded successfully with the desired filename: $googleDriveFileName');
        return true;
      } else {
        print(
            '--- Error updating file metadata. Status code: ${updateResponse.statusCode}');
        return false;
      }
    } else {
      print(
          '--- Error uploading file to Google Drive. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('--- Error uploading file to Google Drive: $e');
    return false;
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
