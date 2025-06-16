# WebSocket 学習カリキュラム（改訂版：WebSocket API中心）

## 📚 カリキュラム概要
**総学習時間**: 約50-60時間  
**対象者**: TypeScript/JavaScript中級者、Angular+RxJS経験者、Svelte学習者、PWA・リアルタイム通信に興味がある開発者  
**最終目標**: **ブラウザ標準WebSocket API**を使ったモダンなリアルタイムWebアプリケーション（PWA対応）の設計・実装ができる

**主要技術スタック**: 
- **フロントエンド**: Svelte/SvelteKit + TypeScript（RxJSパターンからの移行含む）
- **バックエンド**: Node.js + TypeScript + WebSocket標準ライブラリ
- **テスト**: Vitest + Playwright
- **PWA**: Service Worker + WebSocket統合

**学習方針**: 
- **WebSocket API（ブラウザ標準）をマスター**してから応用技術を学習
- Socket.IOは応用・オプション扱い（高度な機能が必要な場合のみ）
- Angular+RxJS経験を活かしたパターン学習からSvelteへの移行


## 1. WebSocket 入門（学習時間: 5-7時間）

### 1.1 WebSocketとは何か（1時間）
- **学習内容**
  - WebSocketの定義と基本概念
  - **ブラウザ標準WebSocket API**の重要性
  - リアルタイム通信の必要性
  - WebSocketの歴史と標準化（RFC 6455）
- **演習**
  - ブラウザ開発者ツールでWebSocket通信を観察
  - 簡単なWebSocketテストサイトでの動作確認

### 1.2 HTTPの限界とWebSocketの優位性（1時間）
- **学習内容**
  - HTTPリクエスト/レスポンス型の制限
  - ポーリング手法の問題点（定期ポーリング、ロングポーリング）
  - **WebSocket API**による双方向通信の実現
  - **2016年以降のブラウザ対応状況**：モダンブラウザでは標準対応
- **演習**
  - ポーリングとWebSocketのパフォーマンス比較
  - ネットワークトラフィックの測定と分析

### 1.3 WebSocketの利用例と適用場面（2-3時間）
- **学習内容**
  - **WebSocketの11の主要カテゴリー分析**
    - リアルタイム通信（チャット、Discord、サポートチャット）
    - 共同編集（Google Docs風、コード共同編集）
    - 通知・アラート（在庫更新、リアルタイムアラート）
    - データ配信（株価、為替、スポーツスコア）
    - IoT連携（スマートホーム、センサー通知）
    - PWA統合（オフライン対応、Service Worker連携）
    - Webベースシミュレーション（教育用、マルチユーザ動作）
    - バックエンド連携（GraphQL Subscriptions、RPC風通信）
    - セキュリティ・監査（認証セッション監視、強制ログアウト）
    - 金融・医療（オーダー処理、患者モニタリング）
    - VR/メタバース（アバター状態同期、ルーム移動）
  - **アーキテクチャ構成例の理解**
    - 各用途での技術スタック構成
    - 中継システム（Redis Pub/Sub）の活用
    - 認証・セキュリティの統合パターン
  - **適さない場面の理解**: 静的コンテンツ配信、一方向データ取得
- **演習**
  - 11カテゴリーからの適用場面選択演習
  - アーキテクチャ構成図の作成
  - 既存WebSocketアプリの分類・分析
  - 自分のプロジェクトでの適用可能性検討

### 1.4 WebSocket vs 他技術の比較理解（1時間）
- **学習内容**
  - **WebSocket vs WebTransport**
    - WebTransportの位置づけ（HTTP/3ベースの次世代通信）
    - WebSocketの「現在の実用性」と「将来性」
    - 使い分けの判断基準
  - **WebSocket vs Server-Sent Events (SSE)**
    - 双方向 vs 一方向通信
  - **WebSocket vs Socket.IO**（概要のみ）
    - Socket.IOは「WebSocketの拡張ライブラリ」
    - 基礎習得後の応用技術として位置づけ
