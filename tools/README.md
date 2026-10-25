# tools/

本目录不提交二进制工具，请自行准备（.gitignore 已忽略 tools/）：

1. **retoc**（UE IoStore 打包/校验）
   - 下载：https://github.com/trumank/retoc/releases
   - 解压后放：`tools/retoc/retoc.exe`（同目录需有其运行所需的 oo2core DLL，首次运行会自行处理）
2. **UnrealPak.exe**
   - 安装 Unreal Engine 5.7/5.8 后位于：
     `<UE>\Engine\Binaries\Win64\UnrealPak.exe`
   - 构建时用 `-UnrealPak` 参数指定路径即可