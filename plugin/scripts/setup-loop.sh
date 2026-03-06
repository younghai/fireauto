#!/bin/bash

# fireauto loop 셋업 스크립트
# 루프 상태 파일을 생성하고 루프를 시작

set -euo pipefail

PROMPT_PARTS=()
MAX_ITERATIONS=0
COMPLETION_PROMISE="null"

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      cat << 'HELP_EOF'
fireauto loop - AI가 반복하며 작업을 완성해요

사용법:
  /loop 할일 [옵션]

옵션:
  --max-iterations <횟수>         최대 반복 횟수 (기본: 무제한)
  --completion-promise '<조건>'   완료 조건 (여러 단어면 따옴표로 감싸세요)
  -h, --help                     도움말

예시:
  /loop TODO API 만들어줘 --completion-promise '완료' --max-iterations 20
  /loop --max-iterations 10 인증 버그 고쳐줘
  /loop 캐시 레이어 리팩토링해줘 (무한 반복)

중단하기:
  /cancel-loop 으로 언제든 중단할 수 있어요
HELP_EOF
      exit 0
      ;;
    --max-iterations)
      if [[ -z "${2:-}" ]] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "max-iterations에는 숫자를 넣어주세요. (예: --max-iterations 20)" >&2
        exit 1
      fi
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    --completion-promise)
      if [[ -z "${2:-}" ]]; then
        echo "completion-promise에 완료 조건을 넣어주세요. (예: --completion-promise '모든 테스트 통과')" >&2
        exit 1
      fi
      COMPLETION_PROMISE="$2"
      shift 2
      ;;
    *)
      PROMPT_PARTS+=("$1")
      shift
      ;;
  esac
done

PROMPT="${PROMPT_PARTS[*]}"

if [[ -z "$PROMPT" ]]; then
  echo "할 일을 알려주세요!" >&2
  echo "" >&2
  echo "  예시: /loop TODO API 만들어줘 --max-iterations 20" >&2
  echo "  도움말: /loop --help" >&2
  exit 1
fi

mkdir -p .claude

if [[ -n "$COMPLETION_PROMISE" ]] && [[ "$COMPLETION_PROMISE" != "null" ]]; then
  COMPLETION_PROMISE_YAML="\"$COMPLETION_PROMISE\""
else
  COMPLETION_PROMISE_YAML="null"
fi

cat > .claude/fireauto-loop.local.md <<EOF
---
active: true
iteration: 1
session_id: ${CLAUDE_CODE_SESSION_ID:-}
max_iterations: $MAX_ITERATIONS
completion_promise: $COMPLETION_PROMISE_YAML
started_at: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
---

$PROMPT
EOF

cat <<EOF
fireauto loop 시작!

반복: 1회차
최대 반복: $(if [[ $MAX_ITERATIONS -gt 0 ]]; then echo "${MAX_ITERATIONS}회"; else echo "무제한"; fi)
완료 조건: $(if [[ "$COMPLETION_PROMISE" != "null" ]]; then echo "$COMPLETION_PROMISE"; else echo "없음 (무한 반복)"; fi)

AI가 작업하고 → 나가려 하면 → 같은 프롬프트가 다시 들어와요.
매번 이전 작업 결과를 보면서 점점 더 완성도를 높여요.

중단하려면: /cancel-loop
상태 확인: head -10 .claude/fireauto-loop.local.md

EOF

echo ""
echo "$PROMPT"

if [[ "$COMPLETION_PROMISE" != "null" ]]; then
  echo ""
  echo "════════════════════════════════════════"
  echo "  완료하려면 이걸 출력하세요:"
  echo "  <promise>$COMPLETION_PROMISE</promise>"
  echo ""
  echo "  진짜 완료됐을 때만 출력하세요!"
  echo "════════════════════════════════════════"
fi
