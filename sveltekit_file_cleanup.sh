# WebSocket学習キット - ファイル構成クリーンアップ

# 1. 重複ファイルの検索と削除
echo "🔍 重複ファイルを検索中..."
find src/routes -name "*copy*" -type f

echo "🗑️ 重複ファイルを削除中..."
# 見つかった場合は削除
find src/routes -name "*copy*" -type f -delete

# 2. 正しいファイル構成の確認
echo "📁 現在のファイル構成:"
tree src/routes/ || find src/routes -type f | sort

# 3. 必須ファイルの作成（存在しない場合）
echo "🔧 必須ファイルの確認・作成..."

# ルートレイアウト
if [ ! -f "src/routes/+layout.svelte" ]; then
    echo "Creating src/routes/+layout.svelte..."
    cat > src/routes/+layout.svelte << 'EOF'
<script lang="ts">
	import '../app.css';
</script>

<div class="app">
	<slot />
</div>

<style>
	.app {
		min-height: 100vh;
		padding: 2rem;
		max-width: 1200px;
		margin: 0 auto;
	}
</style>
EOF
fi

# ホームページ
if [ ! -f "src/routes/+page.svelte" ]; then
    echo "Creating src/routes/+page.svelte..."
    cat > src/routes/+page.svelte << 'EOF'
<script lang="ts">
	import { browser } from '$app/environment';
</script>

<svelte:head>
	<title>WebSocket学習キット</title>
	<meta name="description" content="WebSocketとSvelteKitを使ったリアルタイムWeb開発学習" />
</svelte:head>

