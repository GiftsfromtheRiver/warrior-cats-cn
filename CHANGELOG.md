# Changelog

## v0.1.4 — 2026-10-28

- **Gathering 术语按语境区分**：四大族群满月大会 → 「满月会议」（44 处）；族内/一般集会 → 「集会」；晋升任务的 “Clan Gathering” → 「族群集会」
- **任务标题双关**：“The Gathering Storm” 由「风暴将至」改为 **「满月风暴」**——既指满月会议（The Gathering）将起风波，也指风暴将至
- 修复后重建，44 项安装校验通过

## v0.1.3 — 2026-10-26

- **术语修正**：the Gathering 由「大集会」统一改为「满月会议」（《猫武士》中文习惯；涉及任务目标地点等 45 处文本，如河族「风暴将至」的「满月会议」）
- 重建 mod，44 项安装校验通过

## v0.1.2 — 2026-10-26

- 修复游戏原文占位符笔误导致的显示问题：`{RIVERCLAN MEDICINE CAT}`（原文缺空格，游戏中显示为 `0`）→ 改为固定文本“巫医”
- 修正其余 6 处游戏原文中的错误占位符（`{THE WARROR FATHER}`、`{THE MISTRUSTING LEADER}`、`{THE MISTRUSTUL LEADER}`、`{THE VENGEFUL WARRIOR}`、`{Player}`、`{Friend}` → 规范 token）
- 重建 mod，44 项安装校验通过

## v0.1.1 — 2026-10-25

- 修正“获得新动作/技能”弹窗文案：`Movement unlocked` → **已解锁新动作**
- 修正训练场学会招式提示：`Movement learned` → **已学会新招式**
- 统一训练场 NPC 译名（Trainer Cat / Movement Cat → **训练猫**）
- 重新生成字体子集并重建 mod，44 项安装校验通过

## v0.1.0 — 2026-10-24

- 首次发布：8,901 条游戏文本简体中文汉化（覆盖 97.7%）
- 10 个 `.ufont` 字体替换为 Noto Sans SC 子集，解决中文显示
- 2,438 个猫名按《猫武士》命名规则生成
- 补丁式安装（`pakchunk0-Windows_P.*`），支持一键卸载