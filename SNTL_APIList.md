# SNTL 통합 물류 플랫폼 — API 목록

> 총 137개 API | Base URL: `/api/v1` | 최종 업데이트: 2026-04-16

---

## 규칙 및 공통 사항

| 항목 | 내용 |
|---|---|
| Base URL | `/api/v1` |
| 인증 방식 | JWT Bearer Token (`Authorization: Bearer {access_token}`) |
| 응답 형식 | `ApiResponse<T>` 래퍼 (success / data / message) |
| 날짜 형식 | ISO 8601 (`yyyy-MM-ddTHH:mm:ss`) |
| 페이징 | `page`(0-based), `size`, `sort` 쿼리 파라미터 |
| Content-Type | `application/json` (파일 업로드: `multipart/form-data`) |

### 권한 코드 범례

| 코드 | 설명 |
|---|---|
| PUBLIC | 인증 불필요 |
| AUTH | 인증된 모든 사용자 |
| ADMIN | 관리자 |
| ADMIN/OPR | 관리자, 운영자 |
| SELF | 본인 (또는 관리자) |
| CORP | 법인관리자, 부서관리자, 운영자, 관리자 |
| CORP_ADMIN | 법인관리자 (또는 관리자) |

---

## 도메인 요약

| 도메인 | API ID 범위 | API 수 | Phase |
|---|---|---|---|
| 인증 (AUTH) | API-A01 ~ A07 | 7 | 1 |
| 회원 - 개인 (MEMBER-IND) | API-M01 ~ M05 | 5 | 1 |
| 회원 - 법인 (MEMBER-CORP) | API-M06 ~ M15 | 10 | 1 |
| 회원 - 법인담당자 (MEMBER-MGR) | API-M16 ~ M19 | 4 | 1 |
| 회원 - 부서 (MEMBER-DEPT) | API-M20 ~ M27 | 8 | 1 |
| 회원 - 등급정책 (MEMBER-GRADE) | API-M28 ~ M31 | 4 | 1 |
| **선불금 (PREPAID)** | **API-PP01 ~ PP05** | **5** | **1** |
| 오더 (ORDER) | API-O01 ~ O15 | 15 | 2 |
| 마스터오더 (MASTER-ORDER) | API-MO01 ~ MO08 | 8 | 2 |
| 창고 (WAREHOUSE) | API-W01 ~ W07 | 7 | 2 |
| Tracking | API-T01 ~ T06 | 6 | 3 |
| 회계/청구 (BILLING) | API-B01 ~ B12 | 12 | 3 |
| 원가 (COST) | API-C01 ~ C10 | 10 | 3 |
| 알림 (NOTIFICATION) | API-N01 ~ N04 | 4 | 4 |
| VOC | API-V01 ~ V06 | 6 | 3 |
| 시스템 (SYSTEM) | API-S01 ~ S17 | 17 | 4 |
| 기준코드 (CODE) | API-R01 ~ R20 | 20 | 1 |
| **운임요율 (FARE-RATE)** | **API-FR01 ~ FR08** | **8** | **1** |
| **환율 (EXCHANGE-RATE)** | **API-EX01 ~ EX02** | **2** | **1** |
| **항공운송수단 (AIR-TRANSPORT)** | **API-AT01 ~ AT07** | **7** | **1** |
| **해운운송수단 (SEA-TRANSPORT)** | **API-ST01 ~ ST07** | **7** | **1** |
| **통관사 (CUSTOMS-BROKER)** | **API-CB01 ~ CB07** | **7** | **1** |
| **택배배송장 (COURIER-WAYBILL)** | **API-CW01 ~ CW04** | **4** | **1** |
| **합계** | | **182** | |

---

## 1. 인증 (AUTH)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-A01 | POST | /auth/login | 로그인 | N | PUBLIC | 1 |
| API-A02 | POST | /auth/logout | 로그아웃 | Y | AUTH | 1 |
| API-A03 | POST | /auth/token/refresh | Access Token 갱신 | N | PUBLIC | 1 |
| API-A04 | POST | /auth/sms/send | SMS 인증번호 발송 | N | PUBLIC | 1 |
| API-A05 | POST | /auth/sms/verify | SMS 인증번호 확인 | N | PUBLIC | 1 |
| API-A06 | POST | /auth/password/reset-request | 비밀번호 재설정 요청 | N | PUBLIC | 1 |
| API-A07 | PUT | /auth/password/reset | 비밀번호 재설정 | N | PUBLIC | 1 |

