import 'package:cash_flow_app/providers/record_provider.dart';
import 'package:cash_flow_app/screens/edit_record_screen.dart';
import 'package:cash_flow_app/screens/home_screen.dart';
import 'package:cash_flow_app/screens/monthly_report_screen.dart';
import 'package:cash_flow_app/screens/search_record_screen.dart';
import 'package:cash_flow_app/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => RecordProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cash Flow',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEAF2CE),
        backgroundColor: const Color.fromARGB(255, 151, 234, 154),
        fontFamily: 'Source Sans Pro',
        colorScheme: colorScheme,
        elevatedButtonTheme: elevatedButtonTheme,
        cardTheme: cardTheme,
        textTheme: textTheme,
      ),
      home: const HomeScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        EditRecordScreen.routeName: (context) => const EditRecordScreen(),
        SearchRecordScreen.routeName: (context) => const SearchRecordScreen(),
        MonthlyReportScreen.routeName: (context) => const MonthlyReportScreen(),
      },
    );
  }
}
