# FLOWLET API設計書

## 1. 概要

本ドキュメントはFLOWLETアプリケーションのREST APIの詳細仕様を定義します。

### API基本方針

- **ベースURL**: `/api`
- **URL設計**: RESTfulなリソースベース
- **バージョニング**: なし
- **認証**: JWT (Authorization: Bearer {token}) ※後回し
- **HTTPメソッド**: GET(取得), POST(作成), PUT(更新), DELETE(削除)
- **レスポンス形式**: JSON (シンプル形式)
- **命名規則**: キャメルケース

### HTTPステータスコード

- `200 OK`: 成功(GET, PUT)
- `201 Created`: 作成成功(POST)
- `204 No Content`: 削除成功(DELETE)
- `400 Bad Request`: バリデーションエラー
- `404 Not Found`: リソースが見つからない
- `500 Internal Server Error`: サーバーエラー

---

## 2. エンドポイント一覧

### アプリ設定 (App Settings)

| メソッド | エンドポイント           | 説明      |
|------|-------------------|---------|
| GET  | /api/app-settings | アプリ設定取得 |
| PUT  | /api/app-settings | アプリ設定更新 |

### 口座 (Accounts)

| メソッド   | エンドポイント                   | 説明     |
|--------|---------------------------|--------|
| GET    | /api/accounts             | 口座一覧取得 |
| POST   | /api/accounts             | 口座作成   |
| GET    | /api/accounts/{accountId} | 口座詳細取得 |
| PUT    | /api/accounts/{accountId} | 口座更新   |
| DELETE | /api/accounts/{accountId} | 口座削除   |

### クレジットカード (Credit Cards)

| メソッド   | エンドポイント                                | 説明           |
|--------|----------------------------------------|--------------|
| GET    | /api/credit-cards                      | クレジットカード一覧取得 |
| POST   | /api/credit-cards                      | クレジットカード作成   |
| GET    | /api/credit-cards/{creditCardId}       | クレジットカード詳細取得 |
| PUT    | /api/credit-cards/{creditCardId}       | クレジットカード更新   |
| DELETE | /api/credit-cards/{creditCardId}       | クレジットカード削除   |
| GET    | /api/credit-cards/{creditCardId}/usage | カード利用状況取得    |

### カテゴリ (Categories)

| メソッド   | エンドポイント                      | 説明       |
|--------|------------------------------|----------|
| GET    | /api/categories              | カテゴリ一覧取得 |
| POST   | /api/categories              | カテゴリ作成   |
| GET    | /api/categories/{categoryId} | カテゴリ詳細取得 |
| PUT    | /api/categories/{categoryId} | カテゴリ更新   |
| DELETE | /api/categories/{categoryId} | カテゴリ削除   |

### 貯金目標 (Savings Goals)

| メソッド   | エンドポイント                            | 説明          |
|--------|------------------------------------|-------------|
| GET    | /api/savings-goals                 | 貯金目標一覧取得    |
| POST   | /api/savings-goals                 | 貯金目標作成      |
| GET    | /api/savings-goals/{savingsGoalId} | 貯金目標詳細取得    |
| PUT    | /api/savings-goals/{savingsGoalId} | 貯金目標更新      |
| DELETE | /api/savings-goals/{savingsGoalId} | 貯金目標削除      |
| GET    | /api/savings-goals/summary         | 貯金用口座サマリー取得 |

### 繰り返し支出 (Recurring Expenses)

| メソッド   | エンドポイント                                      | 説明               |
|--------|----------------------------------------------|------------------|
| GET    | /api/recurring-expenses                      | 繰り返し支出一覧取得       |
| POST   | /api/recurring-expenses                      | 繰り返し支出作成         |
| GET    | /api/recurring-expenses/{recurringExpenseId} | 繰り返し支出詳細取得       |
| PUT    | /api/recurring-expenses/{recurringExpenseId} | 繰り返し支出更新         |
| DELETE | /api/recurring-expenses/{recurringExpenseId} | 繰り返し支出削除         |
| GET    | /api/recurring-expenses/pending              | 未入力の繰り返し支出取得     |
| POST   | /api/recurring-expenses/apply                | 繰り返し支出を取引として一括登録 |

### 取引 (Transactions)

| メソッド   | エンドポイント                           | 説明     |
|--------|-----------------------------------|--------|
| GET    | /api/transactions                 | 取引一覧取得 |
| POST   | /api/transactions                 | 取引作成   |
| GET    | /api/transactions/{transactionId} | 取引詳細取得 |
| PUT    | /api/transactions/{transactionId} | 取引更新   |
| DELETE | /api/transactions/{transactionId} | 取引削除   |

### 予算 (Budgets)

| メソッド   | エンドポイント                 | 説明                |
|--------|-------------------------|-------------------|
| GET    | /api/budgets            | 予算一覧取得            |
| POST   | /api/budgets            | 予算作成              |
| GET    | /api/budgets/{budgetId} | 予算詳細取得            |
| PUT    | /api/budgets/{budgetId} | 予算更新              |
| DELETE | /api/budgets/{budgetId} | 予算削除              |
| GET    | /api/budgets/current    | 現在のサイクルの予算と使用状況取得 |

### 統計・レポート (Reports)

| メソッド | エンドポイント                         | 説明            |
|------|---------------------------------|---------------|
| GET  | /api/reports/dashboard          | ダッシュボード情報取得   |
| GET  | /api/reports/cycle-summary      | サイクル別収支サマリー取得 |
| GET  | /api/reports/category-breakdown | カテゴリ別支出内訳取得   |
| GET  | /api/reports/comparison         | 前期間比較取得       |
| GET  | /api/reports/annual-summary     | 年間サマリー取得      |
| GET  | /api/reports/category-trend     | カテゴリ別推移取得     |

### ユーティリティ (Utilities)

| メソッド | エンドポイント             | 説明          |
|------|---------------------|-------------|
| GET  | /api/cycles/current | 現在のサイクル情報取得 |
| GET  | /api/cycles         | サイクル一覧取得    |

---

## 3. API詳細仕様

### 3.1 アプリ設定 (App Settings)

#### GET /api/app-settings

アプリ設定を取得

**レスポンス:** 200 OK

```json
{
  "appSettingsId": "SET0000001",
  "payday": 25
}
```

**エラー:** 404 Not Found

```json
{
  "error": "App settings not found",
  "code": "NOT_FOUND"
}
```

---

#### PUT /api/app-settings

