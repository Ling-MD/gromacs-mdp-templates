#!/bin/bash
# 蛋白体系标准 MD 流程示例
# 用法: bash protein_workflow.sh <拓扑目录>
# 前提: 目录中已有 solvated.gro 和 topol.top

set -euo pipefail

WORKDIR="${1:-.}"
MDP_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$WORKDIR"

echo "=== Step 1: Energy Minimization ==="
gmx grompp -f "$MDP_ROOT/protein/em.mdp" -c solvated.gro -p topol.top -o em.tpr -maxwarn 1
gmx mdrun -deffnm em -v

echo "=== Step 2: NVT Equilibration ==="
gmx grompp -f "$MDP_ROOT/protein/pr.mdp" -c em.gro -p topol.top -o pr.tpr -maxwarn 1
gmx mdrun -deffnm pr -v

echo "=== Step 3: NPT Production ==="
gmx grompp -f "$MDP_ROOT/protein/md.mdp" -c pr.gro -t pr.cpt -p topol.top -o md.tpr -maxwarn 1
gmx mdrun -deffnm md -v

echo "Done. Output: md.xtc, md.gro, md.edr"
