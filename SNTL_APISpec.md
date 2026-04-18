# SNTL 통합 물류 플랫폼 — API 정의서

> Base URL: `http://localhost:8080/api/v1` | 최종 업데이트: 2026-04-18

---

## 공통 헤더

| 헤더 | 필수 | 설명 |
|---|---|---|
| Authorization | 인증 필요 API | `Bearer {access_token}` |
| Content-Type | Y (POST/PUT) | `application/json` |
| Accept | N | `application/json` |

---

# 1. 인증 (AUTH)

---

## API-A01 · 로그인

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/auth/login` |
| 인증 | 불필요 |
| 설명 | 아이디/비밀번호로 로그인. Access Token(30분) + Refresh Token(7일) 발급 |

**Request Body**
```json
{
  "loginId": "user123",
  "password": "P@ssw0rd!"
}
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| loginId | String | Y | 로그인 ID |
| password | String | Y | 비밀번호 |

**Response 200**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzUx...",
    "refreshToken": "eyJhbGciOiJIUzUx...",
    "tokenType": "Bearer",
    "expiresIn": 1800,
    "memberType": "INDIVIDUAL",
    "memberId": 1,
    "loginId": "user123",
    "name": "홍길동",
    "role": "INDIVIDUAL"
  },
  "message": "로그인 성공"
}
```

**에러 코드**

| ErrorCode | HTTP | 설명 |
|---|---|---|
| INVALID_INPUT | 400 | 필수 필드 누락 |
| MEMBER_NOT_FOUND | 404 | 존재하지 않는 아이디 |
| PASSWORD_MISMATCH | 400 | 비밀번호 불일치 |
| ACCOUNT_LOCKED | 423 | 5회 실패 → 30분 잠금 |

---

## API-A02 · 로그아웃

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/auth/logout` |
| 인증 | Bearer Token |
| 설명 | Redis에서 Refresh Token 삭제, Access Token 블랙리스트 등록 |

**Request Body** — 없음

**Response 200**
```json
{
  "success": true,
  "data": null,
  "message": "로그아웃 되었습니다"
}
```

---

## API-A03 · Access Token 갱신

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/auth/token/refresh` |
| 인증 | 불필요 |
| 설명 | Refresh Token으로 새 Access Token 발급 |

**Request Body**
```json
{
  "refreshToken": "eyJhbGciOiJIUzUx..."
}
```

**Response 200**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzUx...",
    "expiresIn": 1800
  },
  "message": "토큰이 갱신되었습니다"
}
```

**에러 코드**

| ErrorCode | HTTP | 설명 |
|---|---|---|
| TOKEN_EXPIRED | 401 | Refresh Token 만료 (7일 초과) |
| TOKEN_INVALID | 401 | 유효하지 않은 토큰 |

---

## API-A04 · SMS 인증번호 발송

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/auth/sms/send` |
| 인증 | 불필요 |
| 설명 | 6자리 인증번호 생성 후 SMS 발송. 유효시간 3분 |

**Request Body**
```json
{
  "phone": "01012345678",
  "purpose": "SIGNUP"
}
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| phone | String | Y | 휴대폰번호 (숫자만) |
| purpose | String | Y | 용도: SIGNUP / PASSWORD_RESET / ID_FIND |

**Response 200**
```json
{
  "success": true,
  "data": { "sessionKey": "sms-uuid-abc123" },
  "message": "인증번호가 발송되었습니다"
}
```

---

## API-A05 · SMS 인증번호 확인

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/auth/sms/verify` |
| 인증 | 불필요 |
| 설명 | 발송된 인증번호 검증 |

**Request Body**
```json
{
  "sessionKey": "sms-uuid-abc123",
  "code": "123456"
}
```

**Response 200**
```json
{
  "success": true,
  "data": { "verified": true, "verifyToken": "vt-uuid-xyz789" },
  "message": "인증이 완료되었습니다"
}
```

**에러 코드**

| ErrorCode | HTTP | 설명 |
|---|---|---|
| SMS_CODE_EXPIRED | 400 | 인증번호 만료 (3분 초과) |
| SMS_CODE_INVALID | 400 | 인증번호 불일치 |

---

## API-A06 · 비밀번호 재설정 요청

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/auth/password/reset-request` |
| 인증 | 불필요 |
| 설명 | 본인 확인 후 비밀번호 재설정 토큰 발급 |

**Request Body**
```json
{
  "loginId": "user123",
  "verifyToken": "vt-uuid-xyz789"
}
```

**Response 200**
```json
{
  "success": true,
  "data": { "resetToken": "rt-uuid-abc456" },
  "message": "비밀번호 재설정을 진행하세요"
}
```

---

## API-A07 · 비밀번호 재설정

| 항목 | 내용 |
|---|---|
| Method | PUT |
| URL | `/auth/password/reset` |
| 인증 | 불필요 |
| 설명 | 새 비밀번호로 변경 (영문+숫자+특수문자 8자 이상) |

**Request Body**
```json
{
  "resetToken": "rt-uuid-abc456",
  "newPassword": "NewP@ssw0rd!",
  "newPasswordConfirm": "NewP@ssw0rd!"
}
```

**Response 200**
```json
{
  "success": true,
  "data": null,
  "message": "비밀번호가 변경되었습니다"
}
```

---

# 2. 회원 — 개인회원 (MEMBER-IND)

---

## API-M01 · 개인회원 가입

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/members/individual` |
| 인증 | 불필요 |
| 설명 | SMS 인증 완료 후 개인회원 계정 생성 |

**Request Body**
```json
{
  "loginId": "user123",
  "password": "P@ssw0rd!",
  "name": "홍길동",
  "birthDate": "1990-01-15",
  "phone": "01012345678",
  "email": "hong@example.com",
  "zipcode": "06134",
  "address": "서울특별시 강남구 테헤란로",
  "addressDetail": "101호",
  "verifyToken": "vt-uuid-xyz789"
}
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| loginId | String | Y | 로그인 ID (4~50자, 영문+숫자) |
| password | String | Y | 비밀번호 (8자 이상, 영문+숫자+특수문자) |
| name | String | N | 이름 |
| birthDate | String | N | 생년월일 (yyyy-MM-dd) |
| phone | String | N | 휴대폰번호 |
| email | String | N | 이메일 |
| zipcode | String | N | 우편번호 |
| address | String | N | 주소 |
| addressDetail | String | N | 상세주소 |
| verifyToken | String | Y | SMS 인증 완료 토큰 |

