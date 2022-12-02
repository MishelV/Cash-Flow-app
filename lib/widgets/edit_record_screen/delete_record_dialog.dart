import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/record_provider.dart';
import '../general/button_wrapper.dart';

Future<bool> deleteRecordDialog(
    String recordId, String recordName, BuildContext context) async {
  bool didDeleteRecord = false;
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("What??"),
      content: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Text(
                "Are you sure you wish to delete the record of '$recordName'?",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ButtonWrapper(
          height: 50,
          child: TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Text(
              "Abort!",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
        ButtonWrapper(
          height: 50,
          inverse: true,
          child: TextButton(
            onPressed: () {
              Provider.of<RecordProvider>(context, listen: false)
                  .removeRecordById(recordId);
              Navigator.of(ctx).pop();
              didDeleteRecord = true;
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Text(
              "Delete!",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        )
      ],
    ),
  );
  return Future.value(didDeleteRecord);
}
