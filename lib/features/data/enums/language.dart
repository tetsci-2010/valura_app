import 'dart:ui';

enum Language {
  english(
    Locale('en', 'US'),
    'English',
  ),

  persian(
    Locale('fa', 'AF'),
    'Persian',
  );

  const Language(this.value, this.text);

  final Locale value;
  final String text;
}