**Response 201**
```json
{
  "success": true,
  "data": {
    "memberId": 1,
    "loginId": "user123",
    "name": "홍길동",
    "grade": "BASIC",
    "status": "ACTIVE",
    "createdAt": "2026-04-16T10:00:00"
  },
  "message": "회원가입이 완료되었습니다"
}
```

**에러 코드**

| ErrorCode | HTTP | 설명 |
|---|---|---|
| DUPLICATE_LOGIN_ID | 409 | 이미 사용 중인 아이디 |
| INVALID_INPUT | 400 | 필수 값 누락 또는 형식 오류 |
| SMS_CODE_EXPIRED | 400 | SMS 인증 토큰 만료 |

---

## API-M02 · 개인회원 목록

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/members/individual` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---|---|---|---|
| page | int | N | 페이지 번호 (0-based, 기본값 0) |
| size | int | N | 페이지 크기 (기본값 20) |
| sort | String | N | 정렬 (예: createdAt,desc) |
| keyword | String | N | 검색어 (이름, 로그인ID, 이메일) |
| status | String | N | 상태 필터 (ACTIVE/INACTIVE/WITHDRAWN) |

**Response 200**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "memberId": 1,
        "loginId": "user123",
        "name": "홍길동",
        "phone": "01012345678",
        "email": "hong@example.com",
        "grade": "BASIC",
        "status": "ACTIVE",
        "createdAt": "2026-04-16T10:00:00"
      }
    ],
    "totalElements": 50,
    "totalPages": 3,
    "size": 20,
    "number": 0
  },
  "message": "성공"
}
```

---

## API-M03 · 개인회원 상세 조회

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/members/individual/{memberId}` |
| 인증 | Bearer Token |
| 권한 | 본인 또는 ADMIN |

**Path Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---|---|---|---|
| memberId | Long | Y | 개인회원 ID |

**Response 200**
```json
{
  "success": true,
  "data": {
    "memberId": 1,
    "loginId": "user123",
    "name": "홍길동",
    "birthDate": "1990-01-15",
    "phone": "01012345678",
    "email": "hong@example.com",
    "zipcode": "06134",
    "address": "서울특별시 강남구 테헤란로",
    "addressDetail": "101호",
    "grade": "BASIC",
    "balance": 0.00,
    "status": "ACTIVE",
    "createdAt": "2026-04-16T10:00:00",
    "updatedAt": "2026-04-16T10:00:00"
  },
  "message": "성공"
}
```

---

## API-M04 · 개인회원 정보 수정

| 항목 | 내용 |
|---|---|
| Method | PUT |
| URL | `/members/individual/{memberId}` |
| 인증 | Bearer Token |
| 권한 | 본인 또는 ADMIN |
| 설명 | loginId 변경 불가. 비밀번호 변경 시 currentPassword 필수 |

**Request Body**
```json
{
  "name": "홍길동",
  "birthDate": "1990-01-15",
  "phone": "01098765432",
  "email": "new@example.com",
  "zipcode": "06134",
  "address": "서울특별시 강남구 테헤란로",
  "addressDetail": "202호",
  "currentPassword": "P@ssw0rd!",
  "newPassword": "NewP@ssw0rd!"
}
```

**Response 200**
```json
{
  "success": true,
  "data": { "memberId": 1, "updatedAt": "2026-04-16T11:00:00" },
  "message": "회원 정보가 수정되었습니다"
}
```

---

## API-M05 · 개인회원 탈퇴

| 항목 | 내용 |
|---|---|
| Method | DELETE |
| URL | `/members/individual/{memberId}` |
| 인증 | Bearer Token |
| 권한 | 본인 또는 ADMIN |
| 설명 | Soft Delete — 개인정보(name, phone, email 등) NULL 처리, id/login_id 보존, status → WITHDRAWN |

**Request Body**
```json
{
  "password": "P@ssw0rd!",
  "reason": "서비스 이용 종료"
}
```

**Response 200**
```json
{
  "success": true,
  "data": null,
  "message": "탈퇴 처리가 완료되었습니다"
}
```

---

# 3. 회원 — 법인회원 (MEMBER-CORP)

---

## API-M06 · 법인회원 가입 신청

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/members/corporate` |
| 인증 | 불필요 |
| 설명 | 법인 정보 입력 후 심사 신청. 초기 approval_status = PENDING, status = INACTIVE |

**Request Body**
```json
{
  "loginId": "corp_abc",
  "password": "P@ssw0rd!",
  "corpName": "(주)ABC물류",
  "ceoName": "김대표",
  "businessNumber": "123-45-67890",
  "phone": "0212345678",
  "email": "contact@abc.com",
  "zipcode": "06134",
  "address": "서울특별시 강남구",
  "addressDetail": "ABC빌딩 5층"
}
```

**Response 201**
```json
{
  "success": true,
  "data": {
    "corporateId": 1,
    "loginId": "corp_abc",
    "corpName": "(주)ABC물류",
    "approvalStatus": "PENDING",
    "status": "INACTIVE",
    "createdAt": "2026-04-16T10:00:00"
  },
  "message": "법인 가입 신청이 완료되었습니다. 심사 후 승인 알림을 드립니다"
}
```

---

## API-M07 · 법인회원 목록

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/members/corporate` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---|---|---|---|
| page | int | N | 페이지 번호 |
| size | int | N | 페이지 크기 |
| approvalStatus | String | N | PENDING / APPROVED / REJECTED |
| status | String | N | ACTIVE / INACTIVE / WITHDRAWN |
| keyword | String | N | 법인명, 사업자번호 검색 |

**Response 200** — 페이징 목록 (개인회원 목록 구조 동일)

---

## API-M08 · 법인회원 상세 조회

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/members/corporate/{corporateId}` |
| 인증 | Bearer Token |
| 권한 | 본인(법인관리자/담당자) 또는 ADMIN/OPERATOR |

