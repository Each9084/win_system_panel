//这是侧边栏


import 'package:flutter_riverpod/flutter_riverpod.dart';

//定义所有主要导航页面的枚举
enum MainPanelPage {
  powerControl, // 电源控制（当前已完成的页面）
  deviceInfo,// 设备信息（下一阶段要做的页面）
  settings,//  设置页面
  about//关于/信息页面
// filesManagement, // 示例：未来的功能
}

final navigationProvider = StateNotifierProvider<
    NavigationController,
    MainPanelPage>((ref) {
  return NavigationController();
});

class NavigationController extends  StateNotifier<MainPanelPage> {
  // 默认启动页为电源控制
  NavigationController(): super(MainPanelPage.powerControl);

// 切换页面的方法
void selectPage(MainPanelPage page){
  state = page;
}
}