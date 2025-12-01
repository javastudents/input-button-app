#!/usr/bin/env bash
set -euo pipefail

# Usage: GITHUB_TOKEN=xxxx bash scripts/create_and_deploy.sh [username] [repo]
# Defaults: username=javastudents, repo=input-button-app

USERNAME=${1:-javastudents}
REPO=${2:-input-button-app}

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "[ERROR] GITHUB_TOKEN 未设置。请先在环境中设置 GitHub Personal Access Token。"
  echo "示例： export GITHUB_TOKEN=ghp_xxx"
  exit 1
fi

API="https://api.github.com"
AUTH_HEADER=( -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "Accept: application/vnd.github+json" )

echo "[INFO] 创建 GitHub 仓库: ${USERNAME}/${REPO} (public)"
create_resp=$(curl -sS -X POST "${API}/user/repos" \
  "${AUTH_HEADER[@]}" \
  -d "{\"name\":\"${REPO}\",\"private\":false}")

# 若仓库已存在则继续
if echo "$create_resp" | grep -q 'name'; then
  echo "[OK] 仓库创建或已存在"
else
  echo "[WARN] 仓库创建可能失败，响应如下："
  echo "$create_resp"
fi

REMOTE_URL="https://github.com/${USERNAME}/${REPO}.git"
if git remote | grep -q '^origin$'; then
  git remote set-url origin "$REMOTE_URL" || true
else
  git remote add origin "$REMOTE_URL" || true
fi

echo "[INFO] 推送 main 分支"
git push -u origin main

echo "[INFO] 尝试开启 GitHub Pages (main / root)"
pages_resp=$(curl -sS -X POST "${API}/repos/${USERNAME}/${REPO}/pages" \
  "${AUTH_HEADER[@]}" \
  -d '{"source":{"branch":"main","path":"/"}}')

if echo "$pages_resp" | grep -qi 'build.*queued\|status\|url'; then
  echo "[OK] Pages 启用请求已提交"
else
  echo "[WARN] Pages 启用请求可能未成功，响应如下："
  echo "$pages_resp"
  echo "你也可以在 GitHub 仓库 Settings → Pages 中手动启用"
fi

echo "[DONE] 访问地址（稍后生效）： https://${USERNAME}.github.io/${REPO}/"
