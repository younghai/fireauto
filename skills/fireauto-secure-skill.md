---
description: |
  보안 점검, security check, security audit, 취약점 분석, vulnerability scan,
  보안 감사, 시크릿 노출 점검, API 보안, 인증 점검, rate limit 확인
---

# 보안 감사 방법론 (Security Audit Methodology)

실제 SaaS 프로젝트에서 검증된 보안 감사 방법론입니다.
pikome, ditfinder 등 다수 프로젝트에서 총 18개 취약점을 발견한 패턴을 기반으로 합니다.

## 감사 대상 8개 카테고리

1. **환경변수/시크릿 노출** - .env 파일, 하드코딩된 키, NEXT_PUBLIC_ 오용
2. **인증/인가** - 미인증 API, admin 클라이언트 남용, RLS 우회, 미들웨어 범위
3. **Rate Limiting** - AI/비용 발생 엔드포인트 보호
4. **파일 업로드** - MIME 검증, 크기 제한, 위험 파일 차단
5. **스토리지 보안** - 퍼블릭 버킷, URL 추측, 서명된 URL
6. **Prompt Injection** - 사용자 입력 직접 삽입, 시스템/유저 프롬프트 분리
7. **정보 노출** - 에러 상세, 보안 헤더, CSP
8. **의존성 취약점** - npm audit, CVE 체크

## 심각도 분류 체계

| 심각도 | 기준 |
|--------|------|
| CRITICAL | 즉시 조치. 데이터 유출, 인증 우회, 시크릿 노출 |
| HIGH | 빠른 조치. 서비스 장애, 비용 발생 가능 |
| MEDIUM | 계획적 조치. 특정 조건에서 악용 가능 |
| LOW | 개선 권장. 보안 강화 목적 |

## 핵심 검색 패턴

### 시크릿 노출 탐지
```
"sk-", "sk_live", "sk_test"           → API 키
"password.*=", "secret.*=", "token.*=" → 하드코딩
"NEXT_PUBLIC_.*SERVICE"                → 서비스 키 클라이언트 노출
"supabaseAdmin"                        → admin 클라이언트 위치
```

### 인증 누락 탐지
```
API 라우트 파일에서 아래 패턴이 없으면 인증 미적용:
"getSession", "getUser", "auth()", "getServerSession", "cookies()"
```

### Rate Limit 누락 탐지
```
AI 호출 위치: "openai", "anthropic", "claude", "gpt"
이메일 발송: "resend", "sendEmail"
→ 같은 파일에 "ratelimit", "rateLimiter"가 없으면 취약
```

### Prompt Injection 탐지
```
AI 메시지 배열에서 사용자 입력이 템플릿 리터럴로 직접 삽입:
content: `...${userInput}...`
→ 시스템 프롬프트와 사용자 메시지가 분리되어야 함
```

## 우선순위 산정 공식

**우선순위 = 심각도 점수 x 구현 용이성**

- 심각도: CRITICAL(4), HIGH(3), MEDIUM(2), LOW(1)
- 구현 용이성: 쉬움(3), 보통(2), 어려움(1)
- 점수가 높을수록 먼저 조치

예시:
- CRITICAL + 쉬움 = 12점 (최우선)
- HIGH + 보통 = 6점
- LOW + 어려움 = 1점 (후순위)

## 리포트 출력 형식

감사 결과는 `SECURITY_AUDIT.md` 파일로 저장하며, 다음을 포함:
- 요약 테이블 (심각도별 발견 수)
- 취약점 상세 (위치, 설명, 수정 방법 포함)
- 우선순위 정렬된 액션 아이템
- 전반적 권장사항
