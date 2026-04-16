# SNTL 통합 물류 플랫폼 — Claude Code 세션 설정

## 프로젝트 개요

국제 물류 통합 플랫폼 — 항운(AIR), 해운(SEA), 택배(CIR), 통관(CCL) 서비스를 통합 관리하는 B2B/B2C 물류 SaaS

- **GitHub**: https://github.com/jungjs/first_vibe_coding
- **개발 방식**: Vibe Coding (Claude Code 활용)

---

## 기술 스택

### Backend
- Java 21 (Virtual Thread, Record, Pattern Matching, `--enable-preview`)
- Spring Boot 3.3.x (Spring 6 기반)
- Spring Security + JWT (`jjwt 0.12.5`), OAuth2 소셜로그인
- Spring Data JPA + QueryDSL 5.1.0
- Flyway (DB 마이그레이션)
- SpringDoc OpenAPI 3 (Swagger: `/swagger-ui.html`)
- Gradle Kotlin DSL (`build.gradle.kts`)

### Frontend
- Next.js 14+ (App Router)
- TypeScript
- Shadcn/ui + Tailwind CSS
- Zustand + TanStack Query
- React Hook Form + Zod

### Infrastructure
- PostgreSQL 16 (포트: 5432, DB: `sntl_db`, User: `sntl`)
- Redis 7 (포트: 6379 — 세션, Refresh Token 블랙리스트)
- MinIO (포트: 9000/9001 — 법인증빙파일, 운송장 PDF)
- Docker + Docker Compose (로컬 개발)

---

## 디렉토리 구조

```
SNTL/
├── backend/                          # Spring Boot (Java 21)
│   ├── build.gradle.kts
│   └── src/main/
│       ├── java/com/sntl/platform/
│       │   ├── SntlApplication.java
│       │   ├── domain/               # 도메인별 패키지 (아래 도메인 구성 참조)
│       │   ├── global/               # 공통 모듈
│       │   │   ├── config/           # SecurityConfig, JpaConfig, RedisConfig
│       │   │   ├── exception/        # ErrorCode, BusinessException, GlobalExceptionHandler
│       │   │   ├── response/         # ApiResponse
│       │   │   ├── util/
│       │   │   └── security/         # JWT, OAuth2
│       │   └── infra/
│       │       ├── storage/          # MinIO
│       │       └── tracking/         # 외부 항운/해운/택배 API
│       └── resources/
│           ├── application.yml
│           ├── application-dev.yml   # 로컬 DB/Redis/JWT/MinIO 설정
│           ├── application-prod.yml
│           └── db/migration/         # Flyway SQL (V1__, V2__, ...)
├── frontend/                         # Next.js 14+ (TypeScript)
│   └── src/
│       ├── app/
│       │   ├── (auth)/               # 로그인/회원가입 레이아웃
│       │   ├── (main)/               # 일반 사용자 서비스 레이아웃
│       │   └── admin/                # 관리자 레이아웃
│       ├── components/
│       ├── lib/
│       │   ├── api/                  # API 호출 함수
│       │   └── store/                # Zustand 상태관리
│       └── types/
├── infra/
│   └── docker-compose.yml            # PostgreSQL + Redis + MinIO
├── project.md                        # 전체 개발 계획 및 Phase 진행상황
├── work_log_YYYYMMDD.log             # 작업 로그 (날짜별)
└── CLAUDE.md                         # 이 파일
```

---

## 도메인 구성

| 도메인 패키지 | 역할 |
|---|---|
| `auth` | JWT 로그인/로그아웃, OAuth2, Refresh Token |
| `member` | 개인/법인 회원가입, 정보수정, 탈퇴, 등급 |
| `order` | 오더 CRUD, 송하인/수하인/화물정보, HS코드 |
| `masterorder` | 마스터오더, 오더 패킹 |
| `warehouse` | 입고/출고, 바코드 스캔, 운송장 출력 |
| `tracking` | AIR/SEA/CIR Tracking, 통관신고 조회 |
| `billing` | 청구서, 운송비 계산, 세금계산서 |
| `cost` | 운송원가, 회원별 할인율 |
| `notification` | 알림 관리 |
| `statistics` | 운송/비용 통계 |
| `system` | 메뉴, 코드, 권한 관리 |

