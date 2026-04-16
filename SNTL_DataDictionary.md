# SNTL 통합 물류 플랫폼 — Data Dictionary

> 총 37개 테이블 | PostgreSQL 16 기준 | 최종 업데이트: 2026-04-16

---

## 목차

| No | 테이블명(영문) | 테이블명(한글) | 도메인 |
|---|---|---|---|
| 1 | individual_member | 개인회원 | 회원/인증 |
| 2 | corporate | 법인 | 회원/인증 |
| 3 | corporate_attachment | 법인첨부파일 | 회원/인증 |
| 4 | corporate_manager | 법인관리자 | 회원/인증 |
| 5 | department | 부서 | 회원/인증 |
| 6 | department_manager | 부서관리자 | 회원/인증 |
| 7 | refresh_token | 리프레시토큰 | 회원/인증 |
| 8 | member_grade_policy | 회원등급정책 | 회원/인증 |
| 9 | country_code | 국가코드 | 코드관리 |
| 10 | airport_code | 공항코드 | 코드관리 |
| 11 | port_code | 항구코드 | 코드관리 |
| 12 | airline_code | 항공사코드 | 코드관리 |
| 13 | courier_company | 택배사 | 코드관리 |
| 14 | code_group | 코드그룹 | 코드관리 |
| 15 | common_code | 공통코드 | 코드관리 |
| 16 | orders | 오더 | 오더관리 |
| 17 | shipper_info | 송하인정보 | 오더관리 |
| 18 | consignee_info | 수하인정보 | 오더관리 |
| 19 | cargo_info | 화물정보 | 오더관리 |
| 20 | order_service | 오더서비스 | 오더관리 |
| 21 | master_order | 마스터오더 | 운송관리 |
| 22 | transport_schedule | 운항스케줄 | 운송관리 |
| 23 | warehouse_receipt | 입고 | 창고관리 |
| 24 | warehouse_release | 출고 | 창고관리 |
| 25 | tracking_info | 운송Tracking | Tracking |
| 26 | customs_declaration | 통관신고 | Tracking |
| 27 | invoice | 청구서 | 회계/청구 |
| 28 | invoice_item | 청구항목 | 회계/청구 |
| 29 | payment | 입금 | 회계/청구 |
| 30 | transport_cost_master | 운송원가마스터 | 회계/청구 |
| 31 | member_discount | 회원별할인율 | 회계/청구 |
| 32 | tax_invoice | 세금계산서 | 회계/청구 |
| 33 | notification | 알림 | 시스템관리 |
| 34 | voc | VOC | 시스템관리 |
| 35 | menu | 메뉴 | 시스템관리 |
| 36 | role | 권한 | 시스템관리 |
| 37 | menu_role | 메뉴권한매핑 | 시스템관리 |

---

## 도메인 1: 회원/인증

### individual_member (개인회원)
> 개인 사용자 회원 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 개인회원 고유 ID (자동증가) |
| 2 | login_id | 로그인ID | VARCHAR | 50 | - | UNIQUE | Y | - | 로그인에 사용하는 고유 ID |
| 3 | password | 비밀번호 | VARCHAR | 255 | - | - | Y | - | BCrypt 암호화된 비밀번호 |
| 4 | name | 이름 | VARCHAR | 100 | - | - | N | - | 회원 이름 |
| 5 | birth_date | 생년월일 | DATE | - | - | - | N | - | 생년월일 |
| 6 | phone | 휴대폰번호 | VARCHAR | 20 | - | - | N | - | 휴대폰번호 (숫자만) |
| 7 | email | 이메일 | VARCHAR | 100 | - | - | N | - | 이메일 주소 |
| 8 | zipcode | 우편번호 | VARCHAR | 10 | - | - | N | - | 우편번호 |
| 9 | address | 주소 | VARCHAR | 255 | - | - | N | - | 주소 (시/도 시/군/구 읍/면/동) |
| 10 | address_detail | 상세주소 | VARCHAR | 255 | - | - | N | - | 상세주소 |
| 11 | grade | 회원등급 | VARCHAR | 20 | - | - | Y | BASIC | 등급 (BASIC/SILVER/GOLD/VIP) |
| 12 | balance | 잔액 | NUMERIC | 15,2 | - | - | Y | 0 | 충전 잔액 |
| 13 | status | 상태 | VARCHAR | 20 | - | - | Y | ACTIVE | ACTIVE/INACTIVE/WITHDRAWN |
| 14 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 15 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### corporate (법인)
> 법인 회원 기본 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 법인 고유 ID |
| 2 | login_id | 로그인ID | VARCHAR | 50 | - | UNIQUE | Y | - | 법인 로그인 ID |
| 3 | corp_name | 법인명 | VARCHAR | 200 | - | - | Y | - | 법인(회사) 명칭 |
| 4 | ceo_name | 대표자명 | VARCHAR | 100 | - | - | N | - | 법인 대표자 이름 |
| 5 | business_number | 사업자등록번호 | VARCHAR | 20 | - | - | N | - | 사업자등록번호 |
| 6 | phone | 대표전화 | VARCHAR | 20 | - | - | N | - | 법인 대표 전화번호 |
| 7 | email | 대표이메일 | VARCHAR | 100 | - | - | N | - | 법인 대표 이메일 |
| 8 | zipcode | 우편번호 | VARCHAR | 10 | - | - | N | - | 법인 주소 우편번호 |
| 9 | address | 주소 | VARCHAR | 255 | - | - | N | - | 법인 주소 |
| 10 | address_detail | 상세주소 | VARCHAR | 255 | - | - | N | - | 법인 상세주소 |
| 11 | approval_status | 심사상태 | VARCHAR | 20 | - | - | Y | PENDING | PENDING/APPROVED/REJECTED |
| 12 | status | 상태 | VARCHAR | 20 | - | - | Y | INACTIVE | ACTIVE/INACTIVE/WITHDRAWN |
| 13 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 14 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### corporate_attachment (법인첨부파일)
> 법인 심사용 첨부파일 (사업자등록증 등), MinIO 저장

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 첨부파일 고유 ID |
| 2 | corporate_id | 법인ID | BIGINT | - | - | FK(corporate.id) | Y | - | 소속 법인 ID |
| 3 | file_name | 파일명 | VARCHAR | 255 | - | - | Y | - | 원본 파일명 |
| 4 | file_path | 파일경로 | VARCHAR | 500 | - | - | Y | - | MinIO 저장 경로 |
| 5 | file_size | 파일크기 | BIGINT | - | - | - | N | - | 파일 크기 (bytes) |
| 6 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |

