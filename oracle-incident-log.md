# Oracle Incident Log

- [2026-03-20 00:00:00] Oracle 에러 정리
  - 질문 맥락: Redo transport 및 DG broker 통신 오류 점검 요청
  - 핵심 에러: ORA-16764("redo transport service to a member is not running"), ORA-16664("unable to receive the result from a member")
  - 원인 가설: DG broker/redo 전송 서비스 미동작, 네트워크 통신 단절, 대상/receiver 서비스 미가동, 브로커 상태 불일치
  - 권장 조치: 네트워크/리스너 및 tnsnames 점검 -> v$archive_dest/managed standby 상태 확인 -> dgmgrl show/validate -> log_archive_dest 상태 확인 및 필요시 enable -> apply/transport 서비스 재시작
  - 검증 항목: select dest_id, status, error from v$archive_dest에서 상태 정상, v$managed_standby에서 RFS/MRP/ARCH 정상, dgmgrl validate 통과