---

## 2. 회원 — 개인회원 (MEMBER-IND)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-M01 | POST | /members/individual | 개인회원 가입 | N | PUBLIC | 1 |
| API-M02 | GET | /members/individual | 개인회원 목록 | Y | ADMIN/OPR | 1 |
| API-M03 | GET | /members/individual/{memberId} | 개인회원 상세 조회 | Y | SELF | 1 |
| API-M04 | PUT | /members/individual/{memberId} | 개인회원 정보 수정 | Y | SELF | 1 |
| API-M05 | DELETE | /members/individual/{memberId} | 개인회원 탈퇴 | Y | SELF | 1 |

---

## 3. 회원 — 법인회원 (MEMBER-CORP)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-M06 | POST | /members/corporate | 법인회원 가입 신청 | N | PUBLIC | 1 |
| API-M07 | GET | /members/corporate | 법인회원 목록 | Y | ADMIN/OPR | 1 |
| API-M08 | GET | /members/corporate/{corporateId} | 법인회원 상세 조회 | Y | SELF/CORP | 1 |
| API-M09 | PUT | /members/corporate/{corporateId} | 법인회원 정보 수정 | Y | CORP_ADMIN | 1 |
| API-M10 | DELETE | /members/corporate/{corporateId} | 법인회원 탈퇴 | Y | CORP_ADMIN | 1 |
| API-M11 | PATCH | /members/corporate/{corporateId}/approve | 법인 심사 승인 | Y | ADMIN/OPR | 1 |
| API-M12 | PATCH | /members/corporate/{corporateId}/reject | 법인 심사 거부 | Y | ADMIN/OPR | 1 |
| API-M13 | POST | /members/corporate/{corporateId}/attachments | 첨부파일 업로드 | Y | CORP/ADMIN | 1 |
| API-M14 | GET | /members/corporate/{corporateId}/attachments | 첨부파일 목록 | Y | CORP/ADMIN | 1 |
| API-M15 | DELETE | /members/corporate/{corporateId}/attachments/{attachmentId} | 첨부파일 삭제 | Y | CORP_ADMIN | 1 |

---

## 4. 회원 — 법인담당자 (MEMBER-MGR)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-M16 | POST | /members/corporate/{corporateId}/managers | 담당자 추가 | Y | CORP_ADMIN | 1 |
| API-M17 | GET | /members/corporate/{corporateId}/managers | 담당자 목록 | Y | CORP/ADMIN | 1 |
| API-M18 | PUT | /members/corporate/{corporateId}/managers/{managerId} | 담당자 수정 | Y | CORP_ADMIN | 1 |
| API-M19 | DELETE | /members/corporate/{corporateId}/managers/{managerId} | 담당자 삭제 | Y | CORP_ADMIN | 1 |

---

## 5. 회원 — 부서 (MEMBER-DEPT)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-M20 | POST | /members/corporate/{corporateId}/departments | 부서 생성 | Y | CORP_ADMIN | 1 |
| API-M21 | GET | /members/corporate/{corporateId}/departments | 부서 목록 | Y | CORP/ADMIN | 1 |
| API-M22 | PUT | /members/corporate/{corporateId}/departments/{deptId} | 부서 수정 | Y | CORP_ADMIN | 1 |
| API-M23 | DELETE | /members/corporate/{corporateId}/departments/{deptId} | 부서 삭제 | Y | CORP_ADMIN | 1 |
| API-M24 | POST | /members/corporate/{corporateId}/departments/{deptId}/managers | 부서담당자 추가 | Y | CORP_ADMIN | 1 |
| API-M25 | GET | /members/corporate/{corporateId}/departments/{deptId}/managers | 부서담당자 목록 | Y | CORP/ADMIN | 1 |
| API-M26 | PUT | /members/corporate/{corporateId}/departments/{deptId}/managers/{mgId} | 부서담당자 수정 | Y | CORP_ADMIN | 1 |
| API-M27 | DELETE | /members/corporate/{corporateId}/departments/{deptId}/managers/{mgId} | 부서담당자 삭제 | Y | CORP_ADMIN | 1 |

---

