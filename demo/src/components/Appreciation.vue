<template>
  <div class="appreciation-page">
    <!-- 练习详情页面 -->
    <ExerciseDetail 
      v-if="currentExercise" 
      :exercise="currentExercise"
      @close="closeExercise"
    />
    
    <!-- 主页面 -->
    <div v-else>
      <div class="page-header">
        <h2>🔍 诗词赏析</h2>
        <p>掌握诗词鉴赏方法和艺术特色</p>
      </div>
      
      <!-- 赏析技巧 -->
      <div class="techniques-section">
        <h3>📖 赏析技巧</h3>
        <div class="techniques-grid">
          <div class="technique-card">
            <h4>意象分析</h4>
            <p>分析诗词中的意象运用，理解作者的创作意图和情感表达。</p>
          </div>
          <div class="technique-card">
            <h4>韵律节奏</h4>
            <p>把握诗词的韵律美和节奏感，体会音乐性的艺术效果。</p>
          </div>
          <div class="technique-card">
            <h4>修辞手法</h4>
            <p>识别比喻、拟人、夸张等修辞手法，理解艺术表现力。</p>
          </div>
          <div class="technique-card">
            <h4>意境营造</h4>
            <p>感受诗词营造的意境氛围，体会情景交融的艺术境界。</p>
          </div>
        </div>
      </div>
      
      <!-- 实战练习 -->
      <div class="practice-section">
        <h3>🎯 实战练习</h3>
        <div class="practice-cards">
          <div 
            v-for="exercise in exercises" 
            :key="exercise.id" 
            class="practice-card"
            @click="startExercise(exercise)"
          >
            <div class="exercise-icon">{{ exercise.icon }}</div>
            <h4>{{ exercise.title }}</h4>
            <p>{{ exercise.description }}</p>
            <span class="difficulty" :class="exercise.difficulty">
              {{ exercise.difficulty === 'easy' ? '初级' : exercise.difficulty === 'medium' ? '中级' : '高级' }}
            </span>
          </div>
        </div>
      </div>
      

    </div>
  </div>
</template>

<script>
import { StatisticsService } from '../services/statisticsService.js'
import ExerciseDetail from './ExerciseDetail.vue'

export default {
  name: 'Appreciation',
  components: {
    ExerciseDetail
  },
  data() {
    return {
      currentExercise: null,
      exercises: [
        {
          id: 1,
          icon: '🔍',
          title: '意象识别练习',
          description: '识别诗词中的关键意象及其象征意义',
          difficulty: 'easy'
        },
        {
          id: 2,
          icon: '🎵',
          title: '韵律分析练习',
          description: '分析诗词的韵律结构和节奏特点',
          difficulty: 'medium'
        },
        {
          id: 3,
          icon: '🖋️',
          title: '修辞手法练习',
          description: '识别并分析诗词中的修辞手法',
          difficulty: 'medium'
        },
        {
          id: 4,
          icon: '🎨',
          title: '意境赏析练习',
          description: '深入理解诗词的意境和情感表达',
          difficulty: 'hard'
        },
        {
          id: 5,
          icon: '📚',
          title: '综合练习',
          description: '综合运用多种赏析技巧进行深度分析',
          difficulty: 'hard'
        },
        {
          id: 6,
          icon: '✍️',
          title: '填空题练习',
          description: '补全经典诗词名句，检验诗词积累',
          difficulty: 'medium'
        }
      ]
    }
  },
  methods: {
    
    startExercise(exercise) {
      // 打开练习详情页面
      this.currentExercise = exercise
    },
    
    closeExercise() {
      // 关闭练习详情页面
      this.currentExercise = null
    }
  }
}
</script>

<style scoped>
.appreciation-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.page-header {
  text-align: center;
  margin-bottom: 2rem;
}

.page-header h2 {
  font-size: 2.5rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.page-header p {
  color: #7f8c8d;
  font-size: 1.1rem;
}

.techniques-section,
.practice-section {
  margin-bottom: 3rem;
}

.techniques-section h3,
.practice-section h3 {
  font-size: 1.8rem;
  color: #2c3e50;
  margin-bottom: 1.5rem;
  border-left: 4px solid #667eea;
  padding-left: 1rem;
}

.techniques-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
}

.technique-card {
  background: white;
  padding: 1.5rem;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.technique-card h4 {
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.technique-card p {
  color: #7f8c8d;
  line-height: 1.5;
}

.practice-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}

@media (min-width: 1200px) {
  .practice-cards {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 1199px) and (min-width: 768px) {
  .practice-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

.practice-card {
  background: white;
  padding: 1.5rem;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: transform 0.3s ease;
  text-align: center;
}

.practice-card:hover {
  transform: translateY(-5px);
}

.exercise-icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.practice-card h4 {
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.practice-card p {
  color: #7f8c8d;
  margin-bottom: 1rem;
  line-height: 1.5;
}

.difficulty {
  padding: 0.3rem 0.8rem;
  border-radius: 15px;
  font-size: 0.8rem;
  font-weight: 600;
}

.difficulty.easy {
  background: #d4edda;
  color: #155724;
}

.difficulty.medium {
  background: #fff3cd;
  color: #856404;
}

.difficulty.hard {
  background: #f8d7da;
  color: #721c24;
}

@media (max-width: 768px) {
  .techniques-grid,
  .practice-cards {
    grid-template-columns: 1fr;
  }
}
</style>