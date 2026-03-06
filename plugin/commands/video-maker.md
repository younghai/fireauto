---
description: "코드로 영상을 만들어요. React 기반 Remotion으로 프로그래밍 영상 제작."
allowed-tools:
  - Read
  - Edit
  - Write
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
  - WebFetch
  - mcp__remotion-documentation__remotion-documentation
user-invocable: true
---

# video-maker: 코드 기반 영상 제작

React 기반 프레임워크 **Remotion**을 사용해서 코드로 영상을 만들어주는 커맨드예요.
프로그래밍으로 영상을 만들 수 있어서, AI가 직접 영상 코드를 작성하고 렌더링할 수 있어요.

모든 출력은 **한국어(토스체)**로 작성해요.

---

## Step 0: Remotion MCP 설치 확인

Remotion MCP가 설치되어 있으면 문서 검색이 훨씬 정확해져요. 설치 여부를 먼저 확인하세요:

`mcp__remotion-documentation__remotion-documentation` 도구가 사용 가능한지 확인해요.

### 사용 불가능한 경우 — MCP 설치 안내

사용자에게 안내하세요:

> Remotion MCP를 설치하면 AI가 공식 문서를 실시간으로 검색할 수 있어요.
> 설치 방법이에요:

```bash
# Claude Code를 종료하고, .mcp.json 파일에 추가해요
```

프로젝트 루트의 `.mcp.json` 파일을 확인하거나 생성하세요:

```json
{
  "mcpServers": {
    "remotion-documentation": {
      "command": "npx",
      "args": ["@remotion/mcp@latest"]
    }
  }
}
```

> 설정을 저장한 뒤 **Claude Code를 종료하고 다시 시작**해야 MCP가 활성화돼요.
> 종료: `Ctrl+C` 또는 `/exit`
> 재시작: `claude`
>
> 재시작 후 다시 `/video-maker`를 실행해주세요!

MCP 없이도 기본 기능은 동작하지만, MCP가 있으면 30개 이상의 Remotion 전문 규칙(자막, 3D, 차트, 오디오 등)을 실시간 참조할 수 있어요.

---

## Step 1: 모드 파악

사용자 메시지에서 모드를 파악하세요:

- **init** — "새 영상 프로젝트", "Remotion 셋업", "영상 프로젝트 만들기" → 프로젝트 초기 설정
- **create** — "영상 만들어줘", "인트로 영상", "텍스트 애니메이션" → 영상 컴포넌트 생성
- **edit** — "영상 수정", "길이 변경", "색상 바꿔" → 기존 영상 수정
- **render** — "렌더링", "영상 출력", "mp4로" → 영상 렌더링

---

## Step 2-A: init 모드 (프로젝트 셋업)

### 기존 프로젝트에 추가하는 경우

```bash
npm i remotion @remotion/cli @remotion/media
```

필요에 따라 추가 패키지:
- `@remotion/transitions` — 장면 전환 효과
- `@remotion/gif` — GIF 임베딩
- `@remotion/three` — 3D (Three.js)

기본 파일 구조를 생성하세요:

```
src/remotion/
├── index.ts        # registerRoot
├── Root.tsx        # Composition 정의
└── compositions/   # 영상 컴포넌트들
    └── MyVideo.tsx
```

**src/remotion/index.ts:**
```ts
import { registerRoot } from "remotion";
import { Root } from "./Root";
registerRoot(Root);
```

**src/remotion/Root.tsx:**
```tsx
import { Composition } from "remotion";
import { MyVideo } from "./compositions/MyVideo";

export const Root: React.FC = () => (
  <>
    <Composition
      id="MyVideo"
      component={MyVideo}
      durationInFrames={150}
      width={1920}
      height={1080}
      fps={30}
      defaultProps={{}}
    />
  </>
);
```

### 새 프로젝트로 만드는 경우

```bash
npx create-video@latest --blank
```

---

## Step 2-B: create 모드 (영상 제작)

사용자에게 물어보세요:

