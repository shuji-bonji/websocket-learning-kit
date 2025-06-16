# WebSocket学習教材 - SvelteKit + MDsveX セットアップガイド

## 🚀 プロジェクト初期化

### 1. プロジェクト作成
```bash
# プロジェクト作成
npm create svelte@latest websocket-learning-kit
cd websocket-learning-kit

# 設定選択（推奨）
✔ Which template would you like? › SvelteKit demo app
✔ Add type checking with TypeScript? › Yes, using TypeScript syntax
✔ Select additional options › prettier, eslint, vitest, playwright

# 依存関係インストール
npm install

# MDsveX関連パッケージ追加
npm install -D mdsvex rehype-slug rehype-autolink-headings remark-toc
npm install lucide-svelte  # アイコン用
```

### 2. 設定ファイル（svelte.config.js）
```javascript
import adapter from '@sveltejs/adapter-auto';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import { mdsvex } from 'mdsvex';
import rehypeSlug from 'rehype-slug';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';
import remarkToc from 'remark-toc';

/** @type {import('mdsvex').MdsvexOptions} */
const mdsvexOptions = {
	extensions: ['.svelte.md', '.md', '.svx'],
	smartypants: {
		dashes: 'oldschool'
	},
	remarkPlugins: [remarkToc],
	rehypePlugins: [
		rehypeSlug,
		[rehypeAutolinkHeadings, { behavior: 'wrap' }]
	],
	layout: {
		_: './src/mdsvex.svelte'
	}
};

/** @type {import('@sveltejs/kit').Config} */
const config = {
	extensions: ['.svelte', '.md', '.svx'],
	preprocess: [vitePreprocess(), mdsvex(mdsvexOptions)],
	kit: {
		adapter: adapter()
	}
};

export default config;
```

### 3. TypeScript設定（tsconfig.json に追加）
```json
{
	"compilerOptions": {
		"paths": {
			"$lib": ["./src/lib"],
			"$lib/*": ["./src/lib/*"]
		}
	}
}
```

## 📁 プロジェクト構成

```
src/
├── routes/
│   ├── +layout.svelte           # 共通レイアウト
│   ├── +page.svelte             # ホーム（目次）
│   ├── learn/
│   │   ├── +layout.svelte       # 学習ページ共通レイアウト
│   │   ├── 01-introduction/
│   │   │   └── +page.svx        # 第1章
│   │   ├── 02-network-basics/
│   │   │   └── +page.svx        # 第2章
│   │   ├── 03-websocket-api/
│   │   │   └── +page.svx        # 第3章
│   │   └── [chapter]/
│   │       └── +page.svx        # 動的ルート
├── lib/
│   ├── components/
│   │   ├── learning/
│   │   │   ├── WebSocketDemo.svelte
│   │   │   ├── ConnectionStatus.svelte
│   │   │   ├── MessageSender.svelte
│   │   │   ├── ProgressTracker.svelte
│   │   │   └── CodeRunner.svelte
│   │   ├── ui/
│   │   │   ├── Navigation.svelte
│   │   │   └── TableOfContents.svelte
│   ├── stores/
│   │   ├── websocket.ts         # WebSocketストア
│   │   ├── progress.ts          # 学習進捗
│   │   └── theme.ts            # テーマ管理
│   ├── server/
│   │   └── websocket.ts        # サーバーサイド（開発用）
│   └── utils/
│       ├── curriculum.ts       # カリキュラム定義
│       └── helpers.ts
├── mdsvex.svelte               # MDsveX共通レイアウト
└── app.html
```

## 🎨 基本レイアウトファイル

