import 'package:cash_flow_app/providers/record_provider.dart';
import 'package:cash_flow_app/providers/shared_preferences_provider.dart';
import 'package:cash_flow_app/screens/edit_record_screen.dart';
import 'package:cash_flow_app/screens/home_screen.dart';
import 'package:cash_flow_app/screens/monthly_report_screen.dart';
import 'package:cash_flow_app/screens/search_record_screen.dart';
import 'package:cash_flow_app/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => RecordProvider()),
      ChangeNotifierProvider(create: (_) => SharedPreferencesProvider()),
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
        fontFamily: 'Source Sans Pro',
        colorScheme: colorScheme.copyWith(
            background: const Color.fromARGB(255, 151, 234, 154)),
        elevatedButtonTheme: elevatedButtonTheme,
        cardTheme: cardTheme,
        textTheme: textTheme,
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        EditRecordScreen.routeName: (context) => const EditRecordScreen(),
        SearchRecordScreen.routeName: (context) => const SearchRecordScreen(),
        MonthlyReportScreen.routeName: (context) => const MonthlyReportScreen(),
      },
    );
  }
}
