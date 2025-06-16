// src/lib/stores/websocket.ts
import { writable, derived, type Writable, type Readable } from 'svelte/store';
import type { 
	WebSocketStore, 
	WebSocketMessage, 
	ConnectionState, 
	WebSocketOptions,
	WebSocketHandlers 
} from '$lib/types/websocket';

interface WebSocketStoreReturn {
	subscribe: Readable<WebSocketStore>['subscribe'];
	connect: (options?: Partial<WebSocketOptions>) => void;
	disconnect: () => void;
	send: (data: string | object) => boolean;
	clearMessages: () => void;
	addMessage: (type: WebSocketMessage['type'], content: string) => void;
}

export function createWebSocketStore(defaultUrl: string = 'wss://echo.websocket.org'): WebSocketStoreReturn {
	// Internal state
	let ws: WebSocket | null = null;
	
	// Store state
	const state: Writable<WebSocketStore> = writable({
		connected: false,
		connectionState: 'disconnected',
		messages: [],
		error: null,
		messageCount: 0
	});
	
	// Internal methods
	function addMessage(type: WebSocketMessage['type'], content: string): void {
		const timestamp = Date.now();
		const message: WebSocketMessage = {
			type,
			content,
			timestamp,
			time: new Date(timestamp).toLocaleTimeString()
		};
		
		state.update(s => ({
			...s,
			messages: [...s.messages, message],
			messageCount: s.messageCount + 1
		}));
	}
	
	function updateConnectionState(newState: ConnectionState, error: string | null = null): void {
		state.update(s => ({
			...s,
			connectionState: newState,
			connected: newState === 'connected',
			error
		}));
	}
	
	function setupWebSocketEvents(websocket: WebSocket, handlers?: WebSocketHandlers): void {
		websocket.onopen = (event: Event): void => {
			// 再接続カウントのリセットは後の章で実装予定
			// reconnectAttempts = 0;
			updateConnectionState('connected');
			addMessage('system', '接続が確立されました');
			handlers?.onOpen?.(event);
		};
		
		websocket.onmessage = (event: MessageEvent<string>): void => {
			try {
				// Try to parse as JSON, fallback to string
				const data = (() => {
					try {
						return JSON.stringify(JSON.parse(event.data), null, 2);
					} catch {
						return event.data;
					}
				})();
				
				addMessage('receive', data);
				handlers?.onMessage?.(event);
			} catch (error) {
				addMessage('system', `メッセージ解析エラー: ${error instanceof Error ? error.message : String(error)}`);
			}
		};
		
		websocket.onclose = (event: CloseEvent): void => {
			updateConnectionState('disconnected');
			addMessage('system', `接続が閉じられました (code: ${event.code}, reason: ${event.reason || 'なし'})`);
			
			ws = null;
			handlers?.onClose?.(event);
		};
		
		websocket.onerror = (event: Event): void => {
			const errorMessage = '接続エラーが発生しました';
			updateConnectionState('error', errorMessage);
			addMessage('system', errorMessage);
			handlers?.onError?.(event);
		};
	}
	
	// Public methods
	function connect(options?: Partial<WebSocketOptions>): void {
		if (ws?.readyState === WebSocket.OPEN) {
			console.warn('WebSocket is already connected');
			return;
		}
		
		const config: WebSocketOptions = {
			url: defaultUrl,
			autoConnect: false,
			// 再接続機能は後の章で実装予定
			// reconnectInterval: 3000,
			// maxReconnectAttempts: 5,
			...options
		};
		
		updateConnectionState('connecting');
		addMessage('system', `接続試行中: ${config.url}`);
		
		try {
			ws = new WebSocket(config.url, config.protocols);
			setupWebSocketEvents(ws);
		} catch (error) {
			const errorMessage = `接続エラー: ${error instanceof Error ? error.message : String(error)}`;
			updateConnectionState('error', errorMessage);
			addMessage('system', errorMessage);
		}
	}
	
	function disconnect(): void {
		if (ws) {
			ws.close(1000, 'Normal closure by user');
			ws = null;
		}
		
		updateConnectionState('disconnected');
	}
	
	function send(data: string | object): boolean {
		if (ws?.readyState !== WebSocket.OPEN) {
			addMessage('system', 'エラー: WebSocketが接続されていません');
			return false;
		}
		
		try {
			const message = typeof data === 'string' ? data : JSON.stringify(data);
			ws.send(message);
			addMessage('send', message);
			return true;
		} catch (error) {
			const errorMessage = `送信エラー: ${error instanceof Error ? error.message : String(error)}`;
			addMessage('system', errorMessage);
			return false;
		}
	}
	
	function clearMessages(): void {
		state.update(s => ({
			...s,
			messages: [],
			messageCount: 0
		}));
	}
	
	return {
		subscribe: state.subscribe,
		connect,
		disconnect,
		send,
		clearMessages,
		addMessage
	};
}

// Global WebSocket store instance
export const websocketStore = createWebSocketStore();

// Derived stores for specific data
export const connectionState = derived(websocketStore, $store => $store.connectionState);
export const isConnected = derived(websocketStore, $store => $store.connected);
export const messageCount = derived(websocketStore, $store => $store.messageCount);
export const latestMessage = derived(websocketStore, $store => 
	$store.messages.length > 0 ? $store.messages[$store.messages.length - 1] : null
);