### src/mdsvex.svelte
```svelte
<script lang="ts">
	import ProgressTracker from '$lib/components/learning/ProgressTracker.svelte';
	import TableOfContents from '$lib/components/ui/TableOfContents.svelte';
	
	// フロントマターから取得
	export let title: string;
	export let chapter: number;
	export let description: string;
	export let exercises: number = 0;
	export let estimatedTime: string;
</script>

<svelte:head>
	<title>{title} - WebSocket学習キット</title>
	<meta name="description" content={description} />
</svelte:head>

<div class="learning-container">
	<aside class="sidebar">
		<TableOfContents />
		<ProgressTracker {chapter} {exercises} />
	</aside>
	
	<main class="content">
		<header class="chapter-header">
			<div class="chapter-badge">Chapter {chapter}</div>
			<h1>{title}</h1>
			<p class="description">{description}</p>
			<div class="meta">
				<span>⏱️ 推定時間: {estimatedTime}</span>
				<span>📝 演習: {exercises}個</span>
			</div>
		</header>
		
		<article class="prose">
			<slot />
		</article>
	</main>
</div>

<style>
	.learning-container {
		display: grid;
		grid-template-columns: 300px 1fr;
		min-height: 100vh;
		gap: 2rem;
	}
	
	.sidebar {
		position: sticky;
		top: 0;
		height: 100vh;
		overflow-y: auto;
		padding: 1rem;
		background: var(--surface-2);
		border-right: 1px solid var(--border);
	}
	
	.content {
		max-width: 800px;
		padding: 2rem;
	}
	
	.chapter-header {
		margin-bottom: 3rem;
		padding-bottom: 1rem;
		border-bottom: 2px solid var(--primary);
	}
	
	.chapter-badge {
		display: inline-block;
		background: var(--primary);
		color: white;
		padding: 0.25rem 0.75rem;
		border-radius: 1rem;
		font-size: 0.875rem;
		font-weight: 600;
		margin-bottom: 1rem;
	}
	
	.prose {
		line-height: 1.7;
	}
	
	.meta {
		display: flex;
		gap: 1rem;
		margin-top: 1rem;
		font-size: 0.875rem;
		color: var(--text-2);
	}
	
	@media (max-width: 768px) {
		.learning-container {
			grid-template-columns: 1fr;
		}
		
		.sidebar {
			position: relative;
			height: auto;
		}
	}
</style>
```

### src/routes/+layout.svelte
```svelte
<script lang="ts">
	import '../app.css';
	import Navigation from '$lib/components/ui/Navigation.svelte';
	import { theme } from '$lib/stores/theme';
</script>

<div class="app" data-theme={$theme}>
	<Navigation />
	<slot />
</div>

<style>
	:global(:root) {
		--primary: #ff3e00;
		--primary-dark: #c92a00;
		--surface-1: #ffffff;
		--surface-2: #f8fafc;
		--surface-3: #e2e8f0;
		--text-1: #1a202c;
		--text-2: #4a5568;
		--border: #e2e8f0;
		--success: #10b981;
		--warning: #f59e0b;
		--error: #ef4444;
	}
	
	:global([data-theme="dark"]) {
		--surface-1: #1a202c;
		--surface-2: #2d3748;
		--surface-3: #4a5568;
		--text-1: #f7fafc;
		--text-2: #e2e8f0;
		--border: #4a5568;
	}
	
	:global(body) {
		margin: 0;
		padding: 0;
		background: var(--surface-1);
		color: var(--text-1);
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
	}
	
	.app {
		min-height: 100vh;
	}
</style>
```

## 🔌 WebSocket学習コンポーネント

