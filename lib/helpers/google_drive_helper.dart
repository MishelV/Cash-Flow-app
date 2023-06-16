import 'package:cash_flow_app/helpers/sqlite_db_helper.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:io';
import 'dart:convert';

const String googleDriveFileName = 'CashFlowBackup.csv';

Future<String> authenticateWithGoogle() async {
  final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );

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

Future<void> backupFileToDrive(String filePath) async {
  final accessToken = await authenticateWithGoogle();
  if (accessToken.isEmpty) {
    throw "Authentication failed.";
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

      if (updateResponse.statusCode != 200) {
        throw 'Error updating file metadata. Status code: ${updateResponse.statusCode}';
      }
    } else {
      throw 'Error uploading file to Google Drive. Status code: ${response.statusCode}';
    }
  } catch (e) {
    throw 'Error uploading file to Google Drive: $e';
  }
}

Future<String> downloadFileFromDrive() async {
  final accessToken = await authenticateWithGoogle();
  if (accessToken.isEmpty) {
    throw "Authentication failed.";
  }

  try {
    // Search for the file by name
    final searchUrl = 'https://www.googleapis.com/drive/v3/files?'
        'q=name="${Uri.encodeQueryComponent(googleDriveFileName)}"';
    final searchHeaders = {'Authorization': 'Bearer $accessToken'};

    final searchResponse =
        await http.get(Uri.parse(searchUrl), headers: searchHeaders);

    if (searchResponse.statusCode == 200) {
      final searchResults = searchResponse.body;
      final searchResultsJson = jsonDecode(searchResults);

      if (searchResultsJson['files'] != null &&
          searchResultsJson['files'].isNotEmpty) {
        // Get the file ID of the first matching file
        final fileId = searchResultsJson['files'][0]['id'];

        // Download the file content
        final downloadUrl =
            'https://www.googleapis.com/drive/v3/files/$fileId?alt=media';
        final downloadHeaders = {'Authorization': 'Bearer $accessToken'};

        final response =
            await http.get(Uri.parse(downloadUrl), headers: downloadHeaders);

        if (response.statusCode == 200) {
          final filePath = await SQFLiteDBHelper.filePath();

          // Save the downloaded content to a file
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          return filePath;
        } else {
          throw 'Error downloading file from Google Drive. Status code: ${response.statusCode}';
        }
      } else {
        throw 'File not found in Google Drive.';
      }
    } else {
      throw 'Error searching for the file in Google Drive. Status code: ${searchResponse.statusCode}';
    }
  } catch (e) {
    throw 'Error downloading file from Google Drive: $e';
  }
}
