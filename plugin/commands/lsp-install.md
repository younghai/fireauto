---
description: "LSP를 켜서 Claude Code의 코드 이해력을 극대화해요."
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - AskUserQuestion
user-invocable: true
---

# fireauto-lsp: Claude Code LSP 원클릭 셋업

Claude Code에 LSP(Language Server Protocol)를 연결해서 코드 탐색 속도와 정확도를 극대화하는 커맨드예요.

모든 출력은 **한국어(토스체)**로 작성해요.

---

## LSP가 뭔지 간단히 설명

Claude Code는 기본적으로 코드를 찾을 때 **텍스트 검색(grep)**을 써요.
LSP를 켜면 VS Code의 "정의로 이동(Ctrl+Click)"처럼 **코드 구조를 이해하면서** 찾아요.

- 속도: 수십 초 → 50ms
- 정확도: 비슷한 단어 → 정확한 호출 계층
- 에러 감지: 편집 직후 타입 에러 즉시 포착
- 토큰 절약: 엉뚱한 파일 안 읽으니까 비용도 절약

---

## Step 1: 어떤 개발을 하시나요?

먼저 사용자에게 **개발 분야**를 물어보세요. 초보자도 쉽게 고를 수 있도록 선택지를 보여줘요:

```
어떤 개발을 하고 계세요? (번호로 골라주세요, 여러 개 가능!)

1. 웹 개발 (React, Next.js, Vue 등)
2. 백엔드 개발 (Python, Go, Java 등)
3. iOS/macOS 앱 개발 (Swift)
4. 안드로이드 앱 개발 (Kotlin)
5. 시스템/임베디드 (C/C++, Rust)
6. 게임 개발 (C#/Unity)
7. 잘 모르겠어요 (프로젝트 자동 감지해줘!)
```

선택에 따라 설치할 항목을 매핑하세요:

| 선택 | 설치되는 LSP | 설치 명령 | 플러그인 |
|------|-------------|-----------|----------|
| 1. 웹 개발 | typescript-language-server | `npm i -g typescript-language-server typescript` | `typescript-lsp` |
| 2. 백엔드 (Python) | pyright | `npm i -g pyright` | `pyright-lsp` |
| 2. 백엔드 (Go) | gopls | `go install golang.org/x/tools/gopls@latest` | `gopls-lsp` |
| 2. 백엔드 (Java) | jdtls | `brew install jdtls` | `jdtls-lsp` |
| 2. 백엔드 (PHP) | intelephense | `npm i -g intelephense` | `php-lsp` |
| 3. iOS/macOS | sourcekit-lsp | (Xcode에 포함) | `swift-lsp` |
| 4. 안드로이드 | kotlin-language-server | `brew install kotlin-language-server` | `kotlin-lsp` |
| 5. 시스템 (C/C++) | clangd | `brew install llvm` | `clangd-lsp` |
| 5. 시스템 (Rust) | rust-analyzer | `rustup component add rust-analyzer` | `rust-analyzer-lsp` |
| 6. 게임 (C#) | csharp-ls | `dotnet tool install -g csharp-ls` | `csharp-lsp` |

### "7. 잘 모르겠어요"를 선택한 경우

프로젝트 루트에서 Glob으로 아래 파일들을 자동 감지하세요:

| 감지 파일 | 언어 |
|-----------|------|
| `tsconfig.json`, `package.json` | TypeScript/JS |
| `requirements.txt`, `pyproject.toml`, `*.py` | Python |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `Package.swift`, `*.xcodeproj` | Swift |
| `pom.xml`, `build.gradle` | Java |
| `*.csproj`, `*.sln` | C# |
| `composer.json` | PHP |
| `CMakeLists.txt` + `*.c`/`*.cpp` | C/C++ |
| `build.gradle.kts` + `*.kt` | Kotlin |

감지 결과를 보여주고 확인을 받으세요:
```
프로젝트를 분석해봤어요!
감지된 언어: TypeScript, Python
이대로 설치할까요?
```

### "2. 백엔드"를 선택한 경우

백엔드 언어가 여러 개라서 추가 질문을 해주세요:
```
어떤 백엔드 언어를 쓰세요? (여러 개 가능!)

1. Python (Django, FastAPI, Flask 등)
2. Go (Gin, Echo, Fiber 등)
3. Java (Spring Boot 등)
4. PHP (Laravel 등)
```

---

## Step 2: Language Server 바이너리 설치

감지된 각 언어에 대해:

1. `which {바이너리이름}` 으로 이미 설치되었는지 확인
2. 설치 안 되어있으면 설치 명령 실행
3. 설치 후 `which`로 재확인

설치 결과를 보여주세요:
```
typescript-language-server ... 이미 설치됨 ✓
pyright ... 설치 중 → 완료 ✓
```

---

## Step 3: ENABLE_LSP_TOOL 환경변수 설정

`~/.claude/settings.json` 파일을 읽어서 `env` 섹션에 `ENABLE_LSP_TOOL`이 있는지 확인하세요.

없으면 추가:
```json
"env": {
  "ENABLE_LSP_TOOL": "1",
  ...기존 값 유지
}
```

**주의**: 기존 `env` 값(예: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`)을 절대 덮어쓰지 마세요. 기존 값을 유지하면서 `ENABLE_LSP_TOOL`만 추가해요.

---

## Step 4: LSP 플러그인 설치 및 활성화

감지된 각 언어에 대해:

1. `~/.claude/settings.json`의 `enabledPlugins`에 이미 있는지 확인
2. 없으면 `claude plugin install {플러그인이름}` 실행
3. `enabledPlugins`에 `"{플러그인이름}@claude-plugins-official": true` 추가

```bash
# 예시
claude plugin install typescript-lsp
claude plugin install pyright-lsp
```

**주의**: `enabledPlugins`의 기존 플러그인(fireauto 등)을 절대 제거하지 마세요.

---

## Step 5: 검증 및 안내

설정 완료 후 사용자에게 보여주세요:

```
LSP 셋업 완료!

설정된 항목:
  ✓ ENABLE_LSP_TOOL=1 (settings.json)
  ✓ typescript-language-server 설치됨
  ✓ typescript-lsp 플러그인 활성화됨
  ✓ pyright 설치됨
  ✓ pyright-lsp 플러그인 활성화됨

⚠️ Claude Code를 재시작해야 LSP가 적용돼요.
   터미널에서 exit 후 다시 claude를 실행하세요.

재시작 후 확인 방법:
  "이 프로젝트의 PaymentProvider 인터페이스 정의를 찾아줘"
  → LSP가 켜져있으면 파일을 뒤지지 않고 바로 찾아요.
```

---

## 톤 & 스타일 가이드

- **언어**: 한국어 (기술 용어는 영어 병기)
- **문체**: 토스체 — 친근하고 명확하게
- 에러가 나면 원인과 해결법을 친절하게 안내해요
- 각 단계가 끝날 때마다 진행 상황을 알려줘요
- 설치 실패 시 수동 설치 방법도 함께 안내해요
