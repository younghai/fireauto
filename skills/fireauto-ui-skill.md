---
description: |
  DaisyUI v5 기반 UI 구축 및 마이그레이션 스킬.
  트리거 키워드: DaisyUI, daisyui, UI 마이그레이션, UI migration, shadcn to daisyui, 테마, theme, 컴포넌트 변환, component migration
---

# DaisyUI v5 Best Practices & Patterns

## 핵심 원칙

1. **시맨틱 컬러 우선**: 하드코딩 색상 대신 DaisyUI 시맨틱 토큰 사용
2. **클래스 기반**: React 컴포넌트 import 없이 HTML 클래스로 UI 구성
3. **테마 일관성**: oklch() 컬러 시스템으로 테마 간 일관된 색상 유지
4. **최소 JS**: 가능한 CSS-only 솔루션 활용 (modal, collapse, swap 등)

---

## DaisyUI v5 컴포넌트 패턴

### 버튼 패턴

```html
<!-- 기본 버튼 -->
<button class="btn btn-primary">기본</button>
<button class="btn btn-secondary">보조</button>
<button class="btn btn-accent">강조</button>

<!-- 크기 변형 -->
<button class="btn btn-xs">아주 작게</button>
<button class="btn btn-sm">작게</button>
<button class="btn btn-md">보통</button>
<button class="btn btn-lg">크게</button>

<!-- 스타일 변형 -->
<button class="btn btn-outline btn-primary">아웃라인</button>
<button class="btn btn-ghost">고스트</button>
<button class="btn btn-link">링크</button>
<button class="btn btn-soft btn-primary">소프트</button>
<button class="btn btn-dash btn-primary">대시</button>

<!-- 상태 -->
<button class="btn btn-primary" disabled>비활성</button>
<button class="btn btn-primary"><span class="loading loading-spinner loading-sm"></span>로딩</button>

<!-- 아이콘 버튼 -->
<button class="btn btn-square btn-sm">
  <svg>...</svg>
</button>
<button class="btn btn-circle">
  <svg>...</svg>
</button>
```

### 카드 패턴

```html
<!-- 기본 카드 -->
<div class="card bg-base-100 shadow-xl">
  <figure><img src="..." alt="..." /></figure>
  <div class="card-body">
    <h2 class="card-title">제목</h2>
    <p>설명 텍스트</p>
    <div class="card-actions justify-end">
      <button class="btn btn-primary">액션</button>
    </div>
  </div>
</div>

<!-- 가로 카드 -->
<div class="card card-side bg-base-100 shadow-xl">
  <figure><img src="..." alt="..." /></figure>
  <div class="card-body">
    <h2 class="card-title">제목</h2>
    <p>설명</p>
  </div>
</div>

<!-- 이미지 오버레이 카드 -->
<div class="card image-full">
  <figure><img src="..." alt="..." /></figure>
  <div class="card-body">
    <h2 class="card-title">제목</h2>
  </div>
</div>

<!-- 콤팩트 카드 -->
<div class="card card-compact bg-base-100 shadow-xl">
```

### 모달 패턴

```html
<!-- HTML dialog 기반 모달 -->
<button class="btn" onclick="my_modal.showModal()">열기</button>
<dialog id="my_modal" class="modal">
  <div class="modal-box">
    <h3 class="font-bold text-lg">제목</h3>
    <p class="py-4">내용</p>
    <div class="modal-action">
      <form method="dialog">
        <button class="btn">닫기</button>
      </form>
    </div>
  </div>
  <form method="dialog" class="modal-backdrop">
    <button>close</button>
  </form>
</dialog>

<!-- React에서 사용 시 -->
const modalRef = useRef<HTMLDialogElement>(null);
<button className="btn" onClick={() => modalRef.current?.showModal()}>열기</button>
<dialog ref={modalRef} className="modal">
  <div className="modal-box">...</div>
</dialog>
```

### 네비게이션 바 패턴

