---
description: "FireShip 보일러플레이트를 커맨드 하나로 설치해요."
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - AskUserQuestion
user-invocable: true
---

# fireauto-fireship-install: FireShip Starter Kit 자동 설치

FireShip Starter Kit(FireShipZip3) 보일러플레이트를 자동으로 설치하고, `docs/llm.md` 온보딩 가이드에 따라 초기 설정까지 도와주는 커맨드예요.

- **GitHub**: https://github.com/imgompanda/FireShipZip3
- **데모**: https://fire-ship-zip3.vercel.app

모든 출력은 **한국어(토스체)**로 작성해요.

---

## Step 1: 설치 환경 확인

먼저 현재 환경을 확인하세요:

```bash
node --version
git --version
```

- Node.js 18 이상이 필요해요
- git이 설치되어 있어야 해요

환경이 준비되지 않았으면 사용자에게 설치 방법을 안내하세요.

---

## Step 2: 프로젝트 이름 및 경로 결정

사용자에게 물어보세요:

> 프로젝트 이름을 정해주세요! (예: my-saas, my-app)
> 기본값: 현재 디렉토리에 `FireShipZip3` 이름으로 생성돼요.

사용자가 이름을 지정하면 그 이름으로, 아니면 기본값으로 진행해요.

---

## Step 3: 보일러플레이트 클론

```bash
git clone https://github.com/imgompanda/FireShipZip3.git {프로젝트이름}
cd {프로젝트이름}
```

클론이 완료되면 git 히스토리를 초기화해요:

```bash
rm -rf .git
git init
git add -A
git commit -m "Initial commit from FireShip Starter Kit"
```

---

## Step 4: 패키지 매니저 확인 및 의존성 설치

사용자에게 물어보세요:

> 어떤 패키지 매니저를 쓸까요? (npm / yarn / pnpm / bun)
> 기본값: npm

선택한 패키지 매니저로 설치해요:

```bash
# npm인 경우
npm install

# pnpm인 경우
pnpm install

# yarn인 경우
yarn install

# bun인 경우
bun install
```

---

## Step 5: 환경 변수 설정

`.env.example` 파일을 `.env.local`로 복사해요:

```bash
cp .env.example .env.local
```

사용자에게 안내하세요:

> `.env.local` 파일이 생성됐어요! 아래 키들을 설정해야 해요:
>
> **필수 (이것만 있으면 기본 동작해요)**
> - `NEXT_PUBLIC_SUPABASE_URL` — Supabase 프로젝트 URL
> - `NEXT_PUBLIC_SUPABASE_ANON_KEY` — Supabase 공개 키
> - `SUPABASE_SERVICE_ROLE_KEY` — Supabase 서비스 키
>
> **결제 연동 (3가지 중 택 1)**
> - `NEXT_PUBLIC_PAYMENT_PROVIDER` — 결제 프로바이더 선택 (lemon / paddle / toss, 기본: lemon)
>
> - LemonSqueezy: `LEMONSQUEEZY_API_KEY`, `LEMONSQUEEZY_WEBHOOK_SECRET`
> - Paddle: `PADDLE_API_KEY`, `PADDLE_WEBHOOK_SECRET`, `PADDLE_ENVIRONMENT` (sandbox/production)
> - Toss: `TOSS_SECRET_KEY`, `TOSS_CLIENT_KEY`, `TOSS_WEBHOOK_SECRET`
>
> **이메일**
> - `RESEND_API_KEY` — Resend API 키
>
> **AI 기능**
> - `GOOGLE_GENERATIVE_AI_API_KEY` — Gemini API 키
>
> 각 서비스 설정 가이드는 `docs/` 폴더에 있어요.
> 지금 바로 설정할 수도 있고, 나중에 해도 괜찮아요.

사용자가 키를 제공하면 `.env.local` 파일에 직접 입력해주세요.
제공하지 않으면 그냥 넘어가세요.

---

## Step 6: llm.md 온보딩 가이드 시작

설치가 완료되면 **`docs/llm.md` 파일을 반드시 읽어서** 이후 설정 가이드로 활용하세요.

