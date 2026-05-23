# 스킬 보안 감사 보고서

감사 일시: 2026-05-23  
대상 파일: `~/.claude/commands/기록.md`, `파악.md`, `점검.md`  
실제 경로: `~/Developer/dotfiles/.claude/commands/`

---

## 발견 이슈 요약

| # | 파일 | 이슈 | 심각도 | 상태 |
|---|------|------|--------|------|
| 1 | `파악.md` | `ssh mac-mini` 하드코딩 — SSH 호스트명 노출 | 중간 | ✅ 수정됨 |
| 2 | `파악.md` | `~/virenti-backup.log` 하드코딩 — 서버 파일 경로 노출 | 중간 | ✅ 수정됨 |
| 3 | `파악.md` | `NOTION_CONSULTATION_DB_ID` 환경변수명 하드코딩 | 낮음 | ✅ 수정됨 |
| 4 | `파악.md` | `consultation_cards` 테이블명 하드코딩 | 낮음 | ✅ 수정됨 |
| 5 | `파악.md` | `파악_tier2_last_run` 내부 system_settings 키 노출 | 낮음 | ✅ 수정됨 |
| 6 | `파악.md` | 포트 `5433` 하드코딩 — 비표준 포트 노출 | 낮음 | ✅ 수정됨 |
| 7 | `기록.md` | `/Users/ura/Documents/MyVault` 예시 경로 — 사용자명 노출 | 낮음 | ✅ 수정됨 |
| 8 | `점검.md` | `lib/notion-consultation-sync.ts` 경로 하드코딩 | 낮음 | ✅ 수정됨 |
| 9 | `점검.md` | `consultation_sessions`, `consultation_cards` 테이블명 하드코딩 | 낮음 | ✅ 수정됨 |
| 10 | `점검.md` | `consultationCards\|consultation_cards` grep 패턴 | 낮음 | ✅ 수정됨 |
| 11 | `skill-config.json` | DB 비밀번호 평문 저장 (`virenti_password`) | **높음** | ⚠️ 구조적 한계 |
| 12 | `skill-config.json` | 내부망 IP 평문 저장 (`192.168.0.98`) | 중간 | ⚠️ 구조적 한계 |
| 13 | `skill-config.json` | Notion 페이지 UUID 노출 | 낮음 | ⚠️ gitignore로 관리 중 |

---

## 이슈 상세

### 이슈 11 — skill-config.json 평문 자격증명 (높음)

```json
"db": {
  "prod_url": "postgresql://virenti:virenti_password@192.168.0.98:5432/virenti"
}
```

**위험**: 파일이 실수로 git에 커밋되면 DB 자격증명이 이력에 영구 기록됨.

**현재 완화 조치**: `.gitignore`에 `.claude/skill-config.json` 포함 → 커밋 차단됨.

**권장 추가 조치**:
- `skill-config.json`을 `.env.local`에서 DB URL을 읽어오도록 개선 (환경변수 위임)
- 또는 DB URL만 env var 참조(`$DATABASE_URL`)로 변경하고 실제 값은 `.env.local` 유지

### 이슈 11~13 — 구조적 한계

`skill-config.json`의 설계 목적 자체가 "민감 값을 한 곳에 모아 스킬 파일에서 분리"하는 것.  
gitignore 처리로 버전 관리 누출은 차단된 상태.  
단, 파일 시스템에 평문 존재 → 공유 계정·화면 녹화 환경에서는 주의 필요.

---

## 미해결 — skill-config.json 누락 키

파악.md / 점검.md 수정으로 아래 키를 참조하도록 변경했으나 아직 `skill-config.json`에 없음:

| 키 | 의미 | 추가 위치 |
|----|------|-----------|
| `ssh.backup_log_path` | 백업 로그 파일 경로 | `"ssh"` 섹션 |
| `sync.tier2_state_key` | Tier 2 캐시 추적 DB 키 이름 | `"sync"` 섹션 |
| `sync.sync_file_path` | Notion sync 담당 파일 경로 | `"sync"` 섹션 |
| `sync.consultation_table` | 정합성 비교 대상 DB 테이블명 | `"sync"` 섹션 |

**다음 할 일**: `skill-config.json`과 `skill-config.example.json` 모두에 위 키 추가.
