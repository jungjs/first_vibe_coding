# SNTL 통합 물류 플랫폼 — UI 화면 목록

> 생성일: 2026-04-16 | 최종 업데이트: 2026-04-18 | 총 **58개** 화면 | `SNTL_UIList.xlsx` 내용 요약
>
> 컬럼 구조: `화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 연결화면 | 비고`

---

## 요약 통계

| 대분류 | 화면 수 |
|--------|---------|
| 로그인/인증 | 5 |
| 회원관리 | 8 |
| 오더관리 | 5 |
| 마스터오더관리 | 3 |
| 창고관리 | 3 |
| 운송Tracking | 4 |
| 회계/청구 | 6 |
| VOC관리 | 3 |
| 고객지원 | 4 |
| 관리자 | 10 |
| 기초정보관리 | 7 |
| **합계** | **58** |

| Phase | 화면 수 |
|-------|---------|
| Phase 1 | 24 |
| Phase 2 | 28 |
| Phase 3 | 6 |

---

## 1. 로그인 / 인증

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 연결화면 | 비고 |
|--------|--------|-----------|---------|---------|-------|---------|------|
| SCR-001 | 로그인 | 전체 | ID/PW 입력, 소셜로그인, JWT Token 발급 | `POST /api/auth/login` | P1 | SCR-004, SCR-002 | Access/Refresh Token 발급 |
| SCR-002 | ID 찾기 | 회원 | 이름+휴대폰 입력, SMS 인증, ID 표시 | `POST /api/auth/find-id` | P1 | SCR-001 | 법인: 법인명+사업자번호 |
| SCR-003 | PW 재설정 | 회원 | SMS/이메일 인증, 새 비밀번호 설정 | `POST /api/auth/reset-password` | P1 | SCR-001 | 8자 이상 복잡성 조건 |
| SCR-004 | 개인회원 가입 | 개인회원 | 본인확인, 개인정보 입력, 계정생성 | `POST /api/members/individual` | P1 | SCR-001 | SMS 본인인증 |
| SCR-005 | 법인회원 가입 | 법인관리자 | 법인정보 입력, 사업자등록증 첨부, 심사요청 | `POST /api/members/corporate` | P1 | SCR-001 | 첨부파일 업로드 포함 |

---

## 2. 회원관리

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 연결화면 | 비고 |
|--------|--------|-----------|---------|---------|-------|---------|------|
| SCR-010 | 마이페이지 | 개인회원 | 회원정보 조회, 등급 확인, 수정 이동 | `GET /api/members/me` | P1 | SCR-011, SCR-012 | |
| SCR-011 | 회원정보 수정 | 개인회원 | 이메일/주소/연락처 수정, PW 변경 | `PUT /api/members/me` | P1 | SCR-010 | |
| SCR-012 | 회원탈퇴 | 회원 | 탈퇴 사유 선택, 본인확인, Soft Delete | `DELETE /api/members/withdraw` | P1 | SCR-010 | 개인정보 Null 처리 |
| SCR-013 | 법인 마이페이지 | 법인관리자 | 법인정보 조회, 부서/멤버 관리 | `GET /api/members/corporate/me` | P2 | SCR-014 | |
| SCR-014 | 부서/멤버 관리 | 법인관리자 | 부서 CRUD, 멤버 초대/삭제 | `GET /api/corporate/departments` | P2 | SCR-013 | |
| SCR-015 | 선불금 관리 | 개인회원/법인관리자 | 잔액 조회, 충전·환불 요청 이력, 버튼 이동 | `GET /api/prepaid/balance` | P1 | SCR-016, SCR-017 | 개인/법인 공통 화면 |
| SCR-016 | 선불금 충전 요청 | 개인회원/법인관리자 | 충전 금액·입금자명·입금 예정일 입력, 요청 제출 | `POST /api/prepaid/charge` | P1 | SCR-015 | 입금 계좌 안내 표시 |
| SCR-017 | 선불금 환불 요청 | 개인회원/법인관리자 | 환불 금액·계좌 정보 입력, 잔액 검증 후 요청 | `POST /api/prepaid/refund` | P1 | SCR-015 | 잔액 부족 시 요청 불가 |

---

