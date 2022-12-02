import 'package:cash_flow_app/models/record.dart';
import 'package:cash_flow_app/providers/record_provider.dart';
import 'package:cash_flow_app/screens/edit_record_screen.dart';
import 'package:cash_flow_app/utils/date_time_util.dart';
import 'package:cash_flow_app/widgets/button_wrapper.dart';
import 'package:cash_flow_app/widgets/record_card.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_type.dart';
import '../widgets/cash_flow_summary.dart';

class SearchRecordScreen extends StatefulWidget {
  const SearchRecordScreen({Key? key}) : super(key: key);

  static const routeName = '/search-record';

  @override
  State<SearchRecordScreen> createState() => _SearchRecordScreenState();
}

class _SearchRecordScreenState extends State<SearchRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Record> _records = [];
  var _startDate = DateTime.now();
  var _endDate = DateTime(DateTime.now().year + 1);
  var _keyword = "";
  var _recordType = RecordType.all;
  var _isInit = true;
  var _isLoading = true;
  var _screenName = "";

  void editRecord(Record record, BuildContext context) {
    final arguments = EditRecordAguments(recordId: record.id);
    Navigator.of(context)
        .pushNamed(EditRecordScreen.routeName, arguments: arguments)
        .then((_) {
      setRecords();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as List<Object>?;
      if (arguments != null && arguments.isNotEmpty) {
        final type = arguments[0] as SearchType;
        switch (type) {
          case SearchType.monthSummary:
            setState(() {
              final date = arguments[1] as DateTime;
              _startDate = DateTime(date.year, date.month);
              _endDate = date.month == 12
                  ? DateTime(date.year + 1, 1)
                  : DateTime(date.year, date.month + 1);
              _screenName = "Records Summary";
            });
            break;
          case SearchType.upcomingExpenses:
            setState(() {
              _startDate = DateTime.now();
              _endDate = _startDate.add(const Duration(days: 365));
              _recordType = RecordType.expense;
              _screenName = "Upcoming Expenses";
            });
            break;
          case SearchType.recordLookup:
          default:
            setState(() {
              _startDate = DateTime(DateTime.now().year);
              _endDate = DateTime(DateTime.now().year + 1);
              _screenName = "Search Record";
            });
            break;
        }
      }
    }
    setState(() {
      _isInit = false;
    });
    setRecords();
  }

  Future<void> setRecords() async {
    setState(() {
      _isLoading = true;
    });
    if (FocusManager.instance.primaryFocus != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }

    Provider.of<RecordProvider>(context, listen: false)
        .getRecordsFromTimeFrameByKeyword(
            _keyword, _startDate, _endDate, _recordType)
        .then((records) {
      setState(() {
        _records = records;
        _records.sort(
          // Reversed
          (a, b) => b.startDate.compareTo(a.startDate),
        );
        _isLoading = false;
      });
    });
  }

  void navigateToAddRecord() {
    final arguments =
        EditRecordAguments(customStartDate: _startDate.toString());
    Navigator.of(context)
        .pushNamed(EditRecordScreen.routeName, arguments: arguments)
        .then((_) {
      setRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cashFlow = Provider.of<RecordProvider>(context, listen: false)
        .getCashFlowSummary(_records);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: FittedBox(child: Text(_screenName)),
        actions: [
          IconButton(
              onPressed: navigateToAddRecord, icon: const Icon(Icons.add))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.grey),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: searchRecordWidget(context),
                  ),
                ),
                if (_records.isNotEmpty) recordsListWidget(),
                if (_records.isNotEmpty)
                  CashFlowSummaryWidget(
                    cashFlow: cashFlow,
                  ),
                if (_records.isEmpty) noRecordsWidget(context),
              ],
            ),
    );
  }

  Expanded recordsListWidget() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          final record = _records.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: RecordCard(record: record, editRecord: editRecord),
          );
        },
        itemCount: _records.length,
      ),
    );
  }

  Column noRecordsWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 150,
        ),
        Text(
          "No records to show!",
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(
          height: 180,
          child: Image.asset(
            'assets/images/free_money.png',
          ),
        ),
      ],
    );
  }

  Container searchRecordWidget(BuildContext context) {
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
                      _keyword = value;
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
                            _recordType = RecordType.expense;
                          } else if (val == "Income") {
                            _recordType = RecordType.income;
                          } else {
                            _recordType = RecordType.all;
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
                  initialValue: _startDate.toString(),
                  firstDate: DateTime(DateTime.now().year - 10),
                  lastDate: _endDate,
                  dateMask: "dd/MM/yyyy",
                  dateLabelText: 'Start Date',
                  onChanged: (val) {
                    setState(() {
                      _startDate = DateTimeUtil.getDateTime(val);
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
                  initialValue: _endDate.toString(),
                  firstDate: _startDate,
                  lastDate: DateTime(DateTime.now().year + 10),
                  dateMask: "dd/MM/yyyy",
                  dateLabelText: 'End Date',
                  onChanged: (val) {
                    setState(() {
                      _endDate = DateTimeUtil.getDateTime(val);
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
        ],
      ),
    );
  }
}