> 어떤 영상을 만들고 싶으세요?
>
> 예시:
> - "로고 인트로 영상 (3초)"
> - "텍스트 타이핑 효과"
> - "제품 소개 슬라이드 (자막 포함)"
> - "데이터 차트 애니메이션"
> - "유튜브 썸네일 스틸 이미지"

### Remotion 핵심 개념 (영상 제작 시 참고)

**프레임 기반 애니메이션:**
- `useCurrentFrame()` — 현재 프레임 번호 (0부터 시작)
- `useVideoConfig()` — fps, durationInFrames, width, height
- 30fps 기준: 1초 = 30프레임, 5초 = 150프레임

**레이아웃:**
- `<AbsoluteFill>` — 요소를 겹쳐서 배치
- `<Sequence from={30} durationInFrames={60}>` — 특정 시점에 등장
- `<Series>` — 순차적 배치
- `<TransitionSeries>` — 전환 효과 포함 순차 배치

**애니메이션:**
- `interpolate(frame, [0, 30], [0, 1], { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' })` — 값 보간
- `spring({ fps, frame, config: { damping: 200 } })` — 스프링 물리 애니메이션

**미디어:**
- `<Video src="..." />` — 비디오 (`@remotion/media`)
- `<Audio src="..." />` — 오디오 (`@remotion/media`)
- `<Img src="..." />` — 이미지 (`remotion`)
- `staticFile('파일명')` — public/ 폴더 에셋 참조

**랜덤:** `Math.random()` 금지. `random('seed')` from `remotion` 사용.

**스타일링:** 일반 CSS, Tailwind CSS 모두 사용 가능.

### 세부 도메인 지식이 필요할 때

Remotion MCP 도구(`mcp__remotion-documentation__remotion-documentation`)를 활용해서 상세 문서를 검색하세요:

| 주제 | 검색 키워드 |
|------|-----------|
| 자막/캡션 | subtitles captions |
| 3D 콘텐츠 | three.js 3d react three fiber |
| 차트 애니메이션 | charts data visualization |
| 텍스트 애니메이션 | text animation typewriter |
| 장면 전환 | transitions fade wipe slide |
| 오디오 시각화 | audio visualization spectrum |
| 폰트 로딩 | google fonts local fonts |
| GIF | gif animation |
| Lottie 애니메이션 | lottie |

---

## Step 2-C: edit 모드 (영상 수정)

1. 프로젝트의 Remotion 파일들을 스캔 (`src/remotion/` 또는 `src/`)
2. Root.tsx에서 Composition 목록 확인
3. 사용자 요청에 따라 수정

---

## Step 2-D: render 모드 (렌더링)

### 프리뷰 (Studio)

```bash
npx remotion studio
# 또는 src/remotion/index.ts를 entry로 지정
npx remotion studio src/remotion/index.ts
```

브라우저에서 localhost:3000으로 프리뷰할 수 있어요.

### 영상 렌더링

```bash
# MP4로 렌더링
npx remotion render MyVideo

# 특정 entry 파일 지정
npx remotion render src/remotion/index.ts MyVideo

# 출력 파일명 지정
npx remotion render MyVideo out/my-video.mp4
```

### 스틸 이미지 (썸네일)

```bash
npx remotion still MyVideo out/thumbnail.png
```

---

## Step 3: 영상 컴포넌트 작성 규칙

코드를 작성할 때 반드시 지켜야 할 것:

1. **TypeScript** 사용
2. **결정론적** — `Math.random()` 대신 `random('seed')` 사용
3. **extrapolate 클램핑** — `interpolate()` 사용 시 항상 `extrapolateLeft: 'clamp', extrapolateRight: 'clamp'` 추가
4. **프레임 기반** — 시간은 초가 아닌 프레임으로 계산 (fps 참조)
5. **Composition 등록** — 새 컴포넌트를 만들면 Root.tsx에 Composition 추가

---

## 톤 & 스타일 가이드

- **언어**: 한국어 (기술 용어는 영어 병기)
- **문체**: 토스체
- 영상 구조를 먼저 설명하고 코드를 작성해요
- 복잡한 영상은 씬(Scene) 단위로 나눠서 구현해요
- 렌더링 전에 프리뷰 방법을 안내해요
