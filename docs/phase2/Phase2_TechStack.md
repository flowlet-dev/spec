# Phase2：技術スタック確定

## 1. 前提

* 想定ユーザー：開発者本人のみ
* 利用頻度：週1回程度
* 利用環境：PCブラウザ中心
* MVP：収支登録／一覧表示／給料日基準集計
* 最優先事項：最短で利用開始すること

---

# 2. 技術スタック最終決定

## 2.1 Backend

* **Java 25**
* **Spring Boot**

### 採用理由

* 既存スキルセットを活用できる
* LocalDateを用いた給料日基準ロジックの実装に適している
* 将来的な機能拡張（口座管理・クレカ管理）に耐えられる構造

### 補足

* Java 25はLTSではないが、個人開発でありリスクは限定的
* 開発速度を優先する

---

## 2.2 Frontend

* **React + TypeScript**
* ビルドツール：Vite

### 採用理由

* 学習投資としての価値がある
* SPA構成の理解を深めるため
* 将来的な拡張やUI改善に柔軟に対応可能

### MVP段階の制約

* 状態管理は useState のみ
* Redux / React Query 等は導入しない
* UIライブラリは使用しない
* 画面は最小構成（登録・一覧・トップ）

---

## 2.3 Database

* **PostgreSQL**

### 採用理由

* 日付型の扱いが安定している
* 集計処理との相性が良い
* 将来的な拡張にも耐えられる

---

## 2.4 認証方式

* 当面なし（ローカル利用前提）

### 採用理由

* ユーザーは本人のみ
* 公開サービスではない
* 実装速度を最優先するため

---

## 2.5 デプロイ構成

* Docker Compose
* 開発環境／本番環境をローカル内で分離

### ディレクトリ構成例

```
flowlet-frontend
flowlet-backend
flowlet-infra
  ├─ docker-compose.dev.yml
  └─ docker-compose.prod.yml
```

---

# 3. アーキテクチャ構成

## 3.1 SPA完全分離型

```
Browser
   ↓ REST
React (Frontend)
   ↓
Spring Boot (Backend)
   ↓
PostgreSQL
```

### 採用理由

* フロント／バックエンドの責務分離を明確化
* 実務的な構成に近い
* 学習効果が高い

---

# 4. Backend内部構成（軽量DDD）

```
controller
service
domain
  └─ model
repository
```

## 方針

* Entityはdomainに配置
* JPA実装依存は将来的にinfrastructureへ分離
* Application層の厳密分離は行わない

---

# 5. 開発方針

1. Backend APIを先に完成させる
2. Postmanで動作確認
3. Frontendから接続する

## 根拠

API仕様が未確定の状態でフロントを実装すると手戻りが発生しやすいため。

---

# 6. 確定スタック一覧

| 項目       | 採用                 |
| -------- | ------------------ |
| Java     | 25                 |
| Backend  | Spring Boot        |
| Frontend | React + TypeScript |
| DB       | PostgreSQL         |
| 認証       | なし                 |
| デプロイ     | Docker（dev/prod分離） |
| 構成       | SPA完全分離            |

---

# 7. 設計判断の根拠

* 個人開発で最も重要なのは「利用開始」
* 過剰設計は開発停止リスクを高める
* 学習価値と実装速度のバランスを取る
* 将来拡張可能だが、現時点では最小構成に留める

---
