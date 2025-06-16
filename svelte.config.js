import adapter from '@sveltejs/adapter-auto';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  extensions: ['.svelte'],  // .svxを削除
  preprocess: [vitePreprocess()],  // mdsvexを削除
  kit: {
    adapter: adapter()
  }
};

export default config;
