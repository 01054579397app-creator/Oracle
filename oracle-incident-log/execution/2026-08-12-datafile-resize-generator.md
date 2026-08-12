[2026-08-12 17:50 KST]
- 주제: V$DATAFILE 기준 데이터파일 50MB 축소문 생성 SQL 검토
- 입력 SQL: `select 'alter database datafile '||name||' resize '||(bytes/1024/1024)-50||'m;' from v$datafile`
- 문제점: 생성 명령의 데이터파일 경로에 작은따옴표가 없고 산술식 괄호가 불명확함. 모든 파일을 일괄 50MB 축소하면 HWM 아래로 내려가는 파일에서 ORA-03297이 발생할 수 있음.
- 수정 SQL: 파일명을 작은따옴표로 감싸고 `TRUNC(bytes/1024/1024)-50`을 괄호로 묶어 명령을 생성함.
- 검증 원칙: 생성된 문장을 바로 일괄 실행하지 말고 각 파일의 HWM과 최소 축소 가능 크기를 확인한 뒤 실행함. V$DATAFILE은 데이터파일 대상이며 tempfile은 별도 처리함.