## 6. 회원 — 등급정책 (MEMBER-GRADE)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-M28 | GET | /members/grade-policies | 등급 정책 목록 | Y | ADMIN | 1 |
| API-M29 | POST | /members/grade-policies | 등급 정책 생성 | Y | ADMIN | 1 |
| API-M30 | PUT | /members/grade-policies/{policyId} | 등급 정책 수정 | Y | ADMIN | 1 |
| API-M31 | DELETE | /members/grade-policies/{policyId} | 등급 정책 삭제 | Y | ADMIN | 1 |

---

## 7. 오더 (ORDER)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-O01 | POST | /orders | 오더 등록 | Y | AUTH | 2 |
| API-O02 | GET | /orders | 오더 목록 | Y | AUTH | 2 |
| API-O03 | GET | /orders/{orderId} | 오더 상세 조회 | Y | AUTH | 2 |
| API-O04 | PUT | /orders/{orderId} | 오더 수정 | Y | SELF | 2 |
| API-O05 | DELETE | /orders/{orderId} | 오더 삭제 | Y | SELF | 2 |
| API-O06 | GET | /orders/{orderId}/shipper | 송하인 정보 조회 | Y | AUTH | 2 |
| API-O07 | PUT | /orders/{orderId}/shipper | 송하인 정보 수정 | Y | SELF | 2 |
| API-O08 | GET | /orders/{orderId}/consignee | 수하인 정보 조회 | Y | AUTH | 2 |
| API-O09 | PUT | /orders/{orderId}/consignee | 수하인 정보 수정 | Y | SELF | 2 |
| API-O10 | GET | /orders/{orderId}/cargo | 화물 정보 조회 | Y | AUTH | 2 |
| API-O11 | PUT | /orders/{orderId}/cargo | 화물 정보 수정 | Y | SELF | 2 |
| API-O12 | POST | /orders/{orderId}/services | 서비스 추가 | Y | SELF | 2 |
| API-O13 | GET | /orders/{orderId}/services | 서비스 목록 | Y | AUTH | 2 |
| API-O14 | PUT | /orders/{orderId}/services/{serviceId} | 서비스 수정 | Y | SELF | 2 |
| API-O15 | DELETE | /orders/{orderId}/services/{serviceId} | 서비스 삭제 | Y | SELF | 2 |

> **제한**: 창고 입고(WAREHOUSED) 이후 수정/삭제 불가

---

## 7-1. 기초정보관리 — 운임요율 (FARE-RATE)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-FR01 | GET | /fare-rates/individual | 개인회원 등급별 운임요율 목록 | Y | ADMIN/OPR | 1 |
| API-FR02 | POST | /fare-rates/individual | 개인회원 운임요율 등록 | Y | ADMIN | 1 |
| API-FR03 | PUT | /fare-rates/individual/{rateId} | 개인회원 운임요율 수정 | Y | ADMIN | 1 |
| API-FR04 | DELETE | /fare-rates/individual/{rateId} | 개인회원 운임요율 삭제 | Y | ADMIN | 1 |
| API-FR05 | GET | /fare-rates/corporate | 법인회원별 운임요율 목록 | Y | ADMIN/OPR | 1 |
| API-FR06 | POST | /fare-rates/corporate | 법인회원 운임요율 등록 | Y | ADMIN | 1 |
| API-FR07 | PUT | /fare-rates/corporate/{rateId} | 법인회원 운임요율 수정 | Y | ADMIN | 1 |
| API-FR08 | DELETE | /fare-rates/corporate/{rateId} | 법인회원 운임요율 삭제 | Y | ADMIN | 1 |

---

## 7-2. 기초정보관리 — 환율 (EXCHANGE-RATE)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-EX01 | GET | /exchange-rates | 환율 조회 | Y | AUTH | 1 |
| API-EX02 | POST | /exchange-rates/sync | 환율 연계 (서울외국환중개소) | Y | ADMIN | 1 |

---

## 7-3. 기초정보관리 — 항공운송수단 (AIR-TRANSPORT)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-AT01 | GET | /transports/air | 항공운송수단 목록 | Y | ADMIN/OPR | 1 |
| API-AT02 | POST | /transports/air | 항공운송수단 등록 | Y | ADMIN | 1 |
| API-AT03 | PUT | /transports/air/{transportId} | 항공운송수단 수정 | Y | ADMIN | 1 |
| API-AT04 | DELETE | /transports/air/{transportId} | 항공운송수단 삭제 | Y | ADMIN | 1 |
| API-AT05 | GET | /transports/air/{transportId}/costs | 항공 운송원가 조회 | Y | ADMIN/OPR | 1 |
| API-AT06 | POST | /transports/air/{transportId}/costs | 항공 운송원가 등록 | Y | ADMIN | 1 |
| API-AT07 | PUT | /transports/air/{transportId}/costs/{costId} | 항공 운송원가 수정 | Y | ADMIN | 1 |

