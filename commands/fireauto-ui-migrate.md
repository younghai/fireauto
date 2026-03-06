---
description: "shadcn/ui에서 DaisyUI로 컴포넌트 마이그레이션"
allowed-tools:
  - Read
  - Edit
  - Write
  - Glob
  - Grep
user-invocable: true
---

# fireauto-ui-migrate: shadcn/ui -> DaisyUI 마이그레이션

shadcn/ui 컴포넌트를 DaisyUI v5 클래스 기반으로 자동 마이그레이션합니다.

## 실행 절차

아래 단계를 순서대로 수행하세요.

### Step 1: shadcn/ui 사용 현황 스캔

```
Grep으로 검색:
- 패턴: from ["']@/components/ui/
- 대상: src/ 디렉토리 전체
```

검색 결과를 정리하여 사용자에게 보고:
- 어떤 shadcn 컴포넌트가 사용되는지
- 각 컴포넌트를 import하는 파일 목록
- 총 마이그레이션 대상 파일 수

### Step 2: 컴포넌트 매핑 계획 수립

각 발견된 shadcn 컴포넌트에 대해 DaisyUI 대응 클래스를 매핑합니다.

#### Button 매핑
```
import { Button } from "@/components/ui/button" -> import 제거

<Button>텍스트</Button>
-> <button className="btn btn-primary">텍스트</button>

<Button variant="ghost">
-> <button className="btn btn-ghost">

<Button variant="outline">
-> <button className="btn btn-outline">

<Button variant="destructive">
-> <button className="btn btn-error">

<Button variant="secondary">
-> <button className="btn btn-secondary">

<Button variant="link">
-> <button className="btn btn-link">

<Button size="sm">
-> <button className="btn btn-sm">

<Button size="lg">
-> <button className="btn btn-lg">

<Button size="icon">
-> <button className="btn btn-square btn-sm">

<Button disabled>
-> <button className="btn" disabled>

<Button className="추가클래스" variant="ghost">
-> <button className="btn btn-ghost 추가클래스">
```

#### Card 매핑
```
import { Card, CardContent, CardHeader, CardTitle, CardFooter } from "@/components/ui/card" -> import 제거

<Card> -> <div className="card bg-base-100 shadow-xl">
<CardHeader> -> 제거 (card-body 내부로 통합)
<CardTitle> -> <h2 className="card-title">
<CardContent> -> <div className="card-body">
<CardFooter> -> <div className="card-actions justify-end">
```

#### Badge 매핑
```
import { Badge } from "@/components/ui/badge" -> import 제거

<Badge> -> <span className="badge badge-primary">
<Badge variant="destructive"> -> <span className="badge badge-error">
<Badge variant="outline"> -> <span className="badge badge-outline">
<Badge variant="secondary"> -> <span className="badge badge-secondary">
```

#### Dialog/Modal 매핑
```
import { Dialog, DialogContent, DialogTrigger, DialogHeader, DialogTitle, DialogDescription, DialogFooter }
-> import 제거

변환 패턴:
<Dialog>
  <DialogTrigger asChild><Button>열기</Button></DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>제목</DialogTitle>
      <DialogDescription>설명</DialogDescription>
    </DialogHeader>
    내용
    <DialogFooter>
      <Button>확인</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>

->

<button className="btn" onClick={() => (document.getElementById('modal_id') as HTMLDialogElement)?.showModal()}>열기</button>
<dialog id="modal_id" className="modal">
  <div className="modal-box">
    <h3 className="font-bold text-lg">제목</h3>
    <p className="py-4">설명</p>
    내용
    <div className="modal-action">
      <form method="dialog">
        <button className="btn">확인</button>
      </form>
    </div>
  </div>
  <form method="dialog" className="modal-backdrop">
    <button>close</button>
  </form>
</dialog>
```

#### Input 매핑
```
import { Input } from "@/components/ui/input" -> import 제거
<Input> -> <input className="input input-bordered w-full">

import { Textarea } from "@/components/ui/textarea" -> import 제거
<Textarea> -> <textarea className="textarea textarea-bordered w-full">

import { Select } from "@/components/ui/select" -> import 제거
<Select> -> <select className="select select-bordered w-full">

import { Checkbox } from "@/components/ui/checkbox" -> import 제거
<Checkbox> -> <input type="checkbox" className="checkbox">

import { Switch } from "@/components/ui/switch" -> import 제거
<Switch> -> <input type="checkbox" className="toggle">
```

#### 기타 컴포넌트 매핑
```
Tabs -> <div role="tablist" className="tabs tabs-bordered">
TabsTrigger -> <a role="tab" className="tab tab-active">
Accordion -> <div className="collapse collapse-arrow bg-base-200">
Alert -> <div role="alert" className="alert">
Avatar -> <div className="avatar"><div className="w-10 rounded-full"><img /></div></div>
DropdownMenu -> <div className="dropdown">
Tooltip -> <div className="tooltip" data-tip="텍스트">
Progress -> <progress className="progress progress-primary w-full" value="70" max="100">
Skeleton -> <div className="skeleton h-4 w-full">
Table -> <table className="table">
Separator -> <div className="divider">
Sheet -> <div className="drawer">
Popover -> <div className="dropdown">
```

### Step 3: 파일별 마이그레이션 실행

각 파일에 대해:

1. **Read**로 파일 내용 읽기
2. shadcn import 문 식별 및 제거
3. JSX에서 shadcn 컴포넌트를 DaisyUI HTML + 클래스로 교체
4. 기존 className에 있는 하드코딩 색상을 시맨틱 토큰으로 변환 (선택적)
5. **Edit**으로 변경사항 적용

#### 색상 변환 (선택)
```
bg-black, bg-zinc-900 -> bg-base-100
bg-zinc-800 -> bg-base-200
bg-zinc-700 -> bg-base-300
text-white -> text-base-content
text-zinc-400 -> text-base-content/60
border-zinc-700 -> border-base-content/20
```

### Step 4: 미사용 shadcn 파일 정리

```
Glob으로 검색: src/components/ui/*.tsx

각 파일에 대해:
- Grep으로 프로젝트 내 import 여부 확인
- import하는 곳이 없으면 삭제 대상으로 표시
- 사용자 확인 후 삭제
```

### Step 5: 의존성 정리 (선택)

마이그레이션 완료 후 불필요한 Radix UI 패키지 확인:
```
package.json에서 @radix-ui/* 패키지 확인
-> 실제 사용 여부 Grep으로 검증
-> 미사용 패키지 제거 제안
```

### Step 6: 결과 보고

마이그레이션 결과를 한국어로 보고:
- 변환된 파일 수
- 제거된 shadcn 컴포넌트 파일 수
- 변환된 컴포넌트 종류
- 주의사항 또는 수동 확인 필요 항목

---

## 주의사항

- shadcn 컴포넌트에 커스텀 로직(forwardRef, custom variants)이 있는 경우 수동 확인 필요
- Radix UI의 접근성 기능(키보드 네비게이션 등)이 DaisyUI에서도 유지되는지 확인
- cn() 유틸리티 함수는 DaisyUI에서도 계속 사용 가능 (clsx + tailwind-merge)
- 복잡한 컴포넌트(Combobox, DataTable 등)는 자동 변환이 어려울 수 있음
- 빌드 확인은 사용자가 직접 수행하도록 안내
