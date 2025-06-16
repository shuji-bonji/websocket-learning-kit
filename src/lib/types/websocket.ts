// src/lib/types/websocket.ts

/**
 * WebSocket接続状態の型定義
 */
export type ConnectionState = 'disconnected' | 'connecting' | 'connected' | 'error';

/**
 * WebSocketメッセージの型定義
 */
export interface WebSocketMessage {
	type: 'send' | 'receive' | 'system';
	content: string;
	timestamp: number;
	time: string;
}

/**
 * WebSocketストアの状態型定義
 */
export interface WebSocketStore {
	connected: boolean;
	connectionState: ConnectionState;
	messages: WebSocketMessage[];
	error: string | null;
	messageCount: number;
}

/**
 * WebSocketイベントハンドラーの型定義
 */
export interface WebSocketHandlers {
	onOpen?: (event: Event) => void;
	onMessage?: (event: MessageEvent) => void;
	onClose?: (event: CloseEvent) => void;
	onError?: (event: Event) => void;
}

/**
 * WebSocket設定オプションの型定義
 */
export interface WebSocketOptions {
	url: string;
	protocols?: string | string[];
	autoConnect?: boolean;
	// 再接続機能は後の章で実装予定
	// reconnectInterval?: number;
	// maxReconnectAttempts?: number;
}

/**
 * カスタムWebSocketメッセージペイロードの型定義
 */
export interface ChatMessage {
	type: 'message' | 'join' | 'leave' | 'typing';
	user: string;
	room: string;
	content?: string;
	timestamp: number;
	version: string;
}

/**
 * 学習進捗の型定義
 */
export interface LearningProgress {
	chapter: number;
	completed: boolean;
	exercises: number;
	completedExercises: number;
	timeSpent: number;
}