---

## 7-4. 기초정보관리 — 해운운송수단 (SEA-TRANSPORT)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-ST01 | GET | /transports/sea | 해운운송수단 목록 | Y | ADMIN/OPR | 1 |
| API-ST02 | POST | /transports/sea | 해운운송수단 등록 | Y | ADMIN | 1 |
| API-ST03 | PUT | /transports/sea/{transportId} | 해운운송수단 수정 | Y | ADMIN | 1 |
| API-ST04 | DELETE | /transports/sea/{transportId} | 해운운송수단 삭제 | Y | ADMIN | 1 |
| API-ST05 | GET | /transports/sea/{transportId}/costs | 해운 운송원가 조회 | Y | ADMIN/OPR | 1 |
| API-ST06 | POST | /transports/sea/{transportId}/costs | 해운 운송원가 등록 | Y | ADMIN | 1 |
| API-ST07 | PUT | /transports/sea/{transportId}/costs/{costId} | 해운 운송원가 수정 | Y | ADMIN | 1 |

---

## 7-5. 기초정보관리 — 통관사 (CUSTOMS-BROKER)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-CB01 | GET | /customs-brokers | 통관사 목록 | Y | ADMIN/OPR | 1 |
| API-CB02 | POST | /customs-brokers | 통관사 등록 | Y | ADMIN | 1 |
| API-CB03 | PUT | /customs-brokers/{brokerId} | 통관사 수정 | Y | ADMIN | 1 |
| API-CB04 | DELETE | /customs-brokers/{brokerId} | 통관사 삭제 | Y | ADMIN | 1 |
| API-CB05 | GET | /customs-brokers/{brokerId}/costs | 통관원가 조회 | Y | ADMIN/OPR | 1 |
| API-CB06 | POST | /customs-brokers/{brokerId}/costs | 통관원가 등록 | Y | ADMIN | 1 |
| API-CB07 | PUT | /customs-brokers/{brokerId}/costs/{costId} | 통관원가 수정 | Y | ADMIN | 1 |

---

## 7-6. 기초정보관리 — 택배사 배송장 (COURIER-WAYBILL)

> 택배사 기본 CRUD는 기존 API-R17~R20 참조. 아래는 배송장 관리 추가 API.

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-CW01 | GET | /codes/couriers/{courierId}/waybills | 택배배송장 목록 | Y | ADMIN/OPR | 1 |
| API-CW02 | POST | /codes/couriers/{courierId}/waybills | 택배배송장 등록 | Y | ADMIN | 1 |
| API-CW03 | PUT | /codes/couriers/{courierId}/waybills/{waybillId} | 택배배송장 수정 | Y | ADMIN | 1 |
| API-CW04 | DELETE | /codes/couriers/{courierId}/waybills/{waybillId} | 택배배송장 삭제 | Y | ADMIN | 1 |

---

## 7-7. 선불금 관리 (PREPAID)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-PP01 | GET | /prepaid/balance | 선불금 잔액 조회 (본인) | Y | AUTH | 1 |
| API-PP02 | POST | /prepaid/charge-request | 선불금 충전 요청 | Y | AUTH | 1 |
| API-PP03 | PATCH | /prepaid/charge-requests/{requestId}/confirm | 충전 확인 (관리자) | Y | ADMIN/OPR | 1 |
| API-PP04 | POST | /prepaid/refund-request | 환불 요청 | Y | AUTH | 1 |
| API-PP05 | GET | /prepaid/admin/balances | 전체 선불금 잔액 조회 (관리자) | Y | ADMIN/OPR | 1 |

---