アプリ設定を更新(初回は作成)

**リクエストボディ:**

```json
{
  "payday": 25
}
```

**バリデーション:**

- `payday`: 必須、1〜31の整数

**レスポンス:** 200 OK

```json
{
  "appSettingsId": "SET0000001",
  "payday": 25
}
```

**エラー:** 400 Bad Request

```json
{
  "error": "Invalid payday value",
  "code": "VALIDATION_ERROR"
}
```

---

### 3.2 口座 (Accounts)

#### GET /api/accounts

口座一覧を取得

**レスポンス:** 200 OK

```json
[
  {
    "accountId": "ACC0000001",
    "accountName": "みずほ銀行メイン口座",
    "initialBalance": 100000.00,
    "currentBalance": 125000.00,
    "isSavingsAccount": false
  },
  {
    "accountId": "ACC0000002",
    "accountName": "貯金用口座",
    "initialBalance": 0.00,
    "currentBalance": 500000.00,
    "isSavingsAccount": true
  }
]
```

---

#### POST /api/accounts

口座を新規作成

**リクエストボディ:**

```json
{
  "accountName": "三菱UFJ銀行",
  "initialBalance": 50000.00,
  "isSavingsAccount": false
}
```

**バリデーション:**

- `accountName`: 必須、100文字以内
- `initialBalance`: 必須、数値
- `isSavingsAccount`: 必須、boolean

**レスポンス:** 201 Created

```json
{
  "accountId": "ACC0000003",
  "accountName": "三菱UFJ銀行",
  "initialBalance": 50000.00,
  "currentBalance": 50000.00,
  "isSavingsAccount": false
}
```

---

#### GET /api/accounts/{accountId}

口座詳細を取得

**レスポンス:** 200 OK

```json
{
  "accountId": "ACC0000001",
  "accountName": "みずほ銀行メイン口座",
  "initialBalance": 100000.00,
  "currentBalance": 125000.00,
  "isSavingsAccount": false
}
```

**エラー:** 404 Not Found

```json
{
  "error": "Account not found",
  "code": "NOT_FOUND"
}
```

---

#### PUT /api/accounts/{accountId}

口座情報を更新

**リクエストボディ:**

```json
{
  "accountName": "みずほ銀行メイン口座(更新)",
  "isSavingsAccount": false
}
```

**バリデーション:**

- `accountName`: 任意、100文字以内
- `isSavingsAccount`: 任意、boolean
- ※ `initialBalance`, `currentBalance` は更新不可

**レスポンス:** 200 OK

```json
{
  "accountId": "ACC0000001",
  "accountName": "みずほ銀行メイン口座(更新)",
  "initialBalance": 100000.00,
  "currentBalance": 125000.00,
  "isSavingsAccount": false
}
```

---

#### DELETE /api/accounts/{accountId}

口座を削除

**レスポンス:** 204 No Content

**エラー:** 400 Bad Request

```json
{
  "error": "Cannot delete account with existing transactions",
  "code": "CONSTRAINT_VIOLATION"
}
```

---

### 3.3 クレジットカード (Credit Cards)

#### GET /api/credit-cards

クレジットカード一覧を取得

**レスポンス:** 200 OK

```json
[
  {
    "creditCardId": "CRD0000001",
    "cardName": "楽天カード",
    "withdrawalAccountId": "ACC0000001",
    "closingDay": "END_OF_MONTH",
    "withdrawalDay": 27,
    "weekendHandling": "NEXT_BUSINESS_DAY"
  },
  {
    "creditCardId": "CRD0000002",
    "cardName": "三井住友カード",
    "withdrawalAccountId": "ACC0000002",
    "closingDay": 15,
    "withdrawalDay": 10,
    "weekendHandling": "NO_CHANGE"
  }
]
```

---

#### POST /api/credit-cards

クレジットカードを新規作成

**リクエストボディ:**

```json
{
  "cardName": "エポスカード",
  "withdrawalAccountId": "ACC0000001",
  "closingDay": "END_OF_MONTH",
  "withdrawalDay": 27,
  "weekendHandling": "NEXT_BUSINESS_DAY"
}
```

**バリデーション:**

- `cardName`: 必須、100文字以内
- `withdrawalAccountId`: 必須、存在する口座ID
- `closingDay`: 必須、1〜31 または "END_OF_MONTH"
- `withdrawalDay`: 必須、1〜31
- `weekendHandling`: 必須、"NEXT_BUSINESS_DAY" / "PREVIOUS_BUSINESS_DAY" / "NO_CHANGE"

**レスポンス:** 201 Created

```json
{
  "creditCardId": "CRD0000003",
  "cardName": "エポスカード",
  "withdrawalAccountId": "ACC0000001",
  "closingDay": "END_OF_MONTH",
  "withdrawalDay": 27,
  "weekendHandling": "NEXT_BUSINESS_DAY"
}
```

---

#### GET /api/credit-cards/{creditCardId}

クレジットカード詳細を取得

**レスポンス:** 200 OK

```json
{
  "creditCardId": "CRD0000001",
  "cardName": "楽天カード",
  "withdrawalAccountId": "ACC0000001",
  "closingDay": "END_OF_MONTH",
  "withdrawalDay": 27,
  "weekendHandling": "NEXT_BUSINESS_DAY"
}
```

---

#### PUT /api/credit-cards/{creditCardId}

クレジットカード情報を更新

**リクエストボディ:**

```json
{
  "cardName": "楽天カード(更新)",
  "withdrawalAccountId": "ACC0000001",
  "closingDay": "END_OF_MONTH",
  "withdrawalDay": 27,
  "weekendHandling": "NEXT_BUSINESS_DAY"
}
```

**レスポンス:** 200 OK

```json
{
  "creditCardId": "CRD0000001",
  "cardName": "楽天カード(更新)",
  "withdrawalAccountId": "ACC0000001",
  "closingDay": "END_OF_MONTH",
  "withdrawalDay": 27,
  "weekendHandling": "NEXT_BUSINESS_DAY"
}
```

---

#### DELETE /api/credit-cards/{creditCardId}

クレジットカードを削除

**レスポンス:** 204 No Content

**エラー:** 400 Bad Request

```json
{
  "error": "Cannot delete credit card with existing transactions",
  "code": "CONSTRAINT_VIOLATION"
}
```

---

#### GET /api/credit-cards/{creditCardId}/usage

カード利用状況を取得

**レスポンス:** 200 OK