**Response 200**
```json
{
  "success": true,
  "data": {
    "corporateId": 1,
    "loginId": "corp_abc",
    "corpName": "(주)ABC물류",
    "ceoName": "김대표",
    "businessNumber": "123-45-67890",
    "phone": "0212345678",
    "email": "contact@abc.com",
    "zipcode": "06134",
    "address": "서울특별시 강남구",
    "addressDetail": "ABC빌딩 5층",
    "approvalStatus": "APPROVED",
    "status": "ACTIVE",
    "createdAt": "2026-04-16T10:00:00",
    "updatedAt": "2026-04-16T10:00:00"
  },
  "message": "성공"
}
```

---

## API-M11 · 법인 심사 승인

| 항목 | 내용 |
|---|---|
| Method | PATCH |
| URL | `/members/corporate/{corporateId}/approve` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | approval_status → APPROVED, status → ACTIVE. 승인 알림 발송 |

**Request Body**
```json
{
  "memo": "서류 확인 완료"
}
```

**Response 200**
```json
{
  "success": true,
  "data": {
    "corporateId": 1,
    "approvalStatus": "APPROVED",
    "status": "ACTIVE"
  },
  "message": "법인 회원이 승인되었습니다"
}
```

---

## API-M12 · 법인 심사 거부

| 항목 | 내용 |
|---|---|
| Method | PATCH |
| URL | `/members/corporate/{corporateId}/reject` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | approval_status → REJECTED. 거부 사유 포함 알림 발송 |

**Request Body**
```json
{
  "rejectReason": "사업자등록증 정보 불일치"
}
```

**Response 200**
```json
{
  "success": true,
  "data": {
    "corporateId": 1,
    "approvalStatus": "REJECTED"
  },
  "message": "법인 가입 신청이 거부되었습니다"
}
```

---

## API-M13 · 첨부파일 업로드

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/members/corporate/{corporateId}/attachments` |
| 인증 | Bearer Token |
| 권한 | 법인관리자, ADMIN |
| Content-Type | multipart/form-data |
| 설명 | 사업자등록증 등 파일 업로드 → MinIO 저장 |

**Form Data**

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| file | MultipartFile | Y | 업로드 파일 (최대 10MB, PDF/JPG/PNG) |
| fileType | String | Y | 파일 유형 (BUSINESS_LICENSE / OTHER) |

**Response 201**
```json
{
  "success": true,
  "data": {
    "attachmentId": 1,
    "fileName": "사업자등록증.pdf",
    "fileType": "BUSINESS_LICENSE",
    "fileSize": 204800,
    "fileUrl": "/api/v1/members/corporate/1/attachments/1/download",
    "uploadedAt": "2026-04-16T10:00:00"
  },
  "message": "파일이 업로드되었습니다"
}
```

---

# 4. 오더 (ORDER)

---

## API-O01 · 오더 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/orders` |
| 인증 | Bearer Token |
| 권한 | 인증된 모든 사용자 |
| 설명 | 오더 + 송하인 + 수하인 + 화물 정보 통합 등록. 오더번호 자동 생성 (ORD-YYYYMMDD-NNNNN) |

**Request Body**
```json
{
  "shipper": {
    "name": "홍길동",
    "phone": "01012345678",
    "email": "hong@example.com",
    "country": "KR",
    "zipcode": "06134",
    "address": "서울특별시 강남구",
    "addressDetail": "101호"
  },
  "consignee": {
    "name": "John Doe",
    "phone": "+1-202-555-0123",
    "email": "john@example.com",
    "country": "US",
    "zipcode": "10001",
    "address": "123 Main St",
    "addressDetail": "Apt 4B",
    "city": "New York",
    "state": "NY"
  },
  "cargo": {
    "cargoName": "전자부품",
    "hsCode": "8542.31",
    "quantity": 10,
    "totalWeight": 25.5,
    "volumeLength": 30.0,
    "volumeWidth": 20.0,
    "volumeHeight": 15.0,
    "declaredValue": 500000.00,
    "currency": "KRW",
    "specialInstruction": "파손주의"
  },
  "remark": "긴급 발송"
}
```

**Response 201**
```json
{
  "success": true,
  "data": {
    "orderId": 1,
    "orderNo": "ORD-20260416-00001",
    "orderStatus": "REGISTERED",
    "createdAt": "2026-04-16T10:00:00"
  },
  "message": "오더가 등록되었습니다"
}
```

**에러 코드**

| ErrorCode | HTTP | 설명 |
|---|---|---|
| INVALID_INPUT | 400 | 필수 필드 누락 |
| CORPORATE_NOT_APPROVED | 403 | 미승인 법인 회원 |

---

## API-O02 · 오더 목록

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/orders` |
| 인증 | Bearer Token |
| 설명 | 일반 사용자는 본인 오더만, ADMIN/OPERATOR는 전체 조회 |

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---|---|---|---|
| page | int | N | 페이지 번호 |
| size | int | N | 페이지 크기 |
| orderStatus | String | N | REGISTERED / PACKED / WAREHOUSED / RELEASED / DELIVERED |
| startDate | String | N | 검색 시작일 (yyyy-MM-dd) |
| endDate | String | N | 검색 종료일 (yyyy-MM-dd) |
| keyword | String | N | 오더번호, 화물명 검색 |

**Response 200** — 페이징 목록

---

## API-O03 · 오더 상세

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/orders/{orderId}` |
| 인증 | Bearer Token |

**Response 200**
```json
{
  "success": true,
  "data": {
    "orderId": 1,
    "orderNo": "ORD-20260416-00001",
    "orderStatus": "REGISTERED",
    "memberId": 1,
    "memberName": "홍길동",
    "shipper": { "name": "홍길동", "phone": "01012345678", "country": "KR" },
    "consignee": { "name": "John Doe", "phone": "+1-202-555-0123", "country": "US" },
    "cargo": {
      "cargoName": "전자부품",
      "hsCode": "8542.31",
      "quantity": 10,
      "totalWeight": 25.5,
      "cbm": 0.009,
      "declaredValue": 500000.00,
      "currency": "KRW"
    },
    "services": [],
    "remark": "긴급 발송",
    "createdAt": "2026-04-16T10:00:00",
    "updatedAt": "2026-04-16T10:00:00"
  },
  "message": "성공"
}
```

