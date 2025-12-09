class NumberFormatters {
  static String toEnglishDigits(String input) {
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < persian.length; i++) {
      input = input.replaceAll(persian[i], english[i]);
    }
    return input;
  }
}
