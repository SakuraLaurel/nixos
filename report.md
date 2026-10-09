# NixOS 配置体检报告（laurel / sakura）

> 审阅日期：2026-10-09
> 审阅范围：仓库内全部 23 个文件（flake、系统模块、home-manager、nixvim）
> 审阅方式：只读了代码。当前机器没有安装 nix，所以**没有实际跑过 `nix flake check` 或构建**，下文结论都来自读代码和对照 nixpkgs 源码。

---

## 总评

| 维度 | 评分 | 一句话 |
| --- | --- | --- |
| **新** | ★★★☆☆ | 跟的是 unstable、最新内核、Plasma 6、Python 3.14、Node 26，路线够新；但 `flake.lock` 停在 **2026-06-26**，已经落后三个半月 |
| **潮** | ★★★☆☆ | nixvim 部分很潮（blink.cmp、conform、原生 `lsp` 模块、Copilot NES）；系统层还停留在“能用”的写法：没用 nh、direnv、nix-flatpak、密钥管理、disko，也没有 btrfs 快照 |
| **合理** | ★★★☆☆ | 整体结构清楚，可读性好。有几处**真问题**：/boot 可能被内核塞满、字体把繁体排在简体前、nvim 键位覆盖了内置功能、clangd 写死了路径、SSH 对外开放密码登录 |

**结论**：作为个人桌面配置已经合格，nixvim 部分明显花了心思。下面「必须修」里的 6 条建议尽快处理；「潮流升级」里的按兴趣挑。

---

## 一、必须修（影响稳定性、正确性或安全）

### 1. `/boot` 迟早会被塞满
`system.nix` 里用的是 `linuxPackages_latest` 和 `systemd-boot`，但没有限制保留多少个启动项。unstable 加最新内核，几乎每次更新都会往 ESP 里放一份新内核和 initrd。`nix.gc` 只会清理 14 天前的代，更新频繁时 ESP（通常 512MB 到 1GB）照样会满，满了之后 `nixos-rebuild` 直接失败。

```nix
boot.loader.systemd-boot.configurationLimit = 10;
```

### 2. 字体顺序：繁体排在简体前面
`software.nix` 的 `defaultFonts` 里，`Noto Sans CJK TC` 排在 `SC` 前面。fontconfig 会优先用 TC 字形渲染汉字，于是简体中文会出现台湾地区的字形写法（比如「骨」「次」「令」这类字的部件不一样）。对大陆用户来说，这几乎肯定不是想要的效果。

```nix
sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Color Emoji" ];
# serif、monospace 两组也同样把 SC 放到 TC 前面
```

### 3. nvim 键位冲突（`home/nixvim/lsp.nix`、`keymaps.nix`）
| 键 | 问题 |
| --- | --- |
| `gt` | 覆盖了 Vim 内置的“切换到下一个标签页” |
| `gi` | 覆盖了内置的“回到上次插入位置并进入插入模式” |
| `gr` | Neovim 0.11+ 默认已有 `grr`、`grn`、`gra`、`gri`、`grt` 一组映射。再把 `gr` 单独映射掉，每次按 `gr` 都要等 `timeoutlen` 的 400ms 才会触发，而且会和这组默认映射打架 |
| `<leader>r` 和 `<leader>rn` | 前缀冲突。`<leader>r`（运行 Python）每次都要等 400ms 才执行 |

建议：直接用 Neovim 0.11 的默认 LSP 映射，把自定义的 `gr`、`gi`、`gt`、`K`、`<leader>rn`、`<leader>ca` 删掉，只保留 `gd` 和 `gD`。运行 Python 改成 `<leader>rp` 之类不冲突的键。

### 4. clangd 写死了 `--compile-commands-dir=build`
clangd 本来就会在每一级父目录及其 `build/` 子目录里找 `compile_commands.json`。写死这个参数后，`compile_commands.json` 在项目根目录或 `out/`、`cmake-build-*` 下的项目反而会找不到。**删掉这一行即可。**

### 5. SSH 对外开放并允许密码登录
`openssh.enable = true` 会默认打开防火墙的 22 端口，再加上 `PasswordAuthentication = true`，等于把密码登录暴露在局域网（甚至公网）上。同时这台机器还开了自动登录、关了锁屏。

- 如果平时不用 SSH 登录这台机器：直接 `services.openssh.enable = false;`
- 如果要用：配好公钥，然后

```nix
users.users.sakura.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
services.openssh.settings = {
  PasswordAuthentication = false;
  KbdInteractiveAuthentication = false;
};
```