---

### corporate_manager (법인관리자)
> 법인의 관리자 계정 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 법인관리자 고유 ID |
| 2 | corporate_id | 법인ID | BIGINT | - | - | FK(corporate.id) | Y | - | 소속 법인 ID |
| 3 | login_id | 로그인ID | VARCHAR | 50 | - | UNIQUE | Y | - | 법인관리자 로그인 ID |
| 4 | password | 비밀번호 | VARCHAR | 255 | - | - | Y | - | BCrypt 암호화된 비밀번호 |
| 5 | name | 이름 | VARCHAR | 100 | - | - | N | - | 법인관리자 이름 |
| 6 | birth_date | 생년월일 | DATE | - | - | - | N | - | 생년월일 |
| 7 | phone | 휴대폰번호 | VARCHAR | 20 | - | - | N | - | 휴대폰번호 |
| 8 | email | 이메일 | VARCHAR | 100 | - | - | N | - | 이메일 주소 |
| 9 | zipcode | 우편번호 | VARCHAR | 10 | - | - | N | - | 우편번호 |
| 10 | address | 주소 | VARCHAR | 255 | - | - | N | - | 주소 |
| 11 | address_detail | 상세주소 | VARCHAR | 255 | - | - | N | - | 상세주소 |
| 12 | status | 상태 | VARCHAR | 20 | - | - | Y | ACTIVE | ACTIVE/INACTIVE/WITHDRAWN |
| 13 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 14 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### department (부서)
> 법인 소속 부서 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 부서 고유 ID |
| 2 | corporate_id | 법인ID | BIGINT | - | - | FK(corporate.id) | Y | - | 소속 법인 ID |
| 3 | dept_name | 부서명 | VARCHAR | 100 | - | - | N | - | 부서명 |
| 4 | status | 상태 | VARCHAR | 20 | - | - | Y | ACTIVE | ACTIVE/INACTIVE/WITHDRAWN |
| 5 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 6 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### department_manager (부서관리자)
> 부서 관리자 계정 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 부서관리자 고유 ID |
| 2 | department_id | 부서ID | BIGINT | - | - | FK(department.id) | Y | - | 소속 부서 ID |
| 3 | login_id | 로그인ID | VARCHAR | 50 | - | UNIQUE | Y | - | 부서관리자 로그인 ID |
| 4 | password | 비밀번호 | VARCHAR | 255 | - | - | Y | - | BCrypt 암호화된 비밀번호 |
| 5 | name | 이름 | VARCHAR | 100 | - | - | N | - | 부서관리자 이름 |
| 6 | birth_date | 생년월일 | DATE | - | - | - | N | - | 생년월일 |
| 7 | phone | 휴대폰번호 | VARCHAR | 20 | - | - | N | - | 휴대폰번호 |
| 8 | email | 이메일 | VARCHAR | 100 | - | - | N | - | 이메일 주소 |
| 9 | zipcode | 우편번호 | VARCHAR | 10 | - | - | N | - | 우편번호 |
| 10 | address | 주소 | VARCHAR | 255 | - | - | N | - | 주소 |
| 11 | address_detail | 상세주소 | VARCHAR | 255 | - | - | N | - | 상세주소 |
| 12 | status | 상태 | VARCHAR | 20 | - | - | Y | ACTIVE | ACTIVE/INACTIVE/WITHDRAWN |
| 13 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 14 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### refresh_token (리프레시토큰)
> JWT Refresh Token 관리 (Redis 연계)

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | member_key | 회원키 | VARCHAR | 100 | - | - | Y | - | 회원 구분 키 (예: IND_1 / CORP_2) |
| 3 | token | 토큰값 | TEXT | - | - | - | Y | - | JWT Refresh Token 값 |
| 4 | expires_at | 만료일시 | TIMESTAMP | - | - | - | Y | - | 토큰 만료일시 |
| 5 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |

