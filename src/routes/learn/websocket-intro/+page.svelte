<!-- src/routes/learn/websocket-intro/+page.svelte -->
<script lang="ts">
  import ChapterHeader from '$lib/components/learning/ChapterHeader.svelte';
  import CodeBlock from '$lib/components/learning/CodeBlock.svelte';
  import ExerciseBox from '$lib/components/learning/ExerciseBox.svelte';
  import WebSocketDemo from '$lib/components/WebSocketDemo.svelte';
  
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

<div class="page-container">
  <!-- 章ヘッダー -->
  <ChapterHeader 
    chapter={1}
    title="🔗 WebSocket入門"
    description="WebSocketの基本概念と使い方を学び、従来のHTTP通信との違いを理解します"
    estimatedTime="3-4時間"
    exercises={3}
    difficulty="beginner"
    tags={["WebSocket", "リアルタイム通信", "Web API"]}
    objectives={[
      "WebSocketとHTTPの違いを説明できる",
      "WebSocketの適用場面を判断できる", 
      "ブラウザ標準WebSocket APIの基本操作ができる",
      "接続状態（readyState）の変化を理解する"
    ]}
  />

  <!-- メインコンテンツ -->
  <main class="content">
    <!-- WebSocketとは -->
    <section>
      <h2>🌐 WebSocketとは何か？</h2>
      <p>
        <strong>WebSocket</strong>は、クライアント（ブラウザ）とサーバー間で
        <strong>双方向のリアルタイム通信</strong>を可能にするプロトコルです。
      </p>

      <h3>従来のHTTP通信の制限</h3>
      <CodeBlock code={httpPollingCode} title="polling.ts" />

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
      <CodeBlock code={websocketCode} title="websocket.ts" />

      <div class="benefit-list">
        <h4>利点:</h4>
        <ul>
          <li>⚡ 真のリアルタイム通信</li>
          <li>🚀 低レイテンシ</li>
          <li>💡 効率的なリソース使用</li>
          <li>🔄 双方向通信</li>
        </ul>
      </div>
    </section>

    <!-- 接続状態 -->
    <section>
      <h2>🔗 WebSocket接続状態</h2>
      <div class="state-table">
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
      </div>
    </section>

    <!-- 基本的な使い方 -->
    <section>
      <h2>💻 基本的な使い方</h2>

      <h3>1. 接続確立</h3>
      <CodeBlock code={basicApiCode} title="connection.ts" />

      <h3>2. イベントハンドラーの設定</h3>
      <CodeBlock code={eventHandlerCode} title="handlers.ts" />

      <h3>3. メッセージ送信</h3>
      <CodeBlock code={sendMessageCode} title="send-message.ts" />
    </section>

    <!-- 実際のデモ -->
    <section>
      <h2>🚀 実際に体験してみよう</h2>
      <p>以下のデモでWebSocketの動作を実際に体験できます：</p>
      
      <WebSocketDemo 
        serverUrl="wss://echo.websocket.org" 
        autoConnect={false}
        showLogs={true}
      />
    </section>

    <!-- 適用場面 -->
    <section>
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
    </section>

    <!-- 演習 -->
    <ExerciseBox 
      title="接続状態の理解" 
      type="quiz" 
      difficulty="easy"
      showAnswer={true}
    >
      <div slot="content">
        <p>以下のコードの<code>readyState</code>の値を予測してください：</p>
        <CodeBlock code={exerciseCode} />
      </div>
      
      <div slot="answer">
        <ul>
          <li><strong>A: 0 (CONNECTING)</strong> - WebSocketコンストラクタ直後は接続中状態</li>
          <li><strong>B: 1 (OPEN)</strong> - onopen内では接続確立済み</li>
          <li><strong>C: 3 (CLOSED)</strong> - onclose内では完全に閉じられた状態</li>
        </ul>
      </div>
    </ExerciseBox>

    <!-- まとめ -->
    <section class="summary">
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
    </section>

    <!-- 次のステップ -->
    <div class="next-step">
      <h2>🏃‍♀️ 次のステップ</h2>
      <p>おめでとうございます！WebSocketの基本概念を理解できました。</p>
      <p>次の章では、WebSocketとHTTP/2、HTTP/3との関係について詳しく学習します。</p>
      
      <div class="navigation-buttons">
        <a href="/learn" class="btn btn-secondary">📚 目次に戻る</a>
        <a href="/learn/network-basics" class="btn btn-primary">次の章へ →</a>
      </div>
    </div>

    <hr class="chapter-end" />
    <p class="completion-message">
      <strong>進捗</strong>: Chapter 1 完了 🎉
    </p>
  </main>