```json
{
  "creditCardId": "CRD0000001",
  "cardName": "楽天カード",
  "currentPeriodUsage": 85000.00,
  "currentPeriod": {
    "startDate": "2024-01-01",
    "endDate": "2024-01-31"
  },
  "nextWithdrawal": {
    "withdrawalDate": "2024-02-27",
    "withdrawalAmount": 120000.00,
    "withdrawalAccountId": "ACC0000001",
    "accountBalance": 150000.00,
    "additionalAmountNeeded": 0.00
  }
}
```

---

### 3.4 カテゴリ (Categories)

#### GET /api/categories

カテゴリ一覧を取得(階層構造)

**クエリパラメータ:**

- `type`: 任意、"INCOME" / "EXPENSE" (指定がない場合は全て)

**レスポンス:** 200 OK

```json
[
  {
    "categoryId": "CAT0000001",
    "categoryName": "食費",
    "categoryType": "EXPENSE",
    "parentCategoryId": null,
    "isDeleted": false,
    "children": [
      {
        "categoryId": "CAT0000002",
        "categoryName": "食料品",
        "categoryType": "EXPENSE",
        "parentCategoryId": "CAT0000001",
        "isDeleted": false
      },
      {
        "categoryId": "CAT0000003",
        "categoryName": "外食",
        "categoryType": "EXPENSE",
        "parentCategoryId": "CAT0000001",
        "isDeleted": false
      }
    ]
  },
  {
    "categoryId": "CAT0000004",
    "categoryName": "交通費",
    "categoryType": "EXPENSE",
    "parentCategoryId": null,
    "isDeleted": false,
    "children": []
  }
]
```

---

#### POST /api/categories

カテゴリを新規作成

**リクエストボディ(大カテゴリ):**

```json
{
  "categoryName": "娯楽費",
  "categoryType": "EXPENSE",
  "parentCategoryId": null
}
```

**リクエストボディ(小カテゴリ):**

```json
{
  "categoryName": "映画",
  "categoryType": "EXPENSE",
  "parentCategoryId": "CAT0000005"
}
```

**バリデーション:**

- `categoryName`: 必須、100文字以内
- `categoryType`: 必須、"INCOME" / "EXPENSE"
- `parentCategoryId`: 任意、存在するカテゴリID(null = 大カテゴリ)

**レスポンス:** 201 Created

```json
{
  "categoryId": "CAT0000006",
  "categoryName": "娯楽費",
  "categoryType": "EXPENSE",
  "parentCategoryId": null,
  "isDeleted": false
}
```

---

#### GET /api/categories/{categoryId}

カテゴリ詳細を取得

**レスポンス:** 200 OK

```json
{
  "categoryId": "CAT0000001",
  "categoryName": "食費",
  "categoryType": "EXPENSE",
  "parentCategoryId": null,
  "isDeleted": false,
  "children": [
    {
      "categoryId": "CAT0000002",
      "categoryName": "食料品",
      "categoryType": "EXPENSE",
      "parentCategoryId": "CAT0000001",
      "isDeleted": false
    }
  ]
}
```

---

#### PUT /api/categories/{categoryId}

カテゴリ情報を更新

**リクエストボディ:**

```json
{
  "categoryName": "食費(更新)",
  "parentCategoryId": null
}
```

**バリデーション:**

- `categoryName`: 任意、100文字以内
- `parentCategoryId`: 任意、存在するカテゴリID
- ※ `categoryType` は変更不可

**レスポンス:** 200 OK

```json
{
  "categoryId": "CAT0000001",
  "categoryName": "食費(更新)",
  "categoryType": "EXPENSE",
  "parentCategoryId": null,
  "isDeleted": false
}
```

---

#### DELETE /api/categories/{categoryId}

カテゴリを論理削除

**レスポンス:** 204 No Content

**補足:**

- 実際にはレコードを削除せず、`isDeleted = true` に更新
- 既存の取引は「削除済みカテゴリ」として表示される

---

### 3.5 貯金目標 (Savings Goals)

#### GET /api/savings-goals

貯金目標一覧を取得

**レスポンス:** 200 OK

```json
[
  {
    "savingsGoalId": "SVG0000001",
    "accountId": "ACC0000002",
    "goalName": "旅行貯金",
    "targetAmount": 500000.00,
    "currentAmount": 300000.00,
    "achievementRate": 60.0
  },
  {
    "savingsGoalId": "SVG0000002",
    "accountId": "ACC0000002",
    "goalName": "車購入",
    "targetAmount": 2000000.00,
    "currentAmount": 800000.00,
    "achievementRate": 40.0
  },
  {
    "savingsGoalId": "SVG0000003",
    "accountId": "ACC0000003",
    "goalName": "緊急資金",
    "targetAmount": null,
    "currentAmount": 150000.00,
    "achievementRate": null
  }
]
```

---

#### POST /api/savings-goals

貯金目標を新規作成

**リクエストボディ:**

```json
{
  "accountId": "ACC0000002",
  "goalName": "結婚資金",
  "targetAmount": 1000000.00
}
```

**バリデーション:**

- `accountId`: 必須、存在する貯金用口座のID (`isSavingsAccount = true`)
- `goalName`: 必須、100文字以内
- `targetAmount`: 任意、数値またはnull

**レスポンス:** 201 Created

```json
{
  "savingsGoalId": "SVG0000004",
  "accountId": "ACC0000002",
  "goalName": "結婚資金",
  "targetAmount": 1000000.00,
  "currentAmount": 0.00,
  "achievementRate": 0.0
}
```

---

#### GET /api/savings-goals/{savingsGoalId}

貯金目標詳細を取得

**レスポンス:** 200 OK

```json
{
  "savingsGoalId": "SVG0000001",
  "accountId": "ACC0000002",
  "goalName": "旅行貯金",
  "targetAmount": 500000.00,
  "currentAmount": 300000.00,
  "achievementRate": 60.0
}
```

---

#### PUT /api/savings-goals/{savingsGoalId}

貯金目標を更新

**リクエストボディ:**

```json
{
  "accountId": "ACC0000003",
  "goalName": "海外旅行貯金",
  "targetAmount": 600000.00
}
```

**バリデーション:**

- ※ `currentAmount` は更新不可(口座間移動で自動計算)

**レスポンス:** 200 OK

```json
{
  "savingsGoalId": "SVG0000001",
  "accountId": "ACC0000003",
  "goalName": "海外旅行貯金",
  "targetAmount": 600000.00,
  "currentAmount": 300000.00,
  "achievementRate": 50.0
}
```