## 8. 마스터오더 (MASTER-ORDER)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-MO01 | POST | /master-orders | 마스터오더 생성 (오더 패킹) | Y | ADMIN/OPR | 2 |
| API-MO02 | GET | /master-orders | 마스터오더 목록 | Y | ADMIN/OPR | 2 |
| API-MO03 | GET | /master-orders/{masterOrderId} | 마스터오더 상세 | Y | ADMIN/OPR | 2 |
| API-MO04 | PUT | /master-orders/{masterOrderId} | 마스터오더 수정 | Y | ADMIN/OPR | 2 |
| API-MO05 | DELETE | /master-orders/{masterOrderId} | 마스터오더 삭제 | Y | ADMIN | 2 |
| API-MO06 | GET | /master-orders/{masterOrderId}/schedules | 운항 스케줄 조회 | Y | ADMIN/OPR | 2 |
| API-MO07 | POST | /master-orders/{masterOrderId}/schedules | 운항 스케줄 등록 | Y | ADMIN/OPR | 2 |
| API-MO08 | PUT | /master-orders/{masterOrderId}/schedules/{scheduleId} | 운항 스케줄 수정 | Y | ADMIN/OPR | 2 |

---

## 9. 창고 (WAREHOUSE)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-W01 | POST | /warehouse/receipts | 입고 등록 | Y | ADMIN/OPR | 2 |
| API-W02 | GET | /warehouse/receipts | 입고 목록 | Y | ADMIN/OPR | 2 |
| API-W03 | GET | /warehouse/receipts/{receiptId} | 입고 상세 | Y | ADMIN/OPR | 2 |
| API-W04 | POST | /warehouse/releases | 출고 등록 | Y | ADMIN/OPR | 2 |
| API-W05 | GET | /warehouse/releases | 출고 목록 | Y | ADMIN/OPR | 2 |
| API-W06 | GET | /warehouse/releases/{releaseId} | 출고 상세 | Y | ADMIN/OPR | 2 |
| API-W07 | GET | /warehouse/barcode/{barcode} | 바코드 스캔 조회 | Y | ADMIN/OPR | 2 |

---

## 10. 운송 Tracking

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-T01 | POST | /tracking | 트래킹 정보 등록 | Y | ADMIN/OPR | 3 |
| API-T02 | GET | /tracking/{masterOrderId} | 트래킹 이력 조회 | Y | AUTH | 3 |
| API-T03 | PUT | /tracking/{trackingId} | 트래킹 상태 수정 | Y | ADMIN/OPR | 3 |
| API-T04 | POST | /tracking/customs | 통관신고 등록 | Y | ADMIN/OPR | 3 |
| API-T05 | GET | /tracking/customs/{masterOrderId} | 통관신고 조회 | Y | AUTH | 3 |
| API-T06 | PUT | /tracking/customs/{declarationId} | 통관신고 수정 | Y | ADMIN/OPR | 3 |

---

## 11. 회계/청구 (BILLING)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-B01 | POST | /billing/invoices | 청구서 생성 | Y | ADMIN/OPR | 3 |
| API-B02 | GET | /billing/invoices | 청구서 목록 | Y | AUTH | 3 |
| API-B03 | GET | /billing/invoices/{invoiceId} | 청구서 상세 | Y | AUTH | 3 |
| API-B04 | PUT | /billing/invoices/{invoiceId} | 청구서 수정 | Y | ADMIN/OPR | 3 |
| API-B05 | PATCH | /billing/invoices/{invoiceId}/confirm | 청구서 확정 | Y | ADMIN/OPR | 3 |
| API-B06 | GET | /billing/invoices/{invoiceId}/items | 청구 항목 목록 | Y | AUTH | 3 |
| API-B07 | POST | /billing/invoices/{invoiceId}/items | 청구 항목 추가 | Y | ADMIN/OPR | 3 |
| API-B08 | PUT | /billing/invoices/{invoiceId}/items/{itemId} | 청구 항목 수정 | Y | ADMIN/OPR | 3 |
| API-B09 | DELETE | /billing/invoices/{invoiceId}/items/{itemId} | 청구 항목 삭제 | Y | ADMIN/OPR | 3 |
| API-B10 | POST | /billing/payments | 입금 등록 | Y | ADMIN/OPR | 3 |
| API-B11 | GET | /billing/payments | 입금 목록 | Y | ADMIN/OPR | 3 |
| API-B12 | GET | /billing/payments/{paymentId} | 입금 상세 | Y | ADMIN/OPR | 3 |

---

