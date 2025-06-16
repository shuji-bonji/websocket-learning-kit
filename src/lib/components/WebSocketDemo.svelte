<!-- src/lib/components/WebSocketDemo.svelte -->
<script lang="ts">
  import { onMount, onDestroy } from 'svelte';
  
  // Props
  export let serverUrl: string = 'wss://echo.websocket.org';
  export let autoConnect: boolean = false;
  export let showLogs: boolean = true;
  
  // State
  let ws: WebSocket | null = null;
  let message: string = '';
  let messages: Array<{type: string, content: string, time: string}> = [];
  let connected: boolean = false;
  let connecting: boolean = false;
  
  // Computed
  $: canSend = connected && message.trim().length > 0;
  $: connectionStatus = connecting ? '接続中...' : (connected ? '接続済み' : '切断中');
  
  function addMessage(type: string, content: string): void {
    const now = new Date();
    messages = [...messages, {
      type,
      content,
      time: now.toLocaleTimeString()
    }];
    
    // メッセージ数制限（パフォーマンス対策）
    if (messages.length > 50) {
      messages = messages.slice(-50);
    }
  }
  
  function connect(): void {
    if (connecting || connected) return;
    
    connecting = true;
    addMessage('system', `接続試行中: ${serverUrl}`);
    
    try {
      ws = new WebSocket(serverUrl);
      
      ws.onopen = () => {
        connected = true;
        connecting = false;
        addMessage('system', '接続が確立されました');
      };
      
      ws.onmessage = (event: MessageEvent) => {
        addMessage('receive', event.data);
      };
      
      ws.onclose = (event: CloseEvent) => {
        connected = false;
        connecting = false;
        addMessage('system', `接続が閉じられました (code: ${event.code})`);
        ws = null;
      };
      
      ws.onerror = () => {
        connecting = false;
        addMessage('system', '接続エラーが発生しました');
      };
      
    } catch (error) {
      connecting = false;
      addMessage('system', `接続エラー: ${error instanceof Error ? error.message : String(error)}`);
    }
  }
  
  function disconnect(): void {
    if (ws) {
      ws.close(1000, 'Normal closure');
    }
  }
  
  function sendMessage(): void {
    if (!canSend || !ws) return;
    
    const messageText = message.trim();
    
    try {
      ws.send(messageText);
      addMessage('send', messageText);
      message = '';
    } catch (error) {
      addMessage('system', `送信エラー: ${error instanceof Error ? error.message : String(error)}`);
    }
  }
  
  function clearMessages(): void {
    messages = [];
  }
  
  function handleKeyPress(event: KeyboardEvent): void {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      sendMessage();
    }
  }
  
  // Lifecycle
  onMount(() => {
    if (autoConnect) {
      connect();
    }
  });
  
  onDestroy(() => {
    if (ws) {
      ws.close();
    }
  });
</script>

