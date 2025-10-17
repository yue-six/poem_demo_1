<template>
  <div class="exercise-detail">
    <div class="exercise-header">
      <button class="back-button" @click="$emit('close')">← 返回</button>
      <h2>{{ exercise.title }}</h2>
      <div class="exercise-meta">
        <span class="difficulty" :class="exercise.difficulty">
          {{ getDifficultyText(exercise.difficulty) }}
        </span>
        <span class="exercise-icon">{{ exercise.icon }}</span>
      </div>
    </div>



    <div class="exercise-content">
      <!-- 练习说明 -->
      <div class="exercise-description">
        <h3>练习说明</h3>
        <p>{{ exercise.description }}</p>
      </div>

      <!-- 练习题目 -->
      <div class="exercise-questions" v-if="questions.length > 0">
        <h3>练习题目</h3>
        <div v-for="(question, index) in questions" :key="question.id" class="question-card">
          <div class="question-header">
            <h4>题目 {{ index + 1 }}</h4>
            <span class="question-type">{{ getQuestionTypeText(question.type) }}</span>
          </div>
          
          <div class="question-content">
            <p v-html="question.content"></p>
            
            <!-- 诗词内容展示 -->
            <div v-if="question.poem" class="poem-preview">
              <h5>{{ question.poem.title }}</h5>
              <p class="poem-author">{{ question.poem.author }} · {{ question.poem.dynasty }}</p>
              <div class="poem-content" v-html="formatPoemContent(question.poem.content)"></div>
            </div>
            
            <!-- 选择题选项 -->
            <div v-if="question.type === 'choice'" class="choice-options">
              <div v-for="(option, optIndex) in question.options" :key="optIndex" 
                   class="option-item" @click="selectAnswer(question.id, option)">
                <span class="option-label">{{ String.fromCharCode(65 + optIndex) }}.</span>
                <span class="option-text">{{ option }}</span>
              </div>
            </div>
            
            <!-- 填空题输入 -->
            <div v-else-if="question.type === 'fill'" class="fill-input">
              <input v-model="userAnswers[question.id]" 
                     :placeholder="question.placeholder || '请输入答案'" 
                     class="answer-input" />
            </div>
            
            <!-- 简答题输入 -->
            <div v-else-if="question.type === 'essay'" class="essay-input">
              <textarea v-model="userAnswers[question.id]" 
                        :placeholder="question.placeholder || '请简要回答'" 
                        class="answer-textarea" rows="4"></textarea>
            </div>
          </div>
          
          <!-- 提交按钮 -->
          <div class="question-actions">
            <button @click="submitAnswer(question)" 
                    :disabled="!userAnswers[question.id]"
                    class="submit-button">
              提交答案
            </button>
          </div>
          
          <!-- 答案反馈 -->
          <div v-if="questionFeedback[question.id]" class="feedback" 
               :class="{ correct: questionFeedback[question.id].isCorrect }">
            <p>{{ questionFeedback[question.id].message }}</p>
            <div v-if="!questionFeedback[question.id].isCorrect && question.explanation" 
                 class="explanation">
              <strong>解析：</strong>{{ question.explanation }}
            </div>
          </div>
        </div>
      </div>

      <!-- 无题目时的提示 -->
      <div v-else class="no-questions">
        <p>暂无练习题目，敬请期待！</p>
      </div>
    </div>

    <!-- 练习统计 -->
    <div class="exercise-stats" v-if="questions.length > 0">
      <div class="stats-card">
        <h4>练习进度</h4>
        <div class="progress-bar">
          <div class="progress-fill" :style="{ width: progressPercentage + '%' }"></div>
        </div>
        <p>已完成 {{ completedCount }} / {{ questions.length }} 题</p>
      </div>
      
      <div class="stats-card">
        <h4>正确率</h4>
        <div class="accuracy">{{ accuracyPercentage }}%</div>
        <p>已提交 {{ submittedCount }} 题</p>
      </div>
    </div>
  </div>
</template>

<script>
import { AppreciationService } from '../services/appreciationService.js'
import { getMockPracticeExercises } from '../utils/dbTest.js'

