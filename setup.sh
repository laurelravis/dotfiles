#!/bin/bash
# dotfiles 설치 스크립트
#
# 새 노트북 (curl|bash):
#   curl -fsSL https://raw.githubusercontent.com/laurelravis/dotfiles/main/setup.sh | bash
#
# 이미 클론된 경우:
#   bash ~/Developer/dotfiles/setup.sh

DOTFILES_REPO="https://github.com/laurelravis/dotfiles.git"
DOTFILES_DIR="$HOME/Developer/dotfiles"

# curl|bash 호환: 레포가 없으면 먼저 클론
if [ ! -d "$DOTFILES_DIR/.git" ]; then
  echo "▶ dotfiles 클론..."
  mkdir -p "$HOME/Developer"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  echo ""
fi

echo "▶ Claude Code 스킬 설치..."
mkdir -p ~/.claude/commands
for f in "$DOTFILES_DIR/.claude/commands/"*.md; do
  fname=$(basename "$f")
  ln -sf "$f" ~/.claude/commands/"$fname"
  echo "  ✅ ~/.claude/commands/$fname"
done

echo ""
echo "✅ 완료. Claude Code 재시작 후 /파악 /점검 /기록 사용 가능."