---

### member_grade_policy (회원등급정책)
> 개인회원 등급별 조건 및 할인율 정책

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | grade | 등급 | VARCHAR | 20 | - | - | Y | - | BASIC/SILVER/GOLD/VIP |
| 3 | min_send_count | 최소발송횟수 | INTEGER | - | - | - | Y | - | 등급 부여 최소 발송 횟수 |
| 4 | discount_rate | 할인율 | NUMERIC | 5,2 | - | - | Y | - | 운송비 할인율 (%) |
| 5 | description | 설명 | VARCHAR | 500 | - | - | N | - | 등급 설명 |
| 6 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 7 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

## 도메인 2: 코드관리

### country_code (국가코드)
> ISO 3166 국가코드 관리

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | country_code | 국가코드 | VARCHAR | 3 | - | UNIQUE | Y | - | ISO 3166-1 alpha-2/3 |
| 3 | country_name_ko | 국가명(한글) | VARCHAR | 100 | - | - | Y | - | 국가 한글 명칭 |
| 4 | country_name_en | 국가명(영문) | VARCHAR | 100 | - | - | Y | - | 국가 영문 명칭 |
| 5 | use_yn | 사용여부 | CHAR | 1 | - | - | Y | Y | 사용여부 (Y/N) |

---

### airport_code (공항코드)
> IATA 공항코드 관리

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | airport_code | 공항코드 | VARCHAR | 10 | - | UNIQUE | Y | - | IATA 공항코드 |
| 3 | airport_name_ko | 공항명(한글) | VARCHAR | 200 | - | - | N | - | 공항 한글 명칭 |
| 4 | airport_name_en | 공항명(영문) | VARCHAR | 200 | - | - | Y | - | 공항 영문 명칭 |
| 5 | country_code | 국가코드 | VARCHAR | 3 | - | FK(country_code) | Y | - | 소속 국가코드 |
| 6 | city | 도시명 | VARCHAR | 100 | - | - | N | - | 공항 소재 도시명 |
| 7 | use_yn | 사용여부 | CHAR | 1 | - | - | Y | Y | 사용여부 (Y/N) |

---

### port_code (항구코드)
> UN/LOCODE 항구코드 관리

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | port_code | 항구코드 | VARCHAR | 10 | - | UNIQUE | Y | - | UN/LOCODE 항구코드 |
| 3 | port_name_ko | 항구명(한글) | VARCHAR | 200 | - | - | N | - | 항구 한글 명칭 |
| 4 | port_name_en | 항구명(영문) | VARCHAR | 200 | - | - | Y | - | 항구 영문 명칭 |
| 5 | country_code | 국가코드 | VARCHAR | 3 | - | FK(country_code) | Y | - | 소속 국가코드 |
| 6 | city | 도시명 | VARCHAR | 100 | - | - | N | - | 항구 소재 도시명 |
| 7 | use_yn | 사용여부 | CHAR | 1 | - | - | Y | Y | 사용여부 (Y/N) |

---

### airline_code (항공사코드)
> IATA 항공사코드 관리

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | airline_code | 항공사코드 | VARCHAR | 10 | - | UNIQUE | Y | - | IATA 항공사코드 |
| 3 | airline_name_ko | 항공사명(한글) | VARCHAR | 200 | - | - | N | - | 항공사 한글 명칭 |
| 4 | airline_name_en | 항공사명(영문) | VARCHAR | 200 | - | - | Y | - | 항공사 영문 명칭 |
| 5 | use_yn | 사용여부 | CHAR | 1 | - | - | Y | Y | 사용여부 (Y/N) |

---

### courier_company (택배사)
> 택배사 정보 관리

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | courier_code | 택배사코드 | VARCHAR | 20 | - | UNIQUE | Y | - | 택배사 식별 코드 |
| 3 | courier_name_ko | 택배사명(한글) | VARCHAR | 200 | - | - | Y | - | 택배사 한글 명칭 |
| 4 | courier_name_en | 택배사명(영문) | VARCHAR | 200 | - | - | N | - | 택배사 영문 명칭 |
| 5 | country_code | 서비스국가코드 | VARCHAR | 3 | - | FK(country_code) | N | - | 서비스 제공 국가코드 |
| 6 | tracking_url | 트래킹URL | VARCHAR | 500 | - | - | N | - | 운송장 조회 URL |
| 7 | use_yn | 사용여부 | CHAR | 1 | - | - | Y | Y | 사용여부 (Y/N) |

---

