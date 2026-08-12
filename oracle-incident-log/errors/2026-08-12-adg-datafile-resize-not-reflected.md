[2026-08-12 18:12 KST]
- 주제: 원본 DB 데이터파일 RESIZE가 ADG 구성 대상에 반영되지 않는 원인
- 질문 맥락: phpagedb 측 데이터파일 용량을 줄였지만 nphpagedb 측 데이터파일 크기가 그대로인 이유를 실측 진단함.
- 원본 상태: phpagedb1 DMHOME은 PRIMARY READ WRITE, CURRENT_SCN=874449. 데이터파일은 54개이며 SYSTEM 610MB, UNDOTBS1 130MB, UNDOTBS2 110MB 등 축소된 크기로 확인됨.
- 대상 상태: nphpagedb1 DMHOME도 PRIMARY READ WRITE, CURRENT_SCN=454937. 데이터파일은 5개뿐이며 SYSTEM 700MB, UNDOTBS1 255MB, UNDOTBS2 200MB임.
- 프로세스 증거: nphpagedb1에는 DGRD만 있고 MRP0/RFS가 없어 physical standby redo apply가 실행되지 않음.
- 직접 원인: nphpagedb1은 현재 Physical Standby가 아니라 독립 PRIMARY로 활성화된 상태라 phpagedb1의 RESIZE redo를 적용할 경로가 없음. 따라서 데이터파일 축소가 전파되지 않음.
- 추가 상태: 양쪽 DB_UNIQUE_NAME이 모두 DMHOME이고 `standby_file_management=MANUAL`; 파일 수와 CURRENT_SCN도 크게 달라 정상 Data Guard 동기화 관계가 아님.
- 조치 범위: 사용자 요청에 따라 원인 확인만 수행했으며 DB 역할, redo apply, 데이터파일을 변경하지 않음.