export default {
  name: 'ExerciseDetail',
  props: {
    exercise: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      questions: [],
      userAnswers: {},
      questionFeedback: {},
      isLoading: false,
      useMockData: false
    }
  },
  computed: {
    completedCount() {
      return Object.keys(this.questionFeedback).length
    },
    submittedCount() {
      return Object.values(this.questionFeedback).filter(fb => fb.submitted).length
    },
    correctCount() {
      return Object.values(this.questionFeedback).filter(fb => fb.isCorrect).length
    },
    progressPercentage() {
      return this.questions.length > 0 ? (this.completedCount / this.questions.length) * 100 : 0
    },
    accuracyPercentage() {
      return this.submittedCount > 0 ? Math.round((this.correctCount / this.submittedCount) * 100) : 0
    }
  },
  methods: {
    async loadQuestions() {
      this.isLoading = true
      this.useMockData = false
      
      try {
        // 首先尝试从数据库加载题目
        const difficulty = this.exercise.difficulty
        const dbQuestions = await AppreciationService.getExercisesByDifficulty(difficulty)
        
        if (dbQuestions && dbQuestions.length > 0) {
          this.questions = dbQuestions
          console.log('从数据库加载题目成功:', dbQuestions.length)
        } else {
          // 如果数据库没有数据，使用模拟数据
          throw new Error('数据库中没有找到相关题目')
        }
        
      } catch (error) {
        console.error('从数据库加载题目失败，使用模拟数据:', error.message)
        this.useMockData = true
        this.questions = this.getMockQuestions()
      }
      
      // 初始化用户答案和反馈
      this.questions.forEach(question => {
        this.userAnswers[question.id] = ''
        this.questionFeedback[question.id] = {}
      })
      
      this.isLoading = false
    },
    
    getMockQuestions() {
      // 从模拟数据中获取对应练习的题目
      const mockExercises = getMockPracticeExercises()
      const matchedExercise = mockExercises.find(ex => 
        ex.title === this.exercise.title || 
        ex.difficulty === this.exercise.difficulty
      )
      
      return matchedExercise ? matchedExercise.questions : []
    },
    
    getDifficultyText(difficulty) {
      const map = { easy: '初级', medium: '中级', hard: '高级' }
      return map[difficulty] || difficulty
    },
    
    getQuestionTypeText(type) {
      const map = { choice: '选择题', fill: '填空题', essay: '简答题' }
      return map[type] || type
    },
    
    formatPoemContent(content) {
      return content.replace(/\n/g, '<br>')
    },
    
    selectAnswer(questionId, answer) {
      this.userAnswers[questionId] = answer
    },
    
    async submitAnswer(question) {
      const userAnswer = this.userAnswers[question.id]
      if (!userAnswer) return
      
      try {
        // 提交答案到数据库
        const result = await AppreciationService.submitExerciseAnswer(
          question.id, 
          userAnswer,
          this.$store?.state.user?.id
        )
        
        // 检查答案是否正确
        const isCorrect = userAnswer === question.correctAnswer
        this.questionFeedback[question.id] = {
          isCorrect,
          message: isCorrect ? '回答正确！' : '回答不正确，请再想想。',
          explanation: question.explanation,
          submitted: true
        }
        
      } catch (error) {
        console.error('提交答案失败:', error)
        // 本地验证作为备选
        const isCorrect = userAnswer === question.correctAnswer
        this.questionFeedback[question.id] = {
          isCorrect,
          message: isCorrect ? '回答正确！' : '回答不正确，请再想想。',
          explanation: question.explanation,
          submitted: true
        }
      }
    }
  },
  async mounted() {
    await this.loadQuestions()
  }
}
</script>

<style scoped>
.exercise-detail {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.exercise-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid #e9ecef;
}

.back-button {
  background: #6c757d;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  cursor: pointer;
  font-size: 0.9rem;
}

.back-button:hover {
  background: #5a6268;
}

.exercise-header h2 {
  color: #2c3e50;
  margin: 0;
}

.exercise-meta {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.exercise-content {
  margin-bottom: 2rem;
}

.exercise-description,
.question-card {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  margin-bottom: 1.5rem;
}

.question-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.question-type {
  background: #667eea;
  color: white;
  padding: 0.3rem 0.8rem;
  border-radius: 15px;
  font-size: 0.8rem;
}

.poem-preview {
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 5px;
  margin: 1rem 0;
}

.poem-author {
  color: #6c757d;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.poem-content {
  line-height: 1.8;
  color: #495057;
}

.choice-options {
  margin: 1rem 0;
}

.option-item {
  display: flex;
  align-items: center;
  padding: 0.8rem;
  margin: 0.5rem 0;
  border: 1px solid #dee2e6;
  border-radius: 5px;
  cursor: pointer;
  transition: background 0.3s;
}

.option-item:hover {
  background: #f8f9fa;
}

.option-label {
  font-weight: bold;
  margin-right: 0.5rem;
  min-width: 20px;
}

.fill-input,
.essay-input {
  margin: 1rem 0;
}

.answer-input,
.answer-textarea {
  width: 100%;
  padding: 0.8rem;
  border: 1px solid #dee2e6;
  border-radius: 5px;
  font-size: 1rem;
}

.answer-textarea {
  resize: vertical;
}

.question-actions {
  margin-top: 1rem;
}

.submit-button {
  background: #28a745;
  color: white;
  border: none;
  padding: 0.8rem 1.5rem;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1rem;
}

.submit-button:hover:not(:disabled) {
  background: #218838;
}

.submit-button:disabled {
  background: #6c757d;
  cursor: not-allowed;
}

.feedback {
  margin-top: 1rem;
  padding: 1rem;
  border-radius: 5px;
}

.feedback.correct {
  background: #d4edda;
  border: 1px solid #c3e6cb;
  color: #155724;
}

.feedback:not(.correct) {
  background: #f8d7da;
  border: 1px solid #f5c6cb;
  color: #721c24;
}

.explanation {
  margin-top: 0.5rem;
  font-size: 0.9rem;
}

.exercise-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-top: 2rem;
}

.stats-card {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  text-align: center;
}

.progress-bar {
  background: #e9ecef;
  border-radius: 10px;
  height: 10px;
  margin: 1rem 0;
  overflow: hidden;
}

.progress-fill {
  background: #28a745;
  height: 100%;
  transition: width 0.3s;
}

.accuracy {
  font-size: 2rem;
  font-weight: bold;
  color: #28a745;
  margin: 1rem 0;
}

.no-questions {
  text-align: center;
  padding: 3rem;
  color: #6c757d;
}



@media (max-width: 768px) {
  .exercise-header {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }
  
  .exercise-stats {
    grid-template-columns: 1fr;
  }
}
</style>