```html
<div class="navbar bg-base-100">
  <div class="navbar-start">
    <a class="btn btn-ghost text-xl">로고</a>
  </div>
  <div class="navbar-center hidden lg:flex">
    <ul class="menu menu-horizontal px-1">
      <li><a>항목 1</a></li>
      <li><a>항목 2</a></li>
    </ul>
  </div>
  <div class="navbar-end">
    <a class="btn btn-primary">CTA</a>
  </div>
</div>
```

### 드로어(사이드바) 패턴

```html
<div class="drawer lg:drawer-open">
  <input id="my-drawer" type="checkbox" class="drawer-toggle" />
  <div class="drawer-content">
    <!-- 메인 콘텐츠 -->
    <label for="my-drawer" class="btn btn-ghost drawer-button lg:hidden">메뉴</label>
  </div>
  <div class="drawer-side">
    <label for="my-drawer" class="drawer-overlay"></label>
    <ul class="menu bg-base-200 min-h-full w-80 p-4">
      <li><a>사이드바 항목</a></li>
    </ul>
  </div>
</div>
```

### 탭 패턴

```html
<div role="tablist" class="tabs tabs-bordered">
  <a role="tab" class="tab">탭 1</a>
  <a role="tab" class="tab tab-active">탭 2</a>
  <a role="tab" class="tab">탭 3</a>
</div>

<!-- 리프트 스타일 -->
<div role="tablist" class="tabs tabs-lifted">

<!-- 박스 스타일 -->
<div role="tablist" class="tabs tabs-boxed">
```

### 통계(Stats) 패턴

```html
<div class="stats shadow">
  <div class="stat">
    <div class="stat-figure text-primary">
      <svg>...</svg>
    </div>
    <div class="stat-title">총 방문</div>
    <div class="stat-value text-primary">25.6K</div>
    <div class="stat-desc">21% 증가</div>
  </div>
  <div class="stat">
    <div class="stat-title">매출</div>
    <div class="stat-value">$1,200</div>
    <div class="stat-desc text-secondary">전월 대비 +14%</div>
  </div>
</div>
```

### 히어로 패턴

```html
<div class="hero min-h-screen bg-base-200">
  <div class="hero-content text-center">
    <div class="max-w-md">
      <h1 class="text-5xl font-bold">제목</h1>
      <p class="py-6">설명 텍스트</p>
      <button class="btn btn-primary">시작하기</button>
    </div>
  </div>
</div>
```

### 토스트 패턴

```html
<div class="toast toast-end">
  <div class="alert alert-success">
    <span>저장되었습니다.</span>
  </div>
</div>
```

### 타임라인 패턴

```html
<ul class="timeline timeline-vertical">
  <li>
    <div class="timeline-start">2024</div>
    <div class="timeline-middle">
      <svg>...</svg>
    </div>
    <div class="timeline-end timeline-box">내용</div>
    <hr />
  </li>
</ul>
```

---

## 테마 설정 가이드

### DaisyUI v5 테마 정의 (globals.css)

```css
@plugin "daisyui" {
  themes: light --default, dark --prefersdark,
  my_theme {
    primary: oklch(0.7 0.2 75);
    primary-content: oklch(0.15 0.01 75);
    secondary: oklch(0.6 0.15 250);
    secondary-content: oklch(0.95 0.01 250);
    accent: oklch(0.75 0.18 150);
    accent-content: oklch(0.15 0.01 150);
    neutral: oklch(0.3 0.01 260);
    neutral-content: oklch(0.9 0.01 260);
    base-100: oklch(0.98 0.005 260);
    base-200: oklch(0.93 0.005 260);
    base-300: oklch(0.88 0.005 260);
    base-content: oklch(0.2 0.01 260);
    info: oklch(0.7 0.15 220);
    info-content: oklch(0.15 0.01 220);
    success: oklch(0.7 0.18 150);
    success-content: oklch(0.15 0.01 150);
    warning: oklch(0.8 0.18 80);
    warning-content: oklch(0.15 0.01 80);
    error: oklch(0.65 0.2 25);
    error-content: oklch(0.95 0.01 25);
  };
}
```

### oklch() 색상 참조

