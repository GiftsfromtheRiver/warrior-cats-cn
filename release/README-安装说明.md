# Warrior Cats: Clans of the Forest — 简体中文汉化包 安装说明

> 本汉化包只替换游戏运行时的**文本资源文件**（外加必要的中文字体文件），
> 不修改游戏 exe、不改动存档，安装/卸载都只是复制/删除 3 个文件。

## 0. 适用版本

| 项目 | 说明 |
| --- | --- |
| 游戏 | Warrior Cats: Clans of the Forest（Steam / UE 5.7） |
| 汉化包 | `0.1.2`（构建日期 `2026-10-26`） |
| 安装位置 | `<游戏安装目录>\Wrc\Content\Paks\` |

## 1. 安装前准备

1. **关闭游戏**（包括 Steam 后台不要处于更新状态）。
2. **备份存档**（本汉化不碰存档，但养成习惯）：
   `%LOCALAPPDATA%\Wrc\Saved\SaveGames\`（或游戏目录内 `Wrc\Saved\SaveGames\`，视安装方式而定）。
3. 确认游戏安装目录，例如：
   `F:\SteamLibrary\steamapps\common\Warrior Cats Clans of the Forest\`

## 2. 安装（两种方式任选）

### 方式 A：双击脚本安装（推荐）

1. 将汉化包解压到任意位置（例如 `D:\WRC-CN\`）。
2. 打开命令行，运行：

```bat
python installer.py install ^
  --paks-dir "<游戏安装目录>\Wrc\Content\Paks" ^
  --mod-dir "<汉化包目录>" ^
  --manifest "<汉化包目录>\mod_manifest.json"
```

脚本会：校验 3 个文件的 SHA256 → 检查 `.pak` 结构与 `.utoc/.ucas` 容器 →
把文件复制进 `Wrc\Content\Paks\` → 再次自动校验。
如果目录里已有同名文件，会先自动备份为 `*.wrccn-backup-<时间>`。

> 无 Python 环境时用方式 B。

### 方式 B：手动复制

把下面 **3 个文件**（必须一起复制，文件名不可改）复制到
`<游戏安装目录>\Wrc\Content\Paks\`：

```
pakchunk0-Windows_P.pak
pakchunk0-Windows_P.utoc
pakchunk0-Windows_P.ucas
```

复制完成后，`Paks` 目录里应同时存在游戏原版文件
`pakchunk0-Windows.pak / .utoc / .ucas`（勿动）和上面 3 个新增文件。

## 3. 校验安装（可选）

```bat
python installer.py verify --paks-dir "<游戏安装目录>\Wrc\Content\Paks"
```

看到 `校验结果: PASS` 即成功。手动校验方法：

```bat
:: 结构/版本（期望 Version: 12、bEncryptedIndex: 0、mount point "../../../"）
UnrealPak.exe "<Paks>\pakchunk0-Windows_P.pak" -Info
UnrealPak.exe "<Paks>\pakchunk0-Windows_P.pak" -List
:: IoStore 容器
retoc.exe verify "<Paks>\pakchunk0-Windows_P.utoc"   :: 期望输出 verified
```

也可对照 `SHA256SUMS.txt` 检查 3 个文件的 SHA256。

## 4. 启动游戏

直接正常启动。进入游戏后：
- 主菜单/UI/任务/对话应为简体中文；
- 若部分界面仍为英文，说明该文本是**未走文本表的硬编码文本**，请把截图/位置反馈给汉化组。

## 5. 卸载 / 回滚

### 方式 A：脚本回滚

```bat
python installer.py rollback --paks-dir "<游戏安装目录>\Wrc\Content\Paks"
```

### 方式 B：手动删除

删除 `Paks` 目录下的这 3 个文件即可完全恢复原版：

```
pakchunk0-Windows_P.pak
pakchunk0-Windows_P.utoc
pakchunk0-Windows_P.ucas
```

（如安装时存在 `*.wrccn-backup-<时间>` 备份文件，按需改名还原；
回滚脚本会自动恢复。）

> 提示：Steam「验证游戏文件完整性」不会删除这 3 个额外文件；若要彻底还原，
> 请先手动删除它们再验证。

## 6. 常见问题

- **中文显示为方块/省略号**：字体未覆盖该字符。联系汉化组反馈具体界面；
  确认汉化包内的字体文件（`.ufont`）完整解压、未被杀毒软件隔离。
- **装完仍是英文**：确认 3 个文件在 `Wrc\Content\Paks\` 下、文件名完全一致，
  且没有改名成 `pakchunk0-Windows.pak`（不能覆盖原版 pak，`_P` 后缀必须保留）。
- **游戏更新后失效**：更新会替换原版 pak；重新复制（或重装）汉化包即可。
- **无法复制/无权限**：右键以管理员身份运行命令行；Steam 安装在受保护目录时也需要。
- **想同时保留原版英文**：卸载汉化包（删除 3 个文件）即可恢复。

## 7. 文件清单与校验值

见同目录 `SHA256SUMS.txt` 与 `mod_manifest.json`。当前版本：

```
a2ffd8d80157fdf493c194b8fb6141e3ad82c15bd7501acc2e6520a8b469488b  pakchunk0-Windows_P.pak
bbc5f021c03e0c79a1459bac23b0729eecbacd0d2bec78eaef9c7e61a55f9e48  pakchunk0-Windows_P.ucas
dd40f7471358399ada3d76fd01f6ced70c776a3a0f22dcb4674f350329a00ed2  pakchunk0-Windows_P.utoc
```

## 8. 更多信息

- 本版本更新内容与已知限制：见同目录 `release_notes.md`
- 卸载/还原详细说明：见同目录 `uninstall_notes.txt`
- 安装包校验值：见同目录 `SHA256SUMS.txt`、`mod_manifest.json`

---

安装脚本源码：`wrc-cn/tools/install/installer.py`（`manifest/install/verify/rollback/status/selftest` 子命令）。
本汉化包以 UE5 的 patch pak 机制加载：文件名 `_P` 后缀使其 ReadOrder 高于原版 pak，
因此能覆盖原版 `<mount>/Wrc/Content/...` 下的同名文件；不会写任何散落文件到游戏目录。
