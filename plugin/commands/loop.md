---
description: "AI가 알아서 반복하며 작업을 완성해요. 프롬프트 하나면 충분해요."
argument-hint: "할 일 [--max-iterations 횟수] [--completion-promise 완료조건]"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/scripts/setup-loop.sh:*)"]
hide-from-slash-command-tool: "true"
user-invocable: true
---

# fireauto loop

셋업 스크립트를 실행해서 루프를 시작해요:

```!
"${CLAUDE_PLUGIN_ROOT}/scripts/setup-loop.sh" $ARGUMENTS
```

이제 작업을 시작하세요. 작업을 끝내고 나가려고 하면, 같은 프롬프트가 다시 들어와요. 이전 작업 결과는 파일과 git 히스토리에 남아있으니, 매번 더 나은 결과를 만들 수 있어요.

중요 규칙: completion-promise가 설정되어 있으면, 그 조건이 진짜로 완전히 달성되었을 때만 `<promise>완료조건</promise>`을 출력하세요. 루프를 탈출하기 위해 거짓말하지 마세요.
