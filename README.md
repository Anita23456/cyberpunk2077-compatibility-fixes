# Cyberpunk 2077 Compatibility Fixes

**本兼容包修复《赛博朋克 2077》2.5 部分服装、裙子和丝袜因材质引用缺失而透明或无法显示，丝袜与脚甲未随鞋履切换脚型，UV 与 Angel 共存时身形识别被覆盖，以及部分 Nola 新旧物品代码不一致的问题。**

## 修复的问题与涉及项目

|问题|涉及 Mod / 物品|本包处理内容|
|---|---|---|
|格裙透明、部分颜色无法显示|Nola Dreamer — Loose Top and Plaid Mini Skirt / ND Plaid Mini Skirt|补齐 Angel、Vanilla 格裙的无效材质槽；覆盖两份网格的全部外观定义，保留原颜色引用|
|丝袜透明、Fishnet B / Black 等款式无法显示|Nola Dreamer — Stocking Collection，当前 TF 分支|修正 8 份脚型网格中的空材质槽，保留款式、颜色和原脚型网格|
|单肩上衣黑色及其他颜色无法显示|Nola Dreamer — One Shoulder Shirt|修正对应网格的无效材质名称引用，保留命名颜色引用|
|其他衣物或配饰引用了不存在的材质名|下方列出的 Nola、Hyst、Adshield、Peachu、KMKC 等项目|共 300 项材质名称映射；只将已核对的无效引用指向现有材质|
|腰带材质引用与 Angel 适配版本不一致|Nola Dreamer × Aquelyras — Girly Outfit 的 Angel 腰带|单独修正该适配网格，保留几何与材质缓冲区|
|高跟鞋穿上后，丝袜或脚甲仍使用平脚网格；脱鞋后不切回|Equipment-EX 扩展鞋履槽、ArchiveXL FeetState / LegsState，以及支持对应脚型的丝袜和脚甲|按鞋履标签自动切换 Flat / FlatShoes / Lifted / HighHeels；鞋履槽为空默认 Flat|
|UV 与 Angel 共存时未正确识别 Angel，导致衣物选择不合适的身形分支|UV Framework + Hyst Angel Body|保留 Angel 原始的两个外观资源，使 ANGEL 身形标记生效|
|旧合集与独立版本的部分 Nola 默认色裤装物品代码不同|`Items.nd_alt_pants2_default_black`、`Items.nd_alt_pants2_default_blue`、`Items.nd_alt_pants_default_black`、`Items.nd_alt_pants_default_blue`|提供四条旧代码到现有代码的别名，保留旧引用|

### 衣物与配饰项目

材质修复清单涉及以下项目及其部分身形适配网格：

- **Nola Dreamer / Aquelyras**：Absolute Mini Outfit、Chic Heels、Combat Outfit、Goth Outfit（项链、腰带）、Office Lady Uniform（束身上衣、裙子）、Punk Shoes、Street Outfit、Swimwear Devil、Swimwear Mystique、Barbed Accessories、Belly Chain Hearts、Simple Drops、Loose Top and Plaid Mini Skirt、Moon Accessories、Romantic Lingerie Set、Spiked Collar、Girly Outfit、Beach Outfit and Fishnet Dress、One Shoulder Shirt、Stocking Collection。
- **旧 Nola Angel 合集**：ND Angel Outfit Vol.2、Vol.3，以及 ND Aquelyras Angel Outfit Vol.1 中与映射路径一致的资源。包括 Offset、Tangled、Casual Shorts、Evelyn Coat、Shiny Top 等相关网格；具体以详细清单为准。
- **Hyst**：Skirt、Evelyn Dress、Summer Suit、Sandals Glam High Heel。
- **Adshield**：PT Lingerie、Tactical Crop Top。
- **Peachu**：Mini Bikini 的 Mini Bra、Mini Pantie。
- **KMKC**：Mockingbird、Negan Fem BIG BOOBA、Plague Doctors FemV、Shaundi's。
- **Nude Moxe**：Succubi Stompers。

完整 Mod / 合集对应关系、11 个资源覆盖及全部 300 项网格引用见 **[详细修复清单](docs/affected-mods.md)**。其中部分是静态扫描发现并补齐的引用，尚未逐件完成游戏内验证；本包不承诺解决所有衣物穿模，也不包含大猩猩手臂透明的修复。

## 四个安装模块

|模块|版本|内容|
|---|---|---|
|Nola item aliases|2026.10.27.1|4 条 Nola 物品代码别名|
|Clothing material references|2026.10.27.6|300 项材质映射 + 11 个资源覆盖|
|Global foot state|2026.10.27.4|鞋履驱动的全局脚型切换|
|UV–Angel body tag|2026.10.28.2|UV 与 Angel 共存时的身形识别|

`mods/` 为实际脚本、配置、资源和清单；**[packages/](packages/)** 为可通过 Vortex「从文件安装」导入的 ZIP，并附 SHA256 校验清单。

## 安装与排序

这是针对特定整合环境的补丁集合，不是通用必装包。先安装对应原版 Mod 及其前置，再按需安装对应补丁。

1. 用 Vortex「从文件安装」导入需要的 ZIP，不要解压到 Vortex 程序目录。
2. 保持原有前置依赖关系。补丁发生同文件冲突时，让补丁覆盖对应原始资源。
3. 四个包放在同一兼容修复区：Nola 别名 → 衣物材质引用 → 全局脚型 → UV/Angel 身形识别。
4. 鞋履脚型模块依赖 CET、REDscript、ArchiveXL 及 Equipment-EX 的槽位环境。脱鞋默认 Flat；其他状态依鞋履视觉标签判定。加载后预热约 5 秒。
5. 升级已有修复包时替换同名旧包，避免重复安装中间实验版本。

UV/Angel 包只在同时使用 UV 与 Angel 并发生身形识别覆盖时需要。衣物引用补丁要求相应的原始衣物及其材质存在；不要把映射当作缺失原 Mod 的替代品。丝袜保留 TF 分支，不转换成 non-TF/NT。

## 验证范围

上述最终修复组合已在本人的游戏中通过读档、衣物显示与换鞋脚型切换测试。2026-10-29 更新至 ArchiveXL 1.28.6、Codeware 1.21.2、Angel 3.0.0 后完成静态校验，尚未完成该新组合的游戏内复测。UV/Angel 包的两个资源与 Angel 3.0.0 逐字节一致。

没有启用 native loader callback 拦截；脚型脚本采用 CET 主线程轮询和 REDscript 缓存，不写入装备或存档。

## 原作者与资源

这些修复依赖第三方 Mod；`.archive` 中的模型、材质及原始外观资源仍归原作者所有。此仓库不是对应原 Mod 的替代发布，不对第三方资源授予额外许可。参见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。

不含 UV HQ Arms、2BT RealSkinn、丽兹或其他完整第三方 Mod。
