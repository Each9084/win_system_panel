# 💻 Win System Panel

一个基于 Flutter (Dart) 开发的 Windows 系统面板应用，旨在提供系统性能实时监控、硬件信息查看以及定时电源控制等功能。

主要电源界面:

![1](./assets/1.gif)



定时设置:

![2](./assets/2.gif)



性能监控:

![3](./assets/3.gif)



## ✨ 已完成的核心功能

### 1. 实时系统性能监控 (Device Info)

应用能实时获取并展示 CPU 和内存的负载情况。

* **数据采集：** 通过 Windows 的原生命令 **`PowerShell / Get-CimInstance`** 获取 CPU 负载，通过 **`system_info2`** 插件获取内存使用情况。
* **数据流管理 (Riverpod)：**
    * `systemMetricsStreamProvider` (**`device_service.dart`**)：一个 `StreamProvider`，每秒通过 `Timer.periodic` 调用原生命令采集一次数据，并将数据实时推送到流中。
    * `metricsHistoryProvider` (**`metrics_history_notifier.dart`**)：一个 `StateNotifierProvider`，持续监听实时数据流，维护一个包含最新 **60 秒**历史数据的列表（用于图表展示）。
* **可视化 (UI)：**
    * **性能图表 (`PerformanceChart`)：** 使用 `fl_chart` 库，实时绘制 CPU 负载 (`cpuLoad`) 和内存使用率 (`memoryUsage`) 的折线图，支持平滑曲线和下方区域着色。
    * **硬件信息展示：** 通过 `hardwareInfoProvider` (`FutureProvider`) 一次性获取并展示 **OS 名称/版本、CPU 名称、总内存 (GB)、系统制造商和型号**。

---

### 2. 定时电源控制 (Power Control)

应用允许用户设定定时关机、重启或休眠任务，并在倒计时结束时执行。

* **核心状态管理 (Riverpod)：**
    * **`PowerTask` (Model)：** 定义了任务状态模型，包括操作类型 (`PowerOperation`: shutdown/restart/hibernate/abort) 和计划执行时间 (`scheduledAt`)。
    * **`PowerController` (Notifier)：** 一个 `StateNotifier`，管理当前的 `PowerTask` 状态。
        * `schedule(operation, duration)`：启动任务。对于关机和重启，会调用 Windows 的 **`shutdown.exe`** 命令进行系统级定时。
        * `abortTask()`：取消任务，同时取消 Windows 系统的定时命令 (`shutdown /a`) 和内部倒计时。
* **UI 倒计时逻辑：**
    * `countdownStream`：`PowerController` 内部的 `StreamController<Duration>`，每秒更新一次剩余时间，供 UI 实时展示。
    * **休眠特殊处理：** 由于 `shutdown.exe` 不直接支持休眠，休眠操作的系统命令 (`_performPowerOperation`) 在 **Flutter 内部倒计时结束时**执行。

---

### 3. 应用架构与工具

* **状态管理：** 全局采用 **Riverpod** 框架进行依赖注入和响应式状态管理（`StreamProvider`, `FutureProvider`, `StateNotifierProvider`, `StateProvider`）。
* **国际化 (I18n)：** 实现了基于 **`LocalizationManager`** 的国际化（本地化）方案，支持在 UI 层面通过 `ref.t.translate('key')` 获取文本。
* **跨平台/原生集成 (Windows)：** 利用 **`dart:io.Process.run`** 调用 Windows 原生命令 (`powershell`, `wmic`, `shutdown.exe`) 进行系统级交互。
* **UI 框架：** 使用 **Material 3 (M3)** 设计，实现了一个带有侧边导航栏 (`NavigationRail`) 的桌面应用布局。



## 🛠️ 技术栈与依赖

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



## 项目结构 (Project Structure)

项目的主要结构围绕 `lib/` 目录展开，划分为**核心层 (Core)** 和**功能层 (Features)**。

📁 lib/

| **目录/文件**                   | **描述**                                                     | **关键文件示例**                                             |
| ------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **`main.dart`**                 | 应用的入口文件，负责初始化窗口、系统托盘以及 Riverpod 的配置。 | `main.dart`                                                  |
| **`core/`**                     | 跨功能模块共享的基础代码、配置和主题。                       |                                                              |
| ├── `config/`                   | 应用程序级别的配置和控制器。                                 | `navigation_controller.dart`                                 |
| └── `theme/`                    | 应用的主题定义。                                             | `app_theme.dart`                                             |
| **`features/`**                 | 所有的独立功能模块都放在这里。                               |                                                              |
| ├── `device_info/`              | **设备信息** (实时监控与静态信息) 功能模块。                 |                                                              |
| │   ├── `domain/`               | 数据模型层：定义领域实体。                                   | `device_info.dart`                                           |
| │   └── `presentation/`         | 表现层/UI：定义页面和组件。                                  | `device_info_page.dart`, `widgets/performance_chart.dart`    |
| └── `power_control/`            | **电源控制** (定时关机/重启/休眠) 功能模块。                 |                                                              |
| ├── `domain/`                   | 数据模型层：定义领域实体和枚举。                             | `power_task.dart`                                            |
| ├── `application/`              | 应用服务层/业务逻辑：包含 Riverpod Controllers 和 Service。  | `power_controller.dart`, `device_service.dart`, `metrics_history_notifier.dart` |
| └── `presentation/`             | 表现层/UI：定义页面和组件。                                  | `pages/power_control_page.dart`                              |
| **`i18n/`**                     | 国际化 (Internationalization) 相关的代码。                   |                                                              |
| ├── `l10n/`                     | 生成的本地化文件。                                           | `app_localizations.dart`                                     |
| └── `localization_manager.dart` | 封装本地化逻辑和状态。                                       | `localization_manager.dart`                                  |



![structure](./assets/structure.png)





### 关键实现细节

#### 1\. 定时休眠 (Hibernate) 

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

为了实现系统托盘功能，项目集成了 `system_tray` 插件。在配置过程中，遇到了 C++ 链接错误，未来会加以解决

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


    注意目前仍然是beta版本
    *(项目将在 Windows 桌面启动，并包含自定义标题栏和系统托盘图标。)*
