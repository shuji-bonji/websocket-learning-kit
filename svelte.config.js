import adapter from '@sveltejs/adapter-auto';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import { mdsvex } from 'mdsvex';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	extensions: ['.svelte', '.svx'],
	preprocess: [vitePreprocess(), mdsvex({
		extensions: ['.svx'],
		layout: { _: './src/mdsvex.svelte' }
	})],
	kit: {
		adapter: adapter()
	}
};

export default config;