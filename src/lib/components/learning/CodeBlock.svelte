<!-- src/lib/components/learning/CodeBlock.svelte -->
<script lang="ts">
  export let code: string;
  export let language: string = 'typescript';
  export let title: string = '';
  export let highlightLines: number[] = [];
  export let showLineNumbers: boolean = true;
  
  // コードを行ごとに分割
  $: codeLines = code.split('\n');
  
  // Simple syntax highlighting
  function highlightCode(line: string, lang: string): string {
    let highlighted = line
      .replace(/\b(const|let|var|function|async|await|return|if|else|for|while|class|interface|type|export|import|new)\b/g, '<span class="keyword">$1</span>')
      .replace(/\b(string|number|boolean|void|any|unknown|WebSocket|Event|MessageEvent|CloseEvent)\b/g, '<span class="type">$1</span>')
      .replace(/'([^']*?)'/g, '<span class="string">\'$1\'</span>')
      .replace(/"([^"]*?)"/g, '<span class="string">"$1"</span>')
      .replace(/`([^`]*?)`/g, '<span class="template">`$1`</span>')
      .replace(/\/\/.*$/gm, '<span class="comment">$&</span>')
      .replace(/\/\*[\s\S]*?\*\//g, '<span class="comment">$&</span>')
      .replace(/\b(\d+)\b/g, '<span class="number">$1</span>')
      .replace(/\.([\w]+)/g, '.<span class="property">$1</span>');
    
    return highlighted;
  }
  
  // 行がハイライト対象かチェック
  function isHighlightedLine(lineNumber: number): boolean {
    return highlightLines.includes(lineNumber);
  }
</script>

<div class="code-block">
  {#if title}
    <div class="code-title">
      {title}
      {#if highlightLines.length > 0}
        <span class="highlight-info">
          📍 ハイライト行: {highlightLines.join(', ')}
        </span>
      {/if}
    </div>
  {/if}
  
  <div class="code-container">
    {#if showLineNumbers}
      <div class="line-numbers">
        {#each codeLines as _, index}
          <div 
            class="line-number" 
            class:highlighted={isHighlightedLine(index + 1)}
          >
            {index + 1}
          </div>
        {/each}
      </div>
    {/if}
    
    <pre class="code-content"><code>{#each codeLines as line, index}<div 
        class="code-line" 
        class:highlighted={isHighlightedLine(index + 1)}
      >{@html highlightCode(line, language)}</div>{/each}</code></pre>
  </div>
</div>

<style>
  .code-block {
    background: #1e293b;
    border-radius: 8px;
    margin: 1.5rem 0;
    overflow: hidden;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    font-family: 'JetBrains Mono', 'Fira Code', Consolas, monospace;
  }
  
  .code-title {
    background: #334155;
    color: #e2e8f0;
    padding: 0.75rem 1.5rem;
    font-size: 0.875rem;
    font-weight: 500;
    border-bottom: 1px solid #475569;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
  }
  
  .highlight-info {
    background: #0ea5e9;
    color: white;
    padding: 0.25rem 0.75rem;
    border-radius: 1rem;
    font-size: 0.75rem;
    font-weight: 500;
  }
  
  .code-container {
    display: flex;
    overflow-x: auto;
  }
  
  .line-numbers {
    background: #1e293b;
    color: #64748b;
    padding: 1rem 0;
    text-align: right;
    user-select: none;
    border-right: 1px solid #475569;
    min-width: 3rem;
    flex-shrink: 0;
  }
  
  .line-number {
    padding: 0 0.75rem;
    line-height: 1.5;
    font-size: 0.875rem;
    transition: all 0.2s;
  }
  
  .line-number.highlighted {
    background: rgba(59, 130, 246, 0.2);
    color: #3b82f6;
    font-weight: 600;
  }
  
  .code-content {
    margin: 0;
    padding: 1rem 0 1rem 1rem;
    overflow: visible;
    flex: 1;
    min-width: 0;
  }
  
  code {
    color: #f1f5f9;
    font-size: 0.875rem;
    line-height: 1.5;
  }
  
  .code-line {
    transition: background-color 0.2s;
    padding: 0 1rem 0 0;
    margin: 0;
    min-height: 1.5em;
  }
  
  .code-line.highlighted {
    background: rgba(59, 130, 246, 0.15);
    border-left: 3px solid #3b82f6;
    padding-left: 0.5rem;
    margin-left: -0.5rem;
  }
  
  /* Syntax highlighting styles */
  :global(.code-block .keyword) {
    color: #60a5fa;
    font-weight: 500;
  }
  
  :global(.code-block .type) {
    color: #34d399;
    font-weight: 500;
  }
  
  :global(.code-block .string) {
    color: #fbbf24;
  }
  
  :global(.code-block .template) {
    color: #f87171;
  }
  
  :global(.code-block .comment) {
    color: #64748b;
    font-style: italic;
  }
  
  :global(.code-block .number) {
    color: #a78bfa;
  }
  
  :global(.code-block .property) {
    color: #fb7185;
  }
  
  /* スクロールバーのスタイリング */
  .code-container::-webkit-scrollbar {
    height: 8px;
  }
  
  .code-container::-webkit-scrollbar-track {
    background: #1e293b;
  }
  
  .code-container::-webkit-scrollbar-thumb {
    background: #475569;
    border-radius: 4px;
  }
  
  .code-container::-webkit-scrollbar-thumb:hover {
    background: #64748b;
  }
  
  /* レスポンシブ対応 */
  @media (max-width: 768px) {
    .code-title {
      flex-direction: column;
      align-items: flex-start;
    }
    
    .code-content {
      font-size: 0.8rem;
    }
    
    .line-numbers {
      min-width: 2.5rem;
    }
    
    .line-number {
      padding: 0 0.5rem;
    }
  }
</style>