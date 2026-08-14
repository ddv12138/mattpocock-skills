#!/usr/bin/env bash
# 安装本 fork 的 Claude Code 插件（mattpocock-skills-cn）。
#
# 官方插件 mattpocock-skills 与本 fork 插件各带全套技能，不能共存：
# 检测到官方插件已安装时，询问是否先卸载，确认后才继续安装本 fork。
set -euo pipefail

OFFICIAL="mattpocock-skills"
FORK="mattpocock-skills-cn"
REPO="ddv12138/mattpocock-skills"
MARKETPLACE="mattpocock"

if ! command -v claude >/dev/null 2>&1; then
  echo "错误：找不到 claude CLI。请先安装 Claude Code 再运行本脚本。" >&2
  exit 1
fi

# 本 fork 插件已装 → 直接结束
if claude plugin list 2>/dev/null | grep -qE "(^|[^a-z-])${FORK}@"; then
  echo "本 fork 插件 ${FORK} 已安装。"
  exit 0
fi

# 官方插件已装 → 提示先卸载
UNINSTALL_OFFICIAL=false
if claude plugin list 2>/dev/null | grep -qE "(^|[^a-z-])${OFFICIAL}@"; then
  echo "检测到官方插件 ${OFFICIAL} 已安装。它与本 fork 插件各带全套技能，不能共存。"
  read -r -p "是否先卸载官方插件 ${OFFICIAL}，再安装 ${FORK}？[y/N] " ans
  case "$ans" in
    [yY]*)
      UNINSTALL_OFFICIAL=true
      ;;
    *)
      echo "保留官方插件，中止安装。" >&2
      exit 1
      ;;
  esac
fi

# 添加本 fork 的 marketplace（已配置则跳过）
if ! claude plugin marketplace list 2>/dev/null | grep -q "^${MARKETPLACE}\b"; then
  echo "添加 marketplace ${REPO}…"
  claude plugin marketplace add "$REPO"
else
  echo "marketplace ${MARKETPLACE} 已配置，跳过添加。"
fi

# 确认后才卸载官方插件（先 add marketplace，失败时不至于误伤官方插件）
if [ "$UNINSTALL_OFFICIAL" = true ]; then
  echo "卸载官方插件 ${OFFICIAL}…"
  claude plugin uninstall "$OFFICIAL"
fi

echo "安装 ${FORK}…"
claude plugin install "${FORK}@${MARKETPLACE}"
echo "完成：${FORK} 已安装，重启会话后生效。"
