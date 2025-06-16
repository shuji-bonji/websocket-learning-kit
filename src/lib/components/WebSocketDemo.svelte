<!-- src/lib/components/WebSocketDemo.svelte -->
<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { Play, Square, Send } from 'lucide-svelte';
	import type { ConnectionState, WebSocketMessage, WebSocketOptions } from '$lib/types/websocket';
	
	// Props with TypeScript types
	interface Props {
		serverUrl?: string;
		autoConnect?: boolean;
		showLogs?: boolean;
		protocols?: string | string[];
	}
	
	let {
		serverUrl = 'wss://echo.websocket.org',
		autoConnect = false,
		showLogs = true,
		protocols
	}: Props = $props();
	
	// State with TypeScript types
	let ws: WebSocket | null = $state(null);
	let message: string = $state('');
	let messages: WebSocketMessage[] = $state([]);
	let connectionState = $state<ConnectionState>('disconnected');
	
	// Computed properties
	let isConnected = $derived(connectionState === 'connected');
	let canSend = $derived(isConnected && message.trim().length > 0);
	
	function addMessage(type: WebSocketMessage['type'], content: string): void {
		const now = new Date();
		const newMessage: WebSocketMessage = {
			type,
			content,
			timestamp: now.getTime(),
			time: now.toLocaleTimeString()
		};
		messages = [...messages, newMessage];
	}
	
	function connect(): void {
		if (ws?.readyState === WebSocket.OPEN) return;
		
		connectionState = 'connecting';
		addMessage('system', `接続試行中: ${serverUrl}`);
		
		try {
			ws = new WebSocket(serverUrl, protocols);
			
			ws.onopen = (event: Event): void => {
				connectionState = 'connected';
				addMessage('system', '接続が確立されました');
			};
			
			ws.onmessage = (event: MessageEvent<string>): void => {
				addMessage('receive', event.data);
			};
			
			ws.onclose = (event: CloseEvent): void => {
				connectionState = 'disconnected';
				addMessage('system', `接続が閉じられました (code: ${event.code})`);
				ws = null;
			};
			
			ws.onerror = (event: Event): void => {
				connectionState = 'error';
				addMessage('system', '接続エラーが発生しました');
			};
		} catch (error) {
			connectionState = 'error';
			addMessage('system', `接続エラー: ${error instanceof Error ? error.message : String(error)}`);
		}
	}
	
	function disconnect(): void {
		if (ws) {
			ws.close(1000, 'Normal closure');
			ws = null;
		}
	}
	
	function sendMessage(): void {
		if (ws?.readyState === WebSocket.OPEN && message.trim()) {
			ws.send(message);
			addMessage('send', message);
			message = '';
		}
	}
	
	function handleKeydown(event: KeyboardEvent): void {
		if (event.key === 'Enter' && canSend) {
			sendMessage();
		}
	}
	
	function clearMessages(): void {
		messages = [];
	}
	
	// Lifecycle
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
	<div class="header">
		<h3>WebSocket接続デモ</h3>
		<button 
			type="button" 
			class="clear-btn" 
			onclick={clearMessages}
			disabled={messages.length === 0}
		>
			ログクリア
		</button>
	</div>
	
	<div class="controls">
		<div class="connection-status" class:connected={isConnected} class:error={connectionState === 'error'}>
			<div class="status-indicator"></div>
			<span>
				{#if connectionState === 'connected'}
					接続中
				{:else if connectionState === 'connecting'}
					接続中...
				{:else if connectionState === 'error'}
					エラー
				{:else}
					未接続
				{/if}
			</span>
			<span class="url">({serverUrl})</span>
		</div>
		
		<div class="actions">
			{#if connectionState === 'disconnected' || connectionState === 'error'}
				<button type="button" onclick={connect} class="btn btn-primary">
					<Play size={16} />
					接続
				</button>
			{:else}
				<button type="button" onclick={disconnect} class="btn btn-secondary">
					<Square size={16} />
					切断
				</button>
			{/if}
		</div>
	</div>
	
	{#if isConnected}
		<div class="message-sender">
			<input
				type="text"
				bind:value={message}
				placeholder="メッセージを入力..."
				onkeydown={handleKeydown}
			/>
			<button 
				type="button"
				onclick={sendMessage} 
				class="btn btn-primary" 
				disabled={!canSend}
			>
				<Send size={16} />
				送信
			</button>
		</div>
	{/if}
	
	{#if showLogs}
		<div class="message-log">
			<div class="log-header">
				<h4>通信ログ ({messages.length}件)</h4>
				{#if messages.length > 0}
					<span class="message-count">
						送信: {messages.filter(m => m.type === 'send').length} / 
						受信: {messages.filter(m => m.type === 'receive').length}
					</span>
				{/if}
			</div>
			
			<div class="messages" role="log" aria-live="polite">
				{#each messages as msg (msg.timestamp)}
					<div class="message message-{msg.type}">
						<span class="time">{msg.time}</span>
						<span class="content">{msg.content}</span>
					</div>
				{/each}
				
				{#if messages.length === 0}
					<div class="empty-state">
						接続してメッセージを送信すると、ここにログが表示されます
					</div>
				{/if}
			</div>
		</div>
	{/if}
</div>

<style>
	.websocket-demo {
		border: 2px solid var(--border, #e2e8f0);
		border-radius: 8px;
		padding: 1rem;
		margin: 1rem 0;
		background: var(--surface-2, #f8fafc);
		font-family: system-ui, sans-serif;
	}
	
	.header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 1rem;
	}
	
	.header h3 {
		margin: 0;
		color: var(--text-1, #1a202c);
	}
	
	.clear-btn {
		background: var(--surface-3, #e2e8f0);
		color: var(--text-2, #4a5568);
		border: none;
		padding: 0.25rem 0.5rem;
		border-radius: 4px;
		cursor: pointer;
		font-size: 0.875rem;
	}
	
	.clear-btn:hover:not(:disabled) {
		background: var(--surface-3, #cbd5e0);
	}
	
	.clear-btn:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}
	
	.controls {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 1rem;
		padding: 0.75rem;
		background: var(--surface-1, #ffffff);
		border-radius: 4px;
		border: 1px solid var(--border, #e2e8f0);
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
		background: var(--text-2, #9ca3af);
		transition: background-color 0.2s;
	}
	
	.connection-status.connected .status-indicator {
		background: var(--success, #10b981);
		animation: pulse 2s infinite;
	}
	
	.connection-status.error .status-indicator {
		background: var(--error, #ef4444);
	}
	
	.url {
		color: var(--text-2, #6b7280);
		font-size: 0.875rem;
		font-family: monospace;
	}
	
	.message-sender {
		display: flex;
		gap: 0.5rem;
		margin-bottom: 1rem;
	}
	
	.message-sender input {
		flex: 1;
		padding: 0.75rem;
		border: 1px solid var(--border, #d1d5db);
		border-radius: 4px;
		background: var(--surface-1, #ffffff);
		color: var(--text-1, #1a202c);
		font-size: 1rem;
	}
	
	.message-sender input:focus {
		outline: none;
		border-color: var(--primary, #3b82f6);
		box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
	}
	
	.btn {
		display: flex;
		align-items: center;
		gap: 0.25rem;
		padding: 0.75rem 1rem;
		border: none;
		border-radius: 4px;
		cursor: pointer;
		font-weight: 500;
		font-size: 0.875rem;
		transition: all 0.2s;
	}
	
	.btn-primary {
		background: var(--primary, #3b82f6);
		color: white;
	}
	
	.btn-primary:hover:not(:disabled) {
		background: var(--primary-dark, #2563eb);
		transform: translateY(-1px);
		box-shadow: 0 2px 4px rgba(0,0,0,0.1);
	}
	
	.btn-secondary {
		background: var(--surface-3, #e2e8f0);
		color: var(--text-1, #1a202c);
	}
	
	.btn-secondary:hover:not(:disabled) {
		background: var(--surface-3, #cbd5e0);
	}
	
	.btn:disabled {
		opacity: 0.5;
		cursor: not-allowed;
		transform: none;
	}
	
	.message-log {
		border-top: 1px solid var(--border, #e2e8f0);
		padding-top: 1rem;
	}
	
	.log-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 0.5rem;
	}
	
	.log-header h4 {
		margin: 0;
		font-size: 1rem;
		color: var(--text-1, #1a202c);
	}
	
	.message-count {
		font-size: 0.875rem;
		color: var(--text-2, #6b7280);
	}
	
	.messages {
		max-height: 200px;
		overflow-y: auto;
		background: var(--surface-1, #ffffff);
		border: 1px solid var(--border, #e2e8f0);
		border-radius: 4px;
		padding: 0.5rem;
	}
	
	.message {
		display: flex;
		gap: 0.5rem;
		padding: 0.25rem 0;
		font-family: 'SF Mono', 'Monaco', 'Cascadia Code', monospace;
		font-size: 0.875rem;
		border-bottom: 1px solid var(--border, #f1f5f9);
	}
	
	.message:last-child {
		border-bottom: none;
	}
	
	.time {
		color: var(--text-2, #6b7280);
		min-width: 80px;
		flex-shrink: 0;
	}
	
	.content {
		flex: 1;
		word-break: break-word;
	}
	
	.message-send .content {
		color: var(--primary, #3b82f6);
	}
	
	.message-receive .content {
		color: var(--success, #10b981);
	}
	
	.message-system .content {
		color: var(--text-2, #6b7280);
		font-style: italic;
	}
	
	.empty-state {
		text-align: center;
		color: var(--text-2, #6b7280);
		font-style: italic;
		padding: 2rem;
	}
	
	@keyframes pulse {
		0%, 100% { opacity: 1; }
		50% { opacity: 0.7; }
	}
	
	@media (max-width: 768px) {
		.controls {
			flex-direction: column;
			gap: 0.5rem;
			align-items: stretch;
		}
		
		.connection-status {
			justify-content: center;
		}
		
		.message {
			flex-direction: column;
			gap: 0.25rem;
		}
		
		.time {
			min-width: auto;
		}
	}
</style>