### code_group (코드그룹)
> 공통 코드 그룹 관리

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | group_code | 그룹코드 | VARCHAR | 50 | - | UNIQUE | Y | - | 코드 그룹 식별자 |
| 3 | group_name | 그룹명 | VARCHAR | 100 | - | - | Y | - | 코드 그룹 명칭 |
| 4 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |

---

### common_code (공통코드)
> 시스템 공통 코드 관리

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | group_id | 그룹ID | BIGINT | - | - | FK(code_group.id) | Y | - | 소속 코드그룹 ID |
| 3 | code | 코드 | VARCHAR | 50 | - | - | Y | - | 코드값 |
| 4 | code_name | 코드명 | VARCHAR | 200 | - | - | Y | - | 코드 명칭 |
| 5 | sort_order | 정렬순서 | INTEGER | - | - | - | Y | 0 | 목록 표시 순서 |
| 6 | use_yn | 사용여부 | CHAR | 1 | - | - | Y | Y | 사용여부 (Y/N) |
| 7 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 8 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

## 도메인 3: 오더관리

### orders (오더)
> 물류 오더 기본 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 오더 고유 ID |
| 2 | order_no | 오더번호 | VARCHAR | 30 | - | UNIQUE | Y | - | 시스템 생성 오더번호 (ORD-YYYYMMDD-NNNNN) |
| 3 | member_type | 회원타입 | VARCHAR | 20 | - | - | Y | - | INDIVIDUAL/CORPORATE/DEPT |
| 4 | member_id | 회원ID | BIGINT | - | - | - | Y | - | 등록 회원 ID |
| 5 | order_status | 오더상태 | VARCHAR | 30 | - | - | Y | REGISTERED | REGISTERED/PACKED/WAREHOUSED/RELEASED/DELIVERED |
| 6 | master_order_id | 마스터오더ID | BIGINT | - | - | FK(master_order.id) | N | - | 포함된 마스터오더 ID |
| 7 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 오더 등록일시 |
| 8 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

**오더 상태 흐름:** `REGISTERED → PACKED → WAREHOUSED → RELEASED → DELIVERED`

---

