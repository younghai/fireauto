# fireauto

AI 서비스 40개를 만들면서 실전에서 검증된 Claude Code 자동화 플러그인 모음.

## Plugins

| Command | Description |
|---------|-------------|
| `/fireauto-research` | 레딧 수요조사 + 리드스코어링 자동화 |
| `/fireauto-team` | 팀 에이전트 병렬작업 구성 및 실행 |
| `/fireauto-seo` | SEO 종합점검 (기술 SEO, 구조화 데이터, pSEO) |
| `/fireauto-secure` | 보안 종합점검 (API, 인증, 입력값, 의존성) |
| `/fireauto-ui` | DaisyUI v5 기반 UI 구축 및 마이그레이션 |
| `/fireauto-ui-migrate` | shadcn/ui → DaisyUI 마이그레이션 |
| `/fireauto-team-status` | 실행중인 팀 에이전트 상태 확인 |

## Install

```bash
# Claude Code에서
/install-plugin /path/to/fireauto
```

## Structure

```
fireauto/
├── plugin.json              # 플러그인 매니페스트
├── commands/                # 슬래시 커맨드
│   ├── fireauto-research.md
│   ├── fireauto-team.md
│   ├── fireauto-team-status.md
│   ├── fireauto-seo.md
│   ├── fireauto-secure.md
│   ├── fireauto-ui.md
│   └── fireauto-ui-migrate.md
├── agents/                  # 에이전트
│   ├── research-analyzer.md
│   ├── team-coordinator.md
│   ├── seo-auditor.md
│   ├── security-auditor.md
│   └── ui-builder.md
└── skills/                  # 스킬 (자동 트리거)
    ├── fireauto-research-skill.md
    ├── fireauto-team-skill.md
    ├── fireauto-seo-skill.md
    ├── fireauto-secure-skill.md
    └── fireauto-ui-skill.md
```

## About

Made by [FreAiner](https://fireship.me) — 1년간 AI 서비스 40개를 만들고, 그 중 3개를 수익화한 1인 개발자.

- Threads: [@freainer](https://www.threads.net/@freainer)
- Bootcamp: [FireShip](https://fireship.me)

## License

MIT
