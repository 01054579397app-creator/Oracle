# Oracle Incident Log

- [2026-03-20 00:00:00] Oracle 에러 정리
  - 질문 맥락: Redo transport 및 DG broker 통신 오류 점검 요청
  - 핵심 에러: ORA-16764("redo transport service to a member is not running"), ORA-16664("unable to receive the result from a member")
  - 원인 가설: DG broker/redo 전송 서비스 미동작, 네트워크 통신 단절, 대상/receiver 서비스 미가동, 브로커 상태 불일치
  - 권장 조치: 네트워크/리스너 및 tnsnames 점검 -> v$archive_dest/managed standby 상태 확인 -> dgmgrl show/validate -> log_archive_dest 상태 확인 및 필요시 enable -> apply/transport 서비스 재시작
  - 검증 항목: select dest_id, status, error from v$archive_dest에서 상태 정상, v$managed_standby에서 RFS/MRP/ARCH 정상, dgmgrl validate 통과

## 문서별 누적 정리

- [2026-03-20 09:05:00] [문서: AGENTS.md]
  - 질문 맥락: 향후 오라클 관련 내용은 한국어 응답 및 스킬 기반으로 기록 정책 적용 요청
  - 핵심 에러/메시지: 해당 없음
  - 원인 가설: 장기 추적을 위해 정책 고정이 필요
  - 권장 조치: AGENTS 규칙에 Oracle handling 및 Skills 항목 등록
  - 검증 항목: AGENTS에 oracle-incident-log 적용 규칙 존재 여부 확인

- [2026-03-20 09:15:00] [문서: oracle-incident-log SKILL 생성]
  - 질문 맥락: Oracle 에러 내용이 들어올 때마다 전부 정리되는 스킬 작성 요청
  - 핵심 에러/메시지: 사용자 요구 미반영 시 누락 위험
  - 원인 가설: 기존 로컬 규칙에 자동 누락 가능성 존재
  - 권장 조치: `oracle-incident-log` 스킬 생성, 기록 항목 형식 고정(맥락/에러/가설/조치/검증)
  - 검증 항목: 스킬 파일 내 description·실행 규칙 반영 여부 확인

- [2026-03-20 09:25:00] [문서: 스킬 탐색]
  - 질문 맥락: 오라클 관련 공개 스킬(인터넷/외부) 여부 확인 요청
  - 핵심 에러/메시지: openai/skills 공개 목록에서 oracle 키워드 미포함
  - 원인 가설: 공식 커브레이트에는 오라클 전문 스킬 부재
  - 권장 조치: 로컬 스킬 사용 유지 및 추가 외부 스킬 탐색 제한 명시
  - 검증 항목: 공개 목록(35개) 및 oracle 키워드 검색 결과 없음 기록

- [2026-03-20 09:33:00] [문서: oracle-incident-log 정책 확장]
  - 질문 맥락: 앞으로 오라클 질문마다 항상 기록하고 다음 질문마다 업데이트하라 요청
  - 핵심 에러/메시지: 미자동화로 인한 누락 우려
  - 원인 가설: 추적 기준을 리포지토리 기반으로 고정해야 일관성 확보
  - 권장 조치: 대상 저장소 `https://github.com/01054579397app-creator/Oracle` 지정, AGENTS/스킬에 저장+커밋+푸시 규칙 등록
  - 검증 항목: 저장소 경로, remote, 기록/푸시 규칙 문서화

- [2026-03-20 09:40:00] [문서: Git 연동]
  - 질문 맥락: 오라클 관련 내용은 항상 지정 저장소에 기록하고 푸시까지 수행 요청
  - 핵심 에러/메시지: 해당 없음
  - 원인 가설: 반복 질문 처리 시 수기 누락 방지 필요
  - 권장 조치: `record_oracle_incident.ps1` 스크립트 제공 및 Git add/commit/push 플로우 명시
  - 검증 항목: 스크립트 저장 경로/실행 인자/브랜치(main) 명시

- [2026-03-20 09:45:00] [문서: 운영 지침]
  - 질문 맥락: 정리 시에는 매번 업데이트(append) 방식으로 누적 저장하라는 요청
  - 핵심 에러/메시지: 기존 overwrite 방식 오해 가능성
  - 원인 가설: append 규칙 미명시
  - 권장 조치: AGENTS 및 SKILL 문구를 "update/append"로 통일
  - 검증 항목: 규칙 항목에 append 문구 포함 여부 확인