---

## API-O04 · 오더 수정

| 항목 | 내용 |
|---|---|
| Method | PUT |
| URL | `/orders/{orderId}` |
| 인증 | Bearer Token |
| 권한 | 본인 또는 ADMIN |
| **제한** | orderStatus가 WAREHOUSED 이상이면 수정 불가 |

**Request Body** — 오더 등록과 동일 구조

**에러 코드**

| ErrorCode | HTTP | 설명 |
|---|---|---|
| ORDER_ALREADY_WAREHOUSED | 409 | 입고 이후 수정 불가 |
| ORDER_NOT_FOUND | 404 | 오더 없음 |
| FORBIDDEN | 403 | 본인 오더 아님 |

---

## API-O12 · 서비스 추가

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/orders/{orderId}/services` |
| 인증 | Bearer Token |
| 설명 | AIR(항운) / SEA(해운) / CIR(택배) / CCL(통관) 서비스 유형별 세부정보 입력 |

**Request Body (AIR 예시)**
```json
{
  "serviceType": "AIR",
  "airlineId": 1,
  "originAirportId": 1,
  "destAirportId": 2,
  "departureDate": "2026-05-01",
  "arrivalDate": "2026-05-02",
  "flightNo": "KE001",
  "hawbNo": "12345678",
  "mawbNo": "180-12345678"
}
```

**Request Body (SEA 예시)**
```json
{
  "serviceType": "SEA",
  "originPortId": 1,
  "destPortId": 2,
  "departureDate": "2026-05-01",
  "arrivalDate": "2026-05-20",
  "vesselName": "EVER GIVEN",
  "voyageNo": "V001",
  "hblNo": "SNTL202604160001",
  "mblNo": "CMDU202604160001",
  "containerNo": "CMAU1234567",
  "containerType": "20GP"
}
```

**Request Body (CIR 예시)**
```json
{
  "serviceType": "CIR",
  "courierId": 1,
  "trackingNo": "1234567890",
  "deliveryAddress": "서울특별시 강남구 테헤란로 101호"
}
```

**Request Body (CCL 예시)**
```json
{
  "serviceType": "CCL",
  "customsType": "EXPORT",
  "customsOffice": "인천공항세관",
  "declarationNo": "2026-ABC-00001",
  "extraCharge": 50.0,
  "extraChargeNote": "통관 수수료"
}
```

**Response 201**
```json
{
  "success": true,
  "data": {
    "serviceId": 1,
    "orderId": 1,
    "serviceType": "AIR",
    "createdAt": "2026-04-16T10:00:00"
  },
  "message": "서비스가 추가되었습니다"
}
```

---

# 5. 마스터오더 (MASTER-ORDER)

---

## API-MO01 · 마스터오더 생성 (오더 패킹)

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/master-orders` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | 다수 오더를 패킹하여 마스터오더 생성. 마스터오더번호 자동 생성 (MO-YYYYMMDD-NNNNN) |

**Request Body**
```json
{
  "orderIds": [1, 2, 3],
  "serviceType": "AIR",
  "remark": "인천발 뉴욕행 항운 패킹"
}
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| orderIds | List\<Long\> | Y | 패킹할 오더 ID 목록 (1개 이상) |
| serviceType | String | Y | AIR / SEA / CIR / CCL |
| remark | String | N | 비고 |

**Response 201**
```json
{
  "success": true,
  "data": {
    "masterOrderId": 1,
    "masterOrderNo": "MO-20260416-00001",
    "masterOrderStatus": "CREATED",
    "serviceType": "AIR",
    "orderCount": 3,
    "createdAt": "2026-04-16T10:00:00"
  },
  "message": "마스터오더가 생성되었습니다"
}
```

---

## API-MO07 · 운항 스케줄 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/master-orders/{masterOrderId}/schedules` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |

**Request Body**
```json
{
  "departureDate": "2026-05-01T14:00:00",
  "arrivalDate": "2026-05-02T06:00:00",
  "originCode": "ICN",
  "destinationCode": "JFK",
  "carrierCode": "KE",
  "flightOrVoyageNo": "KE081",
  "mawbOrMblNo": "180-12345678"
}
```

**Response 201**
```json
{
  "success": true,
  "data": {
    "scheduleId": 1,
    "masterOrderId": 1,
    "departureDate": "2026-05-01T14:00:00",
    "arrivalDate": "2026-05-02T06:00:00"
  },
  "message": "운항 스케줄이 등록되었습니다"
}
```

---

# 6. 창고 (WAREHOUSE)

---

## API-W01 · 입고 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/warehouse/receipts` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | 바코드 스캔 또는 수동 입력으로 입고 처리. 오더 상태 → WAREHOUSED |

**Request Body**
```json
{
  "orderId": 1,
  "barcode": "SNTL-20260416-00001",
  "receivedQuantity": 10,
  "receivedWeight": 25.5,
  "warehouseLocation": "A-01-003",
  "remark": "파손 없음"
}
```

**Response 201**
```json
{
  "success": true,
  "data": {
    "receiptId": 1,
    "orderId": 1,
    "orderNo": "ORD-20260416-00001",
    "barcode": "SNTL-20260416-00001",
    "orderStatus": "WAREHOUSED",
    "receiptDate": "2026-04-16T10:00:00"
  },
  "message": "입고 처리가 완료되었습니다"
}
```

---

## API-W04 · 출고 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/warehouse/releases` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | 마스터오더 단위로 출고 처리. 오더 상태 → RELEASED |

**Request Body**
```json
{
  "masterOrderId": 1,
  "releaseType": "NORMAL",
  "remark": "정상 출고"
}
```

**Response 201**
```json
{
  "success": true,
  "data": {
    "releaseId": 1,
    "masterOrderId": 1,
    "masterOrderNo": "MO-20260416-00001",
    "masterOrderStatus": "RELEASED",
    "releaseDate": "2026-04-16T15:00:00"
  },
  "message": "출고 처리가 완료되었습니다"
}
```

---

