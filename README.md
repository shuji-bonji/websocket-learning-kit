# sv

Everything you need to build a Svelte project, powered by [`sv`](https://github.com/sveltejs/cli).

## Creating a project

If you're seeing this, you've probably already done this step. Congrats!

```bash
# create a new project in the current directory
npx sv create

# create a new project in my-app
npx sv create my-app
```

## Developing

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.


## 必要なファイル構成

```
src/
├── lib/
│   ├── types/
│   │   ├── websocket.ts          # WebSocket型定義
│   │   └── mdsvex.ts             # MDsveX型定義
│   ├── components/
│   │   └── WebSocketDemo.svelte  # TypeScript対応デモ
│   ├── stores/
│   │   └── websocket.ts          # TypeScript対応ストア
├── routes/
│   └── learn/
│       └── 01-introduction/
│           └── +page.svx         # TypeScript対応コンテンツ
└── mdsvex.svelte                 # TypeScript対応レイアウト
```


## TypeScriptチェック
```
npm run check
```
## ESLintチェック（もし設定している場合）

```
npm run lint
```
## 開発サーバー起動
```
npm run dev
```