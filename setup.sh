#!/bin/bash
# dotfiles 설치 스크립트
# 새 노트북에서: bash ~/Developer/dotfiles/setup.sh

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "▶ Claude Code 스킬 설치..."
mkdir -p ~/.claude/commands
for f in "$DOTFILES_DIR/.claude/commands/"*.md; do
  fname=$(basename "$f")
  ln -sf "$f" ~/.claude/commands/"$fname"
  echo "  ✅ ~/.claude/commands/$fname"
done

echo ""
echo "✅ 완료. Claude Code 재시작 후 /파악 /점검 /기록 사용 가능."
