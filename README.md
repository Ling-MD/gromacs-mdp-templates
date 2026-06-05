# GROMACS MDP Templates

个人分子动力学模拟工作流中积累的 GROMACS `.mdp` 参数模板，按体系类型分类。

## 目录结构

| 目录 | 说明 |
|------|------|
| `DNA/` | DNA 体系：能量最小化、平衡、生产 |
| `mem/` | 膜体系：平衡与生产 |
| `protein/` | 蛋白体系：em / pr / md |
| `protein/GBSA/` | 蛋白 GBSA 隐式溶剂模拟 |
| `protein_lig/` | 蛋白-配体复合物 |
| 根目录 | 通用模板：`em.mdp`、`md_NPT.mdp`、`md_heat_NPT.mdp`、`md_nopbc.mdp` |

## 使用方式

将对应模板复制到模拟目录，按体系修改 `nsteps`、`dt`、`tc-grps` 等参数后运行：

```bash
gmx grompp -f em.mdp -c conf.gro -p topol.top -o em.tpr
gmx mdrun -deffnm em
```

## 兼容性

模板主要面向 GROMACS 2018–2024 系列。不同版本对部分关键字的支持可能略有差异，使用前请对照所用版本的文档。

## License

MIT
