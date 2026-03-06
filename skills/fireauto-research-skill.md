---
description: |
  이 스킬은 다음과 같은 요청에 사용합니다:
  - "레딧 리서치" 또는 "reddit research"
  - "수요조사" 또는 "시장조사"
  - "리드 스코어링" 또는 "lead scoring"
  - "market research"
  - "레딧 데이터 수집"
  - "reddit lead generation"
  - "경쟁사 분석 reddit"
---

# Reddit 기반 시장 조사 방법론 (fireauto-research)

## 개요

Reddit은 B2B/B2C SaaS 시장 조사에 가장 풍부한 무료 데이터 소스 중 하나입니다. 사용자들이 익명으로 솔직한 의견, 불만, 요구사항을 공유하기 때문에 설문조사보다 더 진솔한 인사이트를 얻을 수 있습니다.

## 핵심 방법론

### 1. 데이터 수집 전략

#### Public API 활용
Reddit의 공개 JSON/RSS 엔드포인트를 활용하여 인증 없이 데이터를 수집합니다.

**주요 엔드포인트:**
- 서브레딧 검색: `reddit.com/r/{sub}/search.json?q={query}&restrict_sr=1&sort=relevance&t=month`
- 서브레딧 최신글: `reddit.com/r/{sub}/new.json?limit=25`
- 포스트 댓글: `reddit.com/comments/{post_id}.json`

**Rate Limiting 모범 사례:**
- 요청 간 최소 2초 간격
- User-Agent 헤더에 봇 정보 포함하지 않음 (WebFetch 기본 설정 사용)
- 429 응답 시 exponential backoff (10초 -> 20초 -> 40초)
- 세션당 최대 100 요청 권장

#### WebSearch 보조 활용
- `site:reddit.com` 검색으로 Google 인덱싱된 Reddit 포스트 발견
- JSON API가 반환하지 않는 오래된 포스트 접근
- 크로스 서브레딧 검색에 유용

### 2. 서브레딧 선정 기준

좋은 서브레딧의 특징:
- **활성 사용자 수:** 최소 10K subscribers
- **포스트 빈도:** 일 평균 5개 이상의 새 포스트
- **질문/추천 비율:** 질문 포스트가 전체의 30% 이상
- **자기홍보 규칙:** 엄격한 자기홍보 규정이 있는 곳 (더 진솔한 대화)

#### 카테고리별 추천 서브레딧

**SaaS/스타트업:**
- r/SaaS, r/startups, r/Entrepreneur, r/microsaas, r/indiehackers

**개발 도구:**
- r/webdev, r/nextjs, r/reactjs, r/node, r/programming

**비즈니스:**
- r/smallbusiness, r/ecommerce, r/marketing, r/digital_marketing

**특정 니치:**
- 제품 도메인에 따라 관련 서브레딧 추가

### 3. 키워드 전략

#### 직접 키워드
제품/서비스를 직접 설명하는 키워드:
- 제품 카테고리명 (예: "SaaS boilerplate", "landing page builder")
- 기능 키워드 (예: "payment integration", "email automation")

#### 문제 키워드
타겟 고객이 겪는 문제를 설명하는 키워드:
- "struggling with", "can't figure out", "pain point"
- "too expensive", "takes too long", "complicated"

#### 의도 키워드
구매/도입 의향을 나타내는 키워드:
- "looking for", "recommend", "best tool for"
- "alternative to", "switching from", "comparing"

#### 한국어 키워드 (한국 시장 타겟 시)
- "추천해주세요", "어떤 게 좋을까요", "대안", "비교"

### 4. 리드 스코어링 모범 사례

#### 고품질 리드의 특징
1. **구체적 요구사항 나열** - 기능 리스트, 기술 스택 제약 등
2. **예산 언급** - "$", "willing to pay", "budget"
3. **긴급성** - "ASAP", "this week", 데드라인 언급
4. **실패 경험 공유** - 다른 도구를 써봤는데 안 됐다
5. **팀 규모/맥락 제공** - 구체적 사용 환경 설명

#### 주의해야 할 신호
1. **tire kicker 패턴** - 여러 포스트에서 같은 질문 반복, 결코 결정하지 않음
2. **학생/취미 프로젝트** - 상업적 가치 낮음
3. **이미 깊이 investmentd** - 기존 솔루션에 많이 투자해서 전환 비용 높음

### 5. Pain Point 분류 체계

| 카테고리 | 키워드 패턴 | 제품 대응 전략 |
|----------|------------|---------------|
| Cost | "expensive", "budget", "free alternative", "pricing" | 가격 경쟁력/ROI 강조 |
| Time | "takes forever", "slow", "time-consuming", "deadline" | 시간 절약/생산성 강조 |
| Complexity | "complicated", "steep learning curve", "too technical" | 사용 편의성/온보딩 강조 |
| Regulation | "GDPR", "compliance", "security", "SOC2" | 컴플라이언스 기능 강조 |
| Scale | "growing", "can't handle", "performance", "enterprise" | 확장성/안정성 강조 |

### 6. 경쟁사 인텔리전스 수집

#### 추출 대상
- 직접 언급: 경쟁사 제품명/회사명
- 간접 언급: "the tool I'm using now", "current solution"
- 비교 포스트: "X vs Y", "alternative to X"

#### Sentiment 분류
- **Positive:** "love", "great", "recommend", "best"
- **Neutral:** "use", "tried", "works", factual statements
- **Negative:** "hate", "terrible", "switched from", "disappointed"

### 7. 결과 활용 모범 사례

#### 즉시 액션 (Hot Leads)
- 가치 제공형 댓글 작성 (자기홍보 아닌 문제 해결 중심)
- DM으로 무료 리소스/가이드 공유
- 24시간 내 대응이 전환율 3배 높음

#### 중기 액션 (Warm Leads)
- 관련 콘텐츠 (블로그, 가이드) 작성하여 SEO/공유
- 해당 서브레딧에서 커뮤니티 참여 시작
- 7일 이내 가치 기반 접근

#### 장기 액션 (Cold Leads + 인사이트)
- Pain Point 데이터를 제품 로드맵에 반영
- 경쟁사 약점을 마케팅 메시지에 활용
- 콘텐츠 캘린더에 주요 주제 반영

### 8. 윤리적 가이드라인

- Reddit의 Terms of Service 준수
- 스팸/대량 메시지 금지
- 가치를 제공하는 진정한 커뮤니티 참여
- 개인정보 수집/저장 최소화
- 자동화된 DM 발송 금지
- 수집 데이터는 내부 분석 목적으로만 사용
