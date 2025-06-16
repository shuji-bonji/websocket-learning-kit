<!-- src/routes/learn/websocket-intro/+page.svelte -->
<script lang="ts">
  import WebSocketDemo from '$lib/components/WebSocketDemo.svelte';
  
  let title = "WebSocket入門";
  let chapter = 1;
  
  // コードブロックを文字列として定義（構文エラーを修正）
  const httpPollingCode = `// 従来のHTTP方式（ポーリング）
async function checkMessages() {
  setInterval(async () => {
    const response = await fetch('/api/messages');
    const newMessages = await response.json();
    // UIを更新
  }, 1000); // 1秒ごとにサーバーに問い合わせ
}`;

  const websocketCode = `// WebSocket方式
const ws = new WebSocket('wss://api.example.com/messages');

ws.onmessage = (event) => {
  const newMessage = JSON.parse(event.data);
  // リアルタイムでUIを更新
};

// メッセージを送信
ws.send(JSON.stringify({ 
  type: 'message', 
  content: 'Hello!' 
}));`;

  const basicApiCode = `// 1. WebSocket接続の確立
const ws = new WebSocket('wss://echo.websocket.org');

// 接続状態を確認
console.log(ws.readyState); // 0 (CONNECTING)`;

  const eventHandlerCode = `// 2. イベントハンドラーの設定
ws.onopen = (event) => {
  console.log('Connection established');
  console.log(ws.readyState); // 1 (OPEN)
};

ws.onmessage = (event) => {
  console.log('Received:', event.data);
};

ws.onclose = (event) => {
  console.log('Connection closed', event.code);
};

ws.onerror = (event) => {
  console.log('WebSocket error:', event);
};`;

  const sendMessageCode = `// 3. メッセージ送信
// 接続が確立してから送信
if (ws.readyState === WebSocket.OPEN) {
  ws.send('Hello WebSocket!');
}`;

  const exerciseCode = `const ws = new WebSocket('wss://echo.websocket.org');
console.log('A:', ws.readyState); // ?

ws.onopen = () => {
  console.log('B:', ws.readyState); // ?
  ws.close();
};

ws.onclose = () => {
  console.log('C:', ws.readyState); // ?
};`;
</script>

<svelte:head>
  <title>Chapter 1: WebSocket入門 - WebSocket学習キット</title>
  <meta name="description" content="WebSocketの基本概念と使い方を学ぶ入門編" />
</svelte:head>

