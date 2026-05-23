# 스킬 보안 설정 체크리스트

스킬 파일(`.claude/commands/*.md`)을 작성하거나 공유하기 전에 확인한다.

---

## 스킬 파일에 넣으면 안 되는 것

| 항목 | 대신 쓰는 방법 |
|------|--------------|
| DB URL (호스트·포트·사용자·비밀번호) | `skill-config.json → db.prod_url` / `db.local_url` |
| SSH 호스트명 / alias | `skill-config.json → ssh.mac_mini` |
| 서버 파일 경로 (`~/backup.log` 등) | `skill-config.json → ssh.backup_log_path` |
| Notion 페이지·DB UUID | `skill-config.json → notion.*` |
| 환경변수명 (프로젝트 특정) | `skill-config.json → sync.*` |
| DB 테이블명 (프로젝트 특정) | `skill-config.json → sync.consultation_table` |
| 내부망 IP 주소 | `skill-config.json → db.prod_url` 내 포함 |
| OS 사용자명이 드러나는 절대 경로 (`/Users/<name>/...`) | `/path/to/your/vault` 같은 플레이스홀더로 |

---

## skill-config.json 필수 키

새 프로젝트에 스킬을 붙일 때 `skill-config.json`에 넣어야 하는 항목:

```jsonc
{
  "project": "<project-name>",

  // Notion
  "notion": {
    "adr_db_collection": "<uuid>",       // 결정 로그 DB
    "adr_db_url":        "<url>",        // 위 DB의 Notion 웹 URL
    "system_guide_page": "<uuid>",       // 운영 가이드 페이지
    "handover_page":     "<uuid>",       // 핸드오버 페이지
    "workspace_root":    "<uuid>",       // 최상위 워크스페이스
    "skill_index_page":  "<uuid>"        // 스킬 목록 페이지
  },

  // 데이터베이스
  "db": {
    "prod_url":  "postgresql://<user>:<pass>@<host>:<port>/<db>",
    "local_url": "postgresql://<user>:<pass>@localhost:<port>/<db>"
  },

  // SSH / 서버 접근
  "ssh": {
    "mac_mini":        "<ssh-alias>",       // ~/.ssh/config에 정의된 alias
    "project_path":    "~/<project-dir>",   // 서버의 프로젝트 루트
    "backup_log_path": "~/<backup.log>"     // 백업 로그 파일 경로
  },

  // Sync / 정합성 비교
  "sync": {
    "consultation_db_id":   "<notion-uuid>",        // Notion sync 대상 DB
    "state_key":            "<last-sync-key>",       // system_settings 키 이름
    "tier2_state_key":      "<tier2-tracking-key>",  // 파악 Tier 2 캐시 키
    "sync_file_path":       "lib/<sync-file>.ts",    // Notion sync 담당 파일
    "consultation_table":   "<db-table-name>"        // 정합성 비교 DB 테이블
  }
}
```

---

## gitignore 규칙

프로젝트 `.gitignore`에 반드시 포함:

```
.claude/skill-config.json
.claude/settings.json
.claude/settings.local.json
```

커밋 허용 (템플릿 파일):
```
.claude/skill-config.example.json   ← 실제 값 없이 플레이스홀더만
```

---

## 스킬 파일 공유 전 체크

- [ ] `grep -n "192\.\|password\|secret\|@" .claude/commands/*.md` 결과 없음
- [ ] `grep -n "/Users/" .claude/commands/*.md` 결과 없음 (OS 사용자명 노출 확인)
- [ ] `grep -n "ssh [a-z]" .claude/commands/*.md` 결과가 `<config:...>` 형식인지 확인
- [ ] `skill-config.json`이 gitignore에 있는지 확인
- [ ] `skill-config.example.json`에 실제 값이 없는지 확인

---

## 보안 등급별 저장 위치

| 등급 | 예시 | 저장 위치 |
|------|------|-----------|
| 공개 가능 | 스킬 작동 로직, 템플릿 구조 | `~/.claude/commands/*.md` (dotfiles 공개 가능) |
| 프로젝트 비공개 | UUID, 키 이름, 파일 경로 | `skill-config.json` (gitignore, 로컬만) |
| 기밀 | DB 자격증명, SSH 키 | `skill-config.json` + 추후 `.env` 위임 권장 |