## API-W07 · 바코드 스캔 조회

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/warehouse/barcode/{barcode}` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | 바코드로 오더 정보 즉시 조회 (입출고 전 오더 확인용) |

**Response 200**
```json
{
  "success": true,
  "data": {
    "orderId": 1,
    "orderNo": "ORD-20260416-00001",
    "barcode": "SNTL-20260416-00001",
    "orderStatus": "REGISTERED",
    "cargoName": "전자부품",
    "quantity": 10,
    "totalWeight": 25.5,
    "consigneeName": "John Doe",
    "consigneeCountry": "US"
  },
  "message": "성공"
}
```

---

# 7. 운송 Tracking

---

## API-T01 · 트래킹 정보 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/tracking` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | 마스터오더의 운송 상태 이력 등록. 갱신 임계값 30분 (중복 방지) |

**Request Body**
```json
{
  "masterOrderId": 1,
  "trackingStatus": "IN_TRANSIT",
  "location": "JFK Airport, New York",
  "statusMessage": "화물이 목적지 공항에 도착하였습니다",
  "eventTime": "2026-05-02T06:30:00",
  "source": "MANUAL"
}
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| masterOrderId | Long | Y | 마스터오더 ID |
| trackingStatus | String | Y | IN_TRANSIT / ARRIVED / CUSTOMS / DELIVERED |
| location | String | N | 현재 위치 |
| statusMessage | String | N | 상태 메시지 |
| eventTime | String | Y | 이벤트 발생 시각 |
| source | String | Y | MANUAL / API_SYNC |

**Response 201**
```json
{
  "success": true,
  "data": {
    "trackingId": 1,
    "masterOrderId": 1,
    "trackingStatus": "IN_TRANSIT",
    "eventTime": "2026-05-02T06:30:00"
  },
  "message": "트래킹 정보가 등록되었습니다"
}
```

---

## API-T02 · 트래킹 이력 조회

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/tracking/{masterOrderId}` |
| 인증 | Bearer Token |
| 설명 | 마스터오더의 전체 Tracking 이력 조회 (최신순) |

**Response 200**
```json
{
  "success": true,
  "data": {
    "masterOrderId": 1,
    "masterOrderNo": "MO-20260416-00001",
    "currentStatus": "IN_TRANSIT",
    "trackingHistory": [
      {
        "trackingId": 2,
        "trackingStatus": "IN_TRANSIT",
        "location": "JFK Airport, New York",
        "statusMessage": "화물이 목적지 공항에 도착하였습니다",
        "eventTime": "2026-05-02T06:30:00"
      },
      {
        "trackingId": 1,
        "trackingStatus": "CUSTOMS",
        "location": "인천공항 세관",
        "statusMessage": "수출 통관이 완료되었습니다",
        "eventTime": "2026-05-01T13:00:00"
      }
    ]
  },
  "message": "성공"
}
```

---

# 8. 회계/청구 (BILLING)

---

## API-B01 · 청구서 생성

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/billing/invoices` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | 마스터오더 기준 청구서 생성. 운송비 자동 계산 후 청구 항목 구성. 청구서번호 자동 생성 (INV-YYYYMMDD-NNNNN) |

**Request Body**
```json
{
  "masterOrderId": 1,
  "extraCharge": 50.0,
  "extraChargeNote": "특수 포장비",
  "remark": "긴급 발송 청구서"
}
```

> 운송비 계산식: `운송비 = 원가 + (원가 × 영업이익율%) − (원가 × (1 − 할인율%))`

**Response 201**
```json
{
  "success": true,
  "data": {
    "invoiceId": 1,
    "invoiceNo": "INV-20260416-00001",
    "masterOrderId": 1,
    "masterOrderNo": "MO-20260416-00001",
    "transportCost": 150000.00,
    "extraCharge": 50.0,
    "totalAmount": 150050.00,
    "currency": "KRW",
    "invoiceStatus": "UNPAID",
    "createdAt": "2026-04-16T10:00:00"
  },
  "message": "청구서가 생성되었습니다"
}
```

---

## API-B05 · 청구서 확정

| 항목 | 내용 |
|---|---|
| Method | PATCH |
| URL | `/billing/invoices/{invoiceId}/confirm` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | 청구서 확정. 확정 후 수정 불가 |

**Request Body** — 없음

**Response 200**
```json
{
  "success": true,
  "data": {
    "invoiceId": 1,
    "invoiceStatus": "CONFIRMED",
    "confirmedAt": "2026-04-16T11:00:00"
  },
  "message": "청구서가 확정되었습니다"
}
```

---

## API-B10 · 입금 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/billing/payments` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | 입금 확인 후 등록. 전액/일부 입금 구분. invoice_status 자동 갱신 (PARTIAL / PAID) |

**Request Body**
```json
{
  "invoiceId": 1,
  "paidAmount": 100000.00,
  "paymentMethod": "BANK_TRANSFER",
  "paymentDate": "2026-04-16",
  "memo": "1차 입금"
}
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| invoiceId | Long | Y | 청구서 ID |
| paidAmount | Decimal | Y | 입금액 |
| paymentMethod | String | Y | BANK_TRANSFER / CARD / CASH |
| paymentDate | String | Y | 입금일 (yyyy-MM-dd) |
| memo | String | N | 비고 |

**Response 201**
```json
{
  "success": true,
  "data": {
    "paymentId": 1,
    "invoiceId": 1,
    "paidAmount": 100000.00,
    "remainingAmount": 50050.00,
    "invoiceStatus": "PARTIAL",
    "paymentDate": "2026-04-16"
  },
  "message": "입금이 등록되었습니다"
}
```

---

# 9. 원가 (COST)

---

## API-C02 · 운송원가 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/costs/transport-masters` |
| 인증 | Bearer Token |
| 권한 | ADMIN |
| 설명 | 서비스 유형/구간별 운송원가 등록 |

**Request Body**
```json
{
  "serviceType": "AIR",
  "originCode": "ICN",
  "destinationCode": "JFK",
  "weightUnit": "KG",
  "baseRate": 5000.00,
  "currency": "KRW",
  "profitRate": 20.0,
  "validFrom": "2026-04-01",
  "validTo": "2026-12-31"
}
```

