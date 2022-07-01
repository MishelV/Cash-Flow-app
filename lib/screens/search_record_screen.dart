import 'package:cash_flow_app/models/cash_flow_summary.dart';
import 'package:cash_flow_app/models/record.dart';
import 'package:cash_flow_app/providers/record_provider.dart';
import 'package:cash_flow_app/screens/edit_record_screen.dart';
import 'package:cash_flow_app/utils/date_time_util.dart';
import 'package:cash_flow_app/widgets/button_wrapper.dart';
import 'package:cash_flow_app/widgets/record_card.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';

import '../widgets/cash_flow_summary.dart';
import '../widgets/delete_record_dialog.dart';

class SearchRecordScreen extends StatefulWidget {
  const SearchRecordScreen({Key? key}) : super(key: key);

  static const routeName = '/search-record';

  @override
  State<SearchRecordScreen> createState() => _SearchRecordScreenState();
}

class _SearchRecordScreenState extends State<SearchRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Record> _records = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime(DateTime.now().year + 1);
  String _keyword = "";
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final yearMonth =
          ModalRoute.of(context)?.settings.arguments as List<int>?;
      if (yearMonth != null) {
        setState(() {
          _startDate = DateTime(yearMonth[0], yearMonth[1]);
          _endDate = _startDate.add(const Duration(days: 30));
        });
      }
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
    setRecords();
  }

  void setRecords() {
    if (FocusManager.instance.primaryFocus != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }

    // final isValid = _formKey.currentState?.validate();
    // if (isValid == null || !isValid) {
    //   return;
    // }
    // _formKey.currentState!.save();
    setState(() {
      _records = Provider.of<RecordProvider>(context, listen: false)
          .getRecordsFromTimeFrameByKeyword(_keyword, _startDate, _endDate);
      _records.sort(
        (a, b) => a.startDate.compareTo(b.startDate),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cashFlow = Provider.of<RecordProvider>(context, listen: false)
        .getCashFlowSummary(_records);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Lookup Record"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditRecordScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Container(
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
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: "",
                        decoration: const InputDecoration(
                          labelText: "Keyword (Optional)",
                          border: UnderlineInputBorder(),
                          enabledBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _keyword = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 80,
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        initialValue: _startDate.toString(),
                        firstDate: DateTime(DateTime.now().year - 10),
                        lastDate: _endDate,
                        dateMask: "dd/MM/yyyy",
                        dateLabelText: 'Start Date',
                        onSaved: (val) {
                          if (val != null) {
                            setState(() {
                              _startDate = DateTimeUtil.getDateTime(val);
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 80,
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        initialValue: _endDate.toString(),
                        firstDate: _startDate,
                        lastDate: DateTime(DateTime.now().year + 10),
                        dateMask: "dd/MM/yyyy",
                        dateLabelText: 'End Date',
                        onSaved: (val) {
                          if (val != null) {
                            setState(() {
                              _endDate = DateTimeUtil.getDateTime(val);
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ButtonWrapper(
                      width: 50,
                      height: 50,
                      child: TextButton(
                        onPressed: setRecords,
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
              ),
            ),
            SizedBox(
              width: 28,
            ),
            if (_records.isNotEmpty)
              SizedBox(
                width: 300,
                height: 400,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    final record = _records.elementAt(index);
                    return RecordCard(
                        record: record, deleteRecord: deleteRecord);
                  },
                  itemCount: _records.length,
                ),
              ),
            if (_records.isNotEmpty)
              CashFlowSummaryWidget(
                cashFlow: cashFlow,
              ),
            if (_records.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Text(
                    "No records to show!",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 180,
                    child: Image.asset(
                      'assets/images/dollar.gif',
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