<main>
	<h1>🔗 WebSocket学習キット</h1>
	<p>WebSocketとSvelteKitでリアルタイムWeb開発を学びましょう！</p>
	
	<nav class="course-nav">
		<h2>📚 学習コース</h2>
		<ul>
			<li><a href="/learn/websocket-intro">Chapter 1: WebSocket基礎</a></li>
			<li><a href="/learn/svelte-integration">Chapter 2: Svelte統合</a></li>
			<li><a href="/learn/practical-examples">Chapter 3: 実践例</a></li>
		</ul>
	</nav>
	
	{#if browser}
		<div class="browser-support">
			<p>✅ WebSocket対応ブラウザで表示中</p>
		</div>
	{/if}
</main>

<style>
	main {
		text-align: center;
		padding: 2rem 0;
	}
	
	h1 {
		color: #ff3e00;
		font-size: 2.5rem;
		margin-bottom: 1rem;
	}
	
	.course-nav {
		max-width: 600px;
		margin: 2rem auto;
		text-align: left;
		background: #f8f9fa;
		padding: 2rem;
		border-radius: 8px;
	}
	
	.course-nav ul {
		list-style: none;
		padding: 0;
	}
	
	.course-nav li {
		margin: 1rem 0;
	}
	
	.course-nav a {
		color: #0066cc;
		text-decoration: none;
		font-weight: 500;
		padding: 0.5rem 1rem;
		border-radius: 4px;
		display: inline-block;
		transition: background-color 0.2s;
	}
	
	.course-nav a:hover {
		background-color: #e9ecef;
	}
	
	.browser-support {
		margin-top: 2rem;
		padding: 1rem;
		background: #d4edda;
		border: 1px solid #c3e6cb;
		border-radius: 4px;
		color: #155724;
	}
</style>
EOF
fi

# 学習セクションディレクトリの作成
mkdir -p src/routes/learn

# 学習セクション用レイアウト
if [ ! -f "src/routes/learn/+layout.svelte" ]; then
    echo "Creating src/routes/learn/+layout.svelte..."
    cat > src/routes/learn/+layout.svelte << 'EOF'
<script lang="ts">
	import { page } from '$app/stores';
	
	$: currentPath = $page.url.pathname;
</script>

<div class="learn-layout">
	<nav class="sidebar">
		<h3>📚 学習メニュー</h3>
		<ul>
			<li>
				<a 
					href="/learn/websocket-intro" 
					class:active={currentPath === '/learn/websocket-intro'}
				>
					Chapter 1: WebSocket基礎
				</a>
			</li>
			<li>
				<a 
					href="/learn/svelte-integration"
					class:active={currentPath === '/learn/svelte-integration'}
				>
					Chapter 2: Svelte統合
				</a>
			</li>
			<li>
				<a 
					href="/learn/practical-examples"
					class:active={currentPath === '/learn/practical-examples'}
				>
					Chapter 3: 実践例
				</a>
			</li>
		</ul>
	</nav>
	
	<main class="content">
		<slot />
	</main>
</div>

<style>
	.learn-layout {
		display: grid;
		grid-template-columns: 250px 1fr;
		gap: 2rem;
		min-height: calc(100vh - 4rem);
	}
	
	.sidebar {
		background: #f8f9fa;
		padding: 1.5rem;
		border-radius: 8px;
		height: fit-content;
		position: sticky;
		top: 2rem;
	}
	
	.sidebar h3 {
		margin-top: 0;
		color: #333;
	}
	
	.sidebar ul {
		list-style: none;
		padding: 0;
		margin: 0;
	}
	
	.sidebar li {
		margin: 0.5rem 0;
	}
	
	.sidebar a {
		color: #0066cc;
		text-decoration: none;
		padding: 0.75rem 1rem;
		border-radius: 4px;
		display: block;
		transition: all 0.2s;
	}
	
	.sidebar a:hover {
		background-color: #e9ecef;
	}
	
	.sidebar a.active {
		background-color: #0066cc;
		color: white;
	}
	
	.content {
		background: white;
		padding: 2rem;
		border-radius: 8px;
		box-shadow: 0 2px 4px rgba(0,0,0,0.1);
	}
	
	@media (max-width: 768px) {
		.learn-layout {
			grid-template-columns: 1fr;
		}
		
		.sidebar {
			position: relative;
			top: 0;
		}
	}
</style>
EOF
fi

# WebSocket入門ページの作成
mkdir -p src/routes/learn/websocket-intro
if [ ! -f "src/routes/learn/websocket-intro/+page.svelte" ]; then
    echo "Creating src/routes/learn/websocket-intro/+page.svelte..."
    cat > src/routes/learn/websocket-intro/+page.svelte << 'EOF'
<script lang="ts">
	import { onMount } from 'svelte';
	
	let ws: WebSocket | null = null;
	let connected = false;
	let message = '';
	let messages: Array<{type: string, content: string, time: string}> = [];
	
	function connect() {
		try {
			ws = new WebSocket('wss://echo.websocket.org');
			
			ws.onopen = () => {
				connected = true;
				addMessage('system', 'WebSocketに接続しました');
			};
			
			ws.onmessage = (event) => {
				addMessage('received', event.data);
			};
			
			ws.onclose = () => {
				connected = false;
				addMessage('system', '接続が閉じられました');
			};
			
			ws.onerror = () => {
				addMessage('error', '接続エラーが発生しました');
			};
		} catch (error) {
			addMessage('error', `接続失敗: ${error}`);
		}
	}
	
	function disconnect() {
		if (ws) {
			ws.close();
		}
	}
	
	function sendMessage() {
		if (ws && connected && message.trim()) {
			ws.send(message);
			addMessage('sent', message);
			message = '';
		}
	}
	
	function addMessage(type: string, content: string) {
		messages = [...messages, {
			type,
			content,
			time: new Date().toLocaleTimeString()
		}];
	}
	
	function handleKeyPress(event: KeyboardEvent) {
		if (event.key === 'Enter') {
			sendMessage();
		}
	}
</script>

<svelte:head>
	<title>Chapter 1: WebSocket基礎 - WebSocket学習キット</title>
</svelte:head>

<h1>🔗 Chapter 1: WebSocket基礎</h1>

<div class="intro">
	<p>WebSocketの基本的な使い方を学びましょう。以下のデモでリアルタイム通信を体験できます。</p>
</div>

<div class="demo-section">
	<h2>📡 WebSocket接続デモ</h2>
	
	<div class="connection-status">
		<span class="status-indicator" class:connected>
			{connected ? '🟢 接続中' : '🔴 切断中'}
		</span>
	</div>
	
	<div class="controls">
		<button onclick={connect} disabled={connected}>
			接続
		</button>
		<button onclick={disconnect} disabled={!connected}>
			切断
		</button>
	</div>
	
	<div class="message-area">
		<h3>📨 メッセージログ</h3>
		<div class="messages">
			{#each messages as msg}
				<div class="message" class:sent={msg.type === 'sent'} class:system={msg.type === 'system'} class:error={msg.type === 'error'}>
					<span class="time">{msg.time}</span>
					<span class="content">{msg.content}</span>
				</div>
			{/each}
		</div>
		
		<div class="send-area">
			<input
				type="text"
				bind:value={message}
				onkeypress={handleKeyPress}
				disabled={!connected}
				placeholder={connected ? 'メッセージを入力...' : '接続してください'}
			>
			<button onclick={sendMessage} disabled={!connected || !message.trim()}>
				送信
			</button>
		</div>
	</div>
</div>

<div class="explanation">
	<h2>🧠 実装のポイント</h2>
	<ul>
		<li><strong>WebSocket接続</strong>: <code>new WebSocket(url)</code>でインスタンス作成</li>
		<li><strong>イベントハンドラー</strong>: <code>onopen</code>, <code>onmessage</code>, <code>onclose</code>, <code>onerror</code></li>
		<li><strong>メッセージ送信</strong>: <code>ws.send(data)</code>でデータ送信</li>
		<li><strong>状態管理</strong>: Svelteのリアクティブ変数で接続状態を管理</li>
	</ul>
</div>

<style>
	.intro {
		background: #e3f2fd;
		padding: 1.5rem;
		border-radius: 8px;
		margin-bottom: 2rem;
	}
	
	.demo-section {
		border: 1px solid #ddd;
		border-radius: 8px;
		padding: 2rem;
		margin-bottom: 2rem;
	}
	
	.connection-status {
		margin-bottom: 1rem;
	}
	
	.status-indicator {
		padding: 0.5rem 1rem;
		border-radius: 4px;
		background: #ffebee;
		color: #c62828;
		font-weight: bold;
	}
	
	.status-indicator.connected {
		background: #e8f5e8;
		color: #2e7d32;
	}
	
	.controls {
		margin-bottom: 2rem;
	}
	
	.controls button {
		margin-right: 1rem;
		padding: 0.75rem 1.5rem;
		border: none;
		border-radius: 4px;
		background: #1976d2;
		color: white;
		cursor: pointer;
		font-weight: 500;
	}
	
	.controls button:disabled {
		background: #ccc;
		cursor: not-allowed;
	}
	
	.controls button:hover:not(:disabled) {
		background: #1565c0;
	}
	
	.messages {
		border: 1px solid #ddd;
		border-radius: 4px;
		height: 200px;
		overflow-y: auto;
		padding: 1rem;
		margin-bottom: 1rem;
		font-family: monospace;
		background: #fafafa;
	}
	
	.message {
		margin-bottom: 0.5rem;
		display: flex;
		gap: 1rem;
	}
	
	.message.sent {
		color: #1976d2;
	}
	
	.message.system {
		color: #757575;
		font-style: italic;
	}
	
	.message.error {
		color: #d32f2f;
	}
	
	.time {
		color: #999;
		font-size: 0.8rem;
		flex-shrink: 0;
	}
	
	.content {
		flex: 1;
	}
	
	.send-area {
		display: flex;
		gap: 1rem;
	}
	
	.send-area input {
		flex: 1;
		padding: 0.75rem;
		border: 1px solid #ddd;
		border-radius: 4px;
	}
	
	.send-area button {
		padding: 0.75rem 1.5rem;
		border: none;
		border-radius: 4px;
		background: #4caf50;
		color: white;
		cursor: pointer;
	}
	
	.send-area button:disabled {
		background: #ccc;
		cursor: not-allowed;
	}
	
	.explanation {
		background: #f5f5f5;
		padding: 2rem;
		border-radius: 8px;
	}
	
	.explanation ul {
		padding-left: 1.5rem;
	}
	
	.explanation li {
		margin-bottom: 0.5rem;
	}
	
	code {
		background: #e0e0e0;
		padding: 0.2rem 0.4rem;
		border-radius: 3px;
		font-family: monospace;
	}
</style>
EOF
fi

# app.css の作成
if [ ! -f "src/app.css" ]; then
    echo "Creating src/app.css..."
    cat > src/app.css << 'EOF'
/* Global styles */
:root {
	--primary: #ff3e00;
	--primary-dark: #c92a00;
	--surface-1: #ffffff;
	--surface-2: #f8fafc;
	--text-1: #1a202c;
	--text-2: #4a5568;
	--border: #e2e8f0;
}

body {
	margin: 0;
	padding: 0;
	font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
	background: var(--surface-2);
	color: var(--text-1);
	line-height: 1.6;
}

h1, h2, h3, h4, h5, h6 {
	margin-top: 0;
	color: var(--text-1);
}

a {
	color: var(--primary);
	text-decoration: none;
}

a:hover {
	text-decoration: underline;
}

button {
	font-family: inherit;
}

* {
	box-sizing: border-box;
}
EOF
fi

echo "✅ ファイル構成のクリーンアップが完了しました"
echo "🚀 再度 npm run dev を実行してください"