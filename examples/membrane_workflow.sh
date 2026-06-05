#!/bin/bash
# 膜体系 MD 流程示例
# 用法: bash membrane_workflow.sh <拓扑目录>
# 注意: 运行前请检查 mem/*.mdp 中的 tc_grps 是否与 topol.top 一致

set -euo pipefail

WORKDIR="${1:-.}"
MDP_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$WORKDIR"

echo "=== Step 1: Membrane Equilibration ==="
gmx grompp -f "$MDP_ROOT/mem/eq.mdp" -c membrane.gro -p topol.top -o eq.tpr -maxwarn 1
gmx mdrun -deffnm eq -v

echo "=== Step 2: Membrane Production ==="
gmx grompp -f "$MDP_ROOT/mem/md.mdp" -c eq.gro -t eq.cpt -p topol.top -o md.tpr -maxwarn 1
gmx mdrun -deffnm md -v

echo "Done. Output: md.xtc, md.gro, md.edr"
