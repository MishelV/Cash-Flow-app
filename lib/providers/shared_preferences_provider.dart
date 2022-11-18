import 'package:cash_flow_app/models/shared_preferences_model.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider with ChangeNotifier {
  static const sharedPreferencesCurrencyString = "currency";

  SharedPreferencesModel? _model;

  SharedPreferences? preferences;

  Future<void> fetchAndSetPreferences() async {
    if (_model != null) return;

    preferences = await SharedPreferences.getInstance();
    final Currency? currency = stringToCurrency(
        preferences?.getString(sharedPreferencesCurrencyString));
    _model = SharedPreferencesModel(currency ?? Currency.dollar);
    notifyListeners();
  }

  SharedPreferencesProvider() {
    fetchAndSetPreferences();
  }

  void setCurrency(Currency c) {
    _model?.currency = c;
    final String? currencyString = currencyToString(c);
    if (currencyString != null) {
      preferences?.setString(sharedPreferencesCurrencyString, currencyString);
      notifyListeners();
    }
  }

  Currency? getCurrency() {
    return _model?.currency;
  }
}
