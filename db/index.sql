-- flowlet.m_accounts
CREATE INDEX idx_m_accounts_user_id ON flowlet.m_accounts(user_id);

-- flowlet.m_credit_cards
CREATE INDEX idx_m_credit_cards_user_id ON flowlet.m_credit_cards(user_id);
CREATE INDEX idx_m_credit_cards_withdrawal_account_id ON flowlet.m_credit_cards(withdrawal_account_id);

-- flowlet.m_categories
CREATE INDEX idx_m_categories_user_id ON flowlet.m_categories(user_id);
CREATE INDEX idx_m_categories_parent_category_id ON flowlet.m_categories(parent_category_id);

-- flowlet.m_savings_goals
CREATE INDEX idx_m_savings_goals_user_id ON flowlet.m_savings_goals(user_id);

-- flowlet.m_recurring_expenses
CREATE INDEX idx_m_recurring_expenses_user_id ON flowlet.m_recurring_expenses(user_id);

-- flowlet.t_transactions
CREATE INDEX idx_t_transactions_user_id ON flowlet.t_transactions(user_id);
CREATE INDEX idx_t_transactions_date ON flowlet.t_transactions(transaction_date);
CREATE INDEX idx_t_transactions_category_id ON flowlet.t_transactions(category_id);
CREATE INDEX idx_t_transactions_account_id ON flowlet.t_transactions(account_id);
CREATE INDEX idx_t_transactions_credit_card_id ON flowlet.t_transactions(credit_card_id);

-- flowlet.t_budgets
CREATE INDEX idx_t_budgets_user_id ON flowlet.t_budgets(user_id);
CREATE INDEX idx_t_budgets_cycle_dates ON flowlet.t_budgets(cycle_start_date, cycle_end_date);

-- flowlet.t_savings_allocations
CREATE INDEX idx_t_savings_allocations_transaction_id ON flowlet.t_savings_allocations(transaction_id);
CREATE INDEX idx_t_savings_allocations_goal_id ON flowlet.t_savings_allocations(savings_goal_id);
