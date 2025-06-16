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