### src/lib/components/learning/WebSocketDemo.svelte
```svelte
<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { writable } from 'svelte/store';
	import { Play, Square, Send } from 'lucide-svelte';
	
	export let serverUrl: string = 'ws://localhost:8080';
	export let autoConnect: boolean = false;
	export let showLogs: boolean = true;
	
	let ws: WebSocket | null = null;
	let message = '';
	let messages = writable<Array<{type: 'send' | 'receive' | 'system', content: string, time: string}>>([]);
	
	const connectionState = writable<'disconnected' | 'connecting' | 'connected' | 'error'>('disconnected');
	
	function addMessage(type: 'send' | 'receive' | 'system', content: string) {
		const time = new Date().toLocaleTimeString();
		messages.update(msgs => [...msgs, { type, content, time }]);
	}
	
	function connect() {
		if (ws?.readyState === WebSocket.OPEN) return;
		
		connectionState.set('connecting');
		addMessage('system', `接続試行中: ${serverUrl}`);
		
		try {
			ws = new WebSocket(serverUrl);
			
			ws.onopen = () => {
				connectionState.set('connected');
				addMessage('system', '接続が確立されました');
			};
			
			ws.onmessage = (event) => {
				addMessage('receive', event.data);
			};
			
			ws.onclose = (event) => {
				connectionState.set('disconnected');
				addMessage('system', `接続が閉じられました (code: ${event.code})`);
			};
			
			ws.onerror = () => {
				connectionState.set('error');
				addMessage('system', '接続エラーが発生しました');
			};
		} catch (error) {
			connectionState.set('error');
			addMessage('system', `接続エラー: ${error}`);
		}
	}
	
	function disconnect() {
		if (ws) {
			ws.close();
			ws = null;
		}
	}
	
	function sendMessage() {
		if (ws?.readyState === WebSocket.OPEN && message.trim()) {
			ws.send(message);
			addMessage('send', message);
			message = '';
		}
	}
	
	onMount(() => {
		if (autoConnect) {
			connect();
		}
	});
	
	onDestroy(() => {
		disconnect();
	});
</script>

<div class="websocket-demo">
	<div class="controls">
		<div class="connection-status status-{$connectionState}">
			<div class="status-indicator"></div>
			<span>{$connectionState === 'connected' ? '接続中' : 
			       $connectionState === 'connecting' ? '接続中...' : 
			       $connectionState === 'error' ? 'エラー' : '未接続'}</span>
		</div>
		
		<div class="actions">
			{#if $connectionState === 'disconnected' || $connectionState === 'error'}
				<button on:click={connect} class="btn btn-primary">
					<Play size={16} />
					接続
				</button>
			{:else}
				<button on:click={disconnect} class="btn btn-secondary">
					<Square size={16} />
					切断
				</button>
			{/if}
		</div>
	</div>
	
	{#if $connectionState === 'connected'}
		<div class="message-sender">
			<input
				bind:value={message}
				placeholder="メッセージを入力..."
				on:keydown={(e) => e.key === 'Enter' && sendMessage()}
			/>
			<button on:click={sendMessage} class="btn btn-primary" disabled={!message.trim()}>
				<Send size={16} />
			</button>
		</div>
	{/if}
	
	{#if showLogs && $messages.length > 0}
		<div class="message-log">
			<h4>通信ログ</h4>
			<div class="messages">
				{#each $messages as msg}
					<div class="message message-{msg.type}">
						<span class="time">{msg.time}</span>
						<span class="content">{msg.content}</span>
					</div>
				{/each}
			</div>
		</div>
	{/if}
</div>

<style>
	.websocket-demo {
		border: 2px solid var(--border);
		border-radius: 8px;
		padding: 1rem;
		margin: 1rem 0;
		background: var(--surface-2);
	}
	
	.controls {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 1rem;
	}
	
	.connection-status {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		font-weight: 500;
	}
	
	.status-indicator {
		width: 12px;
		height: 12px;
		border-radius: 50%;
		background: var(--text-2);
	}
	
	.status-connected .status-indicator { background: var(--success); }
	.status-connecting .status-indicator { 
		background: var(--warning); 
		animation: pulse 1s infinite;
	}
	.status-error .status-indicator { background: var(--error); }
	
	.message-sender {
		display: flex;
		gap: 0.5rem;
		margin-bottom: 1rem;
	}
	
	.message-sender input {
		flex: 1;
		padding: 0.5rem;
		border: 1px solid var(--border);
		border-radius: 4px;
		background: var(--surface-1);
		color: var(--text-1);
	}
	
	.btn {
		display: flex;
		align-items: center;
		gap: 0.25rem;
		padding: 0.5rem 1rem;
		border: none;
		border-radius: 4px;
		cursor: pointer;
		font-weight: 500;
		transition: all 0.2s;
	}
	
	.btn-primary {
		background: var(--primary);
		color: white;
	}
	
	.btn-secondary {
		background: var(--surface-3);
		color: var(--text-1);
	}
	
	.btn:hover:not(:disabled) {
		transform: translateY(-1px);
		box-shadow: 0 2px 4px rgba(0,0,0,0.1);
	}
	
	.btn:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}
	
	.message-log {
		border-top: 1px solid var(--border);
		padding-top: 1rem;
	}
	
	.messages {
		max-height: 200px;
		overflow-y: auto;
		font-family: 'SF Mono', 'Monaco', 'Cascadia Code', monospace;
		font-size: 0.875rem;
	}
	
	.message {
		display: flex;
		gap: 0.5rem;
		padding: 0.25rem 0;
		border-bottom: 1px solid var(--border);
	}
	
	.time {
		color: var(--text-2);
		min-width: 80px;
	}
	
	.message-send .content { color: var(--primary); }
	.message-receive .content { color: var(--success); }
	.message-system .content { color: var(--text-2); font-style: italic; }
	
	@keyframes pulse {
		0%, 100% { opacity: 1; }
		50% { opacity: 0.5; }
	}
</style>
```