### 6. home-manager 的 flatpak 激活脚本可能让整个 HM 激活失败
`home/sakura.nix` 里的 `home.activation.addUserFlathub`：
- 写成了普通字符串，没有用 `lib.hm.dag.entryAfter [ "writeBoundary" ]` 指定执行顺序；
- `remote-add` 需要联网下载 `.flatpakrepo`。作为 NixOS 模块使用时，HM 会在开机时通过 `home-manager-sakura.service` 激活，这时网络可能还没好（而且你关掉了 `wait-online`）。一旦这条命令失败，**整个 HM 激活都会失败**。

最低限度的修法：

```nix
home.activation.addUserFlathub = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  run ${pkgs.flatpak}/bin/flatpak --user remote-add --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo || true
  run ${pkgs.flatpak}/bin/flatpak --user remote-modify flathub \
    --url=https://mirrors.ustc.edu.cn/flathub || true
'';
```

更好的做法见下文「潮流升级 → nix-flatpak」。

---

## 二、建议改（合理性、一致性）

### 系统层

1. **只放了公钥、没配对应的源**：`system.nix` 的 `trusted-public-keys` 里有 `nix-community.cachix.org` 的公钥，但 `substituters` 里没有这个缓存，这个公钥目前不起作用。要么加上 `https://nix-community.cachix.org`（nixvim 等社区包能少编译一些），要么把公钥删掉。
2. **`auto-optimise-store = true`**：每次构建都会同步做硬链接去重，会拖慢构建。现在更常见的做法是定时去重：
   ```nix
   nix.settings.auto-optimise-store = false;
   nix.optimise.automatic = true;
   ```
3. **纯 flake 系统可以关掉 channel**：`nix.channel.enable = false;`，避免 `nix-channel` 和 flake 并存造成困惑。
4. **网络栈和 Plasma 不配套**：现在用的是 `systemd-networkd` 加 `iwd`。我核对了 nixpkgs 的 `plasma6.nix`：只有开启 NetworkManager 时才会装 `plasma-nm`，所以**托盘里没有网络小部件**，连 Wi-Fi 只能用 `iwctl`。README 里装机用的也是 `nmcli`。桌面机更顺手的写法是：
   ```nix
   networking.networkmanager = { enable = true; wifi.backend = "iwd"; };
   # 同时去掉 systemd.network / wireless.iwd 的手写配置
   users.users.sakura.extraGroups = [ "networkmanager" ];
   ```
   如果你就是喜欢 networkd 的极简风格，保持现状也没问题，但要知道这是有代价的。
5. **`services.xserver.enable = true` 可以删**：SDDM 用的是 Wayland，Plasma 6 模块本身就会开启 `programs.xwayland`，不需要整个 X server。
6. **fcitx5 的插件重复了**：`fcitx5-with-addons` 已经默认带上 `fcitx5-gtk` 和 Qt5、Qt6 的 `fcitx5-qt`（已核对 nixpkgs 源码），`addons` 里只保留 `fcitx5-chinese-addons` 即可。可以再加词库：`fcitx5-pinyin-zhwiki`、`fcitx5-pinyin-moegirl`。
7. **btrfs 挂载选项不一致**：`system.nix` 给 `/`、`/home`、`/nix` 都加了 `compress=zstd:3,noatime`，唯独 `/var/log` 没加（README 手动挂载时是加了的）。建议补上，保持一致。
8. **用户组**：
   - `audio`、`video` 在 PipeWire 加 logind（uaccess）的环境下已经不需要；
   - `input` 组让该用户的**任何进程**都能读取全部键盘输入，相当于开了键盘记录的口子。除非有具体工具需要，建议去掉。
9. **root 和 sakura 共用一份密码哈希**：`users.nix` 里 root 也指向 `sakura-password-hash`，但 `.gitignore` 里写了 `root-password-hash`，看起来原本打算分开。有 sudo 的话，推荐直接锁住 root：`users.users.root.hashedPassword = "!";`
10. **密码文件放在 `/etc/nixos/`，配置却在 `~/nixos`**：在 `mutableUsers = false` 的前提下，只要这个文件丢了（重装、换盘、忘了拷），就**登录不进系统**。参见下文「sops-nix / agenix」。
11. **`zramSwap.memoryPercent = 100` 可以保留**，但建议配上 zram 推荐的内核参数：
    ```nix
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
    ```
12. **`LC_MESSAGES = zh_CN` 而 `LANG = en_US`**：命令行工具会输出中文，Plasma 界面语言却由 `LANGUAGE` 或 KDE 设置决定，可能出现中英混杂。确认这是你想要的效果就行。
13. **代理只设了小写变量**：`proxy-on` 只导出了 `http_proxy`/`https_proxy`。有些程序只认大写变量或 `all_proxy`，最好也补上 `no_proxy=localhost,127.0.0.1`。另外 `nix-daemon` 不会继承 shell 里的代理，需要单独配置：
    ```nix
    systemd.services.nix-daemon.environment = { https_proxy = "http://127.0.0.1:7890"; };
    ```
    （前提是 mihomo 作为系统服务启动，见下文。）