### shipper_info (송하인정보)
> 오더의 발송인(송하인) 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | order_id | 오더ID | BIGINT | - | - | FK(orders.id) | Y | - | 소속 오더 ID |
| 3 | shipper_name | 송하인명 | VARCHAR | 100 | - | - | Y | - | 송하인(발송자) 이름 |
| 4 | business_number | 사업자번호 | VARCHAR | 20 | - | - | N | - | 법인 송하인 사업자등록번호 |
| 5 | country_code | 국가코드 | VARCHAR | 3 | - | FK(country_code) | Y | - | 송하인 국가코드 |
| 6 | zipcode | 우편번호 | VARCHAR | 10 | - | - | N | - | 우편번호 |
| 7 | address | 주소 | VARCHAR | 255 | - | - | N | - | 주소 |
| 8 | address_detail | 상세주소 | VARCHAR | 255 | - | - | N | - | 상세주소 |
| 9 | phone | 전화번호 | VARCHAR | 20 | - | - | N | - | 전화번호 |
| 10 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 11 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### consignee_info (수하인정보)
> 오더의 수취인(수하인/수입자) 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | order_id | 오더ID | BIGINT | - | - | FK(orders.id) | Y | - | 소속 오더 ID |
| 3 | consignee_name | 수하인명 | VARCHAR | 100 | - | - | Y | - | 수하인(수취인/수입자) 이름 |
| 4 | business_number | 사업자번호 | VARCHAR | 20 | - | - | N | - | 법인 수하인 사업자등록번호 |
| 5 | country_code | 국가코드 | VARCHAR | 3 | - | FK(country_code) | Y | - | 수하인 국가코드 |
| 6 | zipcode | 우편번호 | VARCHAR | 10 | - | - | N | - | 우편번호 |
| 7 | address | 주소 | VARCHAR | 255 | - | - | N | - | 주소 |
| 8 | address_detail | 상세주소 | VARCHAR | 255 | - | - | N | - | 상세주소 |
| 9 | phone | 전화번호 | VARCHAR | 20 | - | - | N | - | 전화번호 |
| 10 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 11 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### cargo_info (화물정보)
> 오더의 화물 상세 정보 (HS코드, 특수화물 포함)

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | order_id | 오더ID | BIGINT | - | - | FK(orders.id) | Y | - | 소속 오더 ID |
| 3 | cargo_name | 품명 | VARCHAR | 200 | - | - | Y | - | 화물 품명 |
| 4 | hs_code | HS코드 | VARCHAR | 20 | - | - | N | - | HS 관세코드 |
| 5 | origin_country_code | 원산지국가코드 | VARCHAR | 3 | - | FK(country_code) | N | - | 화물 원산지 국가코드 |
| 6 | qty_pcs | 개별수량 | INTEGER | - | - | - | N | - | 개별 수량 (PCS) |
| 7 | qty_pkgs | 포장수량 | INTEGER | - | - | - | N | - | 포장 수량 (CTNS/PKGS) |
| 8 | gross_weight | 총중량 | NUMERIC | 10,3 | - | - | N | - | 총중량 (kg) — 운송원가 계산 기준 |
| 9 | net_weight | 순중량 | NUMERIC | 10,3 | - | - | N | - | 순중량 (kg) |
| 10 | cbm | 용적 | NUMERIC | 10,3 | - | - | N | - | 용적 (CBM) — 운송원가 계산 기준 |
| 11 | is_dangerous | 위험물여부 | CHAR | 1 | - | - | Y | N | 위험물 여부 (Y/N) |
| 12 | imdg_code | 위험물코드 | VARCHAR | 20 | - | - | N | - | IMDG 위험물 코드 |
| 13 | is_refrigerated | 냉동냉장여부 | CHAR | 1 | - | - | Y | N | 냉동/냉장 여부 (Y/N) |
| 14 | temperature | 온도 | NUMERIC | 5,1 | - | - | N | - | 냉동/냉장 온도 (℃) |
| 15 | is_high_value | 고가품여부 | CHAR | 1 | - | - | Y | N | 고가품 여부 (Y/N) |
| 16 | unit_price | 단가 | NUMERIC | 15,2 | - | - | N | - | 고가품 단가 |
| 17 | total_price | 총액 | NUMERIC | 15,2 | - | - | N | - | 고가품 총액 |
| 18 | is_used | 중고품여부 | CHAR | 1 | - | - | Y | N | 중고품 여부 (Y/N) |
| 19 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 20 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### order_service (오더서비스)
> 오더에 추가된 운송 서비스 정보 (AIR/SEA/CIR/CCL)

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | order_id | 오더ID | BIGINT | - | - | FK(orders.id) | Y | - | 소속 오더 ID |
| 3 | service_type | 서비스구분 | VARCHAR | 10 | - | - | Y | - | AIR/SEA/CIR/CCL |
| 4 | departure_country_code | 출발국가코드 | VARCHAR | 3 | - | FK(country_code) | N | - | 출발 국가코드 (AIR/SEA) |
| 5 | departure_code | 출발공항항구코드 | VARCHAR | 10 | - | - | N | - | 출발 공항 또는 항구 코드 |
| 6 | arrival_country_code | 도착국가코드 | VARCHAR | 3 | - | FK(country_code) | Y | - | 도착 국가코드 |
| 7 | arrival_code | 도착공항항구코드 | VARCHAR | 10 | - | - | N | - | 도착 공항 또는 항구 코드 |
| 8 | carrier_id | 운송사ID | BIGINT | - | - | - | N | - | 항공사/선사/택배사/통관사 ID |
| 9 | schedule_id | 스케줄ID | BIGINT | - | - | FK(transport_schedule.id) | N | - | 운항 스케줄 ID |
| 10 | transport_cost | 운송원가 | NUMERIC | 15,2 | - | - | N | - | 운송 원가 |
| 11 | selling_price | 운송비 | NUMERIC | 15,2 | - | - | N | - | 운송비 (판매가) |
| 12 | extra_charge | Extra Charge | NUMERIC | 15,1 | - | - | N | - | 추가 비용 (소수점 1자리) |
| 13 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 14 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

**운송비 계산식:**
```
운송비 = 운송원가 + (운송원가 × 영업이익율%) − (운송원가 × (1 − 할인율%))
```

---

## 도메인 4: 운송관리

### master_order (마스터오더)
> 여러 오더를 묶는 마스터오더 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 마스터오더 고유 ID |
| 2 | master_order_no | 마스터오더번호 | VARCHAR | 30 | - | UNIQUE | Y | - | 시스템 생성 마스터오더번호 (MO-YYYYMMDD-NNNNN) |
| 3 | master_status | 마스터상태 | VARCHAR | 30 | - | - | Y | CREATED | CREATED/WAREHOUSED/RELEASED/IN_TRANSIT/DELIVERED |
| 4 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 5 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

**마스터오더 상태 흐름:** `CREATED → WAREHOUSED → RELEASED → IN_TRANSIT → DELIVERED`

---

### transport_schedule (운항스케줄)
> 항공/해운 운항 스케줄 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | transport_type | 운송타입 | VARCHAR | 10 | - | - | Y | - | AIR/SEA |
| 3 | carrier_id | 운송사ID | BIGINT | - | - | - | Y | - | 항공사 또는 선사 ID |
| 4 | departure_code | 출발코드 | VARCHAR | 10 | - | - | Y | - | 출발 공항 또는 항구 코드 |
| 5 | arrival_code | 도착코드 | VARCHAR | 10 | - | - | Y | - | 도착 공항 또는 항구 코드 |
| 6 | departure_dt | 출발일시 | TIMESTAMP | - | - | - | Y | - | 출발 일시 |
| 7 | arrival_dt | 도착일시 | TIMESTAMP | - | - | - | Y | - | 도착(예정) 일시 |
| 8 | flight_voyage_no | 편명항차 | VARCHAR | 50 | - | - | N | - | 항공 편명 또는 선박 항차 |
| 9 | use_yn | 사용여부 | CHAR | 1 | - | - | Y | Y | 사용여부 (Y/N) |
| 10 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |

