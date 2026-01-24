-- スキーマ作成
CREATE SCHEMA IF NOT EXISTS flowlet;

-- マスタテーブル用Sequence
CREATE SEQUENCE flowlet.seq_m_app_settings START 1 INCREMENT 1;
CREATE SEQUENCE flowlet.seq_m_users START 1 INCREMENT 1;
CREATE SEQUENCE flowlet.seq_m_accounts START 1 INCREMENT 1;
CREATE SEQUENCE flowlet.seq_m_credit_cards START 1 INCREMENT 1;
CREATE SEQUENCE flowlet.seq_m_categories START 1 INCREMENT 1;
CREATE SEQUENCE flowlet.seq_m_savings_goals START 1 INCREMENT 1;
CREATE SEQUENCE flowlet.seq_m_recurring_expenses START 1 INCREMENT 1;

-- トランザクションテーブル用Sequence
CREATE SEQUENCE flowlet.seq_t_transactions START 1 INCREMENT 1;
CREATE SEQUENCE flowlet.seq_t_budgets START 1 INCREMENT 1;
CREATE SEQUENCE flowlet.seq_t_savings_allocations START 1 INCREMENT 1;
