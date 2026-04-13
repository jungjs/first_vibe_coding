# SNTL 통합 물류 플랫폼 개발 계획

## 시스템 개요
국제 물류 통합 플랫폼 — 항운(AIR), 해운(SEA), 택배(CIR), 통관(CCL) 서비스를 통합 관리하는 B2B/B2C 물류 SaaS

---

## 기능 도메인

| # | 도메인 | 주요 기능 |
|---|--------|-----------|
| 1 | 회원/인증 | 로그인, 개인/법인 회원가입, 탈퇴, 정보관리, 등급관리 |
| 2 | 오더 관리 | 오더 CRUD, 송하인/수하인/화물정보, HS코드, 특수화물 |
| 3 | 운송 관리 | 마스터오더, 서비스(AIR/SEA/CIR/CCL) 추가, 운항스케줄 |
| 4 | 창고 관리 | 입고/출고, 바코드 스캔(1차 WEB), 운송장 출력 |
| 5 | Tracking | 항운/해운/택배 Tracking, 통관신고 결과 조회 |
| 6 | 회계/청구 | 수입관리, 입금확인, 운송비 계산, 세금계산서, 비용관리 |
| 7 | 시스템 관리 | 메뉴관리, 코드관리, 택배사관리, 알림, 통계, 데이터백업 |

---

## 확정 기술 스택

### Backend
- Language: Java 21 (Virtual Thread, Record, Pattern Matching)
- Framework: Spring Boot 3.x (Spring 6 기반)
- API: REST API + Spring WebFlux (Tracking 등 비동기 처리)
- Auth: Spring Security + OAuth2 / JWT (Access/Refresh Token), 소셜로그인
- ORM: Spring Data JPA + QueryDSL
- DB Migration: Flyway
- API Docs: SpringDoc OpenAPI 3 (Swagger)
- Build: Gradle (Kotlin DSL)

### Frontend
- Framework: Next.js 14+ (App Router)
- Language: TypeScript
- UI: Shadcn/ui + Tailwind CSS
- State: Zustand + TanStack Query
- Form: React Hook Form + Zod

### Infrastructure
- Database: PostgreSQL 16
- Cache: Redis (세션, 토큰 블랙리스트)
- File Storage: MinIO (법인증빙파일, 운송장 PDF)
- Container: Docker + Docker Compose (개발) / Kubernetes (운영)
- CI/CD: GitHub Actions
- Monitoring: Grafana + Prometheus

---

## 비즈니스 로직 확정 사항

### 운송비 계산
```
운송비 = 서비스운송원가 + (서비스운송원가 × 영업이익율(%)) - (서비스운송원가 × (1 - 회원별할인율(%)))
운송원가 = 화물정보의 총중량, 용적(CBM)으로 도출
Extra Charge = 오더별 수동 입력 (소수점 1자리)
```

### 법인 심사 프로세스
```
법인회원 가입
  → 사업자등록증 등 첨부파일 업로드
  → 관리자 첨부파일 확인
  → 승인 / 거부
  → 승인 시 법인 계정 활성화
```

### 개인회원 등급
- 특정 조건(발송횟수 등)에 따라 등급 부여
- 등급에 따른 운송비용 할인율 제공

---

## 개발 Phase

### Phase 1 — 기반 구축 (1~2개월)
- [x] 프로젝트 환경 셋업 (모노레포 구조, Docker Compose) ✅ 2026-04-13
- [x] DB 설계 및 Flyway 마이그레이션 초기화 ✅ 2026-04-13
- [ ] 회원/인증
  - [ ] 개인회원 가입 (본인확인, 소셜로그인)
  - [ ] 법인회원 가입 (첨부파일 업로드, 관리자 승인/거부)
  - [ ] JWT 로그인/로그아웃, Access/Refresh Token
  - [ ] ID찾기, PW재설정
  - [ ] 회원정보 수정 (개인/법인/부서)
  - [ ] 회원탈퇴 (Soft Delete - 개인정보 Null 처리, ID 보존)
  - [ ] 개인회원 등급 조회, 잔액충전/환불
  - [ ] 청구서 관리 (청구내역/이력 조회)
- [ ] 기초 코드 관리
  - [ ] 국가코드, 공항코드, 항구코드, 항공사코드, 택배사코드
  - [ ] 코드 CRUD (관리자)

### Phase 2 — 핵심 물류 기능 (2~3개월)
- [ ] 오더 관리
  - [ ] 오더 등록/수정/삭제/조회
  - [ ] 송하인/수하인/화물정보 관리
  - [ ] HS코드, 원산지, 특수화물(위험물, 냉동, 고가품, 중고품)
  - [ ] 서비스 추가 (AIR/SEA/CIR/CCL)
  - [ ] 운항 스케줄 조회 및 선택
  - [ ] 운송비용 자동 계산 (원가 + 이익율 + 할인율 + Extra Charge)
- [ ] 마스터오더 관리
  - [ ] 마스터오더 CRUD
  - [ ] 오더 Packing (마스터오더에 오더 포함)
- [ ] 창고 관리 (WEB)
  - [ ] 입고 처리
  - [ ] 출고 처리 (바코드 스캔 → 운송장 출력/부착)
  - [ ] 운송장 출력

### Phase 3 — Tracking & 회계 (1~2개월)
- [ ] 운송 Tracking
  - [ ] 항운(AIR) Tracking
  - [ ] 해운(SEA) Tracking
  - [ ] 택배(CIR) Tracking
  - [ ] 마스터오더/오더 Tracking 정보 갱신
  - [ ] 통관신고 결과 조회
