---
description: "실행 중인 루프를 중단해요."
allowed-tools: ["Bash(test -f .claude/fireauto-loop.local.md:*)", "Bash(rm .claude/fireauto-loop.local.md)", "Read(.claude/fireauto-loop.local.md)"]
hide-from-slash-command-tool: "true"
user-invocable: true
---

# 루프 취소

루프를 취소하려면:

1. `.claude/fireauto-loop.local.md` 파일이 있는지 확인: `test -f .claude/fireauto-loop.local.md && echo "EXISTS" || echo "NOT_FOUND"`

2. **NOT_FOUND**: "실행 중인 루프가 없어요." 라고 안내하세요.

3. **EXISTS**:
   - `.claude/fireauto-loop.local.md`를 읽어서 `iteration:` 값을 확인
   - 파일 삭제: `rm .claude/fireauto-loop.local.md`
   - "루프를 취소했어요. (N번째 반복 중이었어요)" 라고 안내하세요.
