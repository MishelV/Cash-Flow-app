import 'package:cash_flow_app/models/record.dart';
import 'package:cash_flow_app/providers/record_provider.dart';
import 'package:cash_flow_app/widgets/button_wrapper.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/date_time_util.dart';

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
  String? _startDate =
      DateFormat(DateTimeUtil.DATE_FORMAT).format(DateTime.now());
  String? _endDate = null;
  String? _name = "";
  int _recurenceInDays = 0;
  int _sign = 0;
  int _value = 0;
  String _description = '';
  bool _isLoading = false;
  bool _recurring = false;
  bool _isCustomRecurrence = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit && (ModalRoute.of(context) != null)) {
      final recordId = ModalRoute.of(context)!.settings.arguments as String;
      if (recordId.isNotEmpty) {
        Record? record = Provider.of<RecordProvider>(context, listen: false)
            .getRecordById(recordId);
        if (record != null) {
          setState(() {
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

    if (_startDate == null ||
        (_recurring && _recurenceInDays == 0) ||
        _value == 0) {
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
    setState(() {
      _isLoading = true;
    });

    final newRecord = Record(
      name: _name!,
      value: _value * _sign,
      id: _id,
      startDate: _startDate!,
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

    setState(() {
      _isLoading = false;
    });
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
                _formKey.currentState!.reset();
                setState(() {
                  _startDate = DateTime.now().toString();
                  _recurenceInDays = 0;
                  _isLoading = false;
                  _isCustomRecurrence = false;
                });
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
        title: const Text(
          "Edit Record",
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please add record name!';
                    }
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
                  validator: (value) {},
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
                            ? ""
                            : _sign == 1
                                ? "Income"
                                : "Expense",
                        hint: const Text(
                          "Record Type",
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            child: Container(
                              child: const Text("Expense"),
                            ),
                            value: "Expense",
                          ),
                          DropdownMenuItem<String>(
                            child: Container(
                              child: const Text("Income"),
                            ),
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
                  initialValue: _value.toString(),
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "0") {
                      return 'Please add record value!';
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Value of the Record",
                    border: UnderlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value != null || value == "") {
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
                    _startDate = val;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Is the transaction recurring?",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Checkbox(
                      checkColor: Theme.of(context).colorScheme.onPrimary,
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: _recurring,
                      onChanged: (val) {
                        setState(
                          () {
                            _recurring = val!;
                          },
                        );
                      },
                    ),
                  ],
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
                    value: _isCustomRecurrence ? "Custom" : "",
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
                          child: Container(
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
                    // The validator receives the text that the user has entered.
                    initialValue: _recurenceInDays.toString(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please add custom recurrence!';
                      }
                      try {
                        _recurenceInDays = value != null ? int.parse(value) : 0;
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
                      if (value != null || value == "") {
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
                if (!_recurring)
                  const SizedBox(
                    height: 108,
                  ),
                const SizedBox(
                  height: 10,
                ),
                ButtonWrapper(
                  width: 150,
                  height: 50,
                  child: TextButton(
                    onPressed: _saveForm,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "Submit!",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
