# 构建说明 / Build Guide

## 1. 直接构建补丁包（推荐）

需要：Windows、UnrealPak（UE 5.7/5.8）、[retoc](https://github.com/trumank/retoc/releases)。

```powershell
# 把 retoc.exe 放好
mkdir tools\retoc -Force
# 将 retoc.exe 与其运行依赖放到 tools\retoc\（不提交到仓库）

powershell -ExecutionPolicy Bypass -File build\build_mod.ps1 `
  -UnrealPak "C:\Program Files\Epic Games\UE_5.8\Engine\Binaries\Win64\UnrealPak.exe" `
  -Retoc ".\tools\retoc\retoc.exe" `
  -OutDir ".\dist"
```

输出：`dist\pakchunk0-Windows_P.pak / .utoc / .ucas`，安装到
`<游戏目录>\Wrc\Content\Paks\` 即可。

## 2. 重新生成字体（可选）

仓库内的 `assets/fonts/` 已包含最终字体，无需重新生成。
如需修改文本后重新子集化 font：

1. 下载 [Noto Sans SC 可变字体](https://github.com/google/fonts/raw/main/ofl/notosanssc/NotoSansSC%5Bwght%5D.ttf)
   放到 `tools/fonts/NotoSansSC-VF.ttf`
2. 安装 fonttools：`pip install fonttools`
3. 运行：
   ```powershell
   python build\make_fonts.py
   ```
   脚本会从 `assets/strings/Strings_EN.zh.csv` 提取字符集，生成 10 个 `.ufont` 到 `assets/fonts/`。

字体授权：Noto Sans SC，SIL OFL 1.1（`LICENSES/OFL-NotoSansSC.txt`）。

## 3. 修改翻译

- 文本：`assets/strings/Strings_EN.zh.csv`（UTF-8、无 BOM、CRLF；两列 `Key,SourceString`，键不可改）
- 猫名词素：`assets/strings/name_components.json`
- 术语表：`assets/strings/glossary.md`

占位符 `{PLAYER}`、`<B>...</>`、字面量 `\n`、`%s/%d` 必须保持原样，否则游戏内可能显示异常。

重新构建后建议用脚本自检：`UnrealPak <pak> -List`、`retoc verify <utoc>`，并在游戏内重启验证。