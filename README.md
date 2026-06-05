# GROMACS MDP Templates

个人分子动力学（MD）工作流中积累的 GROMACS `.mdp` 参数模板，按体系类型分类，可直接复制使用。

## 特性

- 覆盖蛋白、蛋白-配体、DNA、膜、GBSA 等常见体系
- 统一使用 Verlet + PME、V-rescale 温控等现代 GROMACS 设置
- 每个模板附带典型 `nsteps` / `dt` 参考值，便于按需缩放

## 目录结构

```
.
├── em.mdp              # 通用能量最小化
├── md_NPT.mdp          # 通用 NPT 生产
├── md_heat_NPT.mdp     # 升温后 NPT
├── md_nopbc.mdp        # 无 PBC 体系
├── DNA/                # DNA：em / pr / md
├── mem/                # 膜体系：eq / md
├── protein/            # 蛋白：em / pr / md
│   └── GBSA/           # 隐式溶剂 GBSA
└── protein_lig/        # 蛋白-配体：em / pr / md
```

## 模板速查

| 体系 | 能量最小化 | 平衡 (NVT/NPT) | 生产 MD |
|------|-----------|----------------|---------|
| 蛋白 | `protein/em.mdp` | `protein/pr.mdp` | `protein/md.mdp` |
| 蛋白-配体 | `protein_lig/em.mdp` | `protein_lig/pr.mdp` | `protein_lig/md.mdp` |
| DNA | `DNA/em.mdp` | `DNA/pr.mdp` | `DNA/md.mdp` |
| 膜 | — | `mem/eq.mdp` | `mem/md.mdp` |
| GBSA | `protein/GBSA/em.mdp` | — | `protein/GBSA/md.mdp` |

## 典型工作流

### 蛋白溶液体系

```bash
# 1. 能量最小化
gmx grompp -f protein/em.mdp -c solvated.gro -p topol.top -o em.tpr -maxwarn 1
gmx mdrun -deffnm em -v

# 2. NVT 平衡
gmx grompp -f protein/pr.mdp -c em.gro -p topol.top -o pr.tpr -maxwarn 1
gmx mdrun -deffnm pr -v

# 3. NPT 生产
gmx grompp -f protein/md.mdp -c pr.gro -t pr.cpt -p topol.top -o md.tpr -maxwarn 1
gmx mdrun -deffnm md -v
```

完整示例脚本见 [`examples/protein_workflow.sh`](examples/protein_workflow.sh)。

### 膜体系

膜模板使用 `semiisotropic` 压耦合并区分脂质 / 溶剂温度组（如 `DPP SOL`）。运行前请根据 `topol.top` 中的组名修改 `tc_grps` 和 `pcoupltype` 相关参数。

```bash
gmx grompp -f mem/eq.mdp -c membrane.gro -p topol.top -o eq.tpr
gmx mdrun -deffnm eq
gmx grompp -f mem/md.mdp -c eq.gro -t eq.cpt -p topol.top -o md.tpr
gmx mdrun -deffnm md
```

## 常用参数调整

| 参数 | 含义 | 调整建议 |
|------|------|----------|
| `nsteps` | 模拟步数 | 模拟时间 (ps) = `nsteps × dt` |
| `dt` | 时间步长 | 全原子常用 0.002 ps；约束氢键时可保持 |
| `tc_grps` / `ref_t` | 温控组与目标温度 | 必须与 `topol.top` 组名一致 |
| `tau_t` | 温控耦合时间 | 一般 0.1–0.5 ps |
| `ref_p` / `compressibility` | 目标压强与压缩率 | 膜体系注意 `semiisotropic` |
| `nstxout-compressed` | 轨迹输出频率 | 按所需时间分辨率调整 |

更多说明见 [`examples/TEMPLATE_GUIDE.md`](examples/TEMPLATE_GUIDE.md)。

## 兼容性

- 主要面向 **GROMACS 2018–2024**
- 部分关键字在不同版本间可能有差异（如 `DispCorr`、`cutoff-scheme`），使用前请对照本机 GROMACS 文档
- 蛋白能量最小化模板含 `define = -DFLEXIBLE`，用于柔性水模型；若使用刚性水可删除该行

## 示例文件

| 文件 | 说明 |
|------|------|
| `examples/protein_workflow.sh` | 蛋白 em → pr → md 一键流程模板 |
| `examples/membrane_workflow.sh` | 膜体系平衡与生产流程模板 |
| `examples/TEMPLATE_GUIDE.md` | 各模板关键参数详解 |

## License

MIT
