import 'app_localizations.dart';

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Windows 系统控制台';

  @override
  String get opShutdown => '定时关机';

  @override
  String get opRestart => '定时重启';

  @override
  String get opHibernate => '定时休眠';

  @override
  String get opCancel => '取消任务';

  @override
  String get statusReady => '系统就绪';

  @override
  String get statusScheduled => '定时任务已启动';

  @override
  String get statusNoTask => '当前无定时任务';

  @override
  String logTaskStarted(Object time) {
    return '任务已计划在 $time 执行。';
  }

  @override
  String get logTaskAborted => '用户已取消当前任务。';

  @override
  String get logCommandFailed => '命令执行失败：请检查权限。';

  @override
  String get timeUnitMinutes => '分钟';

  @override
  String get opSchedule => '启动定时';

  @override
  String get switchLightMode => '切换到浅色模式';

  @override
  String get switchDarkMode => '切换到深色模式';

  @override
  String get deviceInfoTitle => '设备状态';

  @override
  String get settingsTitle => '设置';

  @override
  String get infoTitle => '关于与信息';

  @override
  String get underConstruction => '(正在开发中)';

  @override
  String get minimizedToTray => '窗口已最小化到托盘以保持任务运行。';

  @override
  String get showWindow => '显示';

  @override
  String get runningTaskTitle => '有任务正在运行';

  @override
  String runningTaskMessage(Object taskName, Object time) {
    return '定时操作 $taskName 已计划在 $time 执行。您希望如何处理？';
  }

  @override
  String get optionExitAndCancel => '退出并取消任务';

  @override
  String get optionMinimizeToTray => '最小化到托盘';
}
