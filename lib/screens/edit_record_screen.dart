import 'package:cash_flow_app/models/record.dart';
import 'package:cash_flow_app/providers/record_provider.dart';
import 'package:cash_flow_app/widgets/button_wrapper.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../widgets/delete_record_dialog.dart';

class EditRecordScreen extends StatefulWidget {
  const EditRecordScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-record';

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  String _id = "record_" +
      DateTime(2022).difference(DateTime.now()).inMilliseconds.toString();
  String _startDate = DateTime.now().toString();
  String? _endDate;
  String? _name = "";
  int _recurenceInDays = 0;
  int _sign = 0;
  int _value = 0;
  String _description = '';
  bool _recurring = false;
  bool _isCustomRecurrence = false;
  bool _isInit = true;
  String _screenName = "Add Record";
  bool _editingExistingRecord = false;

  void deleteRecord() {
    deleteRecordDialog(_id, _name!, context).then(
      (didDeleteRecord) {
        if (didDeleteRecord) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit && (ModalRoute.of(context) != null)) {
      final recordId = ModalRoute.of(context)!.settings.arguments as String?;
      if (recordId != null && recordId.isNotEmpty) {
        Record? record = Provider.of<RecordProvider>(context, listen: false)
            .getRecordById(recordId);
        if (record != null) {
          setState(() {
            _screenName = "Edit Record";
            _id = record.id;
            _startDate = record.startDate;
            _endDate = record.endDate;
            _name = record.name;
            _recurenceInDays = record.repeatDays;
            _sign = record.value < 0 ? -1 : 1;
            _value = record.value * _sign;
            _description = record.description;
            _recurring = _recurenceInDays > 0;
            _isCustomRecurrence = true;
            _editingExistingRecord = true;
          });
        }
      }
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    if ((_recurring && _recurenceInDays == 0) || _value == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Please fill all the fields!",
            style: TextStyle(backgroundColor: Colors.red),
          ),
        ),
      );
      return;
    }
    _formKey.currentState!.save();

    final newRecord = Record(
      name: _name!,
      value: _value * _sign,
      id: _id,
      startDate: _startDate,
      endDate: _endDate ?? "",
      description: _description,
      repeatDays: _recurring ? _recurenceInDays : 0,
    );

    final recordProvider = Provider.of<RecordProvider>(context, listen: false);

    if (recordProvider.getRecordById(newRecord.id) != null) {
      recordProvider.replaceRecord(newRecord);
    } else {
      recordProvider.addRecord(newRecord);
    }

    FocusManager.instance.primaryFocus?.unfocus();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hurray!"),
        content: const Text("Your record was submitted."),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
              child: const Text("Go Back")),
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pushNamed(EditRecordScreen.routeName);
              },
              child: const Text("Submit another record!")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _screenName,
        ),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save_alt))
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextFormField(
                  initialValue: _name,
                  maxLines: 1,
                  maxLength: 15,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please add record name!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Record Name",
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: _description,
                  maxLength: 60,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLengthEnforcement:
                      MaxLengthEnforcement.truncateAfterCompositionEnds,
                  validator: (value) {
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Description (Optional)",
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isDense: true,
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please pick the record type!";
                          }
                          return null;
                        },
                        value: _sign == 0
                            ? null
                            : _sign == 1
                                ? "Income"
                                : "Expense",
                        hint: const Text(
                          "Record Type",
                        ),
                        items: const [
                          DropdownMenuItem<String>(
                            child: Text("Expense"),
                            value: "Expense",
                          ),
                          DropdownMenuItem<String>(
                            child: Text("Income"),
                            value: "Income",
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(
                              () {
                                if (val == "Expense") {
                                  _sign = -1;
                                } else {
                                  _sign = 1;
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: _value == 0 ? "" : _value.toString(),
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "0") {
                      return 'Please add a valid record value!';
                    } else if (value.contains(",") ||
                        value.contains(".") ||
                        value.contains(" ") ||
                        value.contains("-")) {
                      return "Value must be a valid natural number!";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Value of the Record",
                    border: UnderlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value != "") {
                      setState(
                        () {
                          try {
                            _value = int.parse(value);
                          }
                          // ignore: empty_catches
                          catch (_) {}
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  initialValue: _startDate,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(DateTime.now().year + 1),
                  dateMask: "dd/MM/yyyy",
                  dateLabelText: 'Record Date',
                  onSaved: (val) {
                    if (val != null) {
                      _startDate = val;
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                if (_recurring)
                  DropdownButtonFormField<String>(
                    isDense: true,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Please set type of record!";
                      }
                      return null;
                    },
                    value: _isCustomRecurrence ? "Custom" : null,
                    hint: !_isCustomRecurrence && _recurenceInDays == 0
                        ? const Text("Set Record Recurrence")
                        : _isCustomRecurrence
                            ? const Text("Custom")
                            : Text("Repeats every $_recurenceInDays days."),
                    items: [
                      "Daily",
                      "Weekly",
                      "Bi-weekly",
                      "Monthly",
                      "Yearly",
                      "Custom"
                    ].map(
                      (recurrence) {
                        return DropdownMenuItem<String>(
                          child: SizedBox(
                            height: 40,
                            child: recurrence == "Custom"
                                ? const Text("Custom")
                                : Text(recurrence),
                          ),
                          value: recurrence.toString(),
                        );
                      },
                    ).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(
                          () {
                            if (val == "Custom") {
                              _isCustomRecurrence = true;
                            } else {
                              _isCustomRecurrence = false;
                              if (val == "Daily") {
                                _recurenceInDays = 1;
                              } else if (val == "Weekly") {
                                _recurenceInDays = 7;
                              } else if (val == "Bi-weekly") {
                                _recurenceInDays = 14;
                              } else if (val == "Monthly") {
                                _recurenceInDays = 30;
                              } else if (val == "Yearly") {
                                _recurenceInDays = 365;
                              }
                            }
                          },
                        );
                      }
                    },
                  ),
                const SizedBox(
                  height: 15,
                ),
                if (_recurring && _isCustomRecurrence)
                  TextFormField(
                    initialValue: _recurenceInDays.toString(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please add custom recurrence!';
                      }
                      try {
                        _recurenceInDays = int.parse(value);
                        return null;
                      } catch (_) {
                        return 'Please add custom recurrence!';
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Recurrence in days",
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value == "") {
                        setState(() {
                          try {
                            _recurenceInDays = int.parse(value);
                          }
                          // ignore: empty_catches
                          catch (_) {}
                        });
                      }
                    },
                  ),
                if (_recurring)
                  DateTimePicker(
                    type: DateTimePickerType.date,
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2023),
                    dateMask: "dd/MM/yyyy",
                    dateLabelText: 'End Date (optional)',
                    onSaved: (val) {
                      _endDate = val;
                    },
                  ),
                const SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonWrapper(
                      width: 110,
                      height: 60,
                      child: TextButton(
                        onPressed: _saveForm,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                    if (_editingExistingRecord)
                      ButtonWrapper(
                        width: 110,
                        height: 60,
                        inverse: true,
                        child: TextButton(
                          onPressed: deleteRecord,
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            "Delete",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
