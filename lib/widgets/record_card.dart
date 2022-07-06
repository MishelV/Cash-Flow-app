import 'package:cash_flow_app/models/record.dart';
import 'package:cash_flow_app/utils/date_time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordCard extends StatefulWidget {
  final Record record;
  final Function editRecord;

  const RecordCard({Key? key, required this.record, required this.editRecord})
      : super(key: key);

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  bool _expanded = false;

  TextStyle? _getTextStyle() {
    return widget.record.value > 0
        ? Theme.of(context).textTheme.bodyText1
        : Theme.of(context).textTheme.bodyText2;
  }

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
            widget.editRecord(widget.record, context);
          },
          child: SizedBox(
            height: _expanded ? 120 : 70,
            child: ListTile(
              title: SizedBox(
                height: 20,
                child: FittedBox(
                  child: Text(widget.record.name, style: _getTextStyle()),
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
                        style: _getTextStyle(),
                      ),
                    Text(
                      DateTimeUtil.getDateString(widget.record.startDate),
                      style: _getTextStyle(),
                    ),
                  ],
                ),
              ),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${widget.record.value} ₪",
                    style: _getTextStyle(),
                  ),
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
