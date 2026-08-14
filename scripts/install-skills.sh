#!/usr/bin/env bash
# 一键安装本 fork 的技能（skills.sh 路径）。
#
# 检测到原项目（mattpocock/skills）已安装（项目级 skills-lock.json 或全局
# ~/.agents/.skill-lock.json）时，询问是否先用 npx 完全删除原项目，再装本 fork。
# 直接覆盖会留下子集残留（未覆盖的技能来源仍是上游），所以删除后再装最干净。
set -euo pipefail

FORK_REPO="ddv12138/mattpocock-skills"
UPSTREAM="mattpocock/skills"
PROJECT_LOCK="./skills-lock.json"
GLOBAL_LOCK="${HOME}/.agents/.skill-lock.json"

command -v npx >/dev/null 2>&1 || { echo "错误：找不到 npx。请先安装 Node.js。" >&2; exit 1; }

# 从 lock 里取出 source 为上游的技能名（空格分隔）；lock 不存在或解析失败则输出空
upstream_skills() {
  node -e '
    const fs = require("fs");
    const p = process.argv[1];
    let lock;
    try { lock = JSON.parse(fs.readFileSync(p, "utf8")); } catch { process.exit(0); }
    const names = Object.entries(lock.skills || {})
      .filter(([, v]) => v.source === process.argv[2])
      .map(([n]) => n);
    process.stdout.write(names.join(" "));
  ' "$1" "$UPSTREAM"
}

remove_skills() { # $1=scope(project|global)，其余参数为技能名
  local scope="$1"; shift
  local args=()
  for n in "$@"; do args+=(-s "$n"); done
  if [ "$scope" = global ]; then
    npx -y skills@latest remove "${args[@]}" -g -y
  else
    npx -y skills@latest remove "${args[@]}" -y
  fi
}

PROJECT_NAMES=$(upstream_skills "$PROJECT_LOCK")
GLOBAL_NAMES=$(upstream_skills "$GLOBAL_LOCK")

if [ -n "$PROJECT_NAMES$GLOBAL_NAMES" ]; then
  p_count=$(echo "$PROJECT_NAMES" | wc -w | tr -d ' ')
  g_count=$(echo "$GLOBAL_NAMES" | wc -w | tr -d ' ')
  echo "检测到原项目（${UPSTREAM}）已安装 ${p_count} 个项目级 + ${g_count} 个全局技能。"
  echo "直接装本 fork 会留下子集残留，先删除原项目再装最干净。"
  read -r -p "是否先用 npx 完全删除原项目，再安装本 fork？[y/N] " ans
  case "$ans" in
    [yY]*) ;;
    *)
      echo "保留原项目，中止安装（避免两套技能混合）。" >&2
      exit 1
      ;;
  esac
  if [ -n "$PROJECT_NAMES" ]; then
    echo "删除项目级原项目技能…"
    # shellcheck disable=SC2086
    remove_skills project $PROJECT_NAMES
  fi
  if [ -n "$GLOBAL_NAMES" ]; then
    echo "删除全局原项目技能…"
    # shellcheck disable=SC2086
    remove_skills global $GLOBAL_NAMES
  fi
else
  echo "未检测到原项目安装，直接安装本 fork。"
fi

# 安装本 fork，作用域跟随被清理的范围
install_fork() {
  if [ -n "$GLOBAL_NAMES" ] && [ -n "$PROJECT_NAMES" ]; then
    echo "安装本 fork（项目级 + 全局）…"
    npx -y skills@latest add "$FORK_REPO"
    npx -y skills@latest add "$FORK_REPO" -g
  elif [ -n "$GLOBAL_NAMES" ]; then
    echo "安装本 fork（全局）…"
    npx -y skills@latest add "$FORK_REPO" -g
  else
    echo "安装本 fork（项目级）…"
    npx -y skills@latest add "$FORK_REPO"
  fi
}
install_fork
echo "完成：本 fork 技能已安装。"
