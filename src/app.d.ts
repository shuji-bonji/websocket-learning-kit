// See https://svelte.dev/docs/kit/types#app.d.ts
// for information about these interfaces
import type { PageFrontmatter } from '$lib/types/mdsvex';

declare global {
	namespace App {
		// interface Error {}
		// interface Locals {}
		interface PageData {
			frontmatter?: PageFrontmatter;
		}
		// interface PageState {}
		// interface Platform {}
	}
}

export {};