- [ ] 청구/회계
  - [ ] 청구서 생성/조회/출력
  - [ ] 입금 확인
  - [ ] 수입 관리 (회원별/기간별/운송수단별)
- [ ] 비용 관리
  - [ ] 항운/해운/택배사별 원가 조회
  - [ ] 운송원가 등록/수정
- [ ] 세금계산서 조회 및 출력
- [ ] VOC 관리 (오더별 고객 불만 처리)

### Phase 4 — 운영 기능 (1개월)
- [ ] 알림 관리 (알림 추가/삭제/발송/조회)
- [ ] 통계 (운송통계, 비용통계)
- [ ] 데이터 백업 (DB 자동 백업)
- [ ] 시스템 관리
  - [ ] 메뉴 관리 (CRUD)
  - [ ] 권한 관리
- [ ] QnA / FAQ / 공지사항

---

## 개발 폴더 구조

```
sntl-platform/
│
├── backend/                          # Spring Boot 3.x (Java 21)
│   ├── build.gradle.kts
│   ├── settings.gradle.kts
│   ├── Dockerfile
│   └── src/
│       ├── main/
│       │   ├── java/com/sntl/platform/
│       │   │   ├── SntlApplication.java
│       │   │   │
│       │   │   ├── domain/                   # 도메인별 패키지
│       │   │   │   ├── auth/                 # 인증/로그인
│       │   │   │   │   ├── controller/
│       │   │   │   │   ├── service/
│       │   │   │   │   ├── repository/
│       │   │   │   │   └── dto/
│       │   │   │   ├── member/               # 회원 (개인/법인)
│       │   │   │   ├── order/                # 오더 관리
│       │   │   │   ├── masterorder/          # 마스터오더
│       │   │   │   ├── warehouse/            # 창고 관리
│       │   │   │   ├── tracking/             # 운송 Tracking
│       │   │   │   ├── billing/              # 청구/회계
│       │   │   │   ├── cost/                 # 비용/운송원가
│       │   │   │   ├── notification/         # 알림
│       │   │   │   ├── statistics/           # 통계
│       │   │   │   └── system/               # 시스템관리 (코드, 메뉴, 권한)
│       │   │   │
│       │   │   ├── global/                   # 공통 모듈
│       │   │   │   ├── config/               # Security, JPA, Redis 설정
│       │   │   │   ├── exception/            # 전역 예외 처리
│       │   │   │   ├── response/             # 공통 API Response 형식
│       │   │   │   ├── util/                 # 유틸리티
│       │   │   │   └── security/             # JWT, OAuth2
│       │   │   │
│       │   │   └── infra/                    # 외부 연동
│       │   │       ├── storage/              # MinIO 파일 업로드
│       │   │       └── tracking/             # 항운/해운/택배 외부 API
│       │   │
│       │   └── resources/
│       │       ├── application.yml
│       │       ├── application-dev.yml
│       │       ├── application-prod.yml
│       │       └── db/migration/             # Flyway SQL 파일
│       │           ├── V1__init_member.sql
│       │           ├── V2__init_order.sql
│       │           └── ...
│       │
│       └── test/
│           └── java/com/sntl/platform/
│               └── domain/                   # 도메인별 테스트
│
├── frontend/                         # Next.js 14+ (TypeScript)
│   ├── package.json
│   ├── next.config.ts
│   ├── tailwind.config.ts
│   ├── Dockerfile
│   └── src/
│       ├── app/                      # App Router
│       │   ├── (auth)/               # 로그인/회원가입 (레이아웃 분리)
│       │   │   ├── login/
│       │   │   └── register/
│       │   ├── (main)/               # 일반 사용자 서비스
│       │   │   ├── dashboard/
│       │   │   ├── orders/
│       │   │   ├── master-orders/
│       │   │   ├── warehouse/
│       │   │   ├── tracking/
│       │   │   ├── billing/
│       │   │   └── mypage/
│       │   └── admin/                # 관리자
│       │       ├── members/
│       │       ├── codes/
│       │       ├── costs/
│       │       └── statistics/
│       │
│       ├── components/
│       │   ├── ui/                   # Shadcn/ui 기본 컴포넌트
│       │   └── common/               # 공통 컴포넌트 (Header, Sidebar 등)
│       │
│       ├── lib/
│       │   ├── api/                  # API 호출 함수
│       │   ├── store/                # Zustand 상태관리
│       │   └── utils/
│       │
│       └── types/                    # TypeScript 타입 정의
│
├── infra/                            # 인프라 설정
│   ├── docker-compose.yml            # 로컬 개발용 (PostgreSQL, Redis, MinIO)
│   ├── docker-compose.prod.yml
│   └── k8s/                         # Kubernetes 매니페스트
│
├── .github/
│   └── workflows/
│       ├── backend-ci.yml
│       └── frontend-ci.yml
│
└── project.md
```

### 핵심 설계 포인트

**Backend 패키지 전략 — 도메인형**
- `domain/` 하위에 각 도메인별로 `controller / service / repository / dto` 묶기
- 도메인 간 의존은 `service` 레이어를 통해서만 허용

**Frontend 라우팅 전략 — Route Group**
- `(auth)`: 로그인/회원가입 전용 레이아웃
- `(main)`: 일반 사용자 서비스 레이아웃
- `admin/`: 관리자 전용 레이아웃

---

## 미정 사항 (추후 정의)
- 외부 항공사/해운사 Tracking API 연동 목록
- 창고 PDA/App 개발 (2차 개발)
- 개인회원 등급 부여 조건 상세 정의