- **演習**
  - 具体的な用途での技術選択演習
  - 現在のブラウザ対応状況調査


## 2. WebSocket を取り巻くネットワーク技術（学習時間: 6.5-7.5時間）

### 2.1 WebSocketを理解するためのHTTP基礎（45分）
- **学習内容**
  - HTTP/1.0 vs HTTP/1.1の接続管理の違い（概要）
  - HTTP/1.0: リクエスト/レスポンス毎にTCP接続開閉
  - HTTP/1.1: 持続的接続（Keep-Alive）による効率化
  - WebSocketがHTTP/1.1の持続的接続を前提とする理由
- **演習**
  - HTTP/1.0とHTTP/1.1の接続パターン比較
  - cURLコマンドでの接続ヘッダー確認

### 2.2 OSI参照モデルとWebSocketの位置（1時間）
- **学習内容**
  - OSI 7層モデルの復習
  - WebSocket（セッション層）とSocket（トランスポート層）の違い
  - HTTPからWebSocketへのプロトコル昇格
- **演習**
  - Wiresharkを使ったパケット解析
  - WebSocketハンドシェイクの詳細観察

### 2.3 HTTP/1.1からHTTP/3までのWebSocket対応（2時間）
- **学習内容**
  - **HTTP/1.1（60分）**: WebSocketハンドシェイクの基礎（必須）
    - WebSocket Upgradeリクエスト/レスポンスの詳細
    - 持続的接続を前提としたWebSocket確立
    - 現在でも約25-30%のトラフィックで使用される基礎プロトコル
  - **HTTP/2（45分）**: 現在の主流環境での動作理解（重要）
    - HTTP/2環境でのWebSocket動作（約70%以上のトラフィック）
    - HTTP/2 over WebSocketの制限と課題
    - 多重化とWebSocketの相互作用
  - **HTTP/3（15分）**: 将来動向とWebTransport API（参考）
    - HTTP/3 (QUIC)でのWebSocketの位置づけ
    - WebTransport APIとの比較・将来性
    - 現在の限定的普及状況
- **演習**
  - 各HTTPバージョンでのWebSocket接続テスト
  - パフォーマンス比較測定（HTTP/1.1 vs HTTP/2での差異）
  - HTTP/3対応サービスでの動作確認

### 2.4 WebSocket接続確立プロセス（1.5-2.5時間）
- **学習内容**
  - **End to End vs Hop by Hop通信の基礎（30分）**
    - End to End: クライアント⇔サーバー間で直接関係（暗号化、認証）
    - Hop by Hop: 各中継点で個別処理（プロキシ、ロードバランサー）
    - WebSocketハンドシェイクでの適用例
  - **HTTP/1.1 Upgradeハンドシェイクの詳細（60-90分）**
    - WebSocketキーの生成と検証
    - プロトコルネゴシエーション
    - Connection: Upgradeヘッダーの仕組み（Hop by Hop）
    - Sec-WebSocket-Key/Acceptの交換（End to End）
  - **プロキシ・ファイアウォール環境での動作（30分）**
    - HTTP CONNECTメソッドによるトンネル確立
    - 企業環境でのWebSocket実装課題
- **演習**
  - `curl`コマンドでWebSocketハンドシェイクを手動実行
  - ハンドシェイクヘッダーの検証実装
  - プロキシ環境でのWebSocket接続テスト

### 2.5 セキュリティとポート管理（1時間）
- **学習内容**
  - ws（ポート80）とwss（ポート443）の違い
  - Originチェックとセキュリティ
  - ファイアウォール・プロキシとの関係
  - CORSとの違い
- **演習**
  - wss接続の設定と証明書管理
  - Originチェックの実装


## 3. WebSocket API の基本構造と仕組み（学習時間: 5-6時間）

