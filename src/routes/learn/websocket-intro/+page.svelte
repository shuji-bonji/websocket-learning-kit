<script lang="ts">
  import WebSocketDemo from '$lib/components/WebSocketDemo.svelte';
  
  let title = "WebSocket入門";
  let chapter = 1;
  
  // コードブロックを文字列として定義
  const code1 = `const ws: WebSocket = new WebSocket('wss://echo.websocket.org');

// 接続状態を確認
console.log(ws.readyState); // 0 (CONNECTING)`;

  const code2 = `ws.onopen = (event: Event): void => {
  console.log('Connection established');
  console.log(ws.readyState); // 1 (OPEN)
};

ws.onmessage = (event: MessageEvent<string>): void => {
  console.log('Received:', event.data);
};

ws.onclose = (event: CloseEvent): void => {
  console.log('Connection closed', event.code);
};`;

  const code3 = `// 接続が確立してから送信
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

<style>
  .container {
    max-width: 800px;
    margin: 0 auto;
    padding: 2rem;
    font-family: system-ui, sans-serif;
    line-height: 1.6;
  }
  
  h1 {
    color: #2d3748;
    border-bottom: 2px solid #ff3e00;
    padding-bottom: 0.5rem;
  }
  
  h2 {
    color: #2d3748;
    margin-top: 2rem;
  }
  
  table {
    width: 100%;
    border-collapse: collapse;
    margin: 1rem 0;
  }
  
  th, td {
    border: 1px solid #e2e8f0;
    padding: 0.75rem;
    text-align: left;
  }
  
  th {
    background: #f7fafc;
  }
  
  .chapter-header {
    text-align: center;
    margin-bottom: 3rem;
    padding: 2rem;
    background: #f8fafc;
    border-radius: 8px;
    border: 1px solid #e2e8f0;
  }
  
  .chapter-badge {
    background: #ff3e00;
    color: white;
    padding: 0.375rem 0.75rem;
    border-radius: 1rem;
    font-size: 0.875rem;
    font-weight: 600;
    margin-bottom: 1rem;
    display: inline-block;
  }
  
  .code-block {
    background: #2d3748;
    color: #f7fafc;
    padding: 1rem;
    border-radius: 0.5rem;
    overflow-x: auto;
    margin: 1rem 0;
    font-family: 'SF Mono', 'Monaco', 'Cascadia Code', monospace;
    font-size: 0.875rem;
    white-space: pre-wrap;
  }
  
  .note {
    border-left: 4px solid #3b82f6;
    background: #f8fafc;
    margin: 1.5rem 0;
    padding: 1rem 1.5rem;
    border-radius: 0 0.5rem 0.5rem 0;
  }
  
  details {
    margin: 1rem 0;
    padding: 1rem;
    border: 1px solid #e2e8f0;
    border-radius: 0.5rem;
  }
  
  summary {
    cursor: pointer;
    font-weight: 600;
    color: #3b82f6;
  }
</style>

<div class="container">
  <div class="chapter-header">
    <div class="chapter-badge">Chapter {chapter}</div>
    <h1>{title}</h1>
    <p><strong>推定時間:</strong> 1-2時間</p>
  </div>

  <h2>📖 学習目標</h2>
  <p>この章を完了すると、以下ができるようになります：</p>
  <ul>
    <li>WebSocketの基本概念を説明できる</li>
    <li>HTTPとWebSocketの違いを理解している</li>
    <li>ブラウザでWebSocket接続を実行できる</li>
  </ul>

  <h2>🔍 WebSocketとは？</h2>
  <p><strong>WebSocket</strong>は、クライアント（ブラウザ）とサーバー間で<strong>双方向のリアルタイム通信</strong>を可能にするプロトコルです。</p>

  <h3>HTTPとWebSocketの違い</h3>
  <table>
    <thead>
      <tr>
        <th>特徴</th>
        <th>HTTP</th>
        <th>WebSocket</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>通信方向</strong></td>
        <td>一方向（リクエスト→レスポンス）</td>
        <td>双方向</td>
      </tr>
      <tr>
        <td><strong>接続</strong></td>
        <td>リクエスト毎に開閉</td>
        <td>永続的な接続</td>
      </tr>
      <tr>
        <td><strong>オーバーヘッド</strong></td>
        <td>高い（毎回ヘッダー送信）</td>
        <td>低い（最初だけハンドシェイク）</td>
      </tr>
    </tbody>
  </table>

  <h2>🚀 実際に体験してみましょう</h2>
  <p>下のデモでWebSocket接続を試してください：</p>

  <WebSocketDemo 
    serverUrl="wss://echo.websocket.org"
    autoConnect={false}
    showLogs={true}
  />

  <div class="note">
    <strong>解説</strong>: 上記は実際に動作するWebSocketエコーサーバー（<code>wss://echo.websocket.org</code>）です。送信したメッセージがそのまま返ってきます。
  </div>

  <h2>💡 ここで何が起こっているか？</h2>
  <p>WebSocket接続では以下の流れで通信が行われます：</p>

  <h3>1. 接続確立</h3>
  <div class="code-block">{code1}</div>

  <h3>2. イベントハンドラーの設定</h3>
  <div class="code-block">{code2}</div>

  <h3>3. メッセージ送信</h3>
  <div class="code-block">{code3}</div>

  <h2>🎯 WebSocketが活躍する場面</h2>
  <ul>
    <li><strong>リアルタイム通信</strong>: チャットアプリ（Discord、Slack）</li>
    <li><strong>共同編集</strong>: Google Docs、Figma、VS Code Live Share</li>
    <li><strong>データ配信</strong>: 株価、為替、スポーツライブスコア</li>
    <li><strong>ゲーム</strong>: マルチプレイヤーオンラインゲーム</li>
    <li><strong>IoT</strong>: センサーデータのリアルタイム監視</li>
  </ul>

  <h2>📝 演習: 接続状態の理解</h2>
  <p>以下のコードの<code>readyState</code>の値を予測してください：</p>
  
  <div class="code-block">{exerciseCode}</div>

  <details>
    <summary>答えを見る</summary>
    <ul>
      <li><strong>A: 0 (CONNECTING)</strong> - WebSocketコンストラクタ直後は接続中状態</li>
      <li><strong>B: 1 (OPEN)</strong> - onopen内では接続確立済み</li>
      <li><strong>C: 3 (CLOSED)</strong> - onclose内では完全に閉じられた状態</li>
    </ul>
  </details>

  <h2>🏃‍♀️ 次のステップ</h2>
  <p>おめでとうございます！WebSocketの基本概念を理解できました。</p>
  <p>次の章では、WebSocketを取り巻くネットワーク技術について学習します。</p>

  <hr style="margin: 3rem 0; border: none; border-top: 1px solid #e2e8f0;">
  <p style="text-align: center; color: #10b981; font-weight: 500;"><strong>進捗</strong>: Chapter 1 完了 🎉</p>
</div>