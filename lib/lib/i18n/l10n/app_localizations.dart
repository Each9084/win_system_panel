import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Win System Panel'**
  String get appTitle;

  /// No description provided for @opShutdown.
  ///
  /// In en, this message translates to:
  /// **'Shutdown'**
  String get opShutdown;

  /// No description provided for @opRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get opRestart;

  /// No description provided for @opHibernate.
  ///
  /// In en, this message translates to:
  /// **'Hibernate'**
  String get opHibernate;

  /// No description provided for @opCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Task'**
  String get opCancel;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'System Ready'**
  String get statusReady;

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Shutdown'**
  String get statusScheduled;

  /// No description provided for @statusNoTask.
  ///
  /// In en, this message translates to:
  /// **'No Task Scheduled'**
  String get statusNoTask;

  /// No description provided for @logTaskStarted.
  ///
  /// In en, this message translates to:
  /// **'Task scheduled for {time}.'**
  String logTaskStarted(Object time);

  /// No description provided for @logTaskAborted.
  ///
  /// In en, this message translates to:
  /// **'Task aborted by user.'**
  String get logTaskAborted;

  /// No description provided for @logCommandFailed.
  ///
  /// In en, this message translates to:
  /// **'Command execution failed: Check permissions.'**
  String get logCommandFailed;

  /// No description provided for @timeUnitMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get timeUnitMinutes;

  /// No description provided for @opSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule Task'**
  String get opSchedule;

  /// No description provided for @switchLightMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Light Mode'**
  String get switchLightMode;

  /// No description provided for @switchDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Dark Mode'**
  String get switchDarkMode;

  /// No description provided for @deviceInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Status'**
  String get deviceInfoTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'About & Info'**
  String get infoTitle;

  /// No description provided for @underConstruction.
  ///
  /// In en, this message translates to:
  /// **'(Under Construction)'**
  String get underConstruction;

  /// No description provided for @minimizedToTray.
  ///
  /// In en, this message translates to:
  /// **'Window minimized to tray to keep the task running.'**
  String get minimizedToTray;

  /// No description provided for @showWindow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get showWindow;

  /// No description provided for @runningTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Task Running'**
  String get runningTaskTitle;

  /// No description provided for @runningTaskMessage.
  ///
  /// In en, this message translates to:
  /// **'The power operation \'{taskName}\' is scheduled to execute at {time}. What would you like to do?'**
  String runningTaskMessage(Object taskName, Object time);

  /// No description provided for @optionExitAndCancel.
  ///
  /// In en, this message translates to:
  /// **'Exit and Cancel Task'**
  String get optionExitAndCancel;

  /// No description provided for @optionMinimizeToTray.
  ///
  /// In en, this message translates to:
  /// **'Minimize to Tray'**
  String get optionMinimizeToTray;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
