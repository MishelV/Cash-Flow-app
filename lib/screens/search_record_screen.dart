import 'package:cash_flow_app/models/record.dart';
import 'package:cash_flow_app/providers/record_provider.dart';
import 'package:cash_flow_app/screens/edit_record_screen.dart';
import 'package:cash_flow_app/widgets/search_screen/record_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filter_parameters.dart';
import '../models/search_type.dart';
import '../utils/date_time_util.dart';
import '../widgets/search_screen/cash_flow_timeframe_summary_widget.dart';
import '../widgets/search_screen/filter_records_widget.dart';

class SearchRecordScreen extends StatefulWidget {
  const SearchRecordScreen({Key? key}) : super(key: key);

  static const routeName = '/search-record';

  @override
  State<SearchRecordScreen> createState() => _SearchRecordScreenState();
}

class _SearchRecordScreenState extends State<SearchRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Record> _records = [];
  late FilterParameters _parameters;
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
              _parameters = FilterParameters(
                keyword: "",
                startDate: DateTime(date.year, date.month),
                endDate: DateTimeUtil.endOfMonthFor(date),
                type: RecordType.all,
              );
              _screenName = "Records Summary";
            });
            break;
          case SearchType.upcomingExpenses:
            setState(() {
              _parameters = FilterParameters(
                keyword: "",
                startDate: DateTime.now(),
                endDate: DateTimeUtil.nextYearOf(DateTime.now()),
                type: RecordType.expense,
              );
              _screenName = "Upcoming Expenses";
            });
            break;
          case SearchType.recordLookup:
          default:
            setState(() {
              _parameters = FilterParameters(
                keyword: "",
                startDate: DateTimeUtil.previousYearOf(DateTime.now()),
                endDate: DateTime.now(),
                type: RecordType.all,
              );
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
        .getRecordsByFilterParameters(_parameters)
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

  void updateRecordsByFilterParameters(FilterParameters newParameters) {
    setState(() {
      _parameters = newParameters;
    });
    setRecords();
  }

  void navigateToAddRecord() {
    Navigator.of(context).pushNamed(EditRecordScreen.routeName).then((_) {
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
                    child: FilterRecordsWidget(
                        parameters: _parameters,
                        onTap: updateRecordsByFilterParameters),
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
          style: Theme.of(context).textTheme.headlineMedium,
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
}
