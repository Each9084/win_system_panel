## 🚀  Win System Panel

### 项目简介

`Win System Panel` 是一个基于 **Flutter** 和 **Dart** 开发的现代化 Windows 系统管理工具。它采用美观风格主题，提供简洁的界面，帮助用户高效地执行系统级的电源操作和实时监控设备状态。

该项目旨在作为 Flutter 桌面应用开发的一个优秀实践案例，展示如何处理原生系统调用、实现跨页面状态同步（Riverpod）以及创建自定义窗口和托盘功能。

 目前实现的核心

| 类别 | 功能描述 | 状态 |
| :--- | :--- | :--- |
| **电源控制** | 计划定时关机、定时重启和定时休眠操作。 | ✅ 已实现 |
| **系统交互** | 自定义窗口边框、最小化到托盘、托盘菜单操作。 | ✅ 已实现 |
| **UI/UX** | 响应式布局、自定义标题栏、动态主题切换（暗/亮）。 | ✅ 已实现 |
| **状态管理** | 统一管理电源任务状态、UI 状态，实现跨页面的实时倒计时。 | ✅ 已实现 |
| **设备监控** | 实时显示 CPU、内存、磁盘等设备信息。 | 🚧 开发中 |

### 🛠️ 技术栈与依赖

本项目主要基于 Flutter 框架，并使用了以下关键插件和技术栈：

#### Dart / Flutter 核心依赖

| 插件名称 | 版本 | 用途 |
| :--- | :--- | :--- |
| `flutter_riverpod` | `^2.5.1` | **状态管理框架**，用于管理电源任务、导航和 UI 状态。 |
| `window_manager` | `^0.3.1` | 用于自定义窗口、处理窗口事件（如最大化、关闭拦截）。 |
| `system_tray` | `^0.2.1` | 实现应用最小化到系统托盘以及托盘菜单功能。 |
| `shared_preferences` | `^2.2.3` | 轻量级本地存储，用于保存主题模式等配置。 |
| `flutter_localizations` | *默认* | 实现应用的多语言支持（i18n）。 |

#### Windows 原生交互

| 技术 | 用途 |
| :--- | :--- |
| **Dart `dart:io` `Process.run`** | 执行 Windows 命令行（`shutdown`、`powershell`）以实现电源操作。 |
| **CMake / C++** | 配置原生项目，确保 `system_tray` 等插件能够正确链接和运行。 |

### 💡 关键实现细节与挑战

#### 1\. 定时休眠 (Hibernate) 的优雅处理

由于 Windows 的 `shutdown /h` 命令不支持定时参数 (`/t`)，本项目采用了应用层倒计时的方式实现定时休眠，确保用户体验的一致性。

  * **实现原理：**

    1.  用户设置休眠时间后，**不立即** 调用 Windows 命令。
    2.  `PowerController` 启动一个 **内部 Dart 计时器** (`Timer.periodic`) 来进行倒计时和 UI 刷新。
    3.  当倒计时结束 (`remaining.isNegative`) 时，通过 `Process.run("powershell", ["-Command", "Stop-Computer -Hibernate"])` 立即触发休眠。

  * **⛔ 已知问题（用户须知）：**
    如果用户在 Windows 系统中禁用了休眠功能（例如，通过 `powercfg /hibernate off`），应用倒计时结束后将**无法休眠**，但会打印“命令执行成功”。

      * **解决方法：** 用户需要在管理员权限的命令行中执行 `powercfg /hibernate on` 来启用系统休眠功能。

#### 2\. UI 状态的持久化

为解决页面切换时 UI 选项丢失的问题（例如从重启切换到休眠再切回，选项重置为关机），本项目引入了 `selectedOperationProvider` (`StateProvider`)。

  * **实现原理：** 将用户在 UI 上当前的选中操作（关机/重启/休眠）存储在 Riverpod 状态中，而不是存储在本地 `StatefulWidget` 中。这确保了导航切换时，UI 控件可以从全局状态中读取上次选中的值，保持一致性。

#### 3\. 托盘功能和 C++ 链接

为了实现系统托盘功能，项目集成了 `system_tray` 插件。在配置过程中，遇到了 C++ 链接错误，最终通过以下方式解决：

  * **修复方法：** 在 `windows/runner/CMakeLists.txt` 文件中显式地将 `system_tray_plugin` 添加到 `target_link_libraries`，并执行彻底的 `flutter clean` 和缓存清理，确保原生构建系统正确识别并链接插件。

### ⌨️ 如何运行

1.  **克隆仓库：**
    ```bash
    git clone git@github.com:Each9084/win_sysyem_panel.git
    cd win_sysyem_panel
    ```
2.  **获取依赖：**
    ```bash
    flutter pub get
    ```
3.  **运行项目：**
    ```bash
    flutter run
    ```
    *(项目将在 Windows 桌面启动，并包含自定义标题栏和系统托盘图标。)*