</div>

<style>
  .page-container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 2rem;
    font-family: system-ui, -apple-system, sans-serif;
    line-height: 1.6;
    color: #1a202c;
  }
  
  .content {
    background: white;
    border-radius: 12px;
    padding: 3rem;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  }
  
  section {
    margin: 3rem 0;
  }
  
  section:first-child {
    margin-top: 0;
  }
  
  h2 {
    font-size: 1.875rem;
    color: #334155;
    margin: 2.5rem 0 1.5rem 0;
    border-bottom: 2px solid #e2e8f0;
    padding-bottom: 0.5rem;
  }
  
  h3 {
    font-size: 1.5rem;
    color: #475569;
    margin: 2rem 0 1rem 0;
  }
  
  h4 {
    font-size: 1.25rem;
    color: #64748b;
    margin: 1.5rem 0 0.75rem 0;
  }
  
  p {
    margin: 1rem 0;
    text-align: justify;
  }
  
  /* 問題点・利点リスト */
  .problem-list, .benefit-list {
    background: #fef2f2;
    border: 1px solid #fca5a5;
    border-radius: 8px;
    padding: 1.5rem;
    margin: 1.5rem 0;
  }
  
  .benefit-list {
    background: #f0fdf4;
    border-color: #86efac;
  }
  
  .problem-list h4 {
    color: #991b1b;
    margin-top: 0;
  }
  
  .benefit-list h4 {
    color: #166534;
    margin-top: 0;
  }
  
  /* 状態テーブル */
  .state-table {
    overflow-x: auto;
    margin: 1.5rem 0;
  }
  
  table {
    width: 100%;
    border-collapse: collapse;
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
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 1.5rem;
    transition: transform 0.2s, box-shadow 0.2s;
  }
  
  .use-case-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  .use-case-card h3 {
    margin-top: 0;
    color: #1f2937;
    border-bottom: 2px solid #e2e8f0;
    padding-bottom: 0.5rem;
  }
  
  .use-case-card ul {
    margin: 1rem 0 0 0;
    padding-left: 1.5rem;
  }
  
  .use-case-card li {
    margin: 0.5rem 0;
  }
  
  /* まとめセクション */
  .summary {
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
    margin-top: 1.5rem;
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
  
  .summary-card ul {
    margin: 1rem 0 0 0;
    padding-left: 1.5rem;
  }
  
  .summary-card li {
    margin: 0.5rem 0;
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
    transform: translateY(-1px);
  }
  
  .btn-secondary {
    background: #6b7280;
    color: white;
  }
  
  .btn-secondary:hover {
    background: #4b5563;
    text-decoration: none;
    transform: translateY(-1px);
  }
  
  /* 章の終了 */
  .chapter-end {
    border: none;
    border-top: 2px solid #e2e8f0;
    margin: 3rem 0 2rem 0;
  }
  
  .completion-message {
    text-align: center;
    color: #10b981;
    font-weight: 500;
    font-size: 1.125rem;
    margin: 0;
  }
  
  /* レスポンシブ対応 */
  @media (max-width: 768px) {
    .page-container {
      padding: 1rem;
    }
    
    .content {
      padding: 1.5rem;
    }
    
    h2 {
      font-size: 1.5rem;
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
    
    table {
      font-size: 0.875rem;
    }
    
    th, td {
      padding: 0.75rem 0.5rem;
    }
  }
</style>