---

## 도메인 5: 창고관리

### warehouse_receipt (입고)
> 창고 입고 처리 이력

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | order_id | 오더ID | BIGINT | - | - | FK(orders.id) | Y | - | 입고 오더 ID |
| 3 | receipt_dt | 입고일시 | TIMESTAMP | - | - | - | Y | - | 입고 처리 일시 |
| 4 | receipt_by | 입고처리자 | VARCHAR | 100 | - | - | N | - | 입고 처리 담당자 |
| 5 | note | 비고 | VARCHAR | 500 | - | - | N | - | 입고 메모 |
| 6 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |

---

### warehouse_release (출고)
> 창고 출고 처리 이력 (운송장 출력 포함)

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | order_id | 오더ID | BIGINT | - | - | FK(orders.id) | Y | - | 출고 오더 ID |
| 3 | master_order_id | 마스터오더ID | BIGINT | - | - | FK(master_order.id) | N | - | 마스터오더 ID |
| 4 | waybill_no | 운송장번호 | VARCHAR | 100 | - | - | N | - | 출력된 운송장 번호 |
| 5 | release_dt | 출고일시 | TIMESTAMP | - | - | - | Y | - | 출고 처리 일시 |
| 6 | release_by | 출고처리자 | VARCHAR | 100 | - | - | N | - | 출고 처리 담당자 |
| 7 | note | 비고 | VARCHAR | 500 | - | - | N | - | 출고 메모 |
| 8 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |

---

## 도메인 6: Tracking

### tracking_info (운송Tracking)
> 항운/해운/택배 운송 추적 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | order_id | 오더ID | BIGINT | - | - | FK(orders.id) | Y | - | 소속 오더 ID |
| 3 | service_type | 서비스구분 | VARCHAR | 10 | - | - | Y | - | AIR/SEA/CIR |
| 4 | tracking_no | 추적번호 | VARCHAR | 100 | - | - | N | - | 운송장/B/L 번호 |
| 5 | tracking_status | 추적상태 | VARCHAR | 50 | - | - | N | - | 운송 진행 상태 |
| 6 | tracking_location | 현재위치 | VARCHAR | 200 | - | - | N | - | 화물 현재 위치 |
| 7 | tracking_dt | 추적일시 | TIMESTAMP | - | - | - | N | - | 해당 상태 발생 일시 |
| 8 | raw_data | 원본데이터 | TEXT | - | - | - | N | - | 외부 API 응답 원본 JSON |
| 9 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 10 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### customs_declaration (통관신고)
> 통관 신고 및 결과 조회 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | order_id | 오더ID | BIGINT | - | - | FK(orders.id) | Y | - | 소속 오더 ID |
| 3 | declaration_no | 신고번호 | VARCHAR | 50 | - | - | N | - | 통관 신고 번호 |
| 4 | declaration_status | 신고상태 | VARCHAR | 30 | - | - | N | - | 통관 신고 상태 |
| 5 | declaration_dt | 신고일시 | TIMESTAMP | - | - | - | N | - | 신고 일시 |
| 6 | result_dt | 결과수신일시 | TIMESTAMP | - | - | - | N | - | 통관 결과 수신 일시 |
| 7 | note | 비고 | VARCHAR | 500 | - | - | N | - | 메모 |
| 8 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 9 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

## 도메인 7: 회계/청구

### invoice (청구서)
> 회원별 운송 청구서

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 청구서 고유 ID |
| 2 | invoice_no | 청구서번호 | VARCHAR | 30 | - | UNIQUE | Y | - | 시스템 생성 청구서번호 (INV-YYYYMMDD-NNNNN) |
| 3 | member_type | 회원타입 | VARCHAR | 20 | - | - | Y | - | INDIVIDUAL/CORPORATE/DEPT |
| 4 | member_id | 회원ID | BIGINT | - | - | - | Y | - | 청구 대상 회원 ID |
| 5 | invoice_dt | 청구일 | DATE | - | - | - | Y | - | 청구서 발행일 |
| 6 | due_dt | 납기일 | DATE | - | - | - | N | - | 납기 마감일 |
| 7 | total_amount | 청구총액 | NUMERIC | 15,2 | - | - | Y | - | 청구서 합계 금액 |
| 8 | paid_amount | 입금액 | NUMERIC | 15,2 | - | - | Y | 0 | 입금된 금액 |
| 9 | invoice_status | 청구상태 | VARCHAR | 20 | - | - | Y | UNPAID | UNPAID/PARTIAL/PAID |
| 10 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 11 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

**청구서 상태 흐름:** `UNPAID → PARTIAL → PAID`

---

