<!-- src/mdsvex.svelte -->
<script lang="ts">
	import { page } from '$app/stores';
	import type { PageFrontmatter } from '$lib/types/mdsvex';
	
	// Props from frontmatter (these come from MDsveX)
	interface Props extends Partial<PageFrontmatter> {
		title?: string;
		chapter?: number;
		description?: string;
		estimatedTime?: string;
		exercises?: number;
		difficulty?: 'beginner' | 'intermediate' | 'advanced';
		tags?: string[];
		objectives?: string[];
	}
	
	let {
		title = 'WebSocket学習',
		chapter = 1,
		description = '',
		estimatedTime = '',
		exercises = 0,
		difficulty = 'beginner',
		tags = [],
		objectives = []
	}: Props = $props();
	
	// Computed values
	const difficultyColors = {
		beginner: '#10b981',
		intermediate: '#f59e0b', 
		advanced: '#ef4444'
	} as const;
	
	const difficultyLabels = {
		beginner: '初級',
		intermediate: '中級',
		advanced: '上級'
	} as const;
	
	let currentPath = $derived($page.url.pathname);
</script>

<svelte:head>
	<title>{title} - WebSocket学習キット</title>
	<meta name="description" content={description} />
	{#if tags.length > 0}
		<meta name="keywords" content={tags.join(', ')} />
	{/if}
</svelte:head>

<div class="learning-page">
	<header class="page-header">
		<nav class="breadcrumb">
			<a href="/">ホーム</a>
			<span class="separator">›</span>
			<a href="/learn">学習</a>
			<span class="separator">›</span>
			<span class="current">Chapter {chapter}</span>
		</nav>
		
		<div class="chapter-info">
			<div class="badges">
				<div class="chapter-badge">Chapter {chapter}</div>
				{#if difficulty}
					<div 
						class="difficulty-badge" 
						style="background-color: {difficultyColors[difficulty]}"
					>
						{difficultyLabels[difficulty]}
					</div>
				{/if}
			</div>
			
			<h1>{title}</h1>
			
			{#if description}
				<p class="description">{description}</p>
			{/if}
			
			<div class="meta-info">
				{#if estimatedTime}
					<div class="meta-item">
						<span class="icon">⏱️</span>
						<span>推定時間: {estimatedTime}</span>
					</div>
				{/if}
				
				{#if exercises > 0}
					<div class="meta-item">
						<span class="icon">📝</span>
						<span>演習: {exercises}個</span>
					</div>
				{/if}
			</div>
			
			{#if tags.length > 0}
				<div class="tags">
					{#each tags as tag}
						<span class="tag">{tag}</span>
					{/each}
				</div>
			{/if}
		</div>
	</header>
	
	{#if objectives && objectives.length > 0}
		<section class="objectives" role="region" aria-labelledby="objectives-heading">
			<h2 id="objectives-heading">📖 学習目標</h2>
			<p>この章を完了すると、以下ができるようになります：</p>
			<ul class="objectives-list">
				{#each objectives as objective}
					<li>
						<input type="checkbox" disabled />
						{objective}
					</li>
				{/each}
			</ul>
		</section>
	{/if}
	
	<main class="content" role="main">
		<slot />
	</main>
	
	<footer class="page-footer">
		<div class="progress-info">
			<span>Chapter {chapter} 完了 🎉</span>
		</div>
		
		<nav class="page-navigation" role="navigation" aria-label="章の移動">
			{#if chapter > 1}
				<a href="/learn/{String(chapter - 1).padStart(2, '0')}-introduction" class="nav-link prev">
					← 前の章
				</a>
			{/if}
			
			<a href="/learn" class="nav-link home">
				目次に戻る
			</a>
			
			<a href="/learn/{String(chapter + 1).padStart(2, '0')}-network-basics" class="nav-link next">
				次の章 →
			</a>
		</nav>
	</footer>
</div>

<style>
	.learning-page {
		max-width: 900px;
		margin: 0 auto;
		padding: 2rem;
		font-family: system-ui, -apple-system, sans-serif;
		line-height: 1.6;
		color: var(--text-1, #1a202c);
	}
	
	.page-header {
		border-bottom: 2px solid var(--primary, #ff3e00);
		padding-bottom: 2rem;
		margin-bottom: 3rem;
	}
	
	.breadcrumb {
		font-size: 0.875rem;
		margin-bottom: 1rem;
		color: var(--text-2, #6b7280);
	}
	
	.breadcrumb a {
		color: var(--primary, #3b82f6);
		text-decoration: none;
	}
	
	.breadcrumb a:hover {
		text-decoration: underline;
	}
	
	.separator {
		margin: 0 0.5rem;
	}
	
	.current {
		font-weight: 500;
		color: var(--text-1, #1a202c);
	}
	
	.chapter-info h1 {
		margin: 1rem 0;
		font-size: 2.5rem;
		font-weight: 700;
		color: var(--text-1, #1a202c);
		line-height: 1.2;
	}
	
	.badges {
		display: flex;
		gap: 0.5rem;
		margin-bottom: 1rem;
	}
	
	.chapter-badge {
		display: inline-block;
		background: var(--primary, #ff3e00);
		color: white;
		padding: 0.375rem 0.75rem;
		border-radius: 1rem;
		font-size: 0.875rem;
		font-weight: 600;
	}
	
	.difficulty-badge {
		display: inline-block;
		color: white;
		padding: 0.375rem 0.75rem;
		border-radius: 1rem;
		font-size: 0.875rem;
		font-weight: 600;
	}
	
	.description {
		font-size: 1.125rem;
		color: var(--text-2, #4a5568);
		margin: 1rem 0;
		line-height: 1.7;
	}
	
	.meta-info {
		display: flex;
		gap: 1.5rem;
		margin: 1.5rem 0;
		flex-wrap: wrap;
	}
	
	.meta-item {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		color: var(--text-2, #6b7280);
		font-size: 0.875rem;
	}
	
	.icon {
		font-size: 1rem;
	}
	
	.tags {
		display: flex;
		gap: 0.5rem;
		flex-wrap: wrap;
		margin-top: 1rem;
	}
	
	.tag {
		background: var(--surface-2, #f1f5f9);
		color: var(--text-2, #64748b);
		padding: 0.25rem 0.5rem;
		border-radius: 0.375rem;
		font-size: 0.75rem;
		font-weight: 500;
	}
	
	.objectives {
		background: var(--surface-2, #f8fafc);
		border: 1px solid var(--border, #e2e8f0);
		border-radius: 8px;
		padding: 1.5rem;
		margin-bottom: 2rem;
	}
	
	.objectives h2 {
		margin: 0 0 1rem 0;
		font-size: 1.25rem;
		color: var(--text-1, #1a202c);
	}
	
	.objectives-list {
		margin: 1rem 0 0 0;
		padding: 0;
		list-style: none;
	}
	
	.objectives-list li {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		padding: 0.5rem 0;
		border-bottom: 1px solid var(--border, #f1f5f9);
	}
	
	.objectives-list li:last-child {
		border-bottom: none;
	}
	
	.objectives-list input[type="checkbox"] {
		margin: 0;
		transform: scale(1.1);
	}
	
	.content {
		margin-bottom: 3rem;
	}
	
	/* Global styles for markdown content */
	:global(.content h2) {
		margin: 3rem 0 1rem 0;
		font-size: 1.875rem;
		font-weight: 600;
		color: var(--text-1, #1a202c);
		border-bottom: 1px solid var(--border, #e2e8f0);
		padding-bottom: 0.5rem;
	}
	
	:global(.content h3) {
		margin: 2rem 0 1rem 0;
		font-size: 1.5rem;
		font-weight: 600;
		color: var(--text-1, #1a202c);
	}
	
	:global(.content h4) {
		margin: 1.5rem 0 0.5rem 0;
		font-size: 1.25rem;
		font-weight: 600;
		color: var(--text-1, #1a202c);
	}
	
	:global(.content p) {
		margin: 1rem 0;
		line-height: 1.7;
	}
	
	:global(.content code) {
		background: var(--surface-2, #f1f5f9);
		color: var(--text-1, #1a202c);
		padding: 0.125rem 0.375rem;
		border-radius: 0.25rem;
		font-size: 0.875rem;
		font-family: 'SF Mono', 'Monaco', 'Cascadia Code', monospace;
	}
	
	:global(.content pre) {
		background: var(--surface-3, #2d3748);
		color: #f7fafc;
		padding: 1.5rem;
		border-radius: 0.5rem;
		overflow-x: auto;
		margin: 1.5rem 0;
		font-size: 0.875rem;
		line-height: 1.5;
	}
	
	:global(.content pre code) {
		background: none;
		color: inherit;
		padding: 0;
	}
	
	:global(.content table) {
		width: 100%;
		border-collapse: collapse;
		margin: 1.5rem 0;
		font-size: 0.875rem;
	}
	
	:global(.content th),
	:global(.content td) {
		border: 1px solid var(--border, #e2e8f0);
		padding: 0.75rem;
		text-align: left;
	}
	
	:global(.content th) {
		background: var(--surface-2, #f8fafc);
		font-weight: 600;
		color: var(--text-1, #1a202c);
	}
	
	:global(.content blockquote) {
		border-left: 4px solid var(--primary, #3b82f6);
		background: var(--surface-2, #f8fafc);
		margin: 1.5rem 0;
		padding: 1rem 1.5rem;
		border-radius: 0 0.5rem 0.5rem 0;
	}
	
	:global(.content ul),
	:global(.content ol) {
		margin: 1rem 0;
		padding-left: 1.5rem;
	}
	
	:global(.content li) {
		margin: 0.5rem 0;
	}
	
	.page-footer {
		border-top: 1px solid var(--border, #e2e8f0);
		padding-top: 2rem;
		margin-top: 3rem;
	}
	
	.progress-info {
		text-align: center;
		margin-bottom: 2rem;
		font-weight: 500;
		color: var(--success, #10b981);
	}
	
	.page-navigation {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 1rem;
	}
	
	.nav-link {
		padding: 0.75rem 1.5rem;
		border: 1px solid var(--border, #e2e8f0);
		border-radius: 0.5rem;
		text-decoration: none;
		color: var(--text-1, #1a202c);
		font-weight: 500;
		transition: all 0.2s;
	}
	
	.nav-link:hover {
		background: var(--surface-2, #f8fafc);
		border-color: var(--primary, #3b82f6);
		color: var(--primary, #3b82f6);
	}
	
	.nav-link.home {
		background: var(--primary, #3b82f6);
		color: white;
		border-color: var(--primary, #3b82f6);
	}
	
	.nav-link.home:hover {
		background: var(--primary-dark, #2563eb);
	}
	
	@media (max-width: 768px) {
		.learning-page {
			padding: 1rem;
		}
		
		.chapter-info h1 {
			font-size: 2rem;
		}
		
		.meta-info {
			flex-direction: column;
			gap: 0.5rem;
		}
		
		.page-navigation {
			flex-direction: column;
		}
		
		.nav-link {
			width: 100%;
			text-align: center;
		}
	}
</style>