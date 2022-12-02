import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../../models/filter_parameters.dart';
import '../../models/record.dart';
import '../../utils/date_time_util.dart';
import '../general/button_wrapper.dart';

class FilterRecordsWidget extends StatefulWidget {
  final FilterParameters parameters;
  final Function onTap;

  const FilterRecordsWidget(
      {super.key, required this.parameters, required this.onTap});

  @override
  State<FilterRecordsWidget> createState() => _FilterRecordsWidgetState();
}

class _FilterRecordsWidgetState extends State<FilterRecordsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          50,
        ),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            offset: Offset.fromDirection(1, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      height: 135,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 45,
                width: 170,
                child: TextFormField(
                  initialValue: "",
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Keyword (Optional)",
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.parameters.keyword = value;
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 45,
                width: 100,
                child: DropdownButtonFormField<String>(
                  isDense: true,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please pick the record type!";
                    }
                    return null;
                  },
                  hint: const Text("Type"),
                  items: ["All", "Income", "Expense"].map((recordType) {
                    return DropdownMenuItem<String>(
                      child: SizedBox(
                        height: 20,
                        child: Text(recordType),
                      ),
                      value: recordType,
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(
                        () {
                          if (val == "Expense") {
                            widget.parameters.type = RecordType.expense;
                          } else if (val == "Income") {
                            widget.parameters.type = RecordType.income;
                          } else {
                            widget.parameters.type = RecordType.all;
                          }
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 80,
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  initialValue: widget.parameters.startDate.toString(),
                  firstDate: DateTime(DateTime.now().year - 10),
                  lastDate: widget.parameters.endDate,
                  dateMask: "dd/MM/yyyy",
                  dateLabelText: 'Start Date',
                  onChanged: (val) {
                    setState(() {
                      widget.parameters.startDate =
                          DateTimeUtil.getDateWithTimeFromString(val);
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 80,
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  initialValue: widget.parameters.endDate.toString(),
                  firstDate: widget.parameters.startDate,
                  lastDate: DateTime(DateTime.now().year + 10),
                  dateMask: "dd/MM/yyyy",
                  dateLabelText: 'End Date',
                  onChanged: (val) {
                    setState(() {
                      widget.parameters.endDate =
                          DateTimeUtil.getDateWithTimeFromString(val);
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              ButtonWrapper(
                width: 50,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    widget.onTap(widget.parameters);
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Go!",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