<div class="websocket-demo">
  <div class="demo-header">
    <h3>🔌 WebSocket接続デモ</h3>
    <div class="connection-info">
      <span class="status" class:connected class:connecting>
        {connectionStatus}
      </span>
      <span class="message-count">メッセージ: {messages.length}</span>
    </div>
  </div>
  
  <div class="connection-controls">
    <div class="url-display">
      <label>接続先:</label>
      <code>{serverUrl}</code>
    </div>
    
    <div class="action-buttons">
      <button 
        on:click={connect} 
        disabled={connecting || connected}
        class="connect-btn"
      >
        {connecting ? '接続中...' : '接続'}
      </button>
      
      <button 
        on:click={disconnect} 
        disabled={!connected}
        class="disconnect-btn"
      >
        切断
      </button>
      
      <button 
        on:click={clearMessages}
        class="clear-btn"
      >
        クリア
      </button>
    </div>
  </div>
  
  <div class="message-area">
    <div class="messages" role="log" aria-label="WebSocketメッセージログ">
      {#each messages as msg (msg.time + msg.content)}
        <div class="message" class:system={msg.type === 'system'} class:sent={msg.type === 'send'} class:received={msg.type === 'receive'}>
          <span class="timestamp">{msg.time}</span>
          <span class="type-badge">{msg.type === 'send' ? '送信' : msg.type === 'receive' ? '受信' : 'システム'}</span>
          <span class="content">{msg.content}</span>
        </div>
      {/each}
      
      {#if messages.length === 0}
        <div class="empty-state">
          メッセージはまだありません。接続してメッセージを送信してください。
        </div>
      {/if}
    </div>
  </div>
  
  <div class="message-input">
    <input
      type="text"
      bind:value={message}
      on:keypress={handleKeyPress}
      disabled={!connected}
      placeholder={connected ? 'メッセージを入力してEnterキーで送信' : '接続してください'}
      aria-label="送信するメッセージ"
    />
    <button 
      on:click={sendMessage}
      disabled={!canSend}
      class="send-btn"
    >
      送信
    </button>
  </div>
  
  {#if showLogs}
    <div class="demo-info">
      <details>
        <summary>📖 このデモについて</summary>
        <ul>
          <li><strong>Echo Server使用</strong>: 送信したメッセージがそのまま返されます</li>
          <li><strong>リアルタイム通信</strong>: メッセージは即座に表示されます</li>
          <li><strong>接続状態監視</strong>: 接続・切断状態をリアルタイムで確認できます</li>
          <li><strong>エラーハンドリング</strong>: 接続エラーも適切に表示されます</li>
        </ul>
      </details>
    </div>
  {/if}
</div>

<style>
  .websocket-demo {
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 1.5rem;
    margin: 2rem 0;
    background: #ffffff;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  }
  
  .demo-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
    gap: 1rem;
  }
  
  .demo-header h3 {
    margin: 0;
    color: #1e293b;
    font-size: 1.25rem;
  }
  
  .connection-info {
    display: flex;
    gap: 1rem;
    font-size: 0.875rem;
    align-items: center;
    flex-wrap: wrap;
  }
  
  .status {
    padding: 0.375rem 0.75rem;
    border-radius: 6px;
    font-weight: 500;
    background: #f1f5f9;
    color: #475569;
    transition: all 0.2s;
  }
  
  .status.connected {
    background: #dcfce7;
    color: #166534;
  }
  
  .status.connecting {
    background: #fef3c7;
    color: #92400e;
    animation: pulse 2s infinite;
  }
  
  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.7; }
  }
  
  .message-count {
    color: #64748b;
    font-size: 0.8rem;
  }
  
  .connection-controls {
    display: flex;
    gap: 1rem;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
    align-items: center;
    justify-content: space-between;
  }
  
  .url-display {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.875rem;
  }
  
  .url-display label {
    font-weight: 500;
    color: #374151;
  }
  
  .url-display code {
    background: #f3f4f6;
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-size: 0.8rem;
    color: #1f2937;
  }
  
  .action-buttons {
    display: flex;
    gap: 0.5rem;
    flex-wrap: wrap;
  }
  
  button {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 6px;
    font-size: 0.875rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  
  button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
  
  .connect-btn {
    background: #3b82f6;
    color: white;
  }
  
  .connect-btn:hover:not(:disabled) {
    background: #2563eb;
    transform: translateY(-1px);
  }
  
  .disconnect-btn {
    background: #ef4444;
    color: white;
  }
  
  .disconnect-btn:hover:not(:disabled) {
    background: #dc2626;
    transform: translateY(-1px);
  }
  
  .clear-btn {
    background: #6b7280;
    color: white;
  }
  
  .clear-btn:hover:not(:disabled) {
    background: #4b5563;
    transform: translateY(-1px);
  }
  
  .message-area {
    margin-bottom: 1rem;
  }
  
  .messages {
    height: 300px;
    overflow-y: auto;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    padding: 1rem;
    background: #fafafa;
    font-family: 'JetBrains Mono', 'Fira Code', Consolas, monospace;
    font-size: 0.8rem;
    line-height: 1.5;
  }
  
  .message {
    display: flex;
    gap: 0.75rem;
    margin-bottom: 0.75rem;
    align-items: flex-start;
    padding: 0.5rem;
    border-radius: 6px;
    transition: background-color 0.2s;
  }
  
  .message:hover {
    background: #f3f4f6;
  }
  
  .message.system {
    background: #f8fafc;
    border-left: 3px solid #64748b;
  }
  
  .message.sent {
    background: #eff6ff;
    border-left: 3px solid #3b82f6;
  }
  
  .message.received {
    background: #f0fdf4;
    border-left: 3px solid #10b981;
  }
  
  .timestamp {
    color: #9ca3af;
    flex-shrink: 0;
    font-size: 0.75rem;
    min-width: 70px;
  }
  
  .type-badge {
    background: #e5e7eb;
    color: #374151;
    padding: 0.125rem 0.375rem;
    border-radius: 4px;
    font-size: 0.7rem;
    font-weight: 500;
    flex-shrink: 0;
  }
  
  .message.system .type-badge {
    background: #64748b;
    color: white;
  }
  
  .message.sent .type-badge {
    background: #3b82f6;
    color: white;
  }
  
  .message.received .type-badge {
    background: #10b981;
    color: white;
  }
  
  .content {
    flex: 1;
    word-wrap: break-word;
    color: #1f2937;
  }
  
  .empty-state {
    color: #9ca3af;
    text-align: center;
    padding: 3rem 1rem;
    font-style: italic;
    background: #f9fafb;
    border-radius: 6px;
    border: 2px dashed #d1d5db;
  }
  
  .message-input {
    display: flex;
    gap: 0.75rem;
    align-items: stretch;
  }
  
  .message-input input {
    flex: 1;
    padding: 0.75rem;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    font-size: 0.875rem;
    transition: border-color 0.2s, box-shadow 0.2s;
  }
  
  .message-input input:focus {
    outline: none;
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  }
  
  .message-input input:disabled {
    background: #f9fafb;
    color: #9ca3af;
  }
  
  .send-btn {
    background: #10b981;
    color: white;
    padding: 0.75rem 1.5rem;
  }
  
  .send-btn:hover:not(:disabled) {
    background: #059669;
    transform: translateY(-1px);
  }
  
  .demo-info {
    margin-top: 1.5rem;
    font-size: 0.875rem;
  }
  
  .demo-info details {
    background: #f8fafc;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    padding: 0;
    overflow: hidden;
  }
  
  .demo-info summary {
    cursor: pointer;
    font-weight: 500;
    padding: 1rem;
    background: #f1f5f9;
    transition: background-color 0.2s;
    user-select: none;
  }
  
  .demo-info summary:hover {
    background: #e2e8f0;
  }
  
  .demo-info ul {
    margin: 0;
    padding: 1rem 1rem 1rem 2rem;
  }
  
  .demo-info li {
    margin-bottom: 0.5rem;
    line-height: 1.5;
  }
  
  /* レスポンシブ対応 */
  @media (max-width: 768px) {
    .demo-header {
      flex-direction: column;
      align-items: flex-start;
    }
    
    .connection-controls {
      flex-direction: column;
      align-items: stretch;
    }
    
    .action-buttons {
      width: 100%;
      justify-content: center;
    }
    
    .action-buttons button {
      flex: 1;
      min-width: 0;
    }
    
    .messages {
      height: 250px;
    }
    
    .message {
      flex-wrap: wrap;
      gap: 0.5rem;
    }
    
    .timestamp, .type-badge {
      font-size: 0.7rem;
    }
  }
  
  /* アクセシビリティ */
  @media (prefers-reduced-motion: reduce) {
    * {
      animation: none !important;
      transition: none !important;
    }
  }
  
  /* スクロールバーのスタイリング */
  .messages::-webkit-scrollbar {
    width: 8px;
  }
  
  .messages::-webkit-scrollbar-track {
    background: #f1f5f9;
    border-radius: 4px;
  }
  
  .messages::-webkit-scrollbar-thumb {
    background: #cbd5e1;
    border-radius: 4px;
  }
  
  .messages::-webkit-scrollbar-thumb:hover {
    background: #94a3b8;
  }
</style>