**Response 201**
```json
{
  "success": true,
  "data": {
    "costId": 1,
    "serviceType": "AIR",
    "originCode": "ICN",
    "destinationCode": "JFK",
    "baseRate": 5000.00,
    "profitRate": 20.0,
    "createdAt": "2026-04-16T10:00:00"
  },
  "message": "운송원가가 등록되었습니다"
}
```

---

## API-C10 · 운송비 계산 (미리보기)

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/costs/calculate` |
| 인증 | Bearer Token |
| 설명 | 오더 정보 기반 예상 운송비 계산 (청구서 생성 전 미리보기) |

**Request Body**
```json
{
  "orderId": 1,
  "serviceType": "AIR",
  "originCode": "ICN",
  "destinationCode": "JFK",
  "extraCharge": 50.0
}
```

**Response 200**
```json
{
  "success": true,
  "data": {
    "transportCost": 150000.00,
    "baseRate": 5000.00,
    "profitAmount": 25000.00,
    "discountAmount": 0.00,
    "extraCharge": 50.0,
    "totalAmount": 150050.00,
    "currency": "KRW",
    "calculation": "원가(125,000) + 이익(25,000) - 할인(0) + 추가(50)"
  },
  "message": "운송비 계산 완료"
}
```

---

# 10. 알림 (NOTIFICATION)

---

## API-N01 · 알림 목록

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/notifications` |
| 인증 | Bearer Token |
| 설명 | 본인 알림 목록 조회 (최신순) |

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---|---|---|---|
| page | int | N | 페이지 번호 |
| size | int | N | 페이지 크기 (기본값 20) |
| isRead | Boolean | N | 읽음 여부 필터 |

**Response 200**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "notificationId": 1,
        "title": "법인 가입 승인",
        "message": "(주)ABC물류 가입 신청이 승인되었습니다",
        "notificationType": "CORPORATE_APPROVED",
        "isRead": false,
        "createdAt": "2026-04-16T10:00:00"
      }
    ],
    "unreadCount": 3,
    "totalElements": 10,
    "totalPages": 1
  },
  "message": "성공"
}
```

---

# 11. VOC

---

## API-V01 · VOC 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/voc` |
| 인증 | Bearer Token |
| 권한 | 인증된 모든 사용자 |

**Request Body**
```json
{
  "category": "DELIVERY_DELAY",
  "title": "배송 지연 문의",
  "content": "주문번호 ORD-20260416-00001 건이 예정일보다 3일 지연되고 있습니다.",
  "orderId": 1,
  "priority": "HIGH"
}
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| category | String | Y | DELIVERY_DELAY / DAMAGE / LOST / ETC |
| title | String | Y | 제목 |
| content | String | Y | 내용 |
| orderId | Long | N | 관련 오더 ID |
| priority | String | N | LOW / MEDIUM / HIGH (기본값 MEDIUM) |

**Response 201**
```json
{
  "success": true,
  "data": {
    "vocId": 1,
    "title": "배송 지연 문의",
    "vocStatus": "OPEN",
    "priority": "HIGH",
    "createdAt": "2026-04-16T10:00:00"
  },
  "message": "VOC가 등록되었습니다"
}
```

---

## API-V05 · VOC 상태 변경

| 항목 | 내용 |
|---|---|
| Method | PATCH |
| URL | `/voc/{vocId}/status` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |

**Request Body**
```json
{
  "vocStatus": "IN_PROGRESS",
  "comment": "담당자 배정 후 처리 중"
}
```

| vocStatus | 설명 |
|---|---|
| OPEN | 접수 |
| IN_PROGRESS | 처리 중 |
| CLOSED | 완료 |

**Response 200**
```json
{
  "success": true,
  "data": {
    "vocId": 1,
    "vocStatus": "IN_PROGRESS",
    "updatedAt": "2026-04-16T11:00:00"
  },
  "message": "VOC 상태가 변경되었습니다"
}
```

---

# 12. 시스템관리 (SYSTEM)

---

## API-S14 · 공통코드 목록

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/system/codes` |
| 인증 | Bearer Token |
| 권한 | 인증된 모든 사용자 |
| 설명 | 코드그룹별 공통코드 조회. 프론트엔드 드롭다운 목록 용도 |

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---|---|---|---|
| groupCode | String | N | 코드그룹 코드 |
| useYn | String | N | 사용여부 (Y/N) |

**Response 200**
```json
{
  "success": true,
  "data": [
    {
      "codeId": 1,
      "groupCode": "ORDER_STATUS",
      "codeValue": "REGISTERED",
      "codeName": "등록",
      "sortOrder": 1,
      "useYn": "Y"
    }
  ],
  "message": "성공"
}
```

---

# 13. 기준코드 (CODE)

---

## API-R01 · 국가코드 목록 (공통 예시)

> API-R05(공항), API-R09(항구), API-R13(항공사), API-R17(택배사) 모두 동일 구조

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/codes/countries` |
| 인증 | Bearer Token |

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---|---|---|---|
| keyword | String | N | 국가명, 코드 검색 |
| useYn | String | N | 사용여부 (Y/N) |

**Response 200**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "countryCode": "KR",
      "countryNameKo": "대한민국",
      "countryNameEn": "Republic of Korea",
      "useYn": "Y"
    },
    {
      "id": 2,
      "countryCode": "US",
      "countryNameKo": "미국",
      "countryNameEn": "United States of America",
      "useYn": "Y"
    }
  ],
  "message": "성공"
}
```

---

