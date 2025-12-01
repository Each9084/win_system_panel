//实现系统控制逻辑

// --- Riverpod Provider 定义 ---

import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/power_task.dart';

// 全局访问 PowerController 的实例和状态
//Riverpod 框架中用于创建和管理业务逻辑类（PowerController）的入口点
//实现 依赖注入（Dependency Injection, DI） 和 响应式状态管理
final powerControllerProvider =
//ref 是 Riverpod 传递的一个对象，它负责处理依赖注入和资源清理。
    StateNotifierProvider<PowerController, PowerTask>((ref) {
  return PowerController();
});


// 用于存储用户在 UI 上选择的电源操作 (未执行)
final selectedOperationProvider = StateProvider<PowerOperation>((ref){
  // 默认选中关机 (Shutdown)
  return PowerOperation.shutdown;
});

class PowerController extends StateNotifier<PowerTask> {
  // 状态默认为空任务 (无任务)
  //构造函数 super() 用于调用父类 StateNotifier 的构造函数,将 StateNotifier初始状态设置为 PowerTask.empty。
  PowerController() : super(PowerTask.empty);

  //存储 Timer.periodic 的实例 设定的时间间隔（例如每秒）触发回调的工具。
  // ?是不希望在 Controller 刚创建时就启动计时器和 Stream，只有当用户真正启动任务时才需要。
  Timer? _countdownTimer;

  //数据流的核心控制对象,允许“注入”数据（每秒剩余的 Duration），然后让 UI 监听这些数据。
  StreamController<Duration>? _timerStreamController;

// 提供给 UI 的倒计时 Stream,这是一个getter为外部（即 UI 层）提供了一个可监听的接口
  Stream<Duration> get countdownStream {
    //随时变化的数据(倒计时) 就先显得很科幻感
    _timerStreamController ??= StreamController<Duration>.broadcast();
    return _timerStreamController!.stream;
  }




  // ----------------------------------------------------
  // 核心业务方法：调度电源操作
  // ----------------------------------------------------

  Future<void> schedule(PowerOperation operation, Duration delay) async {
    // 取消任何现有的任务和计时器 确保在启动新任务之前，取消所有可能正在运行的旧任务。
    await abortTask();

    // 计算出定时任务实际执行的具体时间点
    final scheduledTime = DateTime.now().add(delay);

    //更新状态
    state = PowerTask(
      operation: operation,
      duration: delay,
      scheduledAt: scheduledTime,
    );

    //启动 Flutter 内部计时器来实时更新 UI 倒计时
    _startInternalTimer();

    //检查是否需要执行 Windows 命令
    if(operation == PowerOperation.hibernate || operation == PowerOperation.abort){
      // 休眠：由计时器结束时执行
      // 取消：已在 abortTask 中处理
      return;// 直接返回，不执行下面的 Process.run
    }


    //执行windows 命令行
    //这里让 Windows 的 shutdown 命令来处理定时，更稳定。
    final seconds = delay.inSeconds;
    String command = "shutdown";
    List<String> args = [];

    //Dart 3.0 及更高版本中,switch 语句被设计为穷尽性检查
    //当对一个枚举类型（enum，比如 PowerOperation）进行 switch 判断时，Dart 编译器要求必须确保：
    // 1.处理了所有的枚举值（shutdown, restart, hibernate, abort）。
    // 2.或者，提供一个默认的 default 语句来捕获所有未明确列出的值。
    switch (operation) {
      case PowerOperation.shutdown:
        command = "shutdown";
        args = ["/s", "/t", "$seconds", "/f"]; // /s:关机 /t:延迟 /f:强制关闭
        break;

      case PowerOperation.restart:
        command = "shutdown";
        args = ["/r", "/t", "$seconds", "/f"]; // /r:重启
        break;
      case PowerOperation.hibernate:
      case PowerOperation.abort:
        return; //已在上面处理
    }

    //执行 Windows 命令并处理错误
    try {
      final result = await Process.run(command, args, runInShell: true);
      //0代表命令成功执行
      if (result.exitCode != 0) {
        print("命令执行失败:${result.stderr}");
        // ⚠️ 任务启动失败！必须清理状态和计时器
        await abortTask(silent: true); // 使用一个静默取消（见下面改进）
      }
    } catch (e) {
      print("执行命令时出错: $e");
      await abortTask(silent: true);
      //state = PowerTask.empty; // 失败则清空任务
    }
  }

  // ----------------------------------------------------
  // 内部方法：伪装定时休眠(因为win只有立即休眠) 在倒计时结束时执行电源操作
  // ----------------------------------------------------

  Future<void> _performPowerOperation() async {
    if(state.operation == PowerOperation.abort) return;// 已取消则不执行
    String command;
    List<String> args =[];

    // 对于休眠，我们使用特定的命令
    if(state.operation == PowerOperation.hibernate){
      //仅执行休眠操作
      command = "shutdown";

      // /h 是休眠命令，它不支持 /t，所以我们只执行 /h
      args = ["/h","/f"];
    }else{
      // 对于定时关机/重启，让 Windows 命令在后台运行，所以这里不需要重复执行。
      // 但为了确保逻辑完整性，这里可以留空，或加入取消命令以防万一。
      return;
    }

    try{
      final result = await Process.run(command, args,runInShell: true);
      if(result.exitCode != 0){
        print("【Flutter执行】命令失败: ${result.stderr}");
        // 如果失败，取消任务并显示错误（可选）
      }else{
        print("【Flutter执行】命令成功: ${state.operation.name}");
      }
    }catch(e){
      print("【Flutter执行】命令时出错: $e");
    }

    //清理任务状态
    state =PowerTask.empty;
  }

  // ----------------------------------------------------
  // 核心业务方法：取消任务
  // abortTask: 增加一个静默参数，防止重复打印或不必要的重置操作。
  // ----------------------------------------------------
  Future<void> abortTask({bool silent = false}) async {
    // 1. 执行 Windows 取消命令
    await Process.run("shutdown", ['/a'], runInShell: true);

    //2. 清理 Flutter 内部资源
    _countdownTimer?.cancel();
    _timerStreamController?.close();
    _timerStreamController = null;

    //更新状态
    if (!silent) {
      print("任务已取消。");
    }
    //3.更新状态
    state = PowerTask.empty;
  }

  // ----------------------------------------------------
  // 内部方法：控制 UI 倒计时
  // ----------------------------------------------------
  void _startInternalTimer() {
    _countdownTimer?.cancel(); //取消现有的倒计时

    //检查状态是否有效
    if (state.scheduledAt == null) return;

    //每秒更新一次
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {

      //计算剩余时间
      final remianing = state.scheduledAt!.difference(DateTime.now());

      if (remianing.isNegative) {
        // 倒计时结束,清理
        //?是为了不为null再调用,如果都是null了那就说明已经结束了,没必要cancel了
        _countdownTimer?.cancel();
        //向所有坚挺的widget发送结束信号
        _timerStreamController?.close();
        //垃圾回收机制,虽然close了stream的数据流,但是这个变量本身还占用着空间
        _timerStreamController = null;

        //休眠部分:倒计时结束时执行操作
        // 对于休眠，需要在 Flutter 内部执行命令
        if(state.operation == PowerOperation.hibernate){
          _performPowerOperation();
        }else{
          // 对于定时关机/重启，Windows命令在后台已处理，这里只需要清理状态。
          state = PowerTask.empty;
        }
      } else {
        //发送剩余时间 Stream (UI 监听并刷新)
        _timerStreamController?.add(remianing);
      }
    });
  }






  //资源清理
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _timerStreamController?.close();
    super.dispose();
  }
}