## 3. 오더관리

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 연결화면 | 비고 |
|--------|--------|-----------|---------|---------|-------|---------|------|
| SCR-020 | 오더 목록 | 회원/운영자 | 오더 검색, 목록, 상태 필터, 페이징 | `GET /api/orders` | P1 | SCR-021, SCR-022 | |
| SCR-021 | 오더 등록 | 회원 | 송하인/수하인/화물정보 입력 | `POST /api/orders` | P1 | SCR-020, SCR-023 | 오더번호 자동생성 |
| SCR-022 | 오더 상세/수정 | 회원/운영자 | 오더 상세 조회, 수정, 삭제 | `GET/PUT/DELETE /api/orders/{id}` | P1 | SCR-020 | 입고 후 수정불가 |
| SCR-023 | 서비스 추가 | 회원 | AIR/SEA/CIR/CCL 서비스 선택 및 정보 입력 | `POST /api/orders/{id}/services` | P1 | SCR-022 | 서비스별 입력항목 상이 |
| SCR-024 | 운송비용 조회 | 회원/운영자 | 자동계산 운송비, Extra Charge 입력 | `GET /api/orders/{id}/costs` | P2 | SCR-022 | 비용 계산식 적용 |

### 오더 상태 흐름
```
등록 → 창고입고 → 창고출고 → 운송중 → 통관중 → 완료
                ↑
        (입고 이후 수정·삭제 불가)
```

---

## 4. 마스터오더관리

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 연결화면 | 비고 |
|--------|--------|-----------|---------|---------|-------|---------|------|
| SCR-030 | 마스터오더 목록 | 운영자 | 마스터오더 검색, 목록, 상태 필터 | `GET /api/master-orders` | P2 | SCR-031, SCR-032 | |
| SCR-031 | 마스터오더 등록/패킹 | 운영자 | 마스터오더 생성, 오더 패킹(추가/제거) | `POST /api/master-orders` | P2 | SCR-030 | |
| SCR-032 | 마스터오더 상세 | 운영자 | 포함 오더 목록, 서비스 정보, Tracking 현황 | `GET /api/master-orders/{id}` | P2 | SCR-030 | |

---

## 5. 창고관리

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 연결화면 | 비고 |
|--------|--------|-----------|---------|---------|-------|---------|------|
| SCR-040 | 창고 입고 처리 | 운영자 | 바코드 스캔, 입고 확인 및 처리 | `POST /api/warehouse/receipt` | P2 | SCR-041 | 입고 후 오더 수정불가 |
| SCR-041 | 창고 출고 처리 | 운영자 | 바코드 스캔, 운송장 출력, 출고 처리 | `POST /api/warehouse/release` | P2 | SCR-040 | 운송장 PDF 출력 |
| SCR-042 | 창고 현황 | 운영자 | 입고 현황 조회, 재고 목록 | `GET /api/warehouse/status` | P2 | | |

---

## 6. 운송 Tracking

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 비고 |
|--------|--------|-----------|---------|---------|-------|------|
| SCR-050 | AIR Tracking | 회원/운영자 | 항공 화물 실시간 추적, 스케줄 조회 | `GET /api/tracking/air/{id}` | P2 | 외부 AIR API 연동 |
| SCR-051 | SEA Tracking | 회원/운영자 | 선박 운송 현황 추적, 선적 스케줄 | `GET /api/tracking/sea/{id}` | P2 | 외부 SEA API 연동 |
| SCR-052 | CIR Tracking | 회원/운영자 | 국제택배 실시간 추적 | `GET /api/tracking/cir/{id}` | P2 | 외부 택배사 API 연동 |
| SCR-053 | 통관신고 현황 | 회원/운영자 | 통관 신고 현황, 세관 응답 조회 | `GET /api/customs/{id}` | P2 | CCL 서비스 연계 |

---