14. **Intel 显卡**：
    - 如果是 Lunar Lake、Battlemage 或更新的平台，驱动是 `xe` 而不是 `i915`；
    - 11 代及以后的核显想用 QSV 硬件编码，需要在 `extraPackages` 里加 `vpl-gpu-rt`；想用 OpenCL 加 `intel-compute-runtime`。
15. **`nodejs_26` 写死了版本号**：可以改用 `pkgs.nodejs`（跟随 nixpkgs 的默认 LTS），省得以后手动升级。

### 结构和代码风格

16. **文件命名**：根目录的 `shell.nix` 按惯例是 `nix-shell` 的开发环境入口，放 alias 容易让人误会，建议改名为 `aliases.nix`。现在一部分模块在 `config/` 里，另一部分（`graphic.nix`、`system.nix`、`software.nix`、`users.nix`）在根目录，不太统一。建议的结构：
    ```
    flake.nix
    hosts/laurel/{default.nix,hardware-configuration.nix}
    modules/nixos/{desktop,locale,network,graphics,nix,users,fonts}.nix
    home/{default.nix,plasma.nix,konsole.nix,nixvim/...}
    ```
17. **显卡切换靠注释代码**（`graphic.nix` 里注释掉了一段 AMD 配置）：可以改成自定义选项 `my.gpu = "intel";` 加 `lib.mkIf`，或者拆成 `graphics/intel.nix`、`graphics/amd.nix` 两个文件按需 import。
18. **格式不统一**：`home/plasma.nix` 第 18、26 行混用了 Tab；`shell.nix` 第 21 行缩进不对。建议在 flake 里加 formatter，统一跑 `nix fmt`：
    ```nix
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    ```
19. **`flake.nix` 可以更现代一些**：
    - `hardware-configuration.nix` 里已经设置了 `nixpkgs.hostPlatform`，`system = "x86_64-linux"` 可以删；
    - 加上 `specialArgs = { inherit inputs; };`，以后在模块里引用 inputs 更方便；
    - 加上 `home-manager.backupFileExtension = "hm-bak";`。plasma-manager 经常因为“文件已存在、会被覆盖”而导致激活失败，设置后会先把旧文件备份再覆盖。
20. **`system.stateVersion = "26.11"`，而 `home.stateVersion = "26.05"`**：两者不一致本身没有害处。这里只是提醒一句：**stateVersion 应该保持安装时的值，不要随系统升级去改**。如果 26.11 是 `nixos-generate-config` 生成的就别动；如果是手动改上去的，最好查一下当初装机时的值。
21. **提交信息**：最近大量提交写的是 `update`、`暂存`，以后回滚时很难定位。建议至少写清楚改了哪个模块，例如 `nixvim: 调整 copilot 键位`。

### nixvim

22. **`dap` 开了但没有任何键位，也没有 UI**，实际上用不起来。建议加上 `dap-ui` 或 `dap-view`，以及 `<F5>`、`<leader>db` 等常用键位。
23. **telescope 没开 fzf-native**：`plugins.telescope.extensions.fzf-native.enable = true;`，大仓库里搜索会快不少。
24. **格式化工具没打包进 nvim**：`clang-format` 来自 home.packages 里的 `clang-tools`，`ruff` 也来自 home.packages。换个环境、或者这些包从 home.packages 移走后，格式化就会悄悄失效。可以把它们放进 `programs.nixvim.extraPackages`，或者打开 conform-nvim 的 `autoInstall.enable`。
25. **Copilot 的 `filetypes` 里写了 `rust`**，但没有配 rust-analyzer 和 rust 的 treesitter 语法。要么补上，要么把 rust 去掉。
26. **`hide_during_completion` 和自定义的 BlinkCmp 自动命令功能重复**：前者是给 nvim-cmp 设计的，用 blink 时可以删掉，只保留你手写的自动命令就够了。

---

## 三、潮流升级（2026 年的 NixOS 玩家在用什么）

按“收益 / 成本”从高到低排列：