### 3.1 WebSocket接続ライフサイクル（2時間）
- **学習内容**
  - 接続確立（ハンドシェイク）
  - データ通信フェーズ
  - 接続終了（クローズハンドシェイク）
  - 異常切断の検出と処理
- **演習**
  - TypeScriptでWebSocket接続状態の管理実装
  - 接続品質の監視システム作成

### 3.2 イベントベース通信モデル（2時間）
- **学習内容**
  - `onopen`, `onmessage`, `onclose`, `onerror`イベント
  - **Angular+RxJS経験者向け**: ObservableパターンでのWebSocket管理
  - **Svelteへの移行**: Svelteストア（Writable, Readable）でのWebSocket管理
  - Promise/async-awaitでのラッピング
- **演習**
  ```typescript
  // Angular+RxJS パターン（経験活用）
  import { Injectable } from '@angular/core';
  import { Observable, Subject, BehaviorSubject } from 'rxjs';

  @Injectable()
  export class WebSocketService {
    private ws$: Subject<MessageEvent> = new Subject();
    private connectionStatus$ = new BehaviorSubject<boolean>(false);

    connect(url: string): Observable<MessageEvent> {
      const ws = new WebSocket(url);
      
      ws.onopen = () => this.connectionStatus$.next(true);
      ws.onmessage = event => this.ws$.next(event);
      ws.onclose = () => this.connectionStatus$.next(false);
      
      return this.ws$.asObservable();
    }
  }

  // Svelteストア版（学習目標）
  import { writable, type Writable } from 'svelte/store';

  export function createWebSocketStore(url: string) {
    const { subscribe, set, update } = writable({
      connected: false,
      data: null,
      error: null
    });

    let ws: WebSocket;

    return {
      subscribe,
      connect: () => {
        ws = new WebSocket(url);
        ws.onopen = () => update(state => ({ ...state, connected: true }));
        ws.onmessage = event => update(state => ({ 
          ...state, 
          data: JSON.parse(event.data) 
        }));
      },
      send: (data: any) => ws.send(JSON.stringify(data))
    };
  }
  ```

### 3.3 クライアント・サーバー役割分担（1-2時間）
- **学習内容**
  - クライアント側の責務
  - サーバー側の責務
  - 状態管理とセッション管理
- **演習**
  - Node.js + TypeScript + 標準`ws`ライブラリでWebSocketサーバー実装
  - 複数クライアント接続管理


## 4. WebSocket API の基本操作（学習時間: 4-5時間）

### 4.1 WebSocket URL と接続確立（1時間）
- **学習内容**
  - WebSocket URL形式（`ws://`, `wss://`）
  - サブプロトコルの指定
  - 接続オプションとヘッダー
- **演習**
  - 環境別（開発・本番）の接続設定
  - 接続パラメータの動的生成

### 4.2 ブラウザ標準WebSocket API実装（2-3時間）
- **学習内容**
  - **ブラウザ標準WebSocket API**の基本使用法
  - SvelteKitでのクライアント側WebSocket処理
  - Svelteコンポーネントでのリアルタイムデータ表示
  - TypeScriptでの型定義とSvelteでの利用
- **演習**
  ```typescript
  // ブラウザ標準WebSocket API - 基本形
  const ws = new WebSocket('wss://example.com/websocket');

  ws.onopen = () => console.log('接続確立');
  ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    console.log('受信:', data);
  };
  ws.send(JSON.stringify({ type: 'message', content: 'Hello' }));

  // Svelteストア形式のWebSocketクライアント
  interface WebSocketStore {
    connected: boolean;
    error: string | null;
    data: any[];
  }
  
  export function createWebSocketStore(url: string): {
    subscribe: Writable<WebSocketStore>['subscribe'];
    connect: () => void;
    send: <T>(data: T) => void;
    disconnect: () => void;
  } {
    // 実装演習
  }
  ```

