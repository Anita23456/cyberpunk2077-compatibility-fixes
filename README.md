# Cyberpunk 2077 Compatibility Fixes

赛博朋克 2077 2.5：个人整合环境中使用的四个独立兼容修复包。保留最终调试版本，不包含中间实验、游戏存档或个人日志。

## 内容

|模块|版本|用途|
|---|---|---|
|Nola item aliases|2026.10.27.1|4 条新旧 Nola 物品代码别名，保留旧物品代码的引用|
|Clothing material references|2026.10.27.6|300 项材质名称映射，以及 11 个资源覆盖，处理部分格裙、丝袜与腰带缺失材质槽|
|Global foot state|2026.10.27.4|按当前鞋履切换 Flat / FlatShoes / Lifted / HighHeels，供 ArchiveXL 脚型与腿部状态使用|
|UV–Angel body tag|2026.10.28.2|以 Angel 原始的两个外观资源保留 ANGEL 身形识别；不包含 UV HQ Arms|

`mods/` 提供实际载荷与整理后的清单；`packages/` 为可通过 Vortex 从文件安装的 ZIP，并附 SHA256。

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