`llm.md`는 온보딩 매니저 시스템 프롬프트예요. 이 파일에 다음 내용이 모두 담겨있어요:

- **설정 순서**: Prep → Run → Deploy → Auth → Pay → Email → Test → Polish
- **각 단계별 문서 경로**: `docs/00-overview`, `docs/01-quick-start` 등
- **선택/필수 모듈 구분**: 결제, 이메일, AI SDK, Analytics 등은 스킵 가능
- **스킵 시 UI 비활성화 방법**: 어떤 컴포넌트를 제거해야 하는지
- **배포 후 URL 활용법**: Supabase, LemonSqueezy 설정에 배포 URL 사용
- **진행 상황 추적**: `setup_progress.md` 템플릿
- **보안 안내**: 데모 모드, 환경변수, 디버그 페이지 등
- **트러블슈팅**: 의존성, 환경변수, 코드 이슈 해결법

### llm.md 활용 방법

```
1. Read로 docs/llm.md 파일을 읽어요
2. llm.md의 Initialization Protocol에 따라 setup_progress.md를 생성해요
3. Resource Library 매핑 테이블에 따라 단계별로 진행해요
4. 각 단계에서 해당 docs/ 문서를 참조해요
5. 사용자가 스킵하면 Disabling Guide에 따라 UI를 비활성화해요
```

사용자에게 안내하세요:

> 설치 완료! 이제 본격적인 설정을 시작할게요.
> `docs/llm.md` 가이드에 따라 단계별로 진행할게요.
> 선택 모듈(결제, 이메일, AI 등)은 스킵할 수 있어요.
>
> 설정을 시작할까요?

사용자가 동의하면 llm.md의 **Initialization Protocol**을 실행하세요:
1. `docs/` 폴더의 파일 목록을 스캔
2. `setup_progress.md` 생성 (llm.md의 Progress Template 사용)
3. Step 0부터 순차적으로 진행

---

## Step 6.5: MCP 서버 설정 (선택)

AI 코딩 도구(Claude Code, Cursor 등)로 개발할 때 공식 문서 참조를 자동화할 수 있어요.

사용자에게 안내하세요:

> AI 코딩 도구를 사용하시나요? `.mcp.json` 파일을 프로젝트 루트에 생성하면
> Supabase DB, Paddle 문서, Toss 문서를 AI가 직접 참조할 수 있어요.
>
> `.mcp.json`은 `.gitignore`에 포함되어 있어서 API 키가 노출되지 않아요.

```json
{
  "mcpServers": {
    "supabase": {
      "type": "http",
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_REF"
    },
    "paddle": {
      "command": "npx",
      "args": ["-y", "@paddle/paddle-mcp", "--api-key=YOUR_PADDLE_API_KEY", "--environment=sandbox"]
    },
    "tosspayments": {
      "command": "npx",
      "args": ["-y", "@tosspayments/integration-guide-mcp"]
    }
  }
}
```

> 사용하지 않는 프로바이더는 제거해도 돼요.

---

## Step 7: 설치 완료 요약

설정 시작 전에 기본 정보를 보여주세요:

```
설치 완료! 프로젝트가 준비됐어요.

실행하기:
  {패키지매니저} run dev

프로젝트 구조:
  src/app/         — 페이지 (Next.js App Router)
  src/components/  — UI 컴포넌트
  src/lib/         — 유틸리티
  docs/            — 설정 가이드 (12개 섹션)
  docs/llm.md      — AI 온보딩 가이드 (전체 설정 로드맵)
  messages/        — 다국어 파일 (en.json, ko.json)

다음으로 해보면 좋은 것들:
  /fireauto-seo     — SEO 점검
  /fireauto-secure  — 보안 점검
  /fireauto-ui      — UI 커스터마이징

GitHub: https://github.com/imgompanda/FireShipZip3
데모:   https://fire-ship-zip3.vercel.app
```

---

## 톤 & 스타일 가이드

- **언어**: 한국어 (기술 용어는 영어 병기)
- **문체**: 토스체 — 친근하고 명확하게
- 에러가 나면 원인과 해결법을 친절하게 안내해요
- 각 단계가 끝날 때마다 진행 상황을 알려줘요
