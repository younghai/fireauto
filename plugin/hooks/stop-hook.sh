#!/bin/bash

# fireauto loop Stop Hook
# 루프가 활성화되어 있으면 세션 종료를 막고 같은 프롬프트를 다시 전달

set -euo pipefail

HOOK_INPUT=$(cat)

RALPH_STATE_FILE=".claude/fireauto-loop.local.md"

if [[ ! -f "$RALPH_STATE_FILE" ]]; then
  exit 0
fi

FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$RALPH_STATE_FILE")
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//')
COMPLETION_PROMISE=$(echo "$FRONTMATTER" | grep '^completion_promise:' | sed 's/completion_promise: *//' | sed 's/^"\(.*\)"$/\1/')

# 세션 격리
STATE_SESSION=$(echo "$FRONTMATTER" | grep '^session_id:' | sed 's/session_id: *//' || true)
HOOK_SESSION=$(echo "$HOOK_INPUT" | jq -r '.session_id // ""')
if [[ -n "$STATE_SESSION" ]] && [[ "$STATE_SESSION" != "$HOOK_SESSION" ]]; then
  exit 0
fi

# 숫자 검증
if [[ ! "$ITERATION" =~ ^[0-9]+$ ]]; then
  echo "fireauto loop: 상태 파일이 손상됐어요. 루프를 중단할게요." >&2
  rm "$RALPH_STATE_FILE"
  exit 0
fi

if [[ ! "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "fireauto loop: 상태 파일이 손상됐어요. 루프를 중단할게요." >&2
  rm "$RALPH_STATE_FILE"
  exit 0
fi

# 최대 반복 횟수 도달
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  echo "fireauto loop: 최대 반복 횟수($MAX_ITERATIONS)에 도달했어요."
  rm "$RALPH_STATE_FILE"
  exit 0
fi

# 트랜스크립트에서 마지막 어시스턴트 메시지 추출
TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path')

if [[ ! -f "$TRANSCRIPT_PATH" ]]; then
  echo "fireauto loop: 트랜스크립트를 찾을 수 없어요. 루프를 중단할게요." >&2
  rm "$RALPH_STATE_FILE"
  exit 0
fi

if ! grep -q '"role":"assistant"' "$TRANSCRIPT_PATH"; then
  echo "fireauto loop: 어시스턴트 메시지를 찾을 수 없어요. 루프를 중단할게요." >&2
  rm "$RALPH_STATE_FILE"
  exit 0
fi

LAST_LINES=$(grep '"role":"assistant"' "$TRANSCRIPT_PATH" | tail -n 100)
if [[ -z "$LAST_LINES" ]]; then
  rm "$RALPH_STATE_FILE"
  exit 0
fi

set +e
LAST_OUTPUT=$(echo "$LAST_LINES" | jq -rs '
  map(.message.content[]? | select(.type == "text") | .text) | last // ""
' 2>&1)
JQ_EXIT=$?
set -e

if [[ $JQ_EXIT -ne 0 ]]; then
  echo "fireauto loop: JSON 파싱 실패. 루프를 중단할게요." >&2
  rm "$RALPH_STATE_FILE"
  exit 0
fi

# 완료 조건 확인
if [[ "$COMPLETION_PROMISE" != "null" ]] && [[ -n "$COMPLETION_PROMISE" ]]; then
  PROMISE_TEXT=$(echo "$LAST_OUTPUT" | perl -0777 -pe 's/.*?<promise>(.*?)<\/promise>.*/$1/s; s/^\s+|\s+$//g; s/\s+/ /g' 2>/dev/null || echo "")

  if [[ -n "$PROMISE_TEXT" ]] && [[ "$PROMISE_TEXT" = "$COMPLETION_PROMISE" ]]; then
    echo "fireauto loop: 완료 조건 달성! <promise>$COMPLETION_PROMISE</promise>"
    rm "$RALPH_STATE_FILE"
    exit 0
  fi
fi

# 다음 반복으로 진행
NEXT_ITERATION=$((ITERATION + 1))

PROMPT_TEXT=$(awk '/^---$/{i++; next} i>=2' "$RALPH_STATE_FILE")

if [[ -z "$PROMPT_TEXT" ]]; then
  echo "fireauto loop: 프롬프트를 찾을 수 없어요. 루프를 중단할게요." >&2
  rm "$RALPH_STATE_FILE"
  exit 0
fi

TEMP_FILE="${RALPH_STATE_FILE}.tmp.$$"
sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$RALPH_STATE_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$RALPH_STATE_FILE"

if [[ "$COMPLETION_PROMISE" != "null" ]] && [[ -n "$COMPLETION_PROMISE" ]]; then
  SYSTEM_MSG="fireauto loop $NEXT_ITERATION번째 반복 | 완료하려면: <promise>$COMPLETION_PROMISE</promise> (진짜 완료됐을 때만!)"
else
  SYSTEM_MSG="fireauto loop $NEXT_ITERATION번째 반복 | 완료 조건 없음 - 무한 반복 중"
fi

jq -n \
  --arg prompt "$PROMPT_TEXT" \
  --arg msg "$SYSTEM_MSG" \
  '{
    "decision": "block",
    "reason": $prompt,
    "systemMessage": $msg
  }'

exit 0
