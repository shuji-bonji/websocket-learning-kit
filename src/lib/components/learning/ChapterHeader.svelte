<!-- src/lib/components/learning/ChapterHeader.svelte -->
<script lang="ts">
  export let chapter: number;
  export let title: string;
  export let description: string = '';
  export let estimatedTime: string = '';
  export let exercises: number = 0;
  export let difficulty: 'beginner' | 'intermediate' | 'advanced' = 'beginner';
  export let tags: string[] = [];
  export let objectives: string[] = [];
  
  const difficultyColors = {
    beginner: '#10b981',
    intermediate: '#f59e0b', 
    advanced: '#ef4444'
  };
  
  const difficultyLabels = {
    beginner: '初級',
    intermediate: '中級',
    advanced: '上級'
  };
</script>

<div class="chapter-header">
  <div class="badges">
    <div class="chapter-badge">Chapter {chapter}</div>
    <div 
      class="difficulty-badge" 
      style="background-color: {difficultyColors[difficulty]}"
    >
      {difficultyLabels[difficulty]}
    </div>
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
  
  {#if objectives.length > 0}
    <div class="objectives">
      <h3>📖 学習目標</h3>
      <ul>
        {#each objectives as objective}
          <li>{objective}</li>
        {/each}
      </ul>
    </div>
  {/if}
</div>

<style>
  .chapter-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 2rem;
    border-radius: 12px;
    margin-bottom: 3rem;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    text-align: center;
  }
  
  .badges {
    display: flex;
    justify-content: center;
    gap: 1rem;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
  }
  
  .chapter-badge, .difficulty-badge {
    padding: 0.5rem 1rem;
    border-radius: 2rem;
    font-size: 0.875rem;
    font-weight: 600;
    color: white;
  }
  
  .chapter-badge {
    background: rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(10px);
  }
  
  h1 {
    font-size: 2.5rem;
    margin: 1rem 0;
    color: white;
  }
  
  .description {
    font-size: 1.125rem;
    margin: 1rem 0;
    opacity: 0.9;
  }
  
  .meta-info {
    display: flex;
    justify-content: center;
    gap: 2rem;
    margin: 1.5rem 0;
    flex-wrap: wrap;
  }
  
  .meta-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.875rem;
    opacity: 0.9;
  }
  
  .tags {
    display: flex;
    justify-content: center;
    gap: 0.75rem;
    flex-wrap: wrap;
    margin: 1rem 0;
  }
  
  .tag {
    background: rgba(255, 255, 255, 0.15);
    color: white;
    padding: 0.375rem 0.75rem;
    border-radius: 1rem;
    font-size: 0.8rem;
    backdrop-filter: blur(10px);
  }
  
  .objectives {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    padding: 1.5rem;
    margin-top: 2rem;
    text-align: left;
    backdrop-filter: blur(10px);
  }
  
  .objectives h3 {
    margin-top: 0;
    color: white;
  }
  
  .objectives ul {
    margin: 0;
    padding-left: 1.5rem;
  }
  
  .objectives li {
    margin: 0.5rem 0;
    line-height: 1.5;
  }
  
  @media (max-width: 768px) {
    .chapter-header {
      padding: 1.5rem;
    }
    
    h1 {
      font-size: 2rem;
    }
    
    .badges {
      flex-direction: column;
      align-items: center;
    }
    
    .meta-info {
      flex-direction: column;
      gap: 1rem;
    }
  }
</style>