### 4.3 接続失敗と再接続処理（1-2時間）
- **学習内容**
  - 接続失敗の種類と原因
  - 指数バックオフによる再接続
  - 接続品質の監視
- **演習**
  - 堅牢な再接続ロジックの実装
  - 接続状態インジケーターの作成


## 5. WebSocket API データ通信（学習時間: 6-7時間）

### 5.1 WebSocketオブジェクトとSvelteストア（2-3時間）
- **学習内容**
  - `readyState`プロパティ（CONNECTING, OPEN, CLOSING, CLOSED）
  - `send()`メソッドの使い方
  - `close()`メソッドとコード/理由
  - SvelteストアでのWebSocket状態管理
  - リアクティブな接続状態表示
- **演習**
  ```svelte
  <!-- WebSocket接続状態表示コンポーネント -->
  <script lang="ts">
    import { webSocketStore } from '$lib/stores/websocket';
    
    $: status = $webSocketStore.connected ? '接続中' : '切断中';
  </script>
  
  <div class="status {$webSocketStore.connected ? 'connected' : 'disconnected'}">
    {status}
  </div>
  ```

### 5.2 データ送受信パターン（2時間）
- **学習内容**
  - 文字列データの送受信
  - JSONデータのシリアライゼーション
  - メッセージ形式の設計（type, payload パターン）
- **演習**
  ```typescript
  interface WebSocketMessage<T = any> {
    type: string;
    id?: string;
    timestamp: number;
    payload: T;
  }
  
  // メッセージハンドラーの実装
  class MessageHandler {
    handle<T>(message: WebSocketMessage<T>): void {
      // 実装演習
    }
  }
  ```

### 5.3 高度なエラーハンドリング（2-3時間）
- **学習内容**
  - ネットワークエラーの分類
  - メッセージ配送保証の実装
  - タイムアウト処理
- **演習**
  - メッセージACKシステムの実装
  - 配送失敗時の再送機能
  - ハートビート機能の実装


## 6. WebSocket データフレームとサブプロトコル（学習時間: 6-7時間）

### 6.1 WebSocketフレーム構造（1-2時間）
- **学習内容**
  - フレームヘッダーの詳細（FIN, RSV, opcode）
  - ペイロード長の表現方法
  - マスキングキーの仕組み
- **演習**
  - フレーム解析ツールの作成
  - バイナリデータの手動パース

### 6.2 バイナリデータ送信（1-2時間）
- **学習内容**
  - `ArrayBuffer`, `Blob`, `Uint8Array`の使い分け
  - バイナリデータの効率的な送信
  - ファイルアップロードの実装
- **演習**
  - 画像データのリアルタイム送信
  - プロトコルバッファの実装

### 6.3 WebSocketサブプロトコルの設計（2-3時間）
- **学習内容**
  - **サブプロトコルの重要性**
    - WebSocket = 双方向通信の「配管」
    - サブプロトコル = 「データの形式・ルール」
    - 真の価値はサブプロトコル設計にある
  - **標準サブプロトコルの活用**
    - `graphql-ws`: GraphQL Subscriptions
    - `mqtt`: IoT向け軽量Pub/Sub通信
    - `json-rpc`: 双方向リモート呼び出し
    - `wamp`: Web Application Messaging Protocol
  - **独自サブプロトコルの設計指針**
    - メッセージタイプの定義（type, payload パターン）
    - JSON Schema による形式定義
    - バージョニング戦略
    - エラーハンドリング設計
- **演習**
  ```typescript
  // 独自チャットプロトコルの設計演習
  interface ChatMessage {
    type: 'message' | 'join' | 'leave' | 'typing';
    user: string;
    room: string;
    content?: string;
    timestamp: number;
    version: string;
  }
  
  // サブプロトコル指定での接続
  const ws = new WebSocket('wss://chat.example.com', 'myapp-chat-v1');
  ```