## 7. 회계 / 청구

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 연결화면 | 비고 |
|--------|--------|-----------|---------|---------|-------|---------|------|
| SCR-060 | 청구서 목록 | 운영자/회원 | 청구서 목록, 검색, 상태 필터 | `GET /api/invoices` | P2 | SCR-061 | |
| SCR-061 | 청구서 상세 | 운영자/회원 | 청구 항목 상세, 입금 처리 | `GET /api/invoices/{id}` | P2 | SCR-060, SCR-062 | |
| SCR-062 | 입금 처리 | 운영자 | 입금 확인, 미수금 처리 | `POST /api/invoices/{id}/payment` | P2 | SCR-061 | |
| SCR-063 | 세금계산서 | 운영자 | 세금계산서 발행, 조회, 재발행 | `GET/POST /api/tax-invoices` | P3 | SCR-060 | |
| SCR-064 | 수입/비용 현황 | 관리자 | 기간별 수입, 원가, 수익 분석 차트 | `GET /api/statistics/revenue` | P3 | | 차트 포함 |
| SCR-065 | 운송원가 관리 | 관리자 | 서비스/구간별 원가 등록·수정 | `GET/POST /api/transport-costs` | P2 | | |

---

## 8. VOC 관리

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 연결화면 | 비고 |
|--------|--------|-----------|---------|---------|-------|---------|------|
| SCR-070 | VOC 목록 | 회원/운영자 | VOC 목록, 상태 필터, 처리현황 | `GET /api/voc` | P2 | SCR-071, SCR-072 | |
| SCR-071 | VOC 등록 | 회원 | 오더 선택, 불만/문의 내용 등록 | `POST /api/voc` | P2 | SCR-070 | 알림 자동 발송 |
| SCR-072 | VOC 답변 | 운영자 | VOC 내용 조회, 답변 등록, 상태 변경 | `PUT /api/voc/{id}/reply` | P2 | SCR-070 | 고객 알림 발송 |

### VOC 처리 상태
`OPEN` → `IN_PROGRESS` → `CLOSED`

---

## 9. 고객지원

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 비고 |
|--------|--------|-----------|---------|---------|-------|------|
| SCR-080 | QnA 목록/등록 | 회원 | 1:1 문의 목록, 문의 등록 | `GET/POST /api/support/qna` | P2 | |
| SCR-081 | QnA 답변 | 운영자 | 관리자 답변 등록, 처리상태 변경 | `PUT /api/support/qna/{id}` | P2 | |
| SCR-082 | FAQ | 전체 | FAQ 카테고리별 조회, 관리자 CRUD | `GET /api/support/faq` | P2 | |
| SCR-083 | 공지사항 | 전체 | 공지사항 목록, 상세, 중요공지 상단고정 | `GET /api/support/notice` | P2 | 관리자: CRUD |

---

## 10. 관리자

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 연결화면 | 비고 |
|--------|--------|-----------|---------|---------|-------|---------|------|
| SCR-090 | 관리자 대시보드 | 관리자 | 오더현황, 수익, 회원통계 요약 KPI+차트 | `GET /api/admin/dashboard` | P2 | | |
| SCR-091 | 회원 목록/관리 | 관리자 | 회원 검색, 상세, 등급/상태 변경 | `GET /api/admin/members` | P1 | SCR-092 | |
| SCR-092 | 법인 심사 | 관리자 | 법인 가입 신청, 첨부파일 확인, 승인/거부 | `PUT /api/admin/corporate/review` | P1 | SCR-091 | 승인 시 알림 발송 |
| SCR-093 | 메뉴 관리 | 관리자 | 메뉴 트리 조회, 등록, 수정, 순서변경 | `GET/POST /api/system/menus` | P2 | | 계층형 트리 |
| SCR-094 | 코드 관리 | 관리자 | 코드그룹 및 공통코드 CRUD | `GET/POST /api/system/codes` | P2 | | |
| SCR-095 | 권한 관리 | 관리자 | 역할 정의, 메뉴별 접근권한 설정 | `GET/POST /api/system/roles` | P2 | | Role 기반 접근제어 |
| SCR-096 | 택배사 관리 | 관리자 | 택배사 CRUD, Tracking URL 관리 | `GET/POST /api/system/couriers` | P2 | | |
| SCR-097 | 알림 관리 | 관리자 | 알림 발송 내역, 공지 알림 생성 | `GET /api/notifications` | P2 | | |
| SCR-098 | 통계 | 관리자 | 운송/비용 기간별 통계, 차트 | `GET /api/statistics` | P3 | | 차트 |
| SCR-099 | 데이터 백업 | 관리자 | DB 백업 실행, 백업 이력 조회 | `POST /api/admin/backup` | P3 | | |

---

## 11. 기초정보관리

