import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Win System Panel';

  @override
  String get opShutdown => 'Shutdown';

  @override
  String get opRestart => 'Restart';

  @override
  String get opHibernate => 'Hibernate';

  @override
  String get opCancel => 'Cancel Task';

  @override
  String get statusReady => 'System Ready';

  @override
  String get statusScheduled => 'Scheduled Shutdown';

  @override
  String get statusNoTask => 'No Task Scheduled';

  @override
  String logTaskStarted(Object time) {
    return 'Task scheduled for $time.';
  }

  @override
  String get logTaskAborted => 'Task aborted by user.';

  @override
  String get logCommandFailed => 'Command execution failed: Check permissions.';

  @override
  String get timeUnitMinutes => 'minutes';

  @override
  String get opSchedule => 'Schedule Task';

  @override
  String get switchLightMode => 'Switch to Light Mode';

  @override
  String get switchDarkMode => 'Switch to Dark Mode';

  @override
  String get deviceInfoTitle => 'Device Status';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get infoTitle => 'About & Info';

  @override
  String get underConstruction => '(Under Construction)';

  @override
  String get minimizedToTray => 'Window minimized to tray to keep the task running.';

  @override
  String get showWindow => 'Show';

  @override
  String get runningTaskTitle => 'Active Task Running';

  @override
  String runningTaskMessage(Object taskName, Object time) {
    return 'The power operation \'$taskName\' is scheduled to execute at $time. What would you like to do?';
  }

  @override
  String get optionExitAndCancel => 'Exit and Cancel Task';

  @override
  String get optionMinimizeToTray => 'Minimize to Tray';
}