## 📚 最初の学習コンテンツテンプレート

### src/routes/learn/01-introduction/+page.svx
```markdown
---
title: "WebSocket入門 - リアルタイム通信の基礎"
chapter: 1
description: "WebSocketとは何か、なぜ必要なのかを学び、最初のWebSocket接続を体験します"
exercises: 2
estimatedTime: "1-2時間"
---

<script>
  import WebSocketDemo from '$lib/components/learning/WebSocketDemo.svelte';
  import ConnectionStatus from '$lib/components/learning/ConnectionStatus.svelte';
</script>

## 📖 学習目標

この章を完了すると、以下ができるようになります：

- [ ] WebSocketの基本概念を説明できる
- [ ] HTTPとWebSocketの違いを理解している
- [ ] ブラウザでWebSocket接続を実行できる

## 🔍 WebSocketとは？

**WebSocket**は、クライアント（ブラウザ）とサーバー間で**双方向のリアルタイム通信**を可能にするプロトコルです。

### HTTPとの違い

| 特徴 | HTTP | WebSocket |
|------|------|-----------|
| 通信方向 | 一方向 | 双方向 |
| 接続 | リクエスト毎 | 永続的 |
| オーバーヘッド | 高い | 低い |

## 🚀 実際に体験してみましょう

下のデモでWebSocket接続を試してください：

<WebSocketDemo serverUrl="wss://echo.websocket.org" autoConnect={false} />

> **注意**: 上記は実際に動作するWebSocketエコーサーバーです。送信したメッセージがそのまま返ってきます。

## 💡 ここで何が起こっているか？

1. **接続確立**: `new WebSocket(url)` でサーバーに接続
2. **イベント監視**: `onopen`, `onmessage`, `onclose` でイベントを処理
3. **メッセージ送信**: `send()` メソッドでデータを送信

## 📝 演習1: 接続状態の理解

<ConnectionStatus />

## 🏃‍♀️ 次のステップ

次の章では、WebSocketを取り巻くネットワーク技術について学習します。

---

**進捗**: Chapter 1 完了 🎉
```

## ⚡ 開発サーバー起動コマンド

```bash
# 開発サーバー起動
npm run dev

# TypeScriptチェック
npm run check

# テスト実行
npm run test

# ビルド
npm run build
```

## 🎯 次のアクションアイテム

1. **今すぐ実行**: 上記セットアップを完了
2. **明日から開始**: カリキュラムに沿ってコンテンツ作成
3. **週末目標**: 第1-3章の基本コンテンツ完成

これで完璧な学習環境が整いました！実際の学習と並行して、素晴らしい教材が出来上がるはずです。🚀