<div class="container">
  <!-- 章ヘッダー -->
  <div class="chapter-header">
    <div class="chapter-badge">Chapter {chapter}</div>
    <h1>🔗 {title}</h1>
    <p>WebSocketの基本概念と使い方を学び、従来のHTTP通信との違いを理解します</p>
  </div>

  <!-- 学習目標 -->
  <div class="objectives-section">
    <h2>📖 学習目標</h2>
    <ul>
      <li>WebSocketとHTTPの違いを説明できる</li>
      <li>WebSocketの適用場面を判断できる</li>
      <li>ブラウザ標準WebSocket APIの基本操作ができる</li>
      <li>接続状態（readyState）の変化を理解する</li>
    </ul>
  </div>

  <!-- WebSocketとは -->
  <h2>🌐 WebSocketとは何か？</h2>
  <p>
    <strong>WebSocket</strong>は、クライアント（ブラウザ）とサーバー間で
    <strong>双方向のリアルタイム通信</strong>を可能にするプロトコルです。
  </p>

  <h3>従来のHTTP通信の制限</h3>
  <div class="code-block">
    <pre><code>{httpPollingCode}</code></pre>
  </div>

  <div class="problem-list">
    <h4>問題点:</h4>
    <ul>
      <li>🔄 無駄なリクエストが多い</li>
      <li>⚡ リアルタイム性に欠ける</li>
      <li>📈 サーバー負荷が高い</li>
      <li>💰 帯域幅の浪費</li>
    </ul>
  </div>

  <h3>WebSocketによる解決</h3>
  <div class="code-block">
    <pre><code>{websocketCode}</code></pre>
  </div>

  <div class="benefit-list">
    <h4>利点:</h4>
    <ul>
      <li>⚡ 真のリアルタイム通信</li>
      <li>🚀 低レイテンシ</li>
      <li>💡 効率的なリソース使用</li>
      <li>🔄 双方向通信</li>
    </ul>
  </div>

  <!-- 接続状態表 -->
  <h2>🔗 WebSocket接続状態</h2>
  <table>
    <thead>
      <tr>
        <th>定数</th>
        <th>値</th>
        <th>状態</th>
        <th>説明</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>CONNECTING</code></td>
        <td>0</td>
        <td>接続中</td>
        <td>WebSocketコンストラクタ直後</td>
      </tr>
      <tr>
        <td><code>OPEN</code></td>
        <td>1</td>
        <td>接続済み</td>
        <td>データ送受信可能</td>
      </tr>
      <tr>
        <td><code>CLOSING</code></td>
        <td>2</td>
        <td>切断中</td>
        <td>close()実行後</td>
      </tr>
      <tr>
        <td><code>CLOSED</code></td>
        <td>3</td>
        <td>切断済み</td>
        <td>完全に切断された状態</td>
      </tr>
    </tbody>
  </table>

  <!-- 基本的な使い方 -->
  <h2>💻 基本的な使い方</h2>

  <h3>1. 接続確立</h3>
  <div class="code-block">
    <pre><code>{basicApiCode}</code></pre>
  </div>

  <h3>2. イベントハンドラーの設定</h3>
  <div class="code-block">
    <pre><code>{eventHandlerCode}</code></pre>
  </div>

  <h3>3. メッセージ送信</h3>
  <div class="code-block">
    <pre><code>{sendMessageCode}</code></pre>
  </div>

  <!-- 実際のデモ -->
  <h2>🚀 実際に体験してみよう</h2>
  <p>以下のデモでWebSocketの動作を実際に体験できます：</p>
  
  <WebSocketDemo 
    serverUrl="wss://echo.websocket.org" 
    autoConnect={false}
    showLogs={true}
  />

  <!-- 適用場面 -->
  <h2>🎯 WebSocketが活躍する場面</h2>
  <div class="use-cases">
    <div class="use-case-card">
      <h3>💬 リアルタイム通信</h3>
      <ul>
        <li>チャットアプリ（Discord、Slack）</li>
        <li>ライブサポート</li>
        <li>コメント機能</li>
      </ul>
    </div>
    
    <div class="use-case-card">
      <h3>✏️ 共同編集</h3>
      <ul>
        <li>Google Docs風エディタ</li>
        <li>Figma、Miro</li>
        <li>VS Code Live Share</li>
      </ul>
    </div>
    
    <div class="use-case-card">
      <h3>📊 データ配信</h3>
      <ul>
        <li>株価、為替情報</li>
        <li>スポーツライブスコア</li>
        <li>IoTセンサーデータ</li>
      </ul>
    </div>
    
    <div class="use-case-card">
      <h3>🎮 ゲーム</h3>
      <ul>
        <li>マルチプレイヤーゲーム</li>
        <li>リアルタイム対戦</li>
        <li>位置情報共有</li>
      </ul>
    </div>
  </div>

  <!-- 演習 -->
  <h2>📝 演習: 接続状態の理解</h2>
  <p>以下のコードの<code>readyState</code>の値を予測してください：</p>
  
  <div class="code-block">
    <pre><code>{exerciseCode}</code></pre>
  </div>

  <details class="exercise-answer">
    <summary>💡 答えを見る</summary>
    <div class="answer-content">
      <ul>
        <li><strong>A: 0 (CONNECTING)</strong> - WebSocketコンストラクタ直後は接続中状態</li>
        <li><strong>B: 1 (OPEN)</strong> - onopen内では接続確立済み</li>
        <li><strong>C: 3 (CLOSED)</strong> - onclose内では完全に閉じられた状態</li>
      </ul>
    </div>
  </details>

  <!-- まとめ -->
  <div class="summary-section">
    <h2>📋 この章のまとめ</h2>
    <div class="summary-grid">
      <div class="summary-card">
        <h3>✅ 理解したこと</h3>
        <ul>
          <li>WebSocketの基本概念</li>
          <li>HTTPとの違い</li>
          <li>接続状態の種類</li>
          <li>基本的なAPI使用法</li>
        </ul>
      </div>
      
      <div class="summary-card">
        <h3>🎯 適用場面</h3>
        <ul>
          <li>リアルタイム通信</li>
          <li>共同編集システム</li>
          <li>データ配信</li>
          <li>ゲーム開発</li>
        </ul>
      </div>
    </div>
  </div>

  <!-- 次のステップ -->
  <div class="next-step">
    <h2>🏃‍♀️ 次のステップ</h2>
    <p>おめでとうございます！WebSocketの基本概念を理解できました。</p>
    <p>次の章では、WebSocketとHTTP/2、HTTP/3との関係について詳しく学習します。</p>
    
    <div class="navigation-buttons">
      <a href="/learn" class="btn btn-secondary">目次に戻る</a>
      <a href="/learn/network-basics" class="btn btn-primary">次の章へ →</a>
    </div>
  </div>

  <hr style="margin: 3rem 0; border: none; border-top: 1px solid #e2e8f0;">
  <p style="text-align: center; color: #10b981; font-weight: 500;">
    <strong>進捗</strong>: Chapter 1 完了 🎉
  </p>
</div>