---

#### DELETE /api/savings-goals/{savingsGoalId}

貯金目標を削除

**レスポンス:** 204 No Content

**エラー:** 400 Bad Request

```json
{
  "error": "Cannot delete savings goal with current amount",
  "code": "CONSTRAINT_VIOLATION"
}
```

---

#### GET /api/savings-goals/summary

全貯金用口座のサマリーを取得

**レスポンス:** 200 OK

```json
{
  "savingsAccounts": [
    {
      "accountId": "ACC0000002",
      "accountName": "三菱UFJ貯金用",
      "totalBalance": 1200000.00,
      "allocatedAmount": 1100000.00,
      "unallocatedAmount": 100000.00,
      "goals": [
        {
          "savingsGoalId": "SVG0000001",
          "goalName": "旅行貯金",
          "currentAmount": 300000.00
        },
        {
          "savingsGoalId": "SVG0000002",
          "goalName": "車購入",
          "currentAmount": 800000.00
        }
      ]
    },
    {
      "accountId": "ACC0000003",
      "accountName": "ゆうちょ貯金用",
      "totalBalance": 300000.00,
      "allocatedAmount": 150000.00,
      "unallocatedAmount": 150000.00,
      "goals": [
        {
          "savingsGoalId": "SVG0000003",
          "goalName": "緊急資金",
          "currentAmount": 150000.00
        }
      ]
    }
  ]
}
```

---

### 3.6 繰り返し支出 (Recurring Expenses)

#### GET /api/recurring-expenses

繰り返し支出一覧を取得

**レスポンス:** 200 OK

```json
[
  {
    "recurringExpenseId": "REC0000001",
    "expenseName": "家賃",
    "amount": 80000.00,
    "categoryId": "CAT0000010",
    "categoryName": "住居費",
    "accountId": "ACC0000001",
    "creditCardId": null,
    "paymentDay": 27,
    "memo": "大家さんへ振込"
  },
  {
    "recurringExpenseId": "REC0000002",
    "expenseName": "Netflix",
    "amount": 1980.00,
    "categoryId": "CAT0000015",
    "categoryName": "娯楽費",
    "accountId": null,
    "creditCardId": "CRD0000001",
    "paymentDay": 1,
    "memo": null
  }
]
```

---

#### POST /api/recurring-expenses

繰り返し支出を新規作成

**リクエストボディ(口座から支払い):**

```json
{
  "expenseName": "電気代",
  "amount": 8000.00,
  "categoryId": "CAT0000020",
  "accountId": "ACC0000001",
  "creditCardId": null,
  "paymentDay": 26,
  "memo": "東京電力"
}
```

**リクエストボディ(カードで支払い):**

```json
{
  "expenseName": "Spotify",
  "amount": 980.00,
  "categoryId": "CAT0000015",
  "accountId": null,
  "creditCardId": "CRD0000001",
  "paymentDay": 15,
  "memo": null
}
```

**バリデーション:**

- `expenseName`: 必須、100文字以内
- `amount`: 必須、数値
- `categoryId`: 必須、存在するカテゴリID
- `accountId` と `creditCardId`: どちらか一方のみ必須(排他的)
- `paymentDay`: 必須、1〜31
- `memo`: 任意

**レスポンス:** 201 Created

```json
{
  "recurringExpenseId": "REC0000003",
  "expenseName": "電気代",
  "amount": 8000.00,
  "categoryId": "CAT0000020",
  "categoryName": "光熱費",
  "accountId": "ACC0000001",
  "creditCardId": null,
  "paymentDay": 26,
  "memo": "東京電力"
}
```

---

#### GET /api/recurring-expenses/{recurringExpenseId}

繰り返し支出詳細を取得

**レスポンス:** 200 OK

```json
{
  "recurringExpenseId": "REC0000001",
  "expenseName": "家賃",
  "amount": 80000.00,
  "categoryId": "CAT0000010",
  "categoryName": "住居費",
  "accountId": "ACC0000001",
  "creditCardId": null,
  "paymentDay": 27,
  "memo": "大家さんへ振込"
}
```

---

#### PUT /api/recurring-expenses/{recurringExpenseId}

繰り返し支出を更新

**リクエストボディ:**

```json
{
  "expenseName": "家賃",
  "amount": 85000.00,
  "categoryId": "CAT0000010",
  "accountId": "ACC0000001",
  "creditCardId": null,
  "paymentDay": 27,
  "memo": "値上げ後"
}
```

**レスポンス:** 200 OK

```json
{
  "recurringExpenseId": "REC0000001",
  "expenseName": "家賃",
  "amount": 85000.00,
  "categoryId": "CAT0000010",
  "categoryName": "住居費",
  "accountId": "ACC0000001",
  "creditCardId": null,
  "paymentDay": 27,
  "memo": "値上げ後"
}
```

---

#### DELETE /api/recurring-expenses/{recurringExpenseId}

繰り返し支出を削除

**レスポンス:** 204 No Content

---

#### GET /api/recurring-expenses/pending

未入力の繰り返し支出を取得

**レスポンス:** 200 OK

```json
{
  "pendingCount": 3,
  "items": [
    {
      "recurringExpenseId": "REC0000001",
      "expenseName": "家賃",
      "amount": 80000.00,
      "categoryId": "CAT0000010",
      "categoryName": "住居費",
      "accountId": "ACC0000001",
      "creditCardId": null,
      "paymentDay": 27,
      "memo": "大家さんへ振込",
      "missedDates": [
        "2024-11-27",
        "2024-12-27"
      ]
    },
    {
      "recurringExpenseId": "REC0000002",
      "expenseName": "Netflix",
      "amount": 1980.00,
      "categoryId": "CAT0000015",
      "categoryName": "娯楽費",
      "accountId": null,
      "creditCardId": "CRD0000001",
      "paymentDay": 1,
      "memo": null,
      "missedDates": [
        "2025-01-01"
      ]
    }
  ]
}
```

---

#### POST /api/recurring-expenses/apply

選択した繰り返し支出を取引として一括登録

**リクエストボディ:**

```json
{
  "applications": [
    {
      "recurringExpenseId": "REC0000001",
      "applyDates": [
        "2024-11-27",
        "2024-12-27"
      ]
    },
    {
      "recurringExpenseId": "REC0000002",
      "applyDates": [
        "2025-01-01"
      ]
    }
  ]
}
```

**レスポンス:** 200 OK

