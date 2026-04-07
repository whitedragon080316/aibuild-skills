#!/bin/bash
# AI 造局術 — Skill 安裝器
# Usage: bash <(curl -s https://raw.githubusercontent.com/whitedragon080316/aibuild-skills/main/install.sh) <skill-name>
# Or: bash <(curl -s https://raw.githubusercontent.com/whitedragon080316/aibuild-skills/main/install.sh) all

REPO="https://raw.githubusercontent.com/whitedragon080316/aibuild-skills/main"
ALL_SKILLS="notion line-bot meta-ads youtube github deploy course ai-writer funnel-check tappay zeabur"

install_skill() {
  local skill=$1
  mkdir -p ".claude/skills/$skill"
  if curl -sf "$REPO/$skill/SKILL.md" -o ".claude/skills/$skill/SKILL.md"; then
    echo "✅ /$skill 已安裝"
  else
    echo "❌ /$skill 安裝失敗（請確認 skill 名稱）"
  fi
}

if [ -z "$1" ]; then
  echo "AI 造局術 — Skill 安裝器"
  echo ""
  echo "用法："
  echo "  安裝單一 Skill:  bash <(curl -s $REPO/install.sh) line-bot"
  echo "  安裝全部 Skill:  bash <(curl -s $REPO/install.sh) all"
  echo ""
  echo "可用的 Skills:"
  for s in $ALL_SKILLS; do
    echo "  - $s"
  done
  exit 0
fi

if [ "$1" = "all" ]; then
  echo "安裝全部 Skills..."
  for s in $ALL_SKILLS; do
    install_skill "$s"
  done
  echo ""
  echo "✅ 全部安裝完成！在 Claude Code 輸入 /skill-name 就能用"
else
  for s in "$@"; do
    install_skill "$s"
  done
fi
