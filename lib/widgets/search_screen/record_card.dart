import 'package:cash_flow_app/models/record.dart';
import 'package:cash_flow_app/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/shared_preferences_model.dart';
import '../../providers/shared_preferences_provider.dart';

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

  Color? _getIconColor() {
    return widget.record.value < 0 ? Colors.white : null;
  }

  TextStyle? _getTextStyle() {
    return widget.record.value > 0
        ? Theme.of(context).textTheme.bodyText1
        : Theme.of(context).textTheme.bodyText2;
  }

  TextStyle? _getSmallerTextStyle() {
    TextStyle? style = widget.record.value > 0
        ? Theme.of(context).textTheme.bodyText1
        : Theme.of(context).textTheme.bodyText2;

    if (style != null) {
      return TextStyle(
        fontSize: style.fontSize! - 2.0,
        fontWeight: style.fontWeight,
        fontFamily: style.fontFamily,
        color: style.color,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String? currency = currencyToString(
        Provider.of<SharedPreferencesProvider>(context).getCurrency());

    Color c = widget.record.value > 0
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.inversePrimary;
    return SizedBox(
      child: Card(
        margin: const EdgeInsets.all(7),
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
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
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
                        style: _getSmallerTextStyle(),
                      ),
                    Text(
                      DateTimeUtil.getFormattedDateStringFromString(
                          widget.record.startDate),
                      style: _getSmallerTextStyle(),
                    ),
                  ],
                ),
              ),
              leading: SizedBox(
                height: 40,
                child: Text(
                  "${widget.record.value} $currency",
                  style: _getTextStyle(),
                ),
              ),
              trailing: SizedBox(
                height: 40,
                width: 40,
                child: IconButton(
                  icon: Icon(
                    Icons.edit_sharp,
                    color: _getIconColor(),
                  ),
                  onPressed: () {
                    widget.editRecord(widget.record, context);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