```json
{
  "createdTransactions": [
    {
      "transactionId": "TRX0001234",
      "recurringExpenseId": "REC0000001",
      "transactionDate": "2024-11-27",
      "amount": 80000.00
    },
    {
      "transactionId": "TRX0001235",
      "recurringExpenseId": "REC0000001",
      "transactionDate": "2024-12-27",
      "amount": 80000.00
    },
    {
      "transactionId": "TRX0001236",
      "recurringExpenseId": "REC0000002",
      "transactionDate": "2025-01-01",
      "amount": 1980.00
    }
  ]
}
```

---

### 3.7 取引 (Transactions)

#### GET /api/transactions

取引一覧を取得(フィルター、ページネーション対応)

**クエリパラメータ:**

- `startDate`: 任意、開始日(YYYY-MM-DD)
- `endDate`: 任意、終了日(YYYY-MM-DD)
- `categoryId`: 任意、カテゴリID(大カテゴリ指定で小カテゴリも含む)
- `transactionType`: 任意、"INCOME" / "EXPENSE" / "TRANSFER"
- `accountId`: 任意、口座ID
- `creditCardId`: 任意、クレジットカードID
- `keyword`: 任意、メモのキーワード検索
- `page`: 任意、ページ番号(デフォルト: 1)
- `limit`: 任意、1ページあたりの件数(デフォルト: 20)

**レスポンス:** 200 OK

```json
{
  "transactions": [
    {
      "transactionId": "TRX0001234",
      "transactionDate": "2024-01-15",
      "transactionType": "EXPENSE",
      "amount": 5000.00,
      "categoryId": "CAT0000002",
      "categoryName": "食料品",
      "accountId": "ACC0000001",
      "accountName": "みずほ銀行メイン口座",
      "creditCardId": null,
      "memo": "スーパーで買い物",
      "createdAt": "2024-01-15T10:30:00Z"
    },
    {
      "transactionId": "TRX0001235",
      "transactionDate": "2024-01-20",
      "transactionType": "INCOME",
      "amount": 300000.00,
      "categoryId": "CAT0000050",
      "categoryName": "給与",
      "accountId": "ACC0000001",
      "accountName": "みずほ銀行メイン口座",
      "creditCardId": null,
      "memo": "1月分給与",
      "createdAt": "2024-01-20T09:00:00Z"
    },
    {
      "transactionId": "TRX0001236",
      "transactionDate": "2024-01-25",
      "transactionType": "TRANSFER",
      "amount": 50000.00,
      "categoryId": null,
      "categoryName": null,
      "fromAccountId": "ACC0000001",
      "fromAccountName": "みずほ銀行メイン口座",
      "toAccountId": "ACC0000002",
      "toAccountName": "貯金用口座",
      "memo": "貯金",
      "createdAt": "2024-01-25T14:00:00Z"
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalCount": 100,
    "limit": 20
  }
}
```

---

#### POST /api/transactions

取引を新規作成

**リクエストボディ(支出 - 口座):**

```json
{
  "transactionDate": "2024-01-15",
  "transactionType": "EXPENSE",
  "amount": 5000.00,
  "categoryId": "CAT0000002",
  "accountId": "ACC0000001",
  "memo": "スーパーで買い物"
}
```

**リクエストボディ(支出 - クレジットカード):**

```json
{
  "transactionDate": "2024-01-15",
  "transactionType": "EXPENSE",
  "amount": 12000.00,
  "categoryId": "CAT0000003",
  "creditCardId": "CRD0000001",
  "memo": "レストラン"
}
```

**リクエストボディ(収入):**

```json
{
  "transactionDate": "2024-01-25",
  "transactionType": "INCOME",
  "amount": 300000.00,
  "categoryId": "CAT0000050",
  "accountId": "ACC0000001",
  "memo": "給与"
}
```

**リクエストボディ(口座間移動 - 通常):**

```json
{
  "transactionDate": "2024-01-25",
  "transactionType": "TRANSFER",
  "amount": 50000.00,
  "fromAccountId": "ACC0000001",
  "toAccountId": "ACC0000003",
  "memo": "引き落とし口座へ補充"
}
```

**リクエストボディ(口座間移動 - 貯金目標への割り当て):**

```json
{
  "transactionDate": "2024-01-25",
  "transactionType": "TRANSFER",
  "amount": 100000.00,
  "fromAccountId": "ACC0000001",
  "toAccountId": "ACC0000002",
  "memo": "貯金",
  "savingsAllocations": [
    {
      "savingsGoalId": "SVG0000001",
      "allocationAmount": 50000.00
    },
    {
      "savingsGoalId": "SVG0000002",
      "allocationAmount": 50000.00
    }
  ]
}
```

**バリデーション:**

- `transactionDate`: 必須、日付形式
- `transactionType`: 必須、"INCOME" / "EXPENSE" / "TRANSFER"
- `amount`: 必須、数値
- INCOME/EXPENSEの場合:
    - `categoryId`: 必須
    - `accountId` or `creditCardId`: どちらか必須
- TRANSFERの場合:
    - `fromAccountId`, `toAccountId`: 必須
    - `categoryId`: 不要
    - `savingsAllocations`: 任意(貯金用口座への移動時のみ)

**レスポンス:** 201 Created

```json
{
  "transactionId": "TRX0001240",
  "transactionDate": "2024-01-25",
  "transactionType": "TRANSFER",
  "amount": 100000.00,
  "fromAccountId": "ACC0000001",
  "fromAccountName": "みずほ銀行メイン口座",
  "toAccountId": "ACC0000002",
  "toAccountName": "貯金用口座",
  "memo": "貯金",
  "savingsAllocations": [
    {
      "savingsAllocationId": "SAL0000010",
      "savingsGoalId": "SVG0000001",
      "goalName": "旅行貯金",
      "allocationAmount": 50000.00
    },
    {
      "savingsAllocationId": "SAL0000011",
      "savingsGoalId": "SVG0000002",
      "goalName": "車購入",
      "allocationAmount": 50000.00
    }
  ],
  "createdAt": "2024-01-25T14:00:00Z"
}
```

---

#### GET /api/transactions/{transactionId}

取引詳細を取得

**レスポンス(支出):** 200 OK