## 7. WebSocket 高度なトピック（学習時間: 8-10時間）

### 7.1 セキュリティ実装（3-4時間）
- **学習内容**
  - wss（WebSocket Secure）の設定
  - JWT認証トークンの統合
  - CSRF攻撃の対策
  - Rate limitingの実装
- **演習**
  ```typescript
  // 認証付きWebSocket接続
  class AuthenticatedWebSocket {
    constructor(private authToken: string) {}
    
    createConnection(url: string): WebSocket {
      const ws = new WebSocket(url);
      
      ws.onopen = () => {
        // 接続後にJWT認証
        ws.send(JSON.stringify({
          type: 'auth',
          token: this.authToken
        }));
      };
      
      return ws;
    }
  }
  ```

### 7.2 PWAとWebSocketの統合（3-4時間）
- **学習内容**
  - Service WorkerとWebSocketの関係
  - オフライン時のメッセージキューイング
  - Push通知とWebSocketの使い分け
  - Background Syncでの再接続処理
  - PWAライフサイクルとWebSocket管理
- **演習**
  ```typescript
  // Service Worker内でのWebSocketメッセージ管理
  // sw.js
  self.addEventListener('message', (event) => {
    if (event.data.type === 'WEBSOCKET_MESSAGE') {
      // オフライン時のメッセージ保存演習
    }
  });
  
  // SvelteKitでのPWA統合
  // app.html でのService Worker登録
  // WebSocketとPush通知の協調動作
  ```

### 7.3 スケーラビリティと負荷対策（2時間）
- **学習内容**
  - 水平スケーリングの課題
  - Redis Pub/Subによるメッセージ配信
  - ロードバランサー設定
  - 接続数監視とリソース管理
- **演習**
  - Node.js + Redis クラスター構築
  - 接続負荷テストの実施


## 8. テスト手法（学習時間: 5-6時間）

### 8.1 クライアント側テスト（2-3時間）
- **学習内容**
  - Vitest + @vitest/ui を使用したユニットテスト
  - WebSocketのモック化
  - Svelteコンポーネントのテスト（@testing-library/svelte）
  - 非同期処理のテスト
- **演習**
  ```typescript
  // WebSocketストアのテスト（Vitest）
  import { describe, it, expect, vi } from 'vitest';
  import { createWebSocketStore } from '$lib/stores/websocket';
  
  describe('WebSocketStore', () => {
    it('should connect and send message', async () => {
      // WebSocketモック作成
      const mockWS = vi.fn();
      global.WebSocket = mockWS;
      
      // テスト実装演習
    });
  });
  ```

### 8.2 サーバー側テスト（1-2時間）
- **学習内容**
  - VitestでのNode.js WebSocketサーバーテスト
  - 接続管理のテスト
  - メッセージハンドリングのテスト
- **演習**
  - Node.js WebSocketサーバーのテストスイート作成
  - クライアント・サーバー統合テスト

### 8.3 E2Eテスト（1-2時間）
- **学習内容**
  - PlaywrightでのSvelteKitアプリテスト
  - WebSocket通信のE2Eテスト
  - PWA機能のテスト
- **演習**
  - リアルタイムチャット機能のE2Eテスト実装
  - オフライン・オンライン切り替えテスト


## 9. 他技術との比較・使い分け（学習時間: 3-4時間）

### 9.1 代替技術の比較（2時間）
- **学習内容**
  - Server-Sent Events (SSE) との比較
  - Long Polling との違い
  - GraphQL Subscriptions との関係
  - **WebTransport**の将来展望
- **演習**
  - 各技術のパフォーマンス比較実験
  - 使い分けガイドライン作成

### 9.2 適用判断基準（1-2時間）
- **学習内容**
  - WebSocketが適している場面・適さない場面
  - コスト・複雑さとのトレードオフ
  - 代替案の提示方法
