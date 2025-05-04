---
Date: 2024-12-24
Created: 2024-12-24 15:39 Tuesday
Updated: 2025-05-02 18:41 Friday
---

# Readme

## 1. Intro

A custom simple MPV！

## 2. 下载安装

### 2.1. 官方原版

[mpv.io | Installation](https://mpv.io/installation/)

> 推荐使用 [shinchiro](https://github.com/shinchiro/mpv-winbuild-cmake) 构建版，如其中的 `mpv-x86_64-v3-xx-git-xx.7z`。

### 2.2. 第三方懒人包

- [mpvnet-player/mpv.net](https://github.com/mpvnet-player/mpv.net)
- [dyphire/mpv-config](https://github.com/dyphire/mpv-config)
- [hooke007/MPV_lazy](https://github.com/hooke007/MPV_lazy)
- [redomCL/mpv_fruit](https://github.com/redomCL/mpv_fruit)
- [Hill-98/mpv-config](https://github.com/Hill-98/mpv-config)
- [422658476/MPV-EASY-Player](https://github.com/422658476/MPV-EASY-Player)

> 懒人包根据自己喜好选择即可，喜欢折腾可以自己折腾，更加符合自己需求！

## 3. 脚本

### 3.1. 脚本资源

| 地址                                                                                                                  | 描述                                                                      |
| --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| [stax76/awesome-mpv](https://github.com/stax76/awesome-mpv#on-screen-controller)                                      | 基本汇总了所有脚本的仓库                                                  |
| [User Scripts · mpv-player/mpv Wiki](https://github.com/mpv-player/mpv/wiki/User-Scripts)                             | 官方仓库整理的脚本列表                                                    |
| [CogentRedTester/mpv-scripts](https://github.com/CogentRedTester/mpv-scripts)                                         | 一个写脚本的大佬，提供了很多实用的脚本                                    |
| [脚本说明 · dyphire/mpv-config Wiki](https://github.com/dyphire/mpv-config/wiki/%E8%84%9A%E6%9C%AC%E8%AF%B4%E6%98%8E) | [dyphire/mpv-config](https://github.com/dyphire/mpv-config) 用到的脚本汇总 |

### 3.2. 部分内置脚本

| 脚本                                                                         | 作用                                                                                                                    | 备注 |
| ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ---- |
| [console.lua](https://mpv.io/manual/master/#console)                         | 控制台                                                                                                                  |      |
| [stats.lua](https://mpv.io/manual/master/#stats)                             | 状态信息                                                                                                                |      |
| [auto_profiles.lua](https://mpv.io/manual/master/#conditional-auto-profiles) | 根据条件自动切换设置的功能                                                                                              |      |
| [ytdl_hook.lua](https://mpv.io/manual/master/#options-ytdl)                  | 加强了网络串流的播放能力。需要 `mpv.exe` 所在目录存在 [youtube-dl.exe](https://github.com/ytdl-org/youtube-dl/releases) | mpv0.34.0 及之后的版本默认优先使用 [yt-dlp](../../+Inbox/视频下载.md)，非特殊情况应始终使用 yt-dlp，[ytdl_hook.conf 配置参考](https://github.com/hooke007/MPV_lazy/blob/main/portable_config/script-opts/ytdl_hook.conf)     |

### 3.3. 部分第三方脚本

| 脚本                                                                                                    | 说明                                | 备注 |
| ------------------------------------------------------------------------------------------------------- | ----------------------------------- | ---- |
| [dynamic-crop.lua](https://github.com/Ashyni/mpv-scripts#dynamic-croplua)                               | 自动裁剪视频黑边                    |      |
| [history-bookmark.lua](https://github.com/yuukidach/mpv-scripts?tab=readme-ov-file#history-bookmarklua) | 记录并恢复视频目录播放记录          |      |
| [mpv_manager](https://github.com/po5/mpv_manager)                                                       | 一键更新脚本和着色器（依赖 git）     |      |
| [mpv-torrserver](https://github.com/kritma/mpv-torrserver)                                              | 提供 `magnet:?` 磁链协议播放功能      |      |
| [thumbfast](https://github.com/po5/thumbfast)                                                           | 预览图（进度条）                    |      |
| [mpv-file-browser](https://github.com/CogentRedTester/mpv-file-browser)                                 | 文件浏览器                          |      |
| [recent](https://github.com/hacel/recent)                                                               | 最近播放                            |      |
| [mpv-playlistmanager](https://github.com/jonniek/mpv-playlistmanager)                                   | 播放列表                            |      |
| [ekisu/mpv-webm](https://github.com/ekisu/mpv-webm)                                                     | 剪辑导出视频/音频/gif               |      |
| [Play-With-MPV](https://github.com/LuckyPuppy514/Play-With-MPV)                                         | 网页视频发送到 MPV 播放，需要油猴脚本 |      |
| [tomasklaen/uosc](https://github.com/tomasklaen/uosc)                                                   | OSC + 菜单                          |      |
| [Samillion/ModernZ](https://github.com/Samillion/ModernZ)                                               | OSC                                 |      |
| [FinnRaze/mpv-osc-modern-f](https://github.com/FinnRaze/mpv-osc-modern-f)                               | OSC                                 |      |
| [Qiyue0726/awesome-osc](https://github.com/Qiyue0726/awesome-osc)                                       | OSC                                 |      |
| [command_palette](https://github.com/stax76/mpv-scripts?tab=readme-ov-file#command_palette)             |  命令面板                                   |      |

> OSC (On Screen Controller)
> OSD (On Screen Display)

### 3.4. 播放历史

[自动恢复上次播放文件/列表脚本 · hooke007/MPV_lazy · Discussion #153](https://github.com/hooke007/MPV_lazy/discussions/153)

### 3.5. uosc 自定义界面按键

支持自定义按键，看官方配置文档或下方中文说明。

[tomasklaen/uosc](https://github.com/tomasklaen/uosc)
[[Lua] uosc 多功能控制界面 · hooke007/MPV_lazy · Discussion #186](https://github.com/hooke007/MPV_lazy/discussions/186)

### 3.6. 自定义脚本

...

## 4. 着色器 shaders

> [第三方用户着色器 - mpv_CFanStation](https://hooke007.github.io/unofficial/mpv_shaders.html)

### 4.1. Anime4K

[bloc97/Anime4K](https://github.com/bloc97/Anime4K)

Anime4K 是一套开源、高质量的实时动漫放大/降噪算法，可以用任何编程语言实现。

## 5. 补帧

### 5.1. SVP

[SVP – SmoothVideo Project – Real Time Video Frame Rate Conversion](https://www.svp-team.com/zh/home/#)

## 6. 自用版 MPV

> [!danger] 注意！
> - 确保 `mpv.exe` 所在路径（及子文件夹）具有被完全读写的权限，权限不够的话着色器等内容可能存在加载失败情况！
>
> >WIN MPV 文件夹设置参考：`（文件夹右键）属性 → 安全 → 编辑 → 选择需要被授权的用户 → ☑允许`
> - `mpv.conf` 的详细注释来自 [dyphire/mpv-config](https://github.com/dyphire/mpv-config)。

### 6.1. 设置目录

- 以 `C:/Users/用户名/AppData/Roaming/mpv/` 为设置目录，相当于这是“全局设置目录”，不管你使用电脑里存放的多少个不同版本的 mpv，都会自动读取这个设置目录
- （推荐）以 `X:/xx/MPV文件夹/portable_config/` 为设置目录，除去其具有最高优先级（会让其忽略“全局设置”）的特性，还赋予了软件绿色化的特性，非常适合便携党。

> [mpv.io](https://mpv.io/manual/master/#files)

| 文件、文件夹                      | 说明                       | 备注                                                                                                                                           |
| --------------------------------- | -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `portable_config/mpv.conf`        | 配置文件                   |                                                                                                                                                |
| `portable_config/input.conf`      | 快捷键定义文件             | 注意 MPV 有 [官方内建方案](https://github.com/mpv-player/mpv/blob/master/etc/input.conf), 通常 mpv 读取该文件并覆盖内建的初始快捷键方案中的重名项。 |
| `portable_config/scripts/`        | 自定义脚本目录             |                                                                                                                                                |
| `portable_config/script-opts/`    | 自定义脚本配置目录         | 配置项和脚本同名，`脚本名.conf`                                                                                                                |
| `portable_config/script-modules/` | 部分自定义脚本依赖模块目录 | [command_palette](https://github.com/stax76/mpv-scripts?tab=readme-ov-file#command_palette) 依赖就位于这里                                      |
| `portable_config/shaders/`        | 第三方着色器目录           |                                                                                                                                                |
| `portable_config/fonts/`          | 自定义脚本依赖字体存储目录 |                                                                                                                                                |
| `portable_config/icc/`            | icc 色彩管理配置           | 来自 [dyphire/mpv-config](https://github.com/dyphire/mpv-config)                                                                                |
| `portable_config/cache/`         | 缓存                       |                                                                                                                                                |
| `portable_config/files/`          | 生成的文件，如 log                           |                                                                                                                                                |

### 6.2. 快捷键

#### 6.2.1. 当前自定义快捷键

> `mpv.conf` 中禁用（`input-default-bindings=no`）了所有内置按键和脚本内置按键。
> 全局快捷键设置如下。

| 按键            | 说明                                                                                  | 退出         | 脚本            | 备注                                                                                     |
| --------------- | ------------------------------------------------------------------------------------- | ------------ | --------------- | ---------------------------------------------------------------------------------------- |
| i、shift+i（I） | 状态信息，1 2 3 4 5 0 翻到不同页面以展示不同类型的信息，其中部分页面支持 ↑ ↓ 按键翻页 | ESC、shift+i | stats.lua       |                                                                                          |
| ?               | 快捷键信息（shift+i 4 一样）                                                          | ESC          | stats.lua       |                                                                                          |
| \`              | 控制台功能，一般用于便于快速查错、临时变更属性或选项。                                | ESC          | console.lua     | 控制台指令的语法同上文快捷键的语法，例如输入 `set fullscreen yes` 回车即执行“进入全屏”。 |
| MBTN_LEFT_DBL   | 暂停、播放                                                                            |              |                 |                                                                                          |
| ENTER           |     全屏/退出全屏                          |              |                 |                                                                                          |
| q               |                直接退出                       |              |                 |                                                                                          |
| Q               |               退出并记住播放位置                          |              |                 |                                                                                          |
| Ctrl+w          |              直接退出                             |              |                 |                                                                                          |
| ESC             |                退出全屏                                |              |                 |                                                                                          |
| SPACE           |               暂停、播放                                        |              |                 |                                                                                          |
| RIGHT           |        快进                                     |              |                 |                                                                                          |
| LEFT            |       快退                                        |              |                 |                                                                                          |
| WHEEL_UP        |      音量 +                                             |              |                 |                                                                                          |
| WHEEL_DOWN      |      音量 -                                                  |              |                 |                                                                                          |
| UP              |       音量 +                                                       |              |                 |                                                                                          |
| DOWN            |       音量 -                                                              |              |                 |                                                                                          |
| v               |        声音 100                                                                    |              |                 |                                                                                          |
| m               |            静音                                                                       |              |                 |                                                                                          |
| Ctrl+Shift+p    |         打开命令面板                                                           |   ESC           | command_palette |                                                                                          |
| Ctrl+p          |                  打开播放列表                                                                     |   ESC           | playlistmanager |                                                                                          |
| Ctrl+s          |                  保存播放列表                                                                     |   ESC           | playlistmanager |                                                                                          |
| Ctrl+o          |       打开文件管理器                                                                                |  ESC            | file_browser    |                                                                                          |
| ALT+o           |        输入指定路径                                                                               |   ESC           | file_browser    |                                                                                          |
| MBTN_RIGHT                |   右键定制菜单                                                                                    |              |   mpv-menu-plugin              |                                                                                          |

#### 6.2.2. 快捷键补充说明

##### 6.2.2.1. 快捷键官方内建方案屏蔽

你可以直接在 **mpv.conf** 内使用 `--no-input-default-bindings` 参数完全屏蔽 [内建的方案](https://github.com/mpv-player/mpv/blob/master/etc/input.conf)，从而省去逐个参数 `ignore` 依次屏蔽各个按键的步骤。
（注意该参数同样会屏蔽外部脚本的初始快捷键方案，如果你不想外部脚本受影响，那么就使用另一个参数 `--no-input-builtin-bindings` ）

##### 6.2.2.2. input.conf

[快捷键自定义与控制台 - mpv_CFanStation](https://hooke007.github.io/unofficial/mpv_input.html)

**几个常见的修改命令：**

设置某个属性为某个值，用 `set <属性名> <值>`
增减某个属性的数值，用 `add <属性名> <数值>`
乘以某个属性的数值，用 `multiply <属性名> <数值>`
使某属性在可变的多个值中切换，用 `cycle <属性名>`
使某属性在你指定的多个值中切换，用 `cycle-values <属性名> <必要值1> <必要值2> [可选值3] …`
应用某个配置：`apply-profile <配置名> [<模式>]`
显示某个属性当前值：`show-text "${属性名}"`
以上用途的汇总示例：

```
w   set volume 100                        # 设定音量为100
e   add saturation 1                      # 增加饱和度 1
r   add hue -2                            # 减少色相 2
t   multiply speed 1/1.1                  # 减速
y   multiply speed 2                      # 倍速
u   cycle fullscreen                      # 切换 全屏
i   cycle-values hwdec yes no auto-copy   # 切换解码模式
```

### 6.3. 脚本

#### 6.3.1. 普通脚本

> 下方脚本全部针对个人使用进行了自定义，详细看配置，其中 uosc 控制按钮做了很多改动！

| 普通脚本                                                                                    | 说明                                                                           | 部分自定义内容说明（*详看配置文件*）                                                                                                                                                                                                               | 状态 | 本地更新时间 | 版本   | 依赖                                                                                                                                                                                                                                                                                                                   |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [uosc](https://github.com/tomasklaen/uosc)                                                  | OSC+Menu，若卡顿添加配置 `video-sync=display-resample`                         | 界面控制按钮调整                                                                                                                                                                                                                                   | ✅   | 2025-05-01   | 5.8.0  | 配置`/portable_config/script-opts/uosc.conf` ，字体`/portable_config/fonts/uosc*.*`                                                                                                                                                                                                                                    |
| [thumbfast](https://github.com/po5/thumbfast)                                               | 进度条缩略图预览                                                               | 无大改动                                                                                                                                                                                                                                           | ✅   | 2025-05-01   | -      | 配置`/portable_config/script-opts/thumbfast.conf`                                                                                                                                                                                                                                                                      |
| [recent-menu](https://github.com/natural-harmonia-gropius/recent-menu)                      | 最近播放菜单                                                                   | 修改记录存储路径                                                                                                                                                                                                                                   | ✅   | 2024-12-27   |        |                                                                                                                                                                                                                                                                                                                        |
| [command_palette](https://github.com/stax76/mpv-scripts?tab=readme-ov-file#command_palette) | 命令面板                                                                       | 无大改动                                                                                                                                                                                                                                           | ✅   | 2025-05-01   | -      | 配置`/portable_config/script-opts/command_palette.conf`，拓展脚本[`/script-modules/extended-menu.lua`](https://github.com/Seme4eg/mpv-scripts/blob/master/script-modules/extended-menu.lua)，最近播放依赖 [recent-menu](https://github.com/natural-harmonia-gropius/recent-menu)                                       |
| [Mpv-Playlistmanager](https://github.com/jonniek/mpv-playlistmanager)                       | 播放列表管理，部分功能和 autoload 重复。                                       | 修改配色, 修改动态绑定键位                                                                                                                                                                                                                         | ✅   | 2025-05-01   | -      | 配置`/portable_config/script-opts/playlistmanager.conf`，[旧版](https://github.com/kkeenee/jonniek-mpv-playlistmanager/tree/master)播放列表存储的时候依赖[playlistmanager-save-interactive.lua](https://github.com/jonniek/mpv-playlistmanager/blob/master/playlistmanager-save-interactive.lua)，当前版本已不在使用。 |
| [autoload](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua)            | 自动加载同级别目录文件作为播放列表                                             | 排除图片                                                                                                                                                                                                                                           | ✅   | 2025-05-01   | -      | 配置`/portable_config/script-opts/autoload.conf`                                                                                                                                                                                                                                                                       |
| [file-browser](https://github.com/CogentRedTester/mpv-file-browser)                         | 允许用户完全从 mpv 中浏览和打开文件和文件夹。                                  | 根目录配置独立在：`file-browser-root.json`                                                                                                                                                                                                         | ✅   | 2025-05-01   | -      | 配置`/portable_config/script-opts/file_browser.conf`，用户输入依赖 [user-input](https://github.com/CogentRedTester/mpv-user-input)，启用自定义 [动态快捷键](https://github.com/CogentRedTester/mpv-file-browser/blob/master/docs/custom-keybinds.md) 配置，使用的 Addons   *见下方*                                    |
| [mpv-menu-plugin](https://github.com/tsl0922/mpv-menu-plugin)                               | 基于 menu.dll 的菜单插件实现增强性的动态菜单（依赖 menu.dll），兼容 uosc       | [基于官方的上下文菜单](https://hooke007.github.io/official_man/mpv.html#id6)，需要添加键绑定以执行 `context-menu` 命令（设置鼠标右键）, 基于该 [配置](https://gist.github.com/tsl0922/8989aa32994b0448a2652ee260348a35) 修改并屏蔽所有内置快捷键。 | ✅   | 2024-12-28   | 2.4.1  | 插件文件<br>`/portable_config/scripts/dialog.lua`、<br> `/portable_config/scripts/menu.dll`、<br>`/portable_config/scripts/dyn_menu.lua`，<br>最近播放依赖 [recent-menu](https://github.com/natural-harmonia-gropius/recent-menu)                                                                                      |
| [Tony15246/uosc_danmaku](https://github.com/Tony15246/uosc_danmaku)                         | 在MPV播放器中加载弹弹play弹幕，基于 uosc UI框架和弹弹play API的mpv弹幕扩展插件 |                                                                                                                                                                                                                  | ✅   | 2025-05-02   | v1.3.1 |                                                                                                                                                                                                                                                                                                                        |

#### 6.3.2. API 脚本

| API 脚本                                                         | 说明                         | 状态 | 本地更新时间 | 依赖 |
| --------------------------------------------------------------- | ---------------------------- | ---- | ------------ | ---- |
| [user-input](https://github.com/CogentRedTester/mpv-user-input) | 用于请求文本用户输入的 API。 | ✅   | 2024-12-27   |  [script-modules/user-input-module.lua](https://github.com/CogentRedTester/mpv-user-input/blob/master/user-input-module.lua)    |

#### 6.3.3. file-browser Addons 说明

[Addon List · CogentRedTester/mpv-file-browser Wiki](https://github.com/CogentRedTester/mpv-file-browser/wiki/Addon-List)

> [!warning]
> **作者提供的部分 Addon 存在报错，问题没有排查，推荐需要那个 Addon 就下载那个 addon！！**

| Addon                                                                                                   | 说明                                                                                              | 状态 | 本地更新时间 | 快捷键                                                          |
| ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | ---- | ------------ | --------------------------------------------------------------- |
| [favourites.lua](https://github.com/CogentRedTester/mpv-file-browser/blob/master/addons/favourites.lua) | 收藏夹                                                                                            | ✅   | 2024-12-27   | `F`：收藏、取消收藏 </br>`Ctrl+UP`：上移 </br>`Ctrl+DOWN`：下移 |
| [dvd-browser](https://github.com/CogentRedTester/mpv-dvd-browser)                                       | DVD 浏览                                                                                           | ❌   |              |                                                                 |
| [root.lua](https://github.com/CogentRedTester/mpv-file-browser/blob/master/addons/root.lua)             | 根文件夹，`file-browser-root.json` 会覆盖 `file_browser.conf`，建议全设置在 `file-browser-root.json`，</br>[格式说明](https://github.com/CogentRedTester/mpv-file-browser/blob/master/docs/addons.md#the-list-array), 注意 ass 标签的颜色是 16 进制的蓝绿红 (BGR A8F8FF)，而不是普通的红绿蓝 (RGB FFF8A8)。</br>WIN 共享路径设置示例：`"path": "//lg-gram/Movie/"` | ✅   |   2024-12-27           |                                                                 |

### 6.4. TODO

- [x] 启动静音
- [x] 初始窗口尺寸控制
- [x] up、down 控制音量
- [x] 鼠标左键双击暂停、播放
- [x] 回车全屏
- [x] HDR
- [x] ctrl+shitf+p：命令输入（同步 ob 等习惯）
- [x] ctrl+p：播放列表（同步 ob 等习惯）
- [x] wasapi 独占模式
- [x] 弹幕功能

## 7. HDR

**开启 HDR 显示器硬件最低标准参考：**
- HDR ≥ HDR600
- 有相关 HDR 认证。

### 7.1. 相关配置参数

**个人小白，相关参数目前不了解，下方内容设置后倒是可以直观看到效果，但如何设置才是最优解未知！！！**

#### 7.1.1. HDR 直通

> Windows 一般需手动切换显示器 HDR 模式（Windows 的限制）
> HDR 直通时需禁用 `--icc-profile`、`--icc-profile-auto`，-`-target-trc` 需要使用 auto 或 pq 值。

##### 7.1.1.1. 个人配置

基于 [dyphire/mpv-config](https://github.com/dyphire/mpv-config) 设置：

```bash
# dyphire/mpv-config 默认禁用
--icc-profile=""
# dyphire/mpv-config 默认禁用
--icc-profile-auto=no

## 一般只要修改下方几个参数，可设置快捷键、右键菜单，命令输入。

# 开启HDR直通 
--target-colorspace-hint=yes
# 指定显示器的转换特性（伽玛） auto pq，看情况设置
--target-trc=pq
# 指定输出显示器的测量峰值亮度，单位是cd/m^2（又名尼特） 根据显示器的亮度调整到自己舒适的 auto 100 203 300 400 500
--target-peak=100

#####下方是在 mpv.conf配置参考
[HDR_PASS_ON]
profile-desc=开启HDR直通
# icc-profile=""        # 在启动时候 profile=Target 中已经设置
# icc-profile-auto=no   # 在启动时候 profile=Target 中已经设置
target-colorspace-hint=yes
target-trc=pq
target-peak=100

[HDR_PASS_OFF]
profile-desc=关闭HDR直通
# icc-profile=""        # 在启动时候 profile=Target 中已经设置
# icc-profile-auto=no   # 在启动时候 profile=Target 中已经设置
target-colorspace-hint=no
target-trc=gamma2.2
target-peak=auto
```

##### 7.1.1.2. 参数说明

[官方相关参数说明](<[mpv.io](https://mpv.io/manual/master/#options-target-trc)>)：

```bash
--icc-profile=<file>

加载一个ICC profile，并使用它来转换视频RGB到屏幕输出。需要LittleCMS 2的编译支持。它覆盖了 `--target-prim`, `--target-trc` 和 `--icc-profile-auto` 选项。

--icc-profile-auto
自动选择当前由操作系统的显示设置指定的ICC显示profile。
注意：在Windows上，默认profile必须是一个ICC profile。不支持WCS profiles。
使用libmpv和渲染API的应用程序需要通过 `MPV_RENDER_PARAM_ICC_PROFILE` 提供ICC profile。

--target-colorspace-hint
如果可能的话，自动设置显示器的输出色彩空间，来传递流的输入值（例如，用于HDR直通）。需要一个支持的驱动程序和 `--vo=gpu-next`

--target-trc=<value>
指定显示器的转换特性（伽玛）。当不使用ICC色彩管理时，视频色彩将被调整到此曲线。有效值是：
	auto
		禁用任何适应，除了非典型的转换。具体来说，HDR或线性光源材料会自动转换为伽玛2.2，而SDR内容则不被触及（默认）
	bt.1886
		ITU-R BT.1886曲线（假定对比度为无限）
	srgb
		IEC 61966-2-4（sRGB）
	linear
		线性亮度输出
	gamma1.8
		纯功率曲线（伽玛1.8），也被用于苹果RGB
	gamma2.0
		纯功率曲线（伽玛2.0）
	gamma2.2
		纯功率曲线（伽玛2.2）
	gamma2.4
		纯功率曲线（伽玛2.4）
	gamma2.6
		纯功率曲线（伽玛2.6）
	gamma2.8
		纯功率曲线（伽玛2.8），也被用于BT.470-BG
	prophoto
		ProPhoto RGB (ROMM)
	pq
		ITU-R BT.2100 PQ（感知量化器）曲线，又名SMPTE ST2084
	hlg
		ITU-R BT.2100 HLG（混合对数伽马）曲线，又名ARIB STD-B67
	v-log
		松下V-Log（VARICAM）曲线
	s-log1
		索尼S-Log1曲线
	s-log2
		索尼S-Log2曲线
	备注
		当使用HDR输出格式时，mpv将按照指定的曲线进行编码，但它不会设置任何HDMI标志或其它信号，这些信号可能是目标设备正确显示HDR信号所需的。用户在使用这些信号格式进行显示之前，应该独立保证这一点。

--target-peak=<auto|nits>
指定输出显示器的测量峰值亮度，单位是cd/m^2（又名尼特）。这个亮度的解释取决于设置的 `--target-trc` 。在所有情况下，它对将被发送到显示器的信号值施加了一个限制。如果信号源超过了这个亮度水平，将插入一个色调映射滤镜。对于HLG来说，它还有一个额外的作用，就是对逆向OOTF进行参数化，以便获得与母版显示器一致的色度结果。对于SDR，或者当使用ICC profile（ `--icc-profile` ）时，将其设置为高于203的值，基本上会使显示器被视为变相的HDR显示器。（参见下方的注意）
在 `auto` 模式下（默认），所选择的峰值是基于使用中的TRC的一个适当的值。对于SDR曲线，它使用203。对于HDR曲线，它使用203 \* 转换函数的额定峰值。
备注
当使用SDR转换函数时，通常不需要这样做，而且设置它可能会导致非常意外的结果。 *它* 有用的一个场景是如果你想用传统的转换函数和校准设备来校准HDR显示器。在这种情况下，你可以将你的HDR显示器设置为高亮度，如800cd/m^2，然后将其校准到一个标准曲线，如gamma2.8。将这个值设置为800，然后指示mpv将其作为一个具有给定峰值的HDR显示器。在不可能向显示器输入PQ或HLG的环境中，这可能是一个很好的选择，并且使mpv有可能使用HDR显示，而不管操作系统是否支持HDMI HDR元数据。
在这样的设置中，我们强烈推荐将 `--tone-mapping` 设置为 `mobius` 或甚至 `clip`

# --------

video-out-params
	与 `video-params` 相同，但在视频滤镜被应用后。如果没有使用视频滤镜，这将包含与 `video-params` 相同的值。请注意，这仍然不一定是视频窗口所使用的，因为用户可以改变窗口的大小，所有真正的视频输出驱动都独立于滤镜链而自行缩放。
	拥有与 `video-params` 相同的子属性。

video-params
视频参数，由解码器输出（和覆写的例如应用的长宽比等）。这有一系列子属性：
	`video-params/max-luma`
		HDR10 元数据报告的最高亮度（单位：cd/m²）
```

[dyphire/mpv-config](https://github.com/dyphire/mpv-config) 部分补充说明：

```bash
#target-trc=gamma2.2                  # 指定显示屏的传输特性（伽马），未使用 icc 色彩管理时生效。默认值 auto：在--vo=gpu 下 hdr 下使用 gamma2.2，sdr 下不做处理；在--vo=gpu-next 下始终使用 bt.1886 曲线（假设无限对比度，即 oled）

                                      # 建议非 oled 和 hdr 的显示器始终使用 gamma2.2 曲线，避免 mpv 画面过暗。hdr 直通时此项需使用 auto 或 pq 值


#target-peak=auto                     # <auto|nits> 指定输出显示器的测量峰值亮度。受--target-trc 参数影响，默认值 auto：根据 trc 参数使用适当值，sdr 默认为 203，hdr 下建议根据实际显示效果指定具体 nits 值
                                      # 当使用 icc 色彩管理时，若 nits 设置为高于默认值（203），显示器将被 mpv 视为 hdr 屏处理
                                      # --vo=gpu-next 下尽可能不要修改此参数避免画面表现异常
```

### 7.2. 设置参考

- [HDR 转 SDR 的优化方案 · hooke007/MPV_lazy · Discussion #272](https://github.com/hooke007/MPV_lazy/discussions/272)
- [natural-harmonia-gropius/hdr-toys](https://github.com/natural-harmonia-gropius/hdr-toys)(着色器)
- [0_FAQ · hooke007/MPV_lazy Wiki](https://github.com/hooke007/MPV_lazy/wiki/0_FAQ#hdr%E8%BD%ACsdr%E8%89%B2%E8%B0%83%E6%98%A0%E5%B0%84%E6%97%B6%E7%9A%84%E7%94%BB%E9%9D%A2%E4%BA%AE%E5%BA%A6%E9%97%AA%E7%83%81)
- [如何拯救残废的HDR？ · hooke007/MPV_lazy · Discussion #345](https://github.com/hooke007/MPV_lazy/discussions/345)
- [HDR相关的初次配置 求大佬指导 · dyphire/mpv-config · Discussion #26](https://github.com/dyphire/mpv-config/discussions/26)

## 8. 教程

- 官方：[mpv.io](https://mpv.io/manual/master/#synopsis)
- hooke007：[mpv播放器的使用引导 - mpv_CFanStation](https://hooke007.github.io/unofficial/mpv_start.html) | [0_FAQ · hooke007/MPV_lazy Wiki](https://github.com/hooke007/MPV_lazy/wiki/0_FAQ) | [资源、教程集合](https://hooke007.github.io/index2#mpvnetcm)
- [Mathematically Evaluating mpv's Resampling Algorithms](https://artoriuz.github.io/blog/mpv_upscaling.html)
