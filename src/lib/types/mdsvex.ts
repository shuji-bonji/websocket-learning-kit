/**
 * MDsveXページのフロントマター型定義
 */
export interface PageFrontmatter {
	title: string;
	chapter: number;
	description: string;
	estimatedTime: string;
	exercises?: number;
	difficulty?: 'beginner' | 'intermediate' | 'advanced';
	tags?: string[];
	prerequisites?: string[];
	objectives?: string[];
	published?: boolean;
	lastUpdated?: string;
}

/**
 * 学習章の情報
 */
export interface ChapterInfo {
	id: string;
	title: string;
	description: string;
	chapter: number;
	estimatedTime: string;
	exercises: number;
	difficulty: 'beginner' | 'intermediate' | 'advanced';
	path: string;
	completed: boolean;
	tags: string[];
}

/**
 * カリキュラム全体の構造
 */
export interface Curriculum {
	title: string;
	description: string;
	totalChapters: number;
	totalTime: string;
	chapters: ChapterInfo[];
}

/**
 * 学習進捗の追跡
 */
export interface LearningProgress {
	chapterId: string;
	completed: boolean;
	completedExercises: number;
	totalExercises: number;
	timeSpent: number; // minutes
	lastAccessed: string;
	notes?: string;
}

/**
 * ナビゲーションアイテム
 */
export interface NavigationItem {
	title: string;
	path: string;
	chapter?: number;
	children?: NavigationItem[];
	active?: boolean;
}

// Export for module usage - no global namespace needed
export type {};