## 12. 원가 (COST)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-C01 | GET | /costs/transport-masters | 운송원가 목록 | Y | ADMIN/OPR | 3 |
| API-C02 | POST | /costs/transport-masters | 운송원가 등록 | Y | ADMIN | 3 |
| API-C03 | GET | /costs/transport-masters/{costId} | 운송원가 상세 | Y | ADMIN/OPR | 3 |
| API-C04 | PUT | /costs/transport-masters/{costId} | 운송원가 수정 | Y | ADMIN | 3 |
| API-C05 | DELETE | /costs/transport-masters/{costId} | 운송원가 삭제 | Y | ADMIN | 3 |
| API-C06 | GET | /costs/discounts | 할인율 목록 | Y | ADMIN/OPR | 3 |
| API-C07 | POST | /costs/discounts | 할인율 등록 | Y | ADMIN | 3 |
| API-C08 | PUT | /costs/discounts/{discountId} | 할인율 수정 | Y | ADMIN | 3 |
| API-C09 | DELETE | /costs/discounts/{discountId} | 할인율 삭제 | Y | ADMIN | 3 |
| API-C10 | POST | /costs/calculate | 운송비 계산 (미리보기) | Y | AUTH | 3 |

---

## 13. 알림 (NOTIFICATION)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-N01 | GET | /notifications | 알림 목록 | Y | AUTH | 4 |
| API-N02 | PATCH | /notifications/{notificationId}/read | 알림 읽음 처리 | Y | SELF | 4 |
| API-N03 | PATCH | /notifications/read-all | 전체 알림 읽음 처리 | Y | AUTH | 4 |
| API-N04 | DELETE | /notifications/{notificationId} | 알림 삭제 | Y | SELF | 4 |

---

## 14. VOC

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-V01 | POST | /voc | VOC 등록 | Y | AUTH | 3 |
| API-V02 | GET | /voc | VOC 목록 | Y | AUTH | 3 |
| API-V03 | GET | /voc/{vocId} | VOC 상세 | Y | AUTH | 3 |
| API-V04 | PUT | /voc/{vocId} | VOC 수정 | Y | SELF | 3 |
| API-V05 | PATCH | /voc/{vocId}/status | VOC 상태 변경 | Y | ADMIN/OPR | 3 |
| API-V06 | DELETE | /voc/{vocId} | VOC 삭제 | Y | SELF | 3 |

---

## 15. 시스템관리 (SYSTEM)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-S01 | GET | /system/menus | 메뉴 목록 | Y | ADMIN | 4 |
| API-S02 | POST | /system/menus | 메뉴 등록 | Y | ADMIN | 4 |
| API-S03 | PUT | /system/menus/{menuId} | 메뉴 수정 | Y | ADMIN | 4 |
| API-S04 | DELETE | /system/menus/{menuId} | 메뉴 삭제 | Y | ADMIN | 4 |
| API-S05 | GET | /system/roles | 역할 목록 | Y | ADMIN | 4 |
| API-S06 | POST | /system/roles | 역할 등록 | Y | ADMIN | 4 |
| API-S07 | PUT | /system/roles/{roleId} | 역할 수정 | Y | ADMIN | 4 |
| API-S08 | DELETE | /system/roles/{roleId} | 역할 삭제 | Y | ADMIN | 4 |
| API-S09 | POST | /system/menu-roles | 메뉴-역할 매핑 등록 | Y | ADMIN | 4 |
| API-S10 | DELETE | /system/menu-roles/{menuRoleId} | 메뉴-역할 매핑 삭제 | Y | ADMIN | 4 |
| API-S11 | GET | /system/code-groups | 코드그룹 목록 | Y | ADMIN/OPR | 4 |
| API-S12 | POST | /system/code-groups | 코드그룹 등록 | Y | ADMIN | 4 |
| API-S13 | PUT | /system/code-groups/{groupId} | 코드그룹 수정 | Y | ADMIN | 4 |
| API-S14 | GET | /system/codes | 공통코드 목록 | Y | AUTH | 4 |
| API-S15 | POST | /system/codes | 공통코드 등록 | Y | ADMIN | 4 |
| API-S16 | PUT | /system/codes/{codeId} | 공통코드 수정 | Y | ADMIN | 4 |
| API-S17 | DELETE | /system/codes/{codeId} | 공통코드 삭제 | Y | ADMIN | 4 |

---

## 16. 기준코드 (CODE)

