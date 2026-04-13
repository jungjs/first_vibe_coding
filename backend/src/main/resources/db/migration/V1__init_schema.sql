-- =============================================
-- V1: 초기 스키마 생성
-- =============================================

-- 개인회원
CREATE TABLE individual_member (
    id              BIGSERIAL PRIMARY KEY,
    login_id        VARCHAR(50) UNIQUE NOT NULL,
    password        VARCHAR(255) NOT NULL,
    name            VARCHAR(100),
    birth_date      DATE,
    phone           VARCHAR(20),
    email           VARCHAR(100),
    zipcode         VARCHAR(10),
    address         VARCHAR(255),
    address_detail  VARCHAR(255),
    grade           VARCHAR(20) DEFAULT 'BASIC',
    balance         NUMERIC(15, 2) DEFAULT 0,
    status          VARCHAR(20) DEFAULT 'ACTIVE',
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 법인
CREATE TABLE corporate (
    id                  BIGSERIAL PRIMARY KEY,
    login_id            VARCHAR(50) UNIQUE NOT NULL,
    corp_name           VARCHAR(200) NOT NULL,
    ceo_name            VARCHAR(100),
    business_number     VARCHAR(20),
    phone               VARCHAR(20),
    email               VARCHAR(100),
    zipcode             VARCHAR(10),
    address             VARCHAR(255),
    address_detail      VARCHAR(255),
    approval_status     VARCHAR(20) DEFAULT 'PENDING',
    status              VARCHAR(20) DEFAULT 'INACTIVE',
    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 법인 첨부파일 (심사용)
CREATE TABLE corporate_attachment (
    id              BIGSERIAL PRIMARY KEY,
    corporate_id    BIGINT NOT NULL REFERENCES corporate(id),
    file_name       VARCHAR(255) NOT NULL,
    file_path       VARCHAR(500) NOT NULL,
    file_size       BIGINT,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 법인 관리자
CREATE TABLE corporate_manager (
    id              BIGSERIAL PRIMARY KEY,
    corporate_id    BIGINT NOT NULL REFERENCES corporate(id),
    login_id        VARCHAR(50) UNIQUE NOT NULL,
    password        VARCHAR(255) NOT NULL,
    name            VARCHAR(100),
    birth_date      DATE,
    phone           VARCHAR(20),
    email           VARCHAR(100),
    zipcode         VARCHAR(10),
    address         VARCHAR(255),
    address_detail  VARCHAR(255),
    status          VARCHAR(20) DEFAULT 'ACTIVE',
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 부서
CREATE TABLE department (
    id              BIGSERIAL PRIMARY KEY,
    corporate_id    BIGINT NOT NULL REFERENCES corporate(id),
    dept_name       VARCHAR(100),
    status          VARCHAR(20) DEFAULT 'ACTIVE',
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 부서 관리자
CREATE TABLE department_manager (
    id              BIGSERIAL PRIMARY KEY,
    department_id   BIGINT NOT NULL REFERENCES department(id),
    login_id        VARCHAR(50) UNIQUE NOT NULL,
    password        VARCHAR(255) NOT NULL,
    name            VARCHAR(100),
    birth_date      DATE,
    phone           VARCHAR(20),
    email           VARCHAR(100),
    zipcode         VARCHAR(10),
    address         VARCHAR(255),
    address_detail  VARCHAR(255),
    status          VARCHAR(20) DEFAULT 'ACTIVE',
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 코드 그룹
CREATE TABLE code_group (
    id          BIGSERIAL PRIMARY KEY,
    group_code  VARCHAR(50) UNIQUE NOT NULL,
    group_name  VARCHAR(100) NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 공통 코드
CREATE TABLE common_code (
    id          BIGSERIAL PRIMARY KEY,
    group_id    BIGINT NOT NULL REFERENCES code_group(id),
    code        VARCHAR(50) NOT NULL,
    code_name   VARCHAR(200) NOT NULL,
    sort_order  INTEGER DEFAULT 0,
    use_yn      CHAR(1) DEFAULT 'Y',
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (group_id, code)
);
