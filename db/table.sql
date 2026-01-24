CREATE TABLE flowlet.m_app_settings (
                                        app_settings_id VARCHAR(10) PRIMARY KEY DEFAULT ('SET' || LPAD(NEXTVAL('flowlet.seq_m_app_settings')::TEXT, 7, '0')),
                                        user_id VARCHAR(10),
                                        payday INTEGER NOT NULL CHECK (payday BETWEEN 1 AND 31),
                                        created_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                        updated_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE flowlet.m_app_settings IS 'アプリ設定';
COMMENT ON COLUMN flowlet.m_app_settings.app_settings_id IS '設定ID';
COMMENT ON COLUMN flowlet.m_app_settings.user_id IS 'ユーザーID';
COMMENT ON COLUMN flowlet.m_app_settings.payday IS '給料日(1-31、土日祝は前営業日に自動調整)';

CREATE TABLE flowlet.m_users (
                                 user_id VARCHAR(10) PRIMARY KEY DEFAULT ('USR' || LPAD(NEXTVAL('flowlet.seq_m_users')::TEXT, 7, '0')),
                                 username VARCHAR(255) NOT NULL UNIQUE,
                                 email VARCHAR(255) NOT NULL UNIQUE,
                                 password_hash VARCHAR(255) NOT NULL,
                                 created_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                 updated_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE flowlet.m_users IS 'ユーザー';
COMMENT ON COLUMN flowlet.m_users.user_id IS 'ユーザーID';
COMMENT ON COLUMN flowlet.m_users.username IS 'ユーザー名';
COMMENT ON COLUMN flowlet.m_users.email IS 'メールアドレス';
COMMENT ON COLUMN flowlet.m_users.password_hash IS 'パスワードハッシュ';

CREATE TABLE flowlet.m_accounts (
                                    account_id VARCHAR(10) PRIMARY KEY DEFAULT ('ACC' || LPAD(NEXTVAL('flowlet.seq_m_accounts')::TEXT, 7, '0')),
                                    user_id VARCHAR(10),
                                    account_name VARCHAR(100) NOT NULL,
                                    initial_balance DECIMAL(15, 2) NOT NULL DEFAULT 0,
                                    current_balance DECIMAL(15, 2) NOT NULL DEFAULT 0,
                                    is_savings_account BOOLEAN NOT NULL DEFAULT FALSE,
                                    created_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    updated_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE flowlet.m_accounts IS '口座';
COMMENT ON COLUMN flowlet.m_accounts.account_id IS '口座ID';
COMMENT ON COLUMN flowlet.m_accounts.user_id IS 'ユーザーID';
COMMENT ON COLUMN flowlet.m_accounts.account_name IS '口座名';
COMMENT ON COLUMN flowlet.m_accounts.initial_balance IS '初期残高';
COMMENT ON COLUMN flowlet.m_accounts.current_balance IS '現在残高';
COMMENT ON COLUMN flowlet.m_accounts.is_savings_account IS '貯金用口座フラグ';

CREATE TABLE flowlet.m_credit_cards (
                                        credit_card_id VARCHAR(10) PRIMARY KEY DEFAULT ('CRD' || LPAD(NEXTVAL('flowlet.seq_m_credit_cards')::TEXT, 7, '0')),
                                        user_id VARCHAR(10),
                                        card_name VARCHAR(100) NOT NULL,
                                        withdrawal_account_id VARCHAR(10) NOT NULL,
                                        withdrawal_day INTEGER NOT NULL CHECK (withdrawal_day BETWEEN 1 AND 31),
                                        weekend_handling VARCHAR(20) NOT NULL CHECK (weekend_handling IN ('NEXT_BUSINESS_DAY', 'PREVIOUS_BUSINESS_DAY')),
                                        payment_cycle VARCHAR(20) NOT NULL CHECK (payment_cycle IN ('CURRENT_MONTH', 'NEXT_MONTH', 'TWO_MONTHS_LATER')),
                                        created_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                        updated_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                        FOREIGN KEY (withdrawal_account_id) REFERENCES flowlet.m_accounts(account_id)
);

COMMENT ON TABLE flowlet.m_credit_cards IS 'クレジットカード';
COMMENT ON COLUMN flowlet.m_credit_cards.credit_card_id IS 'クレジットカードID';
COMMENT ON COLUMN flowlet.m_credit_cards.card_name IS 'カード名';
COMMENT ON COLUMN flowlet.m_credit_cards.withdrawal_account_id IS '引き落とし口座ID';
COMMENT ON COLUMN flowlet.m_credit_cards.withdrawal_day IS '引き落とし日(1-31)';
COMMENT ON COLUMN flowlet.m_credit_cards.weekend_handling IS '土日祝の扱い';
COMMENT ON COLUMN flowlet.m_credit_cards.payment_cycle IS '支払いサイクル';

CREATE TABLE flowlet.m_categories (
                                      category_id VARCHAR(10) PRIMARY KEY DEFAULT ('CAT' || LPAD(NEXTVAL('flowlet.seq_m_categories')::TEXT, 7, '0')),
                                      user_id VARCHAR(10),
                                      category_name VARCHAR(100) NOT NULL,
                                      category_type VARCHAR(20) NOT NULL CHECK (category_type IN ('INCOME', 'EXPENSE')),
                                      parent_category_id VARCHAR(10),
                                      is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
                                      created_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      updated_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                      updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      FOREIGN KEY (parent_category_id) REFERENCES flowlet.m_categories(category_id)
);

COMMENT ON TABLE flowlet.m_categories IS 'カテゴリ';
COMMENT ON COLUMN flowlet.m_categories.category_id IS 'カテゴリID';
COMMENT ON COLUMN flowlet.m_categories.category_name IS 'カテゴリ名';
COMMENT ON COLUMN flowlet.m_categories.category_type IS 'カテゴリ種別';
COMMENT ON COLUMN flowlet.m_categories.parent_category_id IS '親カテゴリID(NULL: 大カテゴリ)';
COMMENT ON COLUMN flowlet.m_categories.is_deleted IS '削除フラグ';

CREATE TABLE flowlet.m_savings_goals (
                                         savings_goal_id VARCHAR(10) PRIMARY KEY DEFAULT ('SVG' || LPAD(NEXTVAL('flowlet.seq_m_savings_goals')::TEXT, 7, '0')),
                                         user_id VARCHAR(10),
                                         goal_name VARCHAR(100) NOT NULL,
                                         target_amount DECIMAL(15, 2),
                                         current_amount DECIMAL(15, 2) NOT NULL DEFAULT 0,
                                         created_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                         created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         updated_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                         updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE flowlet.m_savings_goals IS '貯金目標';
COMMENT ON COLUMN flowlet.m_savings_goals.savings_goal_id IS '貯金目標ID';
COMMENT ON COLUMN flowlet.m_savings_goals.goal_name IS '目標名';
COMMENT ON COLUMN flowlet.m_savings_goals.target_amount IS '目標金額(NULL可: 退避用など)';
COMMENT ON COLUMN flowlet.m_savings_goals.current_amount IS '現在の積立額';

CREATE TABLE flowlet.m_recurring_expenses (
                                              recurring_expense_id VARCHAR(10) PRIMARY KEY DEFAULT ('REC' || LPAD(NEXTVAL('flowlet.seq_m_recurring_expenses')::TEXT, 7, '0')),
                                              user_id VARCHAR(10),
                                              expense_name VARCHAR(100) NOT NULL,
                                              amount DECIMAL(15, 2) NOT NULL,
                                              category_id VARCHAR(10) NOT NULL,
                                              account_id VARCHAR(10),
                                              credit_card_id VARCHAR(10),
                                              payment_day INTEGER NOT NULL CHECK (payment_day BETWEEN 1 AND 31),
                                              memo TEXT,
                                              created_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                              created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                              updated_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                              updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                              FOREIGN KEY (category_id) REFERENCES flowlet.m_categories(category_id),
                                              FOREIGN KEY (account_id) REFERENCES flowlet.m_accounts(account_id),
                                              FOREIGN KEY (credit_card_id) REFERENCES flowlet.m_credit_cards(credit_card_id),
                                              CHECK ((account_id IS NOT NULL AND credit_card_id IS NULL) OR (account_id IS NULL AND credit_card_id IS NOT NULL))
);

COMMENT ON TABLE flowlet.m_recurring_expenses IS '繰り返し支出設定';
COMMENT ON COLUMN flowlet.m_recurring_expenses.recurring_expense_id IS '繰り返し支出ID';
COMMENT ON COLUMN flowlet.m_recurring_expenses.expense_name IS '支出名';
COMMENT ON COLUMN flowlet.m_recurring_expenses.amount IS '金額';
COMMENT ON COLUMN flowlet.m_recurring_expenses.payment_day IS '支払日';

CREATE TABLE flowlet.t_transactions (
                                        transaction_id VARCHAR(10) PRIMARY KEY DEFAULT ('TRX' || LPAD(NEXTVAL('flowlet.seq_t_transactions')::TEXT, 7, '0')),
                                        user_id VARCHAR(10),
                                        transaction_date DATE NOT NULL,
                                        transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('INCOME', 'EXPENSE', 'TRANSFER')),
                                        amount DECIMAL(15, 2) NOT NULL,
                                        category_id VARCHAR(10),
                                        account_id VARCHAR(10),
                                        credit_card_id VARCHAR(10),
                                        from_account_id VARCHAR(10),
                                        to_account_id VARCHAR(10),
                                        memo TEXT,
                                        created_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                        updated_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                        FOREIGN KEY (category_id) REFERENCES flowlet.m_categories(category_id),
                                        FOREIGN KEY (account_id) REFERENCES flowlet.m_accounts(account_id),
                                        FOREIGN KEY (credit_card_id) REFERENCES flowlet.m_credit_cards(credit_card_id),
                                        FOREIGN KEY (from_account_id) REFERENCES flowlet.m_accounts(account_id),
                                        FOREIGN KEY (to_account_id) REFERENCES flowlet.m_accounts(account_id)
);

COMMENT ON TABLE flowlet.t_transactions IS '取引記録';
COMMENT ON COLUMN flowlet.t_transactions.transaction_id IS '取引ID';
COMMENT ON COLUMN flowlet.t_transactions.transaction_date IS '取引日';
COMMENT ON COLUMN flowlet.t_transactions.transaction_type IS '取引種別';
COMMENT ON COLUMN flowlet.t_transactions.amount IS '金額';

CREATE TABLE flowlet.t_budgets (
                                   budget_id VARCHAR(10) PRIMARY KEY DEFAULT ('BDG' || LPAD(NEXTVAL('flowlet.seq_t_budgets')::TEXT, 7, '0')),
                                   user_id VARCHAR(10),
                                   cycle_start_date DATE NOT NULL,
                                   cycle_end_date DATE NOT NULL,
                                   category_id VARCHAR(10),
                                   budget_amount DECIMAL(15, 2) NOT NULL,
                                   created_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                   created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   updated_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                   updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   FOREIGN KEY (category_id) REFERENCES flowlet.m_categories(category_id),
                                   UNIQUE (user_id, cycle_start_date, category_id)
);

COMMENT ON TABLE flowlet.t_budgets IS '予算設定';
COMMENT ON COLUMN flowlet.t_budgets.budget_id IS '予算ID';
COMMENT ON COLUMN flowlet.t_budgets.cycle_start_date IS 'サイクル開始日';
COMMENT ON COLUMN flowlet.t_budgets.cycle_end_date IS 'サイクル終了日';
COMMENT ON COLUMN flowlet.t_budgets.category_id IS 'カテゴリID(NULL: 全体予算)';
COMMENT ON COLUMN flowlet.t_budgets.budget_amount IS '予算額';

CREATE TABLE flowlet.t_savings_allocations (
                                               savings_allocation_id VARCHAR(10) PRIMARY KEY DEFAULT ('SAL' || LPAD(NEXTVAL('flowlet.seq_t_savings_allocations')::TEXT, 7, '0')),
                                               transaction_id VARCHAR(10) NOT NULL,
                                               savings_goal_id VARCHAR(10) NOT NULL,
                                               allocation_amount DECIMAL(15, 2) NOT NULL,
                                               created_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                               created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                               updated_by VARCHAR(10) NOT NULL DEFAULT 'system',
                                               updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                               FOREIGN KEY (transaction_id) REFERENCES flowlet.t_transactions(transaction_id) ON DELETE CASCADE,
                                               FOREIGN KEY (savings_goal_id) REFERENCES flowlet.m_savings_goals(savings_goal_id)
);

COMMENT ON TABLE flowlet.t_savings_allocations IS '貯金割り当て';
COMMENT ON COLUMN flowlet.t_savings_allocations.savings_allocation_id IS '貯金割り当てID';
COMMENT ON COLUMN flowlet.t_savings_allocations.transaction_id IS '取引ID';
COMMENT ON COLUMN flowlet.t_savings_allocations.savings_goal_id IS '貯金目標ID';
COMMENT ON COLUMN flowlet.t_savings_allocations.allocation_amount IS '割り当て額';