| API ID | Method | URL | 기능명 | 인증 | 권한 | Phase |
|---|---|---|---|---|---|---|
| API-R01 | GET | /codes/countries | 국가코드 목록 | Y | AUTH | 1 |
| API-R02 | POST | /codes/countries | 국가코드 등록 | Y | ADMIN | 1 |
| API-R03 | PUT | /codes/countries/{id} | 국가코드 수정 | Y | ADMIN | 1 |
| API-R04 | DELETE | /codes/countries/{id} | 국가코드 삭제 | Y | ADMIN | 1 |
| API-R05 | GET | /codes/airports | 공항코드 목록 | Y | AUTH | 1 |
| API-R06 | POST | /codes/airports | 공항코드 등록 | Y | ADMIN | 1 |
| API-R07 | PUT | /codes/airports/{id} | 공항코드 수정 | Y | ADMIN | 1 |
| API-R08 | DELETE | /codes/airports/{id} | 공항코드 삭제 | Y | ADMIN | 1 |
| API-R09 | GET | /codes/ports | 항구코드 목록 | Y | AUTH | 1 |
| API-R10 | POST | /codes/ports | 항구코드 등록 | Y | ADMIN | 1 |
| API-R11 | PUT | /codes/ports/{id} | 항구코드 수정 | Y | ADMIN | 1 |
| API-R12 | DELETE | /codes/ports/{id} | 항구코드 삭제 | Y | ADMIN | 1 |
| API-R13 | GET | /codes/airlines | 항공사코드 목록 | Y | AUTH | 1 |
| API-R14 | POST | /codes/airlines | 항공사코드 등록 | Y | ADMIN | 1 |
| API-R15 | PUT | /codes/airlines/{id} | 항공사코드 수정 | Y | ADMIN | 1 |
| API-R16 | DELETE | /codes/airlines/{id} | 항공사코드 삭제 | Y | ADMIN | 1 |
| API-R17 | GET | /codes/couriers | 택배사 목록 | Y | AUTH | 1 |
| API-R18 | POST | /codes/couriers | 택배사 등록 | Y | ADMIN | 1 |
| API-R19 | PUT | /codes/couriers/{id} | 택배사 수정 | Y | ADMIN | 1 |
| API-R20 | DELETE | /codes/couriers/{id} | 택배사 삭제 | Y | ADMIN | 1 |

---

## 공통 응답 스키마

### 성공 응답
```json
{
  "success": true,
  "data": { },
  "message": "성공"
}
```

### 에러 응답
```json
{
  "success": false,
  "data": null,
  "message": "회원 정보를 찾을 수 없습니다.",
  "errorCode": "MEMBER_NOT_FOUND"
}
```

### 목록 응답 (페이징)
```json
{
  "success": true,
  "data": {
    "content": [],
    "totalElements": 100,
    "totalPages": 10,
    "size": 10,
    "number": 0,
    "first": true,
    "last": false
  },
  "message": "성공"
}
```

---

## 공통 에러 코드

| ErrorCode | HTTP Status | 메시지 |
|---|---|---|
| UNAUTHORIZED | 401 | 인증이 필요합니다 |
| FORBIDDEN | 403 | 접근 권한이 없습니다 |
| NOT_FOUND | 404 | 리소스를 찾을 수 없습니다 |
| INVALID_INPUT | 400 | 입력값이 올바르지 않습니다 |
| DUPLICATE_LOGIN_ID | 409 | 이미 사용 중인 아이디입니다 |
| TOKEN_EXPIRED | 401 | 토큰이 만료되었습니다 |
| TOKEN_INVALID | 401 | 유효하지 않은 토큰입니다 |
| MEMBER_NOT_FOUND | 404 | 회원 정보를 찾을 수 없습니다 |
| ORDER_NOT_FOUND | 404 | 오더 정보를 찾을 수 없습니다 |
| ORDER_ALREADY_WAREHOUSED | 409 | 입고된 오더는 수정/삭제할 수 없습니다 |
| CORPORATE_NOT_APPROVED | 403 | 승인되지 않은 법인 회원입니다 |
| PASSWORD_MISMATCH | 400 | 비밀번호가 일치하지 않습니다 |
| ACCOUNT_LOCKED | 423 | 계정이 잠겨 있습니다 (5회 실패 후 30분 잠금) |
| SMS_CODE_EXPIRED | 400 | SMS 인증번호가 만료되었습니다 (3분) |
| SMS_CODE_INVALID | 400 | SMS 인증번호가 올바르지 않습니다 |
| INVOICE_ALREADY_CONFIRMED | 409 | 이미 확정된 청구서입니다 |
| INTERNAL_SERVER_ERROR | 500 | 서버 내부 오류가 발생했습니다 |
