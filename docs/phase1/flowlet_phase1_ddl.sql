-- =========================================
-- Schema
-- =========================================
CREATE SCHEMA IF NOT EXISTS flowlet;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================================
-- m_account
-- =========================================
CREATE TABLE flowlet.m_account (
    account_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_name VARCHAR(100) NOT NULL,
    initial_balance_amount BIGINT NOT NULL DEFAULT 0,
    is_purpose_management_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE flowlet.m_account IS '口座マスタ';

COMMENT ON COLUMN flowlet.m_account.account_id IS '口座ID';
COMMENT ON COLUMN flowlet.m_account.account_name IS '口座名';
COMMENT ON COLUMN flowlet.m_account.initial_balance_amount IS '初期残高（円）';
COMMENT ON COLUMN flowlet.m_account.is_purpose_management_enabled IS '目的別管理有効フラグ';
COMMENT ON COLUMN flowlet.m_account.created_at IS '作成日時';
COMMENT ON COLUMN flowlet.m_account.updated_at IS '更新日時';

-- =========================================
-- m_purpose
-- =========================================
CREATE TABLE flowlet.m_purpose (
    purpose_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID NOT NULL,
    purpose_name VARCHAR(100) NOT NULL,
    allocated_amount BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_purpose_account
        FOREIGN KEY (account_id)
        REFERENCES flowlet.m_account(account_id)
        ON DELETE CASCADE
);

COMMENT ON TABLE flowlet.m_purpose IS '口座内の目的（用途別管理単位）';

COMMENT ON COLUMN flowlet.m_purpose.purpose_id IS '目的ID';
COMMENT ON COLUMN flowlet.m_purpose.account_id IS '所属口座ID';
COMMENT ON COLUMN flowlet.m_purpose.purpose_name IS '目的名';
COMMENT ON COLUMN flowlet.m_purpose.allocated_amount IS '割当金額（円）';
COMMENT ON COLUMN flowlet.m_purpose.created_at IS '作成日時';
COMMENT ON COLUMN flowlet.m_purpose.updated_at IS '更新日時';

CREATE UNIQUE INDEX ux_m_purpose_account_name
    ON flowlet.m_purpose(account_id, purpose_name);

-- =========================================
-- t_transaction
-- =========================================
CREATE TABLE flowlet.t_transaction (
    transaction_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    transaction_type VARCHAR(20) NOT NULL,
    transaction_amount BIGINT NOT NULL,

    from_account_id UUID,
    from_purpose_id UUID,
    to_account_id UUID,
    to_purpose_id UUID,

    memo VARCHAR(300),

    is_income_expense_target BOOLEAN NOT NULL,
    occurred_at TIMESTAMPTZ NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_tx_from_account
        FOREIGN KEY (from_account_id)
        REFERENCES flowlet.m_account(account_id),

    CONSTRAINT fk_tx_to_account
        FOREIGN KEY (to_account_id)
        REFERENCES flowlet.m_account(account_id),

    CONSTRAINT fk_tx_from_purpose
        FOREIGN KEY (from_purpose_id)
        REFERENCES flowlet.m_purpose(purpose_id),

    CONSTRAINT fk_tx_to_purpose
        FOREIGN KEY (to_purpose_id)
        REFERENCES flowlet.m_purpose(purpose_id),

    CONSTRAINT chk_transaction_type
        CHECK (transaction_type IN ('INCOME', 'EXPENSE', 'TRANSFER')),

    CONSTRAINT chk_transaction_amount_positive
        CHECK (transaction_amount > 0),

    CONSTRAINT chk_transaction_direction
        CHECK (
            -- 収入
            (transaction_type = 'INCOME'
                AND from_account_id IS NULL
                AND to_account_id IS NOT NULL)

            OR
            -- 支出
            (transaction_type = 'EXPENSE'
                AND from_account_id IS NOT NULL
                AND to_account_id IS NULL)

            OR
            -- 振替
            (transaction_type = 'TRANSFER'
                AND from_account_id IS NOT NULL
                AND to_account_id IS NOT NULL
                AND is_income_expense_target = FALSE)
        )
);

COMMENT ON TABLE flowlet.t_transaction IS '取引トランザクション';

COMMENT ON COLUMN flowlet.t_transaction.transaction_id IS '取引ID';
COMMENT ON COLUMN flowlet.t_transaction.transaction_type IS '取引種別（INCOME / EXPENSE / TRANSFER）';
COMMENT ON COLUMN flowlet.t_transaction.transaction_amount IS '取引金額（円）';

COMMENT ON COLUMN flowlet.t_transaction.from_account_id IS '出金元口座ID';
COMMENT ON COLUMN flowlet.t_transaction.from_purpose_id IS '出金元目的ID';
COMMENT ON COLUMN flowlet.t_transaction.to_account_id IS '入金先口座ID';
COMMENT ON COLUMN flowlet.t_transaction.to_purpose_id IS '入金先目的ID';

COMMENT ON COLUMN flowlet.t_transaction.memo IS 'メモ';

COMMENT ON COLUMN flowlet.t_transaction.is_income_expense_target IS '収支計算対象フラグ';
COMMENT ON COLUMN flowlet.t_transaction.occurred_at IS '取引発生日';

COMMENT ON COLUMN flowlet.t_transaction.created_at IS '作成日時';
COMMENT ON COLUMN flowlet.t_transaction.updated_at IS '更新日時';

-- =========================================
-- Index
-- =========================================
CREATE INDEX ix_t_transaction_occurred_at
    ON flowlet.t_transaction(occurred_at);

CREATE INDEX ix_t_transaction_from_account
    ON flowlet.t_transaction(from_account_id);

CREATE INDEX ix_t_transaction_to_account
    ON flowlet.t_transaction(to_account_id);
