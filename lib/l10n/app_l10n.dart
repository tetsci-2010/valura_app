import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_l10n_en.dart';
import 'app_l10n_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// No description provided for @hi.
  ///
  /// In fa, this message translates to:
  /// **'سلام'**
  String get hi;

  /// No description provided for @welcome.
  ///
  /// In fa, this message translates to:
  /// **'خوش آمدید'**
  String get welcome;

  /// No description provided for @emailAddress.
  ///
  /// In fa, this message translates to:
  /// **'ایمیل آدرس'**
  String get emailAddress;

  /// No description provided for @enterEmailAddress.
  ///
  /// In fa, this message translates to:
  /// **'ایمیل آدرس را وارد کنید'**
  String get enterEmailAddress;

  /// No description provided for @password.
  ///
  /// In fa, this message translates to:
  /// **'رمز عبور'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In fa, this message translates to:
  /// **'رمز عبور را وارد کنید'**
  String get enterPassword;

  /// No description provided for @pleaseLoginBeforeContinue.
  ///
  /// In fa, this message translates to:
  /// **'برای ادامه لطفا وارد حساب کاربری خود شوید'**
  String get pleaseLoginBeforeContinue;

  /// No description provided for @login.
  ///
  /// In fa, this message translates to:
  /// **'ورود'**
  String get login;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In fa, this message translates to:
  /// **'این فیلد ضروری می‌باشد'**
  String get thisFieldIsRequired;

  /// No description provided for @pleaseFillAllRequiredFields.
  ///
  /// In fa, this message translates to:
  /// **'لطفا تمامی فیلد های لازم را پر کنید'**
  String get pleaseFillAllRequiredFields;

  /// No description provided for @h.
  ///
  /// In fa, this message translates to:
  /// **'ح'**
  String get h;

  /// No description provided for @gh.
  ///
  /// In fa, this message translates to:
  /// **'غ'**
  String get gh;

  /// No description provided for @t.
  ///
  /// In fa, this message translates to:
  /// **'ت'**
  String get t;

  /// No description provided for @comingSoon.
  ///
  /// In fa, this message translates to:
  /// **'به زودی...'**
  String get comingSoon;

  /// No description provided for @present.
  ///
  /// In fa, this message translates to:
  /// **'حاضر'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In fa, this message translates to:
  /// **'غیر حاضر'**
  String get absent;

  /// No description provided for @late.
  ///
  /// In fa, this message translates to:
  /// **'تاخیر'**
  String get late;

  /// No description provided for @details.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات'**
  String get details;

  /// No description provided for @search.
  ///
  /// In fa, this message translates to:
  /// **'جستجو'**
  String get search;

  /// No description provided for @newEmployee.
  ///
  /// In fa, this message translates to:
  /// **'کارمند جدید'**
  String get newEmployee;

  /// No description provided for @employeeName.
  ///
  /// In fa, this message translates to:
  /// **'نام کارمند'**
  String get employeeName;

  /// No description provided for @fatherName.
  ///
  /// In fa, this message translates to:
  /// **'نام پدر'**
  String get fatherName;

  /// No description provided for @nickName.
  ///
  /// In fa, this message translates to:
  /// **'تخلص'**
  String get nickName;

  /// No description provided for @phoneNumber.
  ///
  /// In fa, this message translates to:
  /// **'شماره تماس'**
  String get phoneNumber;

  /// No description provided for @description.
  ///
  /// In fa, this message translates to:
  /// **'توضیحات'**
  String get description;

  /// No description provided for @gallery.
  ///
  /// In fa, this message translates to:
  /// **'گالری'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In fa, this message translates to:
  /// **'دوربین'**
  String get camera;

  /// No description provided for @submit.
  ///
  /// In fa, this message translates to:
  /// **'ثبت'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In fa, this message translates to:
  /// **'لغو'**
  String get cancel;

  /// No description provided for @requiredField.
  ///
  /// In fa, this message translates to:
  /// **'فیلد الزامی'**
  String get requiredField;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
