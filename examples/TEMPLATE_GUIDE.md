# MDP 模板参数指南

## 通用能量最小化 (`em.mdp`)

- `integrator = cg`：共轭梯度最小化
- `emtol = 100.0`：力收敛阈值 (kJ/mol/nm)
- `nsteps = 500`：可按体系大小增至 5000–50000

## 蛋白生产 (`protein/md.mdp`)

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `dt` | 0.002 ps | 2 fs 步长 |
| `nsteps` | 1,000,000 | 约 2 ns，按需修改 |
| `tc_grps` | protein non-protein | 蛋白与溶剂分控温 |
| `ref_t` | 298.15 K | 室温 |
| `Pcoupl` | parrinello-rahman | NPT 控压 |
| `constraints` | hbonds | 约束氢键 |

## 膜生产 (`mem/md.mdp`)

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `tc_grps` | DPP SOL | 脂质 / 溶剂，需与拓扑组名匹配 |
| `ref_t` | 325 K | 膜模拟常用温度 |
| `pcoupltype` | semiisotropic | xy 与 z 方向独立控压 |
| `comm-grps` | lower upper SOL | 膜层质心运动移除 |

## 蛋白-配体 (`protein_lig/`)

流程与蛋白相同（em → pr → md），但平衡阶段通常需要更长的 `nsteps` 以稳定配体构象。建议：

1. 先检查配体周围溶剂密度
2. 适当延长 `pr.mdp` 的 `nsteps`
3. 确认 `topol.top` 中配体原子类型正确

## GBSA (`protein/GBSA/`)

隐式溶剂模拟，无周期性溶剂盒子。注意：

- 不使用 PME，静电模型为 GB
- 运行前确认力场支持 GBSA
- 温度 / 步长设置与显式溶剂类似

## 修改检查清单

开始模拟前，逐项确认：

- [ ] `tc_grps` 与 `topol.top` 中的 `[ molecules ]` 组名一致
- [ ] `nsteps × dt` 达到目标模拟时长
- [ ] 续跑时传入正确的 `-t *.cpt` 检查点
- [ ] 膜 / 各向异性体系已设置正确的 `pcoupltype`