> 관리자 전용 화면. 운임요율·환율·운송수단·통관사·선불금 처리 등 플랫폼 기초 데이터 관리.

| 화면ID | 화면명 | 사용자유형 | 주요기능 | 관련 API | Phase | 연결화면 | 비고 |
|--------|--------|-----------|---------|---------|-------|---------|------|
| SCR-100 | 선불금 요청 관리 | 관리자 | 충전/환불 요청 목록 조회, PENDING 요청 확인·거부 처리 | `GET /api/prepaid/admin`, `PATCH /api/prepaid/charge/{id}/confirm`, `PATCH /api/prepaid/refund/{id}/confirm` | P1 | | 확인 시 회원 잔액 자동 반영 |
| SCR-101 | 운임요율 관리 | 관리자 | 개인등급별(BASIC/SILVER/GOLD/VIP) 및 법인별 운임요율 CRUD, 적용기간 설정 | `GET/POST/PUT/DELETE /api/fare-rates` | P1 | | 서비스구분(AIR/SEA/CIR/CCL) 탭 |
| SCR-102 | 환율 관리 | 관리자 | 최신 환율 목록 조회, 서울외국환중개소 API 수동 연계, 환율 수동 수정 | `GET /api/exchange-rates`, `POST /api/exchange-rates/sync` | P1 | | 영업일 자동 연계 이력 포함 |
| SCR-103 | 항공운송수단 관리 | 관리자 | 항공 운송구간(출발/도착 국가·공항) CRUD, 구간별 부피·중량기준 운송원가 CRUD | `GET/POST/PUT/DELETE /api/air-transports`, `/api/air-transports/{id}/costs` | P1 | | 편명·원가 탭 분리 |
| SCR-104 | 해운운송수단 관리 | 관리자 | 해운 운송구간(출발/도착 국가·항구) CRUD, 구간별 부피·중량기준 운송원가 CRUD | `GET/POST/PUT/DELETE /api/sea-transports`, `/api/sea-transports/{id}/costs` | P1 | | 선사명·원가 탭 분리 |
| SCR-105 | 통관사 관리 | 관리자 | 통관사 CRUD(국가·서비스구분·API연동ON/OFF), 통관원가 CRUD | `GET/POST/PUT/DELETE /api/customs-brokers`, `/api/customs-brokers/{id}/costs` | P1 | | API연동구분 ON/OFF 토글 |
| SCR-106 | 택배배송장 관리 | 관리자 | 택배사별·국가별 배송장 양식 파일 업로드·다운로드·삭제 | `GET/POST/DELETE /api/courier-waybills` | P1 | SCR-096 | MinIO 파일 저장 |

---

## 화면 흐름 요약

### 회원 주요 흐름
```
SCR-004(개인회원가입) → SCR-001(로그인)
  → SCR-020(오더목록) → SCR-021(오더등록) → SCR-023(서비스추가)
  → SCR-050(Tracking) → SCR-060(청구서) → SCR-070(VOC)
  → SCR-015(선불금관리) → SCR-016(충전요청) / SCR-017(환불요청)
```

### 운영자 주요 흐름
```
SCR-090(대시보드) → SCR-092(법인심사)
  → SCR-031(마스터오더패킹)
  → SCR-040(창고입고) → SCR-041(창고출고)
  → SCR-060(청구서생성) → SCR-062(입금처리)
```

### 관리자 기초정보관리 흐름
```
SCR-101(운임요율) → SCR-102(환율연계)
  → SCR-103(항공운송수단) → SCR-104(해운운송수단)
  → SCR-105(통관사) → SCR-106(택배배송장)
  → SCR-100(선불금요청확인)
```

### 접근 권한 매핑
| 역할 | 접근 가능 화면 |
|------|--------------|
| 개인회원 (INDIVIDUAL) | SCR-001~005, SCR-010~012, SCR-015~017, SCR-020~024, SCR-050~053, SCR-060~061, SCR-070~072, SCR-080~083 |
| 법인관리자 (CORPORATE) | 개인회원 + SCR-013~014 |
| 운영자 (OPERATOR) | 회원 전체 + SCR-030~042, SCR-072, SCR-081 |
| 관리자 (ADMIN) | 전체 화면 (SCR-001~106) |