## API-R02 · 국가코드 등록 (공통 예시)

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/codes/countries` |
| 인증 | Bearer Token |
| 권한 | ADMIN |

**Request Body**
```json
{
  "countryCode": "JP",
  "countryNameKo": "일본",
  "countryNameEn": "Japan",
  "useYn": "Y"
}
```

**Response 201**
```json
{
  "success": true,
  "data": { "id": 3, "countryCode": "JP" },
  "message": "국가코드가 등록되었습니다"
}
```

---

## 공항코드 스키마 참고

```json
{
  "id": 1,
  "airportCode": "ICN",
  "airportName": "인천국제공항",
  "countryCode": "KR",
  "city": "인천",
  "useYn": "Y"
}
```

## 항구코드 스키마 참고

```json
{
  "id": 1,
  "portCode": "KRPUS",
  "portName": "부산항",
  "countryCode": "KR",
  "city": "부산",
  "useYn": "Y"
}
```

## 항공사코드 스키마 참고

```json
{
  "id": 1,
  "airlineCode": "KE",
  "airlineName": "대한항공",
  "iataCode": "KE",
  "icaoCode": "KAL",
  "useYn": "Y"
}
```

## 택배사 스키마 참고

```json
{
  "id": 1,
  "courierCode": "CJ",
  "courierName": "CJ대한통운",
  "trackingUrl": "https://trace.cjlogistics.com",
  "useYn": "Y"
}
```

---

# 부록: HTTP 상태코드 정리

| 상태코드 | 용도 |
|---|---|
| 200 OK | 조회, 수정, 상태변경 성공 |
| 201 Created | 리소스 생성 성공 |
| 400 Bad Request | 입력값 오류, 유효성 검사 실패 |
| 401 Unauthorized | 인증 실패 (토큰 없음/만료/유효하지 않음) |
| 403 Forbidden | 권한 없음 |
| 404 Not Found | 리소스 없음 |
| 409 Conflict | 중복 또는 상태 충돌 |
| 423 Locked | 계정 잠금 |
| 500 Internal Server Error | 서버 내부 오류 |

---

# 14. 기초정보관리 (BASIC-INFO)

---

## API-FR01 · 개인회원 등급별 운임요율 목록

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/fare-rates/individual` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | 개인회원 등급(BASIC/SILVER/GOLD/VIP)별 운임요율(%) 목록 조회 |

**Response 200**
```json
{
  "success": true,
  "data": [
    { "rateId": 1, "memberGrade": "BASIC",  "fareRate": 0.0  },
    { "rateId": 2, "memberGrade": "SILVER", "fareRate": 3.0  },
    { "rateId": 3, "memberGrade": "GOLD",   "fareRate": 5.0  },
    { "rateId": 4, "memberGrade": "VIP",    "fareRate": 10.0 }
  ],
  "message": "성공"
}
```

---

## API-FR02 · 개인회원 운임요율 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/fare-rates/individual` |
| 인증 | Bearer Token |
| 권한 | ADMIN |

**Request Body**
```json
{
  "memberGrade": "SILVER",
  "fareRate": 3.0
}
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| memberGrade | String | Y | BASIC / SILVER / GOLD / VIP |
| fareRate | Decimal | Y | 운임요율 (%) — 소수점 1자리 |

**Response 201**
```json
{
  "success": true,
  "data": { "rateId": 2, "memberGrade": "SILVER", "fareRate": 3.0 },
  "message": "운임요율이 등록되었습니다"
}
```

---

## API-FR05 · 법인회원별 운임요율 목록

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/fare-rates/corporate` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |

**Query Parameters**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| corporateId | Long | 법인 ID 필터 |
| keyword | String | 법인명 검색 |

**Response 200**
```json
{
  "success": true,
  "data": [
    { "rateId": 1, "corporateId": 1, "corpName": "(주)ABC물류", "fareRate": 7.5 }
  ],
  "message": "성공"
}
```

---

## API-EX01 · 환율 조회

| 항목 | 내용 |
|---|---|
| Method | GET |
| URL | `/exchange-rates` |
| 인증 | Bearer Token |
| 설명 | 국가관리에 등록된 국가 환율 조회. 기준: 서울외국환중개소 영업일 오전 8시 |

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---|---|---|---|
| currencyCode | String | N | 특정 화폐코드 필터 (예: USD, JPY) |

**Response 200**
```json
{
  "success": true,
  "data": [
    { "currencyCode": "USD", "currencyName": "미국 달러", "baseRate": 1380.50, "updatedAt": "2026-04-18T08:00:00" },
    { "currencyCode": "JPY", "currencyName": "일본 엔",   "baseRate": 9.23,   "updatedAt": "2026-04-18T08:00:00" }
  ],
  "message": "성공"
}
```

---

## API-EX02 · 환율 연계 (서울외국환중개소)

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/exchange-rates/sync` |
| 인증 | Bearer Token |
| 권한 | ADMIN |
| 설명 | 서울외국환중개소 API 호출하여 당일 기준환율 갱신. 배치 스케줄러 또는 수동 실행 |

**Request Body** — 없음

**Response 200**
```json
{
  "success": true,
  "data": { "syncedCount": 15, "syncedAt": "2026-04-18T08:00:00" },
  "message": "환율이 갱신되었습니다"
}
```

---

## API-AT02 · 항공운송수단 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/transports/air` |
| 인증 | Bearer Token |
| 권한 | ADMIN |
| 설명 | 항공편 단위 운송수단 등록. 운항 스케줄·운송원가 연계 기준 |

**Request Body**
```json
{
  "originCountryCode": "KR",
  "originAirportCode": "ICN",
  "destCountryCode": "US",
  "destAirportCode": "JFK",
  "flightName": "인천-뉴욕 노선"
}
```

**Response 201**
```json
{
  "success": true,
  "data": {
    "transportId": 1,
    "originAirportCode": "ICN",
    "destAirportCode": "JFK",
    "flightName": "인천-뉴욕 노선"
  },
  "message": "항공운송수단이 등록되었습니다"
}
```

---

## API-AT06 · 항공 운송원가 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/transports/air/{transportId}/costs` |
| 인증 | Bearer Token |
| 권한 | ADMIN |
| 설명 | 부피기준(X·Y·Z cm, 원가USD) 및 중량기준(Kg, 원가USD) 운송원가 등록 |

**Request Body**
```json
{
  "costType": "VOLUME",
  "dimX": 30.0,
  "dimY": 20.0,
  "dimZ": 15.0,
  "costUsd": 25.00
}
```

또는 중량기준:
```json
{
  "costType": "WEIGHT",
  "weightKg": 10.0,
  "costUsd": 15.00
}
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| costType | String | Y | VOLUME (부피기준) / WEIGHT (중량기준) |
| dimX/Y/Z | Decimal | VOLUME 시 Y | 가로·세로·높이 (cm) |
| weightKg | Decimal | WEIGHT 시 Y | 중량 (kg) |
| costUsd | Decimal | Y | 운송원가 (USD) |

**Response 201**
```json
{
  "success": true,
  "data": { "costId": 1, "transportId": 1, "costType": "VOLUME", "costUsd": 25.00 },
  "message": "운송원가가 등록되었습니다"
}
```

---

## API-ST02 · 해운운송수단 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/transports/sea` |
| 인증 | Bearer Token |
| 권한 | ADMIN |