| 색상 | L | C | H |
|------|---|---|---|
| 밝은 빨강 | 0.65 | 0.2 | 25 |
| 주황 | 0.75 | 0.18 | 60 |
| 황금색 | 0.8 | 0.2 | 85 |
| 초록 | 0.7 | 0.18 | 150 |
| 시안 | 0.7 | 0.15 | 190 |
| 파랑 | 0.6 | 0.2 | 250 |
| 보라 | 0.55 | 0.2 | 290 |
| 분홍 | 0.7 | 0.18 | 340 |

### 다크 테마 만들기

다크 테마에서는 base 값의 Lightness를 낮추고, content의 Lightness를 높입니다:

```
base-100: oklch(0.15 ...)   // 매우 어두운 배경
base-200: oklch(0.12 ...)   // 더 어두운 배경
base-300: oklch(0.1 ...)    // 가장 어두운 배경
base-content: oklch(0.9 ...)  // 밝은 텍스트
```

---

## shadcn/ui -> DaisyUI 마이그레이션 치트시트

### import 제거 대상
```typescript
// 이 모든 import를 제거:
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle, CardFooter, CardDescription } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { Dialog, DialogContent, DialogTrigger, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion"
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Checkbox } from "@/components/ui/checkbox"
import { Switch } from "@/components/ui/switch"
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip"
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu"
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet"
import { Separator } from "@/components/ui/separator"
import { Skeleton } from "@/components/ui/skeleton"
import { Progress } from "@/components/ui/progress"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"
```

### 빠른 변환 참조

```
Button variant="default" -> btn btn-primary
Button variant="ghost" -> btn btn-ghost
Button variant="outline" -> btn btn-outline
Button variant="secondary" -> btn btn-secondary
Button variant="destructive" -> btn btn-error
Button variant="link" -> btn btn-link
Button size="sm" -> btn btn-sm
Button size="lg" -> btn btn-lg
Button size="icon" -> btn btn-square btn-sm

Card -> card bg-base-100 shadow-xl
CardTitle -> card-title
CardContent -> card-body
CardFooter -> card-actions

Badge -> badge
Badge variant="secondary" -> badge badge-secondary
Badge variant="destructive" -> badge badge-error
Badge variant="outline" -> badge badge-outline

Input -> input input-bordered w-full
Textarea -> textarea textarea-bordered w-full
Select -> select select-bordered w-full
Checkbox -> checkbox
Switch -> toggle

Dialog -> modal (HTML dialog)
Alert -> alert
Avatar -> avatar
Tooltip -> tooltip (data-tip 속성)
Separator -> divider
Skeleton -> skeleton
Progress -> progress
Sheet -> drawer
```

---

## 자주 사용하는 조합 패턴

### 가격 카드
```html
<div class="card bg-base-100 shadow-xl border border-primary">
  <div class="card-body items-center text-center">
    <span class="badge badge-primary">인기</span>
    <h2 class="card-title text-2xl">프로 플랜</h2>
    <p class="text-4xl font-bold text-primary">$29<span class="text-sm text-base-content/60">/월</span></p>
    <ul class="space-y-2 my-4">
      <li class="flex items-center gap-2"><svg>체크</svg> 기능 1</li>
      <li class="flex items-center gap-2"><svg>체크</svg> 기능 2</li>
    </ul>
    <div class="card-actions">
      <button class="btn btn-primary btn-wide">시작하기</button>
    </div>
  </div>
</div>
```

### FAQ 아코디언
```html
<div class="join join-vertical w-full">
  <div class="collapse collapse-arrow join-item border border-base-300">
    <input type="radio" name="faq" checked />
    <div class="collapse-title text-xl font-medium">질문 1</div>
    <div class="collapse-content"><p>답변 1</p></div>
  </div>
  <div class="collapse collapse-arrow join-item border border-base-300">
    <input type="radio" name="faq" />
    <div class="collapse-title text-xl font-medium">질문 2</div>
    <div class="collapse-content"><p>답변 2</p></div>
  </div>
</div>
```

### 피처 그리드
```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  <div class="card bg-base-200">
    <div class="card-body">
      <div class="text-primary text-3xl mb-2">아이콘</div>
      <h3 class="card-title">기능 제목</h3>
      <p class="text-base-content/70">기능 설명</p>
    </div>
  </div>
  <!-- 반복 -->
</div>
```