- **演習**
  - 技術選定マトリックスの作成
  - 既存プロジェクトへの適用可能性評価


## 10. 実践演習プロジェクト（学習時間: 15-20時間）

### 10.1 基礎プロジェクト: PWA対応リアルタイムチャット（7-10時間）
- **機能要件**
  - ユーザー認証（JWT）
  - リアルタイムメッセージ送受信
  - オンラインユーザー表示
  - メッセージ履歴
  - **PWA機能**: オフライン対応、プッシュ通知、アプリインストール
- **技術スタック（WebSocket API中心）**
  - フロントエンド: SvelteKit + TypeScript + PWA
  - バックエンド: Node.js + TypeScript + **標準`ws`ライブラリ**
  - データベース: MongoDB/PostgreSQL
  - PWA: @vite-pwa/sveltekit + Service Worker
- **サブプロトコル設計重視のアプローチ**
  ```typescript
  // 1. プロトコル設計から開始
  interface ChatProtocol {
    message: { user: string; content: string; room: string };
    join: { user: string; room: string };
    leave: { user: string; room: string };
    typing: { user: string; room: string; isTyping: boolean };
    userList: { room: string; users: string[] };
  }
  
  // 2. サブプロトコル指定での接続
  const ws = new WebSocket('wss://chat.example.com', 'myapp-chat-v1');
  ```
- **実装ポイント**
  ```typescript
  // SvelteKitでのSSR + WebSocket統合
  // src/routes/chat/+page.svelte
  <script lang="ts">
    import { onMount } from 'svelte';
    import { browser } from '$app/environment';
    import { chatStore } from '$lib/stores/chat';
    
    onMount(() => {
      if (browser) {
        // サブプロトコル指定で接続
        chatStore.connect('myapp-chat-v1');
      }
    });
  </script>
  ```

### 10.2 応用プロジェクト: リアルタイム共同編集システム（8-10時間）
- **機能要件**
  - リアルタイム文書編集
  - カーソル位置共有
  - 変更履歴管理
  - 競合解決
  - **PWA機能**: オフライン編集、同期復旧
- **技術的チャレンジ**
  - Operational Transform/CRDTsの実装
  - 大量データの効率的同期
  - SvelteKitでのSSR + クライアント側リアルタイム処理
  - Service Workerでのオフライン対応
  - 独自サブプロトコルでの複雑な状態管理


## 🔧 応用編：Socket.IO（オプション学習：3-5時間）

> **注意**: この章はWebSocket API習得後の**応用・オプション**です。基礎を理解してから必要に応じて学習してください。

### Socket.IOを学ぶべき場合
- **レガシーブラウザ対応**が必要（IE11など）
- **自動再接続・Room機能**を簡単に実装したい
- **フォールバック機能**（long polling）が必要
- **開発速度重視**でプロトタイピングしたい

### Socket.IO vs WebSocket API比較
| 特徴 | WebSocket API | Socket.IO |
|------|---------------|-----------|
| **標準性** | ブラウザ標準 | サードパーティライブラリ |
| **サイズ** | 軽量 | やや重い |
| **学習コスト** | 中程度 | 低い |
| **柔軟性** | 高い | 中程度 |
| **自動再接続** | 手動実装 | 自動 |
| **Room機能** | 手動実装 | 内蔵 |

### Socket.IO基本実装（演習）
```typescript
// サーバー側（Socket.IO）
import { Server } from 'socket.io';

const io = new Server(server);
io.on('connection', (socket) => {
  socket.on('message', (data) => {
    io.emit('message', data); // 全クライアントに配信
  });
});

// クライアント側（Socket.IO）
import { io } from 'socket.io-client';

const socket = io('wss://example.com');
socket.on('message', (data) => console.log(data));
socket.emit('message', { content: 'Hello' });
```


## 📋 学習リソース・参考資料