각 도메인 내부는 `controller / service / repository / dto` 구조.

---

## 개발 환경 실행

```bash
# 인프라 기동 (PostgreSQL + Redis + MinIO)
cd infra
docker compose up -d

# 백엔드 실행
cd backend
./gradlew bootRun

# 프론트엔드 실행
cd frontend
npm install
npm run dev
```

- Backend: http://localhost:8080
- Swagger: http://localhost:8080/swagger-ui.html
- Frontend: http://localhost:3000
- MinIO Console: http://localhost:9001

---

## 로컬 개발 환경 정보

```
PostgreSQL: 211.192.207.172:45432 / DB: jeongdb / User: aventusm / PW: aventus1!
Redis:      localhost:6379
MinIO:      localhost:9000 / User: sntl-minio / PW: sntl-minio-secret
JWT Access Token:  30분 (1,800,000ms)
JWT Refresh Token: 7일 (604,800,000ms)
```

---

## 핵심 비즈니스 로직

### 운송비 계산식
```
운송비 = 서비스운송원가
       + (서비스운송원가 × 영업이익율(%))
       - (서비스운송원가 × (1 - 회원별할인율(%)))
운송원가 = 화물정보의 총중량, 용적(CBM)으로 도출
Extra Charge = 오더별 수동 입력 (소수점 1자리)
```

### 법인 심사 프로세스
```
법인회원 가입 → 사업자등록증 첨부파일 업로드
  → 관리자 확인 → 승인/거부
  → 승인 시 법인 계정 활성화 + 알림 발송
```

### 회원탈퇴 — Soft Delete
- 개인정보 컬럼 NULL 처리
- ID(PK)는 보존

### 오더 수정/삭제 제한
- 창고 입고 이후 수정/삭제 불가

---

## 코딩 규칙

### Backend
- 도메인 간 의존은 **Service 레이어**를 통해서만 허용
- API 응답은 반드시 `ApiResponse<T>` 래퍼 사용
- 예외는 `BusinessException` + `ErrorCode` enum으로 처리
- Flyway 마이그레이션 파일명: `V{n}__{설명}.sql` (버전 순서 엄수)
- Java 21 Record를 DTO에 적극 활용
- `--enable-preview` 활성화 상태

### Frontend
- App Router 기반 라우팅
- API 호출은 `src/lib/api/` 함수를 통해서만 수행
- 전역 상태는 Zustand (`src/lib/store/`)
- 폼 유효성 검사는 React Hook Form + Zod

---

## 작업 로그 규칙

**매 작업 완료 후 반드시** `work_log_YYYYMMDD.log`에 아래 형식으로 기록:

```
----------------------------------------
[N] 작업 제목
----------------------------------------
- 작업 내용: (무엇을 했는가)
- 수행 내용:
  * (세부 항목)
- 생성/수정 파일:
  * 파일명
```

작업 완료 후 `project.md`의 해당 Phase 체크박스도 업데이트할 것.

---

## 현재 개발 진행상황

### Phase 1 — 기반 구축 (진행 중)
- [x] 프로젝트 환경 셋업 (모노레포 구조, Docker Compose) ✅ 2026-04-13
- [x] DB 설계 및 Flyway 마이그레이션 초기화 ✅ 2026-04-13
- [x] 설계 문서 작성 (DataDictionary, FeatureList, ProcessDefinition) ✅ 2026-04-15
- [ ] 회원/인증 (JWT 로그인, 개인/법인 회원가입, Refresh Token, Redis 블랙리스트)
- [ ] 기초 코드 관리 (국가/공항/항구/항공사/택배사 코드 CRUD)

자세한 Phase 계획은 `project.md` 참조.

---

## 참고 문서

| 파일 | 내용 |
|---|---|
| `project.md` | 전체 개발 계획, 기술스택, Phase 진행상황 |
| `SNTL_DataDictionary.xlsx` | 37개 테이블 컬럼 정의 |
| `SNTL_FeatureList.xlsx` | 142개 기능 항목 (L1~L4 Tree) |
| `SNTL_ProcessDefinition.xlsx` | 13개 업무프로세스 정의서 |