### invoice_item (청구항목)
> 청구서 내 오더별 청구 항목

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | invoice_id | 청구서ID | BIGINT | - | - | FK(invoice.id) | Y | - | 소속 청구서 ID |
| 3 | order_id | 오더ID | BIGINT | - | - | FK(orders.id) | Y | - | 오더 ID |
| 4 | service_type | 서비스구분 | VARCHAR | 10 | - | - | Y | - | AIR/SEA/CIR/CCL |
| 5 | amount | 청구금액 | NUMERIC | 15,2 | - | - | Y | - | 항목별 청구 금액 |
| 6 | extra_charge | Extra Charge | NUMERIC | 15,1 | - | - | N | - | 추가 비용 (소수점 1자리) |
| 7 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |

---

### payment (입금)
> 청구서 입금 처리 이력

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | invoice_id | 청구서ID | BIGINT | - | - | FK(invoice.id) | Y | - | 소속 청구서 ID |
| 3 | paid_amount | 입금액 | NUMERIC | 15,2 | - | - | Y | - | 입금된 금액 |
| 4 | paid_dt | 입금일시 | TIMESTAMP | - | - | - | Y | - | 입금 처리 일시 |
| 5 | payment_method | 입금방법 | VARCHAR | 50 | - | - | N | - | 입금 방법 (계좌이체 등) |
| 6 | note | 비고 | VARCHAR | 500 | - | - | N | - | 메모 |
| 7 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |

---

### transport_cost_master (운송원가마스터)
> 서비스/운송사/구간별 운송 원가 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | service_type | 서비스구분 | VARCHAR | 10 | - | - | Y | - | AIR/SEA/CIR |
| 3 | carrier_id | 운송사ID | BIGINT | - | - | - | Y | - | 항공사/선사/택배사 ID |
| 4 | departure_code | 출발코드 | VARCHAR | 10 | - | - | N | - | 출발 공항 또는 항구 코드 |
| 5 | arrival_code | 도착코드 | VARCHAR | 10 | - | - | N | - | 도착 공항 또는 항구 코드 |
| 6 | weight_from | 중량구간시작 | NUMERIC | 10,3 | - | - | N | - | 중량 구간 시작값 (kg) |
| 7 | weight_to | 중량구간끝 | NUMERIC | 10,3 | - | - | N | - | 중량 구간 끝값 (kg) |
| 8 | unit_cost | 단위원가 | NUMERIC | 15,4 | - | - | Y | - | 단위당 운송 원가 |
| 9 | cost_unit | 원가단위 | VARCHAR | 20 | - | - | N | - | KG/CBM |
| 10 | effective_from | 적용시작일 | DATE | - | - | - | Y | - | 원가 적용 시작일 |
| 11 | effective_to | 적용종료일 | DATE | - | - | - | N | - | 원가 적용 종료일 (NULL=현재적용중) |
| 12 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 13 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### member_discount (회원별할인율)
> 회원별 서비스 할인율 및 영업이익율

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | member_type | 회원타입 | VARCHAR | 20 | - | - | Y | - | INDIVIDUAL/CORPORATE/DEPT |
| 3 | member_id | 회원ID | BIGINT | - | - | - | Y | - | 대상 회원 ID |
| 4 | service_type | 서비스구분 | VARCHAR | 10 | - | - | Y | - | AIR/SEA/CIR/CCL |
| 5 | discount_rate | 할인율 | NUMERIC | 5,2 | - | - | Y | - | 회원 할인율 (%) |
| 6 | profit_rate | 영업이익율 | NUMERIC | 5,2 | - | - | Y | - | 영업 이익율 (%) |
| 7 | effective_from | 적용시작일 | DATE | - | - | - | Y | - | 적용 시작일 |
| 8 | effective_to | 적용종료일 | DATE | - | - | - | N | - | 적용 종료일 |
| 9 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 10 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### tax_invoice (세금계산서)
> 청구서 기반 세금계산서 정보

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | invoice_id | 청구서ID | BIGINT | - | - | FK(invoice.id) | Y | - | 소속 청구서 ID |
| 3 | tax_invoice_no | 세금계산서번호 | VARCHAR | 50 | - | UNIQUE | Y | - | 세금계산서 고유번호 |
| 4 | issue_dt | 발행일 | DATE | - | - | - | Y | - | 세금계산서 발행일 |
| 5 | supply_amount | 공급가액 | NUMERIC | 15,2 | - | - | Y | - | 공급가액 |
| 6 | tax_amount | 세액 | NUMERIC | 15,2 | - | - | Y | - | 부가세액 |
| 7 | total_amount | 합계금액 | NUMERIC | 15,2 | - | - | Y | - | 합계금액 |
| 8 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |

---

## 도메인 8: 시스템관리

