<!-- src/lib/components/learning/ExerciseBox.svelte -->
<script lang="ts">
  export let title: string = '📝 演習';
  export let type: 'exercise' | 'quiz' | 'challenge' = 'exercise';
  export let difficulty: 'easy' | 'medium' | 'hard' = 'easy';
  export let showAnswer: boolean = false;
  
  let isAnswerVisible = false;
  
  const typeConfig = {
    exercise: { icon: '📝', bgColor: '#f0f9ff', borderColor: '#0ea5e9' },
    quiz: { icon: '🤔', bgColor: '#fef3c7', borderColor: '#f59e0b' },
    challenge: { icon: '🚀', bgColor: '#fecaca', borderColor: '#ef4444' }
  };
  
  const difficultyConfig = {
    easy: { label: '初級', color: '#10b981' },
    medium: { label: '中級', color: '#f59e0b' },
    hard: { label: '上級', color: '#ef4444' }
  };
  
  $: config = typeConfig[type];
  $: diffConfig = difficultyConfig[difficulty];
</script>

<div class="exercise-box" style="background: {config.bgColor}; border-color: {config.borderColor}">
  <div class="exercise-header">
    <h3>
      <span class="icon">{config.icon}</span>
      {title}
    </h3>
    <div class="badges">
      <span class="difficulty-badge" style="background-color: {diffConfig.color}">
        {diffConfig.label}
      </span>
    </div>
  </div>
  
  <div class="exercise-content">
    <slot name="content" />
  </div>
  
  {#if showAnswer}
    <div class="answer-section">
      <button 
        class="toggle-answer" 
        on:click={() => isAnswerVisible = !isAnswerVisible}
      >
        💡 {isAnswerVisible ? '答えを隠す' : '答えを見る'}
      </button>
      
      {#if isAnswerVisible}
        <div class="answer-content">
          <slot name="answer" />
        </div>
      {/if}
    </div>
  {/if}
  
  <slot name="actions" />
</div>

<style>
  .exercise-box {
    border: 1px solid;
    border-radius: 8px;
    padding: 0;
    margin: 1.5rem 0;
    overflow: hidden;
  }
  
  .exercise-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 1.5rem;
    background: rgba(255, 255, 255, 0.5);
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    flex-wrap: wrap;
    gap: 1rem;
  }
  
  .exercise-header h3 {
    margin: 0;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  
  .icon {
    font-size: 1.2rem;
  }
  
  .badges {
    display: flex;
    gap: 0.5rem;
  }
  
  .difficulty-badge {
    color: white;
    padding: 0.25rem 0.75rem;
    border-radius: 1rem;
    font-size: 0.75rem;
    font-weight: 500;
  }
  
  .exercise-content {
    padding: 1.5rem;
  }
  
  .answer-section {
    border-top: 1px solid rgba(0, 0, 0, 0.1);
    padding: 1rem 1.5rem;
    background: rgba(255, 255, 255, 0.3);
  }
  
  .toggle-answer {
    background: none;
    border: 1px solid rgba(0, 0, 0, 0.2);
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.875rem;
    transition: all 0.2s;
  }
  
  .toggle-answer:hover {
    background: rgba(0, 0, 0, 0.05);
  }
  
  .answer-content {
    margin-top: 1rem;
    padding: 1rem;
    background: rgba(255, 255, 255, 0.8);
    border-radius: 4px;
    border-left: 3px solid #10b981;
  }
  
  @media (max-width: 768px) {
    .exercise-header {
      flex-direction: column;
      align-items: flex-start;
    }
  }
</style>