### 公式ドキュメント
- **[RFC 6455 - WebSocket Protocol](https://tools.ietf.org/html/rfc6455)** - WebSocket標準仕様
- **[MDN WebSocket API](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket)** - ブラウザ標準API
- [SvelteKit Documentation](https://kit.svelte.dev/docs)
- [Vitest Documentation](https://vitest.dev/)

### 推奨ライブラリ
- **WebSocket**: 
  - **クライアント**: ブラウザ標準WebSocket API
  - **サーバー**: Node.js標準`ws`ライブラリ
- **フレームワーク**: SvelteKit
- **サブプロトコル**: graphql-ws, mqtt.js
- **テスト**: Vitest, @testing-library/svelte, Playwright
- **PWA**: @vite-pwa/sveltekit, workbox
- **応用（オプション）**: Socket.IO

### PWA・WebSocket統合リソース
- [PWA WebSocket Background Sync](https://web.dev/background-sync/)
- [Service Worker WebSocket Integration](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)
- [SvelteKit PWA Guide](https://vite-pwa-org.netlify.app/frameworks/sveltekit.html)

### 開発ツール
- **デバッグ**: ブラウザ開発者ツール、Wireshark
- **テスト**: Postman, WebSocket King, Vitest UI
- **監視**: カスタム監視ダッシュボード
- **PWA**: Lighthouse, PWA Builder


## 🎯 習得目標チェックリスト

### 基礎レベル
- [ ] **ブラウザ標準WebSocket API**の基本概念と適用場面を説明できる
- [ ] WebSocketの11の主要カテゴリーの用途を理解し適用判断ができる
- [ ] HTTP/1.1、HTTP/2、HTTP/3でのWebSocket対応の違いを理解している
- [ ] End to End通信とHop by Hop通信の違いを理解している
- [ ] WebSocketハンドシェイクのEnd to End/Hop by Hop要素を識別できる

### 中級レベル
- [ ] WebSocket vs WebTransport/SSE等の使い分けを判断できる
- [ ] 用途に応じた適切なサブプロトコルを選択できる
- [ ] 独自サブプロトコルを設計・実装できる
- [ ] 標準的なサブプロトコル（graphql-ws、mqtt等）を活用できる
- [ ] プロトコルのバージョニング戦略を理解し実装できる

### 実装レベル
- [ ] **TypeScript + ブラウザ標準WebSocket API**でクライアントを実装できる
- [ ] **Angular+RxJSパターン**でWebSocket管理ができる
- [ ] **SvelteKit**でリアルタイムWebアプリケーションを構築できる
- [ ] Svelteストアを使ったWebSocket状態管理ができる
- [ ] **Node.js + 標準`ws`ライブラリ**でWebSocketサーバーを構築できる

### 応用レベル
- [ ] PWAとWebSocketを統合したアプリケーションを開発できる
- [ ] Service WorkerでのオフラインWebSocket対応ができる
- [ ] 認証・セキュリティを考慮した実装ができる
- [ ] スケーラブルなWebSocketアプリケーションを設計できる
- [ ] Vitestを使った適切なテスト戦略を立てて実装できる

### マスタレベル
- [ ] 他技術との使い分けを判断できる
- [ ] プロダクションレベルのPWA + WebSocketアプリを構築できる
- [ ] **Socket.IO等の応用技術の必要性を判断し適切に選択できる**

## 🚀 学習の進め方

1. **Phase 1 (基礎)**: WebSocket API + あなたのAngular+RxJS経験活用
2. **Phase 2 (移行)**: RxJSパターンからSvelteストアへの移行
3. **Phase 3 (実践)**: PWA統合とプロダクション対応
4. **Phase 4 (応用)**: 必要に応じてSocket.IO等の高度な機能学習

このカリキュラムにより、**WebSocket API**をしっかりとマスターした上で、あなたの経験を活かしながらSvelteを習得し、最終的にはPWA対応のリアルタイムアプリケーションを構築できるようになります。