| 推荐 | 解决什么问题 | 替换掉的东西 |
| --- | --- | --- |
| **`programs.nh`** | `nh os switch` 构建时显示漂亮的进度树，结束后用 nvd 显示版本差异；`nh clean` 智能清理旧代 | `nrs`、`ncg` 两个 alias 和 `nix.gc` |
| **direnv + nix-direnv** | 每个项目自带 devShell，进入目录自动加载 | 全局安装的 `gcc`、`clang-tools`、`python314.withPackages`（全局 Python 环境很容易版本打架） |
| **nix-flatpak**（gmodena） | 声明式管理 flatpak 的远程源和应用，QQ、微信写进配置 | README 里「手动残余：Discover 装 QQ、微信」，以及上面那个脆弱的激活脚本 |
| **`services.mihomo`** | 官方 NixOS 模块，支持 TUN 模式和 webui（`metacubexd`），开机自启 | 手动运行 mihomo 和 `proxy-on` 这套 alias；开了 TUN 后，nix-daemon、Chrome 都不用再单独设代理 |
| **sops-nix / agenix** | 密码哈希、订阅链接加密后放进仓库，重装时不怕丢 | `/etc/nixos/*-password-hash`、`clash-subscribe` |
| **btrbk / snapper** | `@home` 定时快照，误删文件能恢复 | 目前完全没有快照（只有 scrub） |
| **disko** | 分区、btrfs 子卷、挂载选项全部声明式，重装一条命令 | README 里的手工 `mount -o subvol=...` 步骤 |
| **`services.fwupd.enable`** | 通过 KDE Discover 更新 BIOS、SSD 固件 | 无 |
| **`programs.nix-ld.enable`** | 能直接运行 pip wheel、VS Code Server 等外部预编译二进制 | 遇到时才折腾 |
| **nix-index-database + comma** | `, cowsay` 不安装就能直接运行；命令找不到时提示该装哪个包 | `command-not-found` |
| **HM 管理 shell** | `programs.bash`（或 fish、zsh）加 starship、zoxide、eza、bat、fzf、atuin | `environment.shellAliases` 和 `interactiveShellInit` 里的函数 |
| **Stylix** | 一处定义 rose-pine-dawn，Konsole、nvim、Plasma、GTK 统一换色 | 手写的 `rose-pine-dawn.colorscheme` 和 nixvim 的配色设置 |
| **`security.sudo-rs.enable`** | 用 Rust 重写的 sudo，内存更安全 | sudo |
| **`boot.initrd.systemd.enable`** | 基于 systemd 的 initrd，启动更快，日志统一 | 脚本式 initrd |
| **GitHub Actions 自动更新 lock** | `DeterminateSystems/update-flake-lock` 每周自动提 PR 并跑构建检查 | 手动 `flake-update`（这也是现在 lock 落后三个半月的原因） |
| nvim：snacks.nvim / fzf-lua | 更快的 picker，外加 dashboard、lazygit 集成 | telescope（可选，不换也行） |

---

## 四、做得好的地方

- **flake 输入都设置了 `follows`**，避免了多份 nixpkgs，lock 文件很干净。
- **`users.mutableUsers = false` 加 `hashedPasswordFile`**：用户完全声明式管理，思路正确。
- **btrfs 子卷划分合理**：`@`、`@home`、`@nix`、`@log` 分开，开了 zstd 压缩和 noatime，还有每月自动 scrub。
- **zram 代替 swap 分区**，桌面机这样配很合适。
- **国内镜像带优先级，最后回落到官方源**，写法规范。
- **fcitx5 完全声明式**（`ignoreUserConfig` 加 `settings`），并且正确配置了 KWin 的 `Wayland.InputMethod`，Wayland 下输入法能正常工作。
- **nixvim 的写法很新**：用的是 nixvim 新的 `lsp.servers` 模块（基于 Neovim 0.11 的 `vim.lsp.config`），而不是老的 `plugins.lsp`；补全用 blink.cmp，格式化用 conform；Copilot NES 和 blink 补全菜单之间做了互斥处理，这部分花了不少心思。
- **home-manager 的 git 用的是新的 `programs.git.settings` 写法**，紧跟上游。
- **plasma-manager 把 KWin、截图、锁屏、电源都声明式管理了。**
- **README 记录了装机步骤和手动残余项**，重装时很有用。

---

## 五、建议的执行顺序

1. `nix flake update`，然后构建一次（lock 已经落后 3.5 个月）
2. 修复第一部分的 6 条：`configurationLimit`、字体顺序、nvim 键位、clangd 参数、SSH、flatpak 激活脚本
3. 换上 `programs.nh`，加 `formatter`，统一跑一遍 `nix fmt`
4. 上 direnv + nix-direnv，把开发工具挪进各个项目的 devShell
5. 用 `services.mihomo` 加 TUN 模式替换手动代理
6. 用 nix-flatpak 声明 QQ、微信，删掉 README 里的手动步骤
7. 引入 sops-nix 管理密码和订阅链接
8. 加上 btrbk 或 snapper 快照
9. （可选）调整目录结构，引入 disko 和 Stylix