<style>
  .container {
    max-width: 900px;
    margin: 0 auto;
    padding: 2rem;
    font-family: system-ui, -apple-system, sans-serif;
    line-height: 1.6;
    color: #1a202c;
  }
  
  /* 章ヘッダー */
  .chapter-header {
    text-align: center;
    margin-bottom: 3rem;
    padding: 2rem;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-radius: 12px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  
  .chapter-badge {
    background: rgba(255, 255, 255, 0.2);
    color: white;
    padding: 0.5rem 1rem;
    border-radius: 2rem;
    font-size: 0.875rem;
    font-weight: 600;
    margin-bottom: 1rem;
    display: inline-block;
    backdrop-filter: blur(10px);
  }
  
  .chapter-header h1 {
    font-size: 2.5rem;
    margin: 1rem 0;
    color: white;
  }
  
  .chapter-header p {
    font-size: 1.125rem;
    margin: 0;
    opacity: 0.9;
  }
  
  /* 学習目標セクション */
  .objectives-section {
    background: #f0f9ff;
    border: 1px solid #0ea5e9;
    border-radius: 8px;
    padding: 1.5rem;
    margin: 2rem 0;
  }
  
  .objectives-section h2 {
    color: #0c4a6e;
    margin-top: 0;
  }
  
  /* コードブロック */
  .code-block {
    background: #1e293b;
    border-radius: 8px;
    padding: 1.5rem;
    margin: 1rem 0;
    overflow-x: auto;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  .code-block pre {
    margin: 0;
    font-family: 'JetBrains Mono', 'Fira Code', Consolas, 'Monaco', monospace;
    font-size: 0.875rem;
    line-height: 1.5;
  }
  
  .code-block code {
    color: #f1f5f9;
    background: none;
    padding: 0;
    border-radius: 0;
  }
  
  /* 問題点・利点リスト */
  .problem-list, .benefit-list {
    background: #fef2f2;
    border: 1px solid #fca5a5;
    border-radius: 8px;
    padding: 1.5rem;
    margin: 1rem 0;
  }
  
  .benefit-list {
    background: #f0fdf4;
    border-color: #86efac;
  }
  
  .problem-list h4, .benefit-list h4 {
    margin-top: 0;
    color: #991b1b;
  }
  
  .benefit-list h4 {
    color: #166534;
  }
  
  /* テーブル */
  table {
    width: 100%;
    border-collapse: collapse;
    margin: 1.5rem 0;
    background: white;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  th, td {
    padding: 1rem;
    text-align: left;
    border-bottom: 1px solid #e5e7eb;
  }
  
  th {
    background: #f9fafb;
    font-weight: 600;
    color: #374151;
  }
  
  code {
    background: #f3f4f6;
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-family: 'JetBrains Mono', monospace;
    font-size: 0.875em;
    color: #1f2937;
  }
  
  /* 使用例カード */
  .use-cases {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
    margin: 2rem 0;
  }
  
  .use-case-card {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    padding: 1.5rem;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    transition: transform 0.2s, box-shadow 0.2s;
  }
  
  .use-case-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  .use-case-card h3 {
    margin-top: 0;
    color: #1f2937;
    border-bottom: 2px solid #f3f4f6;
    padding-bottom: 0.5rem;
  }
  
  /* 演習セクション */
  .exercise-answer {
    margin: 1.5rem 0;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    background: white;
  }
  
  .exercise-answer summary {
    padding: 1rem;
    cursor: pointer;
    font-weight: 500;
    background: #f9fafb;
    border-radius: 8px 8px 0 0;
    user-select: none;
  }
  
  .exercise-answer summary:hover {
    background: #f3f4f6;
  }
  
  .answer-content {
    padding: 1rem;
  }
  
  /* まとめセクション */
  .summary-section {
    background: #f8fafc;
    border-radius: 12px;
    padding: 2rem;
    margin: 3rem 0;
    border: 1px solid #e2e8f0;
  }
  
  .summary-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 2rem;
    margin-top: 1rem;
  }
  
  .summary-card {
    background: white;
    border-radius: 8px;
    padding: 1.5rem;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  }
  
  .summary-card h3 {
    margin-top: 0;
    color: #1f2937;
  }
  
  /* 次のステップ */
  .next-step {
    background: #f0f9ff;
    border: 1px solid #0ea5e9;
    border-radius: 12px;
    padding: 2rem;
    margin: 3rem 0;
    text-align: center;
  }
  
  .navigation-buttons {
    margin-top: 2rem;
    display: flex;
    gap: 1rem;
    justify-content: center;
    flex-wrap: wrap;
  }
  
  .btn {
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    text-decoration: none;
    font-weight: 500;
    transition: all 0.2s;
    border: none;
    cursor: pointer;
    display: inline-block;
  }
  
  .btn-primary {
    background: #3b82f6;
    color: white;
  }
  
  .btn-primary:hover {
    background: #2563eb;
    text-decoration: none;
  }
  
  .btn-secondary {
    background: #6b7280;
    color: white;
  }
  
  .btn-secondary:hover {
    background: #4b5563;
    text-decoration: none;
  }
  
  /* レスポンシブ対応 */
  @media (max-width: 768px) {
    .container {
      padding: 1rem;
    }
    
    .chapter-header {
      padding: 1.5rem;
    }
    
    .chapter-header h1 {
      font-size: 2rem;
    }
    
    .use-cases {
      grid-template-columns: 1fr;
    }
    
    .summary-grid {
      grid-template-columns: 1fr;
    }
    
    .navigation-buttons {
      flex-direction: column;
      align-items: center;
    }
    
    .btn {
      width: 100%;
      max-width: 300px;
    }
  }
  
  /* アニメーション */
  @keyframes fadeIn {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  .use-case-card, .summary-card {
    animation: fadeIn 0.6s ease-out;
  }
</style>