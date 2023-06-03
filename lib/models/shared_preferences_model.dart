class SharedPreferencesModel {
  Currency currency;

  SharedPreferencesModel(this.currency);
}

enum Currency { shekel, dollar, euro }

const String shekelString = "₪";
const String dollarString = "\$";
const String euroString = "€";

Currency? stringToCurrency(String? input) {
  if (input == shekelString) {
    return Currency.shekel;
  } else if (input == dollarString) {
    return Currency.dollar;
  } else if (input == euroString) {
    return Currency.euro;
  } else {
    return null;
  }
}

String? currencyToString(Currency? input) {
  if (input == Currency.shekel) {
    return shekelString;
  } else if (input == Currency.dollar) {
    return dollarString;
  } else if (input == Currency.euro) {
    return euroString;
  } else {
    return null;
  }
}