**Request Body**
```json
{
  "originCountryCode": "KR",
  "originPortCode": "KRPUS",
  "destCountryCode": "US",
  "destPortCode": "USLAX",
  "vesselName": "부산-LA 노선"
}
```

**Response 201** — 항공운송수단 등록과 동일 구조

---

## API-CB02 · 통관사 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/customs-brokers` |
| 인증 | Bearer Token |
| 권한 | ADMIN |
| 설명 | 국가·운송구분(AIR/SEA)·입항코드(공항/항구) 기준 통관사 등록 |

**Request Body**
```json
{
  "countryCode": "US",
  "serviceType": "AIR",
  "entryCode": "JFK",
  "brokerName": "US Air Customs Co.",
  "apiIntegration": "OFF"
}
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| countryCode | String | Y | 국가코드 |
| serviceType | String | Y | AIR / SEA |
| entryCode | String | Y | AIR: 공항코드, SEA: 항구코드 |
| brokerName | String | Y | 통관사명 |
| apiIntegration | String | Y | ON / OFF |

**Response 201**
```json
{
  "success": true,
  "data": { "brokerId": 1, "brokerName": "US Air Customs Co.", "serviceType": "AIR" },
  "message": "통관사가 등록되었습니다"
}
```

---

## API-CB06 · 통관원가 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/customs-brokers/{brokerId}/costs` |
| 인증 | Bearer Token |
| 권한 | ADMIN |
| 설명 | 통관사별 부피/중량기준 통관원가 등록 |

**Request Body** — 항공 운송원가 등록(API-AT06)과 동일 구조

---

## API-CW02 · 택배배송장 등록

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/codes/couriers/{courierId}/waybills` |
| 인증 | Bearer Token |
| 권한 | ADMIN |
| Content-Type | multipart/form-data |
| 설명 | 국가별 택배사 배송장 출력 양식(BLOB) 등록 |

**Form Data**

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| countryCode | String | Y | 배송장 적용 국가코드 |
| waybillFile | MultipartFile | Y | 배송장 양식 파일 (PDF/XLSX, 최대 20MB) |
| description | String | N | 배송장 설명 |

**Response 201**
```json
{
  "success": true,
  "data": {
    "waybillId": 1,
    "courierId": 1,
    "countryCode": "US",
    "fileName": "CJ_US_waybill.pdf",
    "fileSize": 512000,
    "uploadedAt": "2026-04-18T10:00:00"
  },
  "message": "택배배송장이 등록되었습니다"
}
```

---

## API-PP02 · 선불금 충전 요청

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/prepaid/charge-request` |
| 인증 | Bearer Token |
| 권한 | 인증된 모든 사용자 (개인/법인관리자) |
| 설명 | 입금 완료 후 충전 금액 입력하여 관리자 확인 요청 |

**Request Body**
```json
{
  "chargeAmount": 100000.00,
  "depositDate": "2026-04-18",
  "depositorName": "홍길동",
  "memo": "4월 선불금 충전"
}
```

**Response 201**
```json
{
  "success": true,
  "data": {
    "requestId": 1,
    "chargeAmount": 100000.00,
    "status": "PENDING",
    "createdAt": "2026-04-18T10:00:00"
  },
  "message": "충전 요청이 접수되었습니다. 관리자 확인 후 반영됩니다"
}
```

---

## API-PP03 · 선불금 충전 확인 (관리자)

| 항목 | 내용 |
|---|---|
| Method | PATCH |
| URL | `/prepaid/charge-requests/{requestId}/confirm` |
| 인증 | Bearer Token |
| 권한 | ADMIN, OPERATOR |
| 설명 | 실제 입금 확인 후 최종 충전 처리. 회원 잔액에 즉시 반영 |

**Request Body**
```json
{
  "confirmed": true,
  "memo": "입금 확인 완료"
}
```

**Response 200**
```json
{
  "success": true,
  "data": {
    "requestId": 1,
    "memberId": 1,
    "chargeAmount": 100000.00,
    "newBalance": 100000.00,
    "status": "CONFIRMED",
    "confirmedAt": "2026-04-18T11:00:00"
  },
  "message": "충전이 완료되었습니다"
}
```

---

## API-PP04 · 환불 요청

| 항목 | 내용 |
|---|---|
| Method | POST |
| URL | `/prepaid/refund-request` |
| 인증 | Bearer Token |
| 권한 | 인증된 모든 사용자 (개인/법인관리자) |

**Request Body**
```json
{
  "refundAmount": 50000.00,
  "bankName": "국민은행",
  "accountNumber": "123456-78-901234",
  "accountHolder": "홍길동",
  "memo": "잔액 환불 요청"
}
```

**Response 201**
```json
{
  "success": true,
  "data": {
    "refundId": 1,
    "refundAmount": 50000.00,
    "status": "PENDING",
    "createdAt": "2026-04-18T10:00:00"
  },
  "message": "환불 요청이 접수되었습니다"
}
```

---

# 부록: 도메인별 주요 상태값

| 도메인 | 필드 | 상태값 |
|---|---|---|
| 오더 | order_status | REGISTERED → PACKED → WAREHOUSED → RELEASED → DELIVERED |
| 마스터오더 | master_order_status | CREATED → WAREHOUSED → RELEASED → IN_TRANSIT → DELIVERED |
| 법인 심사 | approval_status | PENDING → APPROVED / REJECTED |
| 법인 계정 | status | INACTIVE → ACTIVE / WITHDRAWN |
| 개인 계정 | status | ACTIVE / INACTIVE / WITHDRAWN |
| 청구서 | invoice_status | UNPAID → PARTIAL → PAID |
| VOC | voc_status | OPEN → IN_PROGRESS → CLOSED |
| Tracking | tracking_status | IN_TRANSIT / ARRIVED / CUSTOMS / DELIVERED |
