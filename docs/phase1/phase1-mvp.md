# FLOWLET Phase 1 MVP仕様書

## 1. MVPゴール

ユーザーが収入・支出を記録し、  
口座および目的別に「今月の収支」と「現在の残高」を把握できる。

---

## 2. 対象ユーザーフロー

1. 口座を作成する
2. （任意）口座に目的を作成する
3. 収入を登録する
4. 支出を登録する
5. 振替を登録する
6. 今月の収支を確認する
7. 口座別／目的別の残高を確認する

---

## 3. MVPに含める機能

- 収入・支出・振替の登録
- 月次収支の自動集計
- 口座残高の自動計算
- 目的別残高の計算（目的別管理有効口座のみ）
- 数値の一覧表示

---

## 4. MVPに含めない機能

- 銀行・クレジットカード連携
- 投資資産の評価・管理
- グラフ・分析・レポート
- 予算超過アラート
- 月跨ぎ繰越の高度な制御

---

## 5. ドメインモデル（最小構成）

### Account（口座）

| プロパティ | 型 | 説明 |
|----|----|----|
| accountId | UUID | 口座ID |
| accountName | String | 口座名 |
| initialBalanceAmount | Long | 初期残高 |
| isPurposeManagementEnabled | Boolean | 目的別管理有効フラグ |

---

### Purpose（目的）

| プロパティ | 型 | 説明 |
|----|----|----|
| purposeId | UUID | 目的ID |
| accountId | UUID | 紐づく口座ID |
| purposeName | String | 目的名 |
| allocatedAmount | Long | 割当金額 |

---

### Transaction（取引）

| プロパティ | 型 | 説明 |
|----|----|----|
| transactionId | UUID | 取引ID |
| transactionType | Enum | INCOME / EXPENSE / TRANSFER |
| transactionAmount | Long | 取引金額 |
| fromAccountId | UUID | 振替元口座ID |
| fromPurposeId | UUID? | 振替元目的ID（任意） |
| toAccountId | UUID | 振替先口座ID |
| toPurposeId | UUID? | 振替先目的ID（任意） |
| isIncomeExpenseTarget | Boolean | 収支計算対象フラグ |
| occurredAt | LocalDateTime | 発生日 |

---

## 6. 取引種別ルール

| 種別 | 残高 | 収支計算 |
|----|----|----|
| INCOME | 加算 | 対象 |
| EXPENSE | 減算 | 対象 |
| TRANSFER | 移動 | 対象外 |

---

## 7. Phase 1 Done定義

- 口座を作成できる
- 収入・支出・振替を登録できる
- 今月の収支が正しく計算される
- 口座残高が取引に応じて変動する
- 目的別残高が正しく表示される（対象口座のみ）
