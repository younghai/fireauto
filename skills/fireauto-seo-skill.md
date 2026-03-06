---
description: |
  SEO 감사, SEO audit, 기술 SEO, technical SEO, 구조화 데이터, schema markup, JSON-LD,
  robots.txt, sitemap, 메타 태그, meta tags, 프로그래매틱 SEO, pSEO, 리다이렉트,
  Core Web Vitals, Rich Results, 검색엔진 최적화
---

# SEO 감사 방법론 및 체크리스트

Next.js 프로젝트에 대한 포괄적 SEO 감사를 수행하기 위한 방법론입니다.
실제 프로덕션 프로젝트(nomadfast, FireShipLanding, ditfinder) 감사 경험에서 축적된 패턴입니다.

## 감사 접근 방식

### 원칙
1. **코드 기반 감사**: 실제 소스 코드를 분석하여 빌드/배포 전에 이슈 발견
2. **프레임워크 인식**: Next.js App Router 패턴에 최적화 (metadata API, generateStaticParams 등)
3. **심각도 기반 우선순위**: P0(Critical) ~ P3(Low)로 분류하여 수정 순서 안내
4. **실행 가능한 피드백**: 각 이슈에 구체적 수정 코드 제시

### 감사 순서 (의존성 기반)
1. robots.txt / sitemap - 크롤링 기반
2. 메타 태그 - 인덱싱 기반
3. JSON-LD 구조화 데이터 - Rich Results
4. pSEO 라우트 - 대량 페이지 품질
5. 리다이렉트 체인 - 크롤 버짓 낭비
6. 성능 SEO - Core Web Vitals

## 핵심 체크리스트

### robots.txt
- [ ] 파일 존재 (public/robots.txt 또는 app/robots.ts)
- [ ] 프로덕션에서 Disallow: / 아닌지 확인
- [ ] 민감 경로 차단 (admin, api, dashboard, _next)
- [ ] Sitemap 지시자 포함
- [ ] User-agent별 규칙 적절성

### Sitemap
- [ ] 파일 존재 (public/sitemap.xml 또는 app/sitemap.ts)
- [ ] 모든 공개 라우트 포함
- [ ] lastmod 정확성
- [ ] 다국어 alternate 링크 (hreflang)
- [ ] sitemap index 사용 시 하위 참조 유효

### JSON-LD 구조화 데이터
- [ ] 홈페이지: Organization + WebSite
- [ ] 블로그: Article / BlogPosting (headline, datePublished, author, image)
- [ ] 상품: Product + Offer (name, price, priceCurrency, availability)
- [ ] FAQ: FAQPage + Question (acceptedAnswer)
- [ ] 네비게이션: BreadcrumbList
- [ ] 장소: Place / LocalBusiness (address, geo, openingHours)
- [ ] 중복 블록 없음
- [ ] @id 참조 일관성

### JSON-LD 필수 속성 참조표

**Article / BlogPosting:**
```json
{
  "@type": "Article",
  "headline": "필수",
  "image": "필수",
  "datePublished": "필수",
  "dateModified": "권장",
  "author": { "@type": "Person", "name": "필수" }
}
```

**Product:**
```json
{
  "@type": "Product",
  "name": "필수",
  "image": "필수",
  "offers": {
    "@type": "Offer",
    "price": "필수",
    "priceCurrency": "필수",
    "availability": "권장",
    "url": "권장"
  }
}
```

**FAQPage:**
```json
{
  "@type": "FAQPage",
  "mainEntity": [{
    "@type": "Question",
    "name": "필수 (질문 텍스트)",
    "acceptedAnswer": {
      "@type": "Answer",
      "text": "필수 (답변 텍스트)"
    }
  }]
}
```

**BreadcrumbList:**
```json
{
  "@type": "BreadcrumbList",
  "itemListElement": [{
    "@type": "ListItem",
    "position": "필수 (숫자)",
    "name": "필수",
    "item": "필수 (URL)"
  }]
}
```

**LocalBusiness / Place:**
```json
{
  "@type": "LocalBusiness",
  "name": "필수",
  "address": { "@type": "PostalAddress", "필수 속성들": "..." },
  "geo": { "@type": "GeoCoordinates", "latitude": "권장", "longitude": "권장" },
  "telephone": "권장",
  "openingHoursSpecification": "권장"
}
```

### 메타 태그
- [ ] title 존재 및 길이 (30-60자)
- [ ] description 존재 및 길이 (120-160자)
- [ ] 페이지별 고유한 title/description
- [ ] og:title, og:description, og:image, og:url
- [ ] twitter:card, twitter:title, twitter:image
- [ ] canonical URL 설정
- [ ] hreflang (다국어 시)
- [ ] viewport 메타 태그

### pSEO 라우트
- [ ] generateStaticParams 구현
- [ ] 동적 페이지별 고유 콘텐츠 존재
- [ ] thin content 없음 (최소 300단어 또는 의미있는 데이터)
- [ ] 저품질 페이지 noindex 처리
- [ ] 내부 링크 구조 적절

### 리다이렉트
- [ ] 체인 없음 (최대 1홉)
- [ ] 301 vs 302 적절 구분
- [ ] 무한 루프 없음
- [ ] trailing slash 일관성
- [ ] www 정규화

### 성능 SEO
- [ ] loading.tsx 존재 (주요 라우트)
- [ ] next/image 사용 (raw img 태그 없음)
- [ ] 이미지 alt 속성
- [ ] next/font 사용
- [ ] 불필요한 "use client" 없음 (page.tsx에서)
- [ ] Suspense 경계 적절

## 자주 발견되는 이슈 패턴 (Next.js)

### 패턴 1: metadata export 누락
App Router에서 `page.tsx`에 `metadata` 또는 `generateMetadata`가 없으면 기본값이 사용됨.
특히 동적 라우트에서 자주 누락됨.

### 패턴 2: JSON-LD 중복
layout.tsx와 page.tsx 양쪽에서 JSON-LD를 렌더링하면 동일 @type이 중복됨.
Google은 첫 번째만 인식할 수 있음.

### 패턴 3: sitemap에서 동적 라우트 누락
`app/sitemap.ts`에서 데이터베이스 조회 없이 정적 URL만 나열하면
동적으로 생성되는 수백~수천 페이지가 sitemap에서 빠짐.

### 패턴 4: canonical URL과 실제 URL 불일치
다국어 사이트에서 canonical이 기본 언어만 가리키거나,
trailing slash 유무가 실제 접근 URL과 다른 경우.

### 패턴 5: OG 이미지 미설정
`opengraph-image.tsx` 또는 metadata의 `openGraph.images` 미설정 시
SNS 공유 시 이미지 없이 노출됨.

### 패턴 6: 클라이언트 컴포넌트 과다 사용
`"use client"`가 page.tsx 최상위에 있으면 해당 페이지 전체가 클라이언트 렌더링.
SSR/SSG 이점을 잃어 LCP에 악영향.

## 도구 활용 가이드

| 감사 영역 | 주요 도구 | 사용 방법 |
|-----------|-----------|-----------|
| robots.txt | Glob, Read | 파일 찾기 + 내용 분석 |
| sitemap | Glob, Read, Grep | 파일 + 라우트 비교 |
| JSON-LD | Grep, Read | 패턴 검색 + 속성 검증 |
| 메타 태그 | Grep, Read | metadata export 검색 |
| pSEO | Glob, Read, Grep | 동적 라우트 구조 분석 |
| 리다이렉트 | Read, Grep | config + middleware 분석 |
| 성능 | Glob, Grep | 파일 존재 + 패턴 검색 |
