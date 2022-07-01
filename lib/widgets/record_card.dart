import 'package:cash_flow_app/models/record.dart';
import 'package:cash_flow_app/utils/date_time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordCard extends StatefulWidget {
  final Record record;
  final Function deleteRecord;

  const RecordCard({Key? key, required this.record, required this.deleteRecord})
      : super(key: key);

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  bool _expanded = false;

  Widget build(BuildContext context) {
    Color c = widget.record.value > 0
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.inversePrimary;
    return SizedBox(
      child: Card(
        margin: EdgeInsets.all(7),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        color: c,
        shadowColor: c,
        child: GestureDetector(
          onLongPress: () {
            widget.deleteRecord(widget.record, context);
          },
          child: SizedBox(
            height: _expanded ? 120 : 70,
            child: ListTile(
              title: SizedBox(
                height: 20,
                child: FittedBox(
                  child: Text(
                    widget.record.name,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              subtitle: SizedBox(
                height: _expanded ? 100 : 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_expanded)
                      Text(
                        widget.record.description.isEmpty
                            ? "No description."
                            : widget.record.description,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    Text(
                      DateTimeUtil.getDateString(widget.record.startDate),
                    ),
                  ],
                ),
              ),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${widget.record.value} ₪"),
                  if (widget.record.repeatDays != 0)
                    Icon(
                      Icons.repeat,
                    ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
