# GTA:SA 崩溃修复 ASI（gtasa_crashfix 中文定制版）

> 本仓库 fork 自 [Whitetigerswt/gtasa_crashfix](https://github.com/Whitetigerswt/gtasa_crashfix)（v2.52）。
> 原作者已停止维护，本定制版在保留全部原版功能的基础上做了如下改动：
>
> 1. **彻底移除联网自动更新**（不再启动时访问 GitHub、不再下载替换自身）；
> 2. 提供中文文档与中文配置说明；
> 3. 可用新版 Visual Studio（v143 工具集）直接编译。

---

## 1. 功能简介

这个 ASI 插件为 GTA: San Andreas（含 SA-MP 0.3.7）提供：

- 修复约 30 种游戏内可能出现的崩溃（行人、载具、遥控炸药、室内等）；
- 支持**任意分辨率和宽高比**；
- **Alt + Enter** 一键切换窗口化 / 全屏；
- 暂停菜单中游戏继续运行（SA-MP 不会因暂停而停止同步）；
- 允许同时启动多个 `gta_sa.exe`（双开 / 多开）；
- 移除室内音乐、云层（提升 FPS）；
- 可关闭部分帧率限制代码以提升帧率；
- 内置 Deji 的 StreamIni 扩展；
- 内置 Ryosuke839 的快速加载（fastloader），带 SA-MP 启动参数时加载明显加快。

## 2. 环境要求

- GTA: San Andreas（1.0 US 版本）；
- ASI Loader（如 [Ultimate ASI Loader](https://github.com/ThirteenAG/Ultimate-ASI-Loader)）；
- SA-MP 0.3.7（如用于联机）。

## 3. 安装与部署

1. 把编译得到的 `crashes.asi` 复制到游戏根目录，或根目录下的 `scripts\` 文件夹；
2. 确保 ASI Loader 已安装；
3. 启动游戏（`gta_sa.exe` 或 `samp.exe` 均可）；
4. 首次运行会在 **asi 所在目录**自动生成配置文件：
   - `crashes.cfg` —— 配置文件；
   - `crashes.cfg_readme.txt` —— 原版英文配置说明（可删除）。

> 注意：游戏根目录和 `scripts\` 目录中**不要同时放置两份** `crashes.asi`，否则等于双重加载，进游戏会崩溃。

## 4. 编译

工程文件：`crashes\crashes.sln`，仅需编译 `Release | Win32`。

原工程绑定的是 v141_xp 工具集 + Windows SDK 8.1。在只装了新版 VS 的机器上，用 MSBuild
命令行覆盖工具集即可，无需修改工程文件：

```powershell
& "D:\ProgramFiles\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" `
  ".\crashes\crashes.sln" `
  /t:Rebuild /p:Configuration=Release /p:Platform=Win32 `
  /p:PlatformToolset=v143 `
  /p:WindowsTargetPlatformVersion=10.0.26100.0 `
  /m /v:minimal
```

编译产物：`crashes\Release\crashes.asi`。

也可以直接用 Visual Studio 2022 打开解决方案，在弹窗中选择"重定解决方案目标"
（升级工具集与 SDK）后编译。

> 编译时可能出现警告 C4819（`RenderWare.h` 含非当前代码页字符），不影响使用。

## 5. 配置说明（crashes.cfg）

配置文件为纯文本，每行格式为 `配置项 值`（空格分隔），修改后**重启游戏**生效。
下表为首次运行生成的默认值与逐项说明：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `brightness` | -1 | 亮度微调，可调范围比游戏内亮度滑条更大。**-1 = 跟随游戏内亮度设置**；同时修复 Win8 下亮度不生效的问题。仅当游戏内拉满仍不够亮、或需要更精细调节时才改为具体数值 |
| `mousefix` | 0 | 修复部分系统（原版主要针对 Win8）Alt+Tab 后游戏画面上残留 Windows 鼠标指针的问题。无此问题保持 0 |
| `shadows` | 0 | 体积阴影（实时阴影）开关：`0` 关闭、`1` 开启。关闭后可在保持高 FX 画质的同时明显提升帧率 |
| `heathaze` | 0 | 热浪效果（远处画面扭曲）：`0` 关闭、`1` 开启 |
| `sound` | 1 | 游戏声音：`0` = 禁用全部游戏音效，`1` = 正常 |
| `vehiclelighting` | 1 | 车辆灯光：`0` 关闭、`1` 开启 |
| `specularvehicle` | 1 | 车辆镜面高光反射：`0` 关闭、`1` 开启 |
| `targetblip` | 1 | 瞄准时行人头顶的目标标记：`0` 不显示、`1` 显示 |
| `clouds` | 0 | 天空云层：`0` 关闭（可提升 FPS）、`1` 开启 |
| `flashes` | 0 | 闪光效果（闪电/枪口环境光等）：`0` 关闭、`1` 开启 |
| `fixblackroads` | 1 | 设为 `1` 修复部分电脑上远处道路发黑的问题 |
| `interiorreflections` | 1 | 室内反射效果：`0` 关闭、`1` 开启 |
| `fpslimit` | 0 | 设为 `1` 移除 SA-MP 客户端内部约 90/100 FPS 的帧率限制。**原版作者注明：在较新的 SA-MP 版本上可能引发问题**，出现异常请改回 `0` |
| `nopostfx` | 0 | 设为 `1` 禁用后期处理特效 |

默认配置文件内容如下，可直接参考：

```text
brightness -1
mousefix 0
shadows 0
heathaze 0
sound 1
vehiclelighting 1
specularvehicle 1
targetblip 1
clouds 0
flashes 0
fixblackroads 1
interiorreflections 1
fpslimit 0
nopostfx 0
```

## 6. 常见问题

| 问题 | 处理 |
|---|---|
| 杀毒软件报毒 | ASI 注入类插件常被杀软误报，加白名单即可 |
| 进游戏秒崩 | 检查游戏根目录和 `scripts\` 是否同时存在两份 `crashes.asi`；并确认游戏版本为 1.0 US |
| 提示找不到 Windows SDK 8.1 | 按本文第 4 节用 `/p:WindowsTargetPlatformVersion` 指定本机已装的 SDK 版本，或在 VS 中重定解决方案目标 |
| 无法生成 crashes.cfg | 以管理员身份运行游戏一次，或检查游戏目录写入权限 |
| 开启 `fpslimit 1` 后异常 | 改回 `0`，部分 SA-MP 版本与解除帧率限制不兼容 |

## 7. 致谢与许可

- 原作者：[Whitetigerswt](https://github.com/Whitetigerswt/gtasa_crashfix)
- 主要代码源自 MTA 团队：[multitheftauto/mtasa-blue](https://github.com/multitheftauto/mtasa-blue)
- 其他贡献者：Deji、0x688、Ryosuke839、bartekdvd
- 本项目沿用原仓库许可（见 [LICENSE](LICENSE)），仅供学习研究使用。