### notification (알림)
> 시스템 알림 발송 관리

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 알림 고유 ID |
| 2 | title | 제목 | VARCHAR | 200 | - | - | Y | - | 알림 제목 |
| 3 | content | 내용 | TEXT | - | - | - | Y | - | 알림 내용 |
| 4 | target_type | 대상타입 | VARCHAR | 20 | - | - | N | - | ALL/INDIVIDUAL/CORPORATE |
| 5 | target_id | 대상ID | BIGINT | - | - | - | N | - | 특정 대상 회원 ID |
| 6 | send_status | 발송상태 | VARCHAR | 20 | - | - | Y | PENDING | PENDING/SENT/FAILED |
| 7 | sent_dt | 발송일시 | TIMESTAMP | - | - | - | N | - | 실제 발송 일시 |
| 8 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |

---

### voc (VOC)
> 오더별 고객 불만/문의(VOC) 관리

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | VOC 고유 ID |
| 2 | order_id | 오더ID | BIGINT | - | - | FK(orders.id) | Y | - | 관련 오더 ID |
| 3 | member_type | 회원타입 | VARCHAR | 20 | - | - | Y | - | 문의 회원 타입 |
| 4 | member_id | 회원ID | BIGINT | - | - | - | Y | - | 문의 회원 ID |
| 5 | content | 문의내용 | TEXT | - | - | - | Y | - | VOC 문의 내용 |
| 6 | reply | 답변 | TEXT | - | - | - | N | - | 담당자 답변 내용 |
| 7 | status | 처리상태 | VARCHAR | 20 | - | - | Y | OPEN | OPEN/IN_PROGRESS/CLOSED |
| 8 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 9 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

**VOC 상태 흐름:** `OPEN → IN_PROGRESS → CLOSED`

---

### menu (메뉴)
> 시스템 메뉴 구조 관리 (계층형)

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 메뉴 고유 ID |
| 2 | parent_id | 상위메뉴ID | BIGINT | - | - | FK(menu.id) | N | - | 상위 메뉴 ID (NULL=최상위) |
| 3 | menu_name | 메뉴명 | VARCHAR | 100 | - | - | Y | - | 메뉴 명칭 |
| 4 | menu_url | 메뉴URL | VARCHAR | 200 | - | - | N | - | 메뉴 링크 URL |
| 5 | sort_order | 정렬순서 | INTEGER | - | - | - | Y | 0 | 메뉴 표시 순서 |
| 6 | use_yn | 사용여부 | CHAR | 1 | - | - | Y | Y | 사용여부 (Y/N) |
| 7 | created_at | 등록일시 | TIMESTAMP | - | - | - | Y | NOW() | 등록일시 |
| 8 | updated_at | 수정일시 | TIMESTAMP | - | - | - | Y | NOW() | 최종수정일시 |

---

### role (권한)
> 시스템 권한(Role) 정의

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 권한 고유 ID |
| 2 | role_code | 권한코드 | VARCHAR | 50 | - | UNIQUE | Y | - | 권한 식별 코드 |
| 3 | role_name | 권한명 | VARCHAR | 100 | - | - | Y | - | 권한 명칭 |
| 4 | description | 설명 | VARCHAR | 500 | - | - | N | - | 권한 설명 |

**권한 종류:** `ADMIN`, `OPERATOR`, `INDIVIDUAL`, `CORPORATE`, `DEPT_MANAGER`

---

### menu_role (메뉴권한매핑)
> 메뉴와 권한 매핑 테이블

| No | 컬럼명(영문) | 컬럼명(한글) | 데이터타입 | 길이/정밀도 | PK | FK | NOT NULL | 기본값 | 설명 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | id | 고유ID | BIGSERIAL | - | PK | - | Y | - | 고유 ID |
| 2 | menu_id | 메뉴ID | BIGINT | - | - | FK(menu.id) | Y | - | 메뉴 ID |
| 3 | role_id | 권한ID | BIGINT | - | - | FK(role.id) | Y | - | 권한 ID |

---

## 주요 Enum 값 요약

| 구분 | 컬럼 | 값 |
|---|---|---|
| 개인회원 등급 | individual_member.grade | BASIC / SILVER / GOLD / VIP |
| 회원 상태 | *.status | ACTIVE / INACTIVE / WITHDRAWN |
| 법인 심사상태 | corporate.approval_status | PENDING / APPROVED / REJECTED |
| 오더 상태 | orders.order_status | REGISTERED / PACKED / WAREHOUSED / RELEASED / DELIVERED |
| 마스터오더 상태 | master_order.master_status | CREATED / WAREHOUSED / RELEASED / IN_TRANSIT / DELIVERED |
| 서비스 구분 | order_service.service_type | AIR / SEA / CIR / CCL |
| 청구서 상태 | invoice.invoice_status | UNPAID / PARTIAL / PAID |
| 알림 발송상태 | notification.send_status | PENDING / SENT / FAILED |
| VOC 처리상태 | voc.status | OPEN / IN_PROGRESS / CLOSED |
| 번호 형식 | order_no | ORD-YYYYMMDD-NNNNN |
| 번호 형식 | master_order_no | MO-YYYYMMDD-NNNNN |
| 번호 형식 | invoice_no | INV-YYYYMMDD-NNNNN |
