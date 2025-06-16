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