```json
{
  "transactionId": "TRX0001234",
  "transactionDate": "2024-01-15",
  "transactionType": "EXPENSE",
  "amount": 5000.00,
  "categoryId": "CAT0000002",
  "categoryName": "食料品",
  "accountId": "ACC0000001",
  "accountName": "みずほ銀行メイン口座",
  "creditCardId": null,
  "memo": "スーパーで買い物",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

**レスポンス(口座間移動):** 200 OK

```json
{
  "transactionId": "TRX0001240",
  "transactionDate": "2024-01-25",
  "transactionType": "TRANSFER",
  "amount": 100000.00,
  "fromAccountId": "ACC0000001",
  "fromAccountName": "みずほ銀行メイン口座",
  "toAccountId": "ACC0000002",
  "toAccountName": "貯金用口座",
  "memo": "貯金",
  "savingsAllocations": [
    {
      "savingsAllocationId": "SAL0000010",
      "savingsGoalId": "SVG0000001",
      "goalName": "旅行貯金",
      "allocationAmount": 50000.00
    }
  ],
  "createdAt": "2024-01-25T14:00:00Z",
  "updatedAt": "2024-01-25T14:00:00Z"
}
```

---

#### PUT /api/transactions/{transactionId}

取引を更新

**リクエストボディ:**

```json
{
  "transactionDate": "2024-01-15",
  "amount": 5500.00,
  "categoryId": "CAT0000002",
  "accountId": "ACC0000001",
  "memo": "スーパーで買い物(修正)"
}
```

**補足:**

- `transactionType` は変更不可
- 口座残高は自動再計算

**レスポンス:** 200 OK

```json
{
  "transactionId": "TRX0001234",
  "transactionDate": "2024-01-15",
  "transactionType": "EXPENSE",
  "amount": 5500.00,
  "categoryId": "CAT0000002",
  "categoryName": "食料品",
  "accountId": "ACC0000001",
  "accountName": "みずほ銀行メイン口座",
  "creditCardId": null,
  "memo": "スーパーで買い物(修正)",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-16T09:00:00Z"
}
```

---

#### DELETE /api/transactions/{transactionId}

取引を削除

**レスポンス:** 204 No Content

**補足:**

- 口座残高は自動調整
- 貯金目標への割り当ても自動削除(CASCADE)

---

### 3.8 予算 (Budgets)

#### GET /api/budgets

予算一覧を取得(サイクル指定)

**クエリパラメータ:**

- `cycleStartDate`: 任意、サイクル開始日(YYYY-MM-DD、指定がない場合は現在のサイクル)

**レスポンス:** 200 OK

```json
{
  "cycle": {
    "cycleStartDate": "2024-01-25",
    "cycleEndDate": "2024-02-24"
  },
  "budgets": [
    {
      "budgetId": "BDG0000001",
      "categoryId": null,
      "categoryName": "全体予算",
      "budgetAmount": 200000.00,
      "usedAmount": 120000.00,
      "remainingAmount": 80000.00,
      "usageRate": 60.0
    },
    {
      "budgetId": "BDG0000002",
      "categoryId": "CAT0000001",
      "categoryName": "食費",
      "budgetAmount": 50000.00,
      "usedAmount": 35000.00,
      "remainingAmount": 15000.00,
      "usageRate": 70.0
    },
    {
      "budgetId": "BDG0000003",
      "categoryId": "CAT0000002",
      "categoryName": "食料品",
      "budgetAmount": 30000.00,
      "usedAmount": 20000.00,
      "remainingAmount": 10000.00,
      "usageRate": 66.7
    }
  ]
}
```

---

#### POST /api/budgets

予算を新規作成

**リクエストボディ(全体予算):**

```json
{
  "cycleStartDate": "2024-01-25",
  "cycleEndDate": "2024-02-24",
  "categoryId": null,
  "budgetAmount": 200000.00
}
```

**リクエストボディ(カテゴリ別予算):**

```json
{
  "cycleStartDate": "2024-01-25",
  "cycleEndDate": "2024-02-24",
  "categoryId": "CAT0000001",
  "budgetAmount": 50000.00
}
```

**バリデーション:**

- `cycleStartDate`: 必須、日付形式
- `cycleEndDate`: 必須、日付形式
- `categoryId`: 任意(null = 全体予算)
- `budgetAmount`: 必須、数値
- 同じサイクル・カテゴリの予算は重複不可(UNIQUE制約)

**レスポンス:** 201 Created

```json
{
  "budgetId": "BDG0000004",
  "cycleStartDate": "2024-01-25",
  "cycleEndDate": "2024-02-24",
  "categoryId": "CAT0000001",
  "categoryName": "食費",
  "budgetAmount": 50000.00,
  "usedAmount": 0.00,
  "remainingAmount": 50000.00,
  "usageRate": 0.0,
  "createdAt": "2024-01-25T10:00:00Z"
}
```

---

#### GET /api/budgets/{budgetId}

予算詳細を取得

**レスポンス:** 200 OK

```json
{
  "budgetId": "BDG0000001",
  "cycleStartDate": "2024-01-25",
  "cycleEndDate": "2024-02-24",
  "categoryId": null,
  "categoryName": "全体予算",
  "budgetAmount": 200000.00,
  "usedAmount": 120000.00,
  "remainingAmount": 80000.00,
  "usageRate": 60.0,
  "createdAt": "2024-01-25T10:00:00Z",
  "updatedAt": "2024-01-25T10:00:00Z"
}
```

---

#### PUT /api/budgets/{budgetId}

予算を更新

**リクエストボディ:**

```json
{
  "budgetAmount": 220000.00
}
```

**バリデーション:**

- `budgetAmount`: 必須、数値
- ※ サイクル、カテゴリは変更不可

**レスポンス:** 200 OK

```json
{
  "budgetId": "BDG0000001",
  "cycleStartDate": "2024-01-25",
  "cycleEndDate": "2024-02-24",
  "categoryId": null,
  "categoryName": "全体予算",
  "budgetAmount": 220000.00,
  "usedAmount": 120000.00,
  "remainingAmount": 100000.00,
  "usageRate": 54.5,
  "createdAt": "2024-01-25T10:00:00Z",
  "updatedAt": "2024-02-01T14:00:00Z"
}
```

---

#### DELETE /api/budgets/{budgetId}

予算を削除

**レスポンス:** 204 No Content

---

#### GET /api/budgets/current

現在のサイクルの予算と使用状況を取得

**レスポンス:** 200 OK

```json
{
  "cycle": {
    "cycleStartDate": "2024-01-25",
    "cycleEndDate": "2024-02-24",
    "daysRemaining": 15
  },
  "overallBudget": {
    "budgetId": "BDG0000001",
    "budgetAmount": 200000.00,
    "usedAmount": 120000.00,
    "remainingAmount": 80000.00,
    "usageRate": 60.0
  },
  "categoryBudgets": [
    {
      "budgetId": "BDG0000002",
      "categoryId": "CAT0000001",
      "categoryName": "食費",
      "budgetAmount": 50000.00,
      "usedAmount": 35000.00,
      "remainingAmount": 15000.00,
      "usageRate": 70.0,
      "subCategories": [
        {
          "budgetId": "BDG0000003",
          "categoryId": "CAT0000002",
          "categoryName": "食料品",
          "budgetAmount": 30000.00,
          "usedAmount": 20000.00,
          "remainingAmount": 10000.00,
          "usageRate": 66.7
        },
        {
          "budgetId": "BDG0000004",
          "categoryId": "CAT0000003",
          "categoryName": "外食",
          "budgetAmount": 20000.00,
          "usedAmount": 15000.00,
          "remainingAmount": 5000.00,
          "usageRate": 75.0
        }
      ]
    },
    {
      "budgetId": "BDG0000005",
      "categoryId": "CAT0000004",
      "categoryName": "交通費",
      "budgetAmount": 15000.00,
      "usedAmount": 8000.00,
      "remainingAmount": 7000.00,
      "usageRate": 53.3,
      "subCategories": []
    }
  ]
}
```

---

### 3.9 統計・レポート (Reports)

#### GET /api/reports/dashboard

ダッシュボード情報を取得

**レスポンス:** 200 OK

```json
{
  "currentCycle": {
    "cycleStartDate": "2024-01-25",
    "cycleEndDate": "2024-02-24",
    "daysRemaining": 15
  },
  "summary": {
    "totalIncome": 300000.00,
    "totalExpense": 120000.00,
    "balance": 180000.00
  },
  "budget": {
    "budgetAmount": 200000.00,
    "usedAmount": 120000.00,
    "remainingAmount": 80000.00,
    "usageRate": 60.0
  },
  "accounts": [
    {
      "accountId": "ACC0000001",
      "accountName": "みずほ銀行メイン口座",
      "currentBalance": 250000.00,
      "isSavingsAccount": false
    },
    {
      "accountId": "ACC0000002",
      "accountName": "貯金用口座",
      "currentBalance": 1500000.00,
      "isSavingsAccount": true
    }
  ],
  "creditCards": [
    {
      "creditCardId": "CRD0000001",
      "cardName": "楽天カード",
      "currentPeriodUsage": 85000.00,
      "nextWithdrawalDate": "2024-02-27",
      "nextWithdrawalAmount": 120000.00,
      "additionalAmountNeeded": 0.00
    }
  ],
  "savingsGoals": [
    {
      "savingsGoalId": "SVG0000001",
      "goalName": "旅行貯金",
      "targetAmount": 500000.00,
      "currentAmount": 300000.00,
      "achievementRate": 60.0
    },
    {
      "savingsGoalId": "SVG0000002",
      "goalName": "車購入",
      "targetAmount": 2000000.00,
      "currentAmount": 800000.00,
      "achievementRate": 40.0
    }
  ],
  "topCategories": [
    {
      "categoryId": "CAT0000001",
      "categoryName": "食費",
      "amount": 45000.00,
      "percentage": 37.5
    },
    {
      "categoryId": "CAT0000004",
      "categoryName": "交通費",
      "amount": 25000.00,
      "percentage": 20.8
    },
    {
      "categoryId": "CAT0000010",
      "categoryName": "住居費",
      "amount": 80000.00,
      "percentage": 66.7
    }
  ]
}
```

---

#### GET /api/reports/cycle-summary

サイクル別収支サマリーを取得

**クエリパラメータ:**

- `count`: 任意、取得するサイクル数(デフォルト: 12)

**レスポンス:** 200 OK

```json
{
  "cycles": [
    {
      "cycleStartDate": "2024-01-25",
      "cycleEndDate": "2024-02-24",
      "totalIncome": 300000.00,
      "totalExpense": 120000.00,
      "balance": 180000.00
    },
    {
      "cycleStartDate": "2023-12-25",
      "cycleEndDate": "2024-01-24",
      "totalIncome": 300000.00,
      "totalExpense": 150000.00,
      "balance": 150000.00
    },
    {
      "cycleStartDate": "2023-11-25",
      "cycleEndDate": "2023-12-24",
      "totalIncome": 300000.00,
      "totalExpense": 140000.00,
      "balance": 160000.00
    }
  ]
}
```

---

#### GET /api/reports/category-breakdown

カテゴリ別支出内訳を取得

**クエリパラメータ:**

- `cycleStartDate`: 任意、サイクル開始日(指定がない場合は現在のサイクル)
- `categoryType`: 任意、"INCOME" / "EXPENSE"(デフォルト: "EXPENSE")

**レスポンス:** 200 OK

```json
{
  "cycle": {
    "cycleStartDate": "2024-01-25",
    "cycleEndDate": "2024-02-24"
  },
  "totalAmount": 120000.00,
  "categories": [
    {
      "categoryId": "CAT0000001",
      "categoryName": "食費",
      "amount": 45000.00,
      "percentage": 37.5,
      "subCategories": [
        {
          "categoryId": "CAT0000002",
          "categoryName": "食料品",
          "amount": 25000.00,
          "percentage": 55.6
        },
        {
          "categoryId": "CAT0000003",
          "categoryName": "外食",
          "amount": 20000.00,
          "percentage": 44.4
        }
      ]
    },
    {
      "categoryId": "CAT0000004",
      "categoryName": "交通費",
      "amount": 15000.00,
      "percentage": 12.5,
      "subCategories": []
    }
  ]
}
```

---

#### GET /api/reports/comparison

前期間比較を取得

**クエリパラメータ:**

- `cycleStartDate`: 任意、比較対象のサイクル開始日(指定がない場合は現在のサイクル)

**レスポンス:** 200 OK

```json
{
  "currentCycle": {
    "cycleStartDate": "2024-01-25",
    "cycleEndDate": "2024-02-24",
    "totalIncome": 300000.00,
    "totalExpense": 120000.00,
    "balance": 180000.00
  },
  "previousCycle": {
    "cycleStartDate": "2023-12-25",
    "cycleEndDate": "2024-01-24",
    "totalIncome": 300000.00,
    "totalExpense": 150000.00,
    "balance": 150000.00
  },
  "comparison": {
    "incomeChange": 0.00,
    "incomeChangeRate": 0.0,
    "expenseChange": -30000.00,
    "expenseChangeRate": -20.0,
    "balanceChange": 30000.00,
    "balanceChangeRate": 20.0
  },
  "categoryComparison": [
    {
      "categoryId": "CAT0000001",
      "categoryName": "食費",
      "currentAmount": 45000.00,
      "previousAmount": 50000.00,
      "change": -5000.00,
      "changeRate": -10.0
    },
    {
      "categoryId": "CAT0000004",
      "categoryName": "交通費",
      "currentAmount": 15000.00,
      "previousAmount": 20000.00,
      "change": -5000.00,
      "changeRate": -25.0
    }
  ]
}
```

---

#### GET /api/reports/annual-summary

年間サマリーを取得(12サイクル分)

**クエリパラメータ:**

- `endCycleStartDate`: 任意、終了サイクルの開始日(指定がない場合は現在のサイクル)

**レスポンス:** 200 OK

```json
{
  "period": {
    "startCycleStartDate": "2023-02-25",
    "endCycleEndDate": "2024-02-24"
  },
  "summary": {
    "totalIncome": 3600000.00,
    "totalExpense": 1800000.00,
    "balance": 1800000.00,
    "averageMonthlyIncome": 300000.00,
    "averageMonthlyExpense": 150000.00
  },
  "cycles": [
    {
      "cycleStartDate": "2024-01-25",
      "cycleEndDate": "2024-02-24",
      "totalIncome": 300000.00,
      "totalExpense": 120000.00,
      "balance": 180000.00
    },
    {
      "cycleStartDate": "2023-12-25",
      "cycleEndDate": "2024-01-24",
      "totalIncome": 300000.00,
      "totalExpense": 150000.00,
      "balance": 150000.00
    }
  ],
  "categoryAnnualExpense": [
    {
      "categoryId": "CAT0000001",
      "categoryName": "食費",
      "totalAmount": 540000.00,
      "percentage": 30.0,
      "averageMonthlyAmount": 45000.00
    },
    {
      "categoryId": "CAT0000010",
      "categoryName": "住居費",
      "totalAmount": 960000.00,
      "percentage": 53.3,
      "averageMonthlyAmount": 80000.00
    }
  ]
}
```

---

#### GET /api/reports/category-trend

カテゴリ別推移を取得

**クエリパラメータ:**

- `categoryId`: 必須、カテゴリID(大カテゴリ)
- `period`: 任意、期間(3, 6, 12サイクル、デフォルト: 6)
- `endCycleStartDate`: 任意、終了サイクルの開始日(指定がない場合は現在のサイクル)

**レスポンス:** 200 OK

```json
{
  "category": {
    "categoryId": "CAT0000001",
    "categoryName": "食費"
  },
  "period": 12,
  "trend": [
    {
      "cycleStartDate": "2024-01-25",
      "cycleEndDate": "2024-02-24",
      "totalAmount": 45000.00,
      "subCategories": [
        {
          "categoryId": "CAT0000002",
          "categoryName": "食料品",
          "amount": 25000.00
        },
        {
          "categoryId": "CAT0000003",
          "categoryName": "外食",
          "amount": 20000.00
        }
      ]
    },
    {
      "cycleStartDate": "2023-12-25",
      "cycleEndDate": "2024-01-24",
      "totalAmount": 50000.00,
      "subCategories": [
        {
          "categoryId": "CAT0000002",
          "categoryName": "食料品",
          "amount": 30000.00
        },
        {
          "categoryId": "CAT0000003",
          "categoryName": "外食",
          "amount": 20000.00
        }
      ]
    }
  ]
}
```

---

### 3.10 ユーティリティ (Utilities)

#### GET /api/cycles/current

現在のサイクル情報を取得

**レスポンス:** 200 OK

```json
{
  "cycleStartDate": "2024-01-25",
  "cycleEndDate": "2024-02-24",
  "daysElapsed": 15,
  "daysRemaining": 15,
  "totalDays": 30
}
```

---

#### GET /api/cycles

サイクル一覧を取得

**クエリパラメータ:**

- `count`: 任意、取得するサイクル数(デフォルト: 12)

**レスポンス:** 200 OK

```json
{
  "cycles": [
    {
      "cycleStartDate": "2024-01-25",
      "cycleEndDate": "2024-02-24",
      "isCurrent": true
    },
    {
      "cycleStartDate": "2023-12-25",
      "cycleEndDate": "2024-01-24",
      "isCurrent": false
    },
    {
      "cycleStartDate": "2023-11-25",
      "cycleEndDate": "2023-12-24",
      "isCurrent": false
    }
  ]
}
```

---

## 4. エラーレスポンス

### 共通エラーフォーマット

```json
{
  "error": "エラーメッセージ",
  "code": "エラーコード"
}
```

### エラーコード一覧

| コード                  | 説明                 |
|----------------------|--------------------|
| VALIDATION_ERROR     | バリデーションエラー         |
| NOT_FOUND            | リソースが見つからない        |
| CONSTRAINT_VIOLATION | 制約違反(外部キー、UNIQUE等) |
| UNAUTHORIZED         | 認証エラー              |
| FORBIDDEN            | 権限エラー              |
| INTERNAL_ERROR       | サーバー内部エラー          |

---

## 5. 補足事項

### 5.1 日付フォーマット

- 日付: `YYYY-MM-DD` (例: 2024-01-25)
- 日時: `YYYY-MM-DDTHH:mm:ssZ` (例: 2024-01-25T10:30:00Z)

### 5.2 数値フォーマット

- 金額: 小数点以下2桁 (例: 12345.67)
- 割合(%): 小数点以下1桁 (例: 66.7)

### 5.3 認証(後回し)

- JWT認証を使用
- リクエストヘッダー: `Authorization: Bearer {token}`
- トークンの有効期限: 24時間

### 5.4 ページネーション

- `page`: ページ番号(1から開始)
- `limit`: 1ページあたりの件数
- レスポンスに`pagination`オブジェクトを含む

### 5.5 給料日サイクルの計算

- アプリ設定の`payday`を基準にサイクルを計算
- 土日祝の場合は前営業日に自動調整
- サイクル期間: 給料日〜次の給料日前日

---

## 6. 変更履歴

| 日付         | バージョン | 変更内容 |
|------------|-------|------|
| 2025-01-24 | 1.0   | 初版作成 |
