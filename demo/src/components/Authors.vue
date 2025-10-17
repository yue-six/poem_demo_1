<template>
  <div class="authors-page">
    <div class="page-header">
      <h2>👨‍🎓 诗人介绍</h2>
      <p>了解诗人的生平事迹和创作风格</p>
    </div>
    
    <!-- 诗人列表 -->
    <div class="authors-grid">
      <div 
        v-for="author in authors" 
        :key="author.id" 
        class="author-card"
        @click="viewAuthorDetail(author)"
      >
        <div class="author-avatar">{{ getAvatarEmoji(author.name) }}</div>
        <h3 class="author-name">{{ author.name }}</h3>
        <p class="author-dynasty">{{ author.dynasty }}</p>
        <p class="author-description">{{ truncateDescription(author.description) }}</p>
        <div class="author-stats">
          <span class="stat-item">📚 {{ author.poem_count || 0 }} 首作品</span>
        </div>
      </div>
    </div>
    
    <!-- 加载状态 -->
    <div v-if="loading" class="loading">
      <p>正在加载诗人数据...</p>
    </div>
  </div>
</template>

<script>
import { PoemService } from '../services/poemService.js'

export default {
  name: 'Authors',
  data() {
    return {
      authors: [],
      loading: false
    }
  },
  methods: {
    async loadAuthors() {
      this.loading = true
      try {
        const authors = await PoemService.getPoets()
        // 获取每个诗人的作品数量
        const poems = await PoemService.getPoems()
        const poemCounts = {}
        
        poems.forEach(poem => {
          if (poem.poet_id) {
            poemCounts[poem.poet_id] = (poemCounts[poem.poet_id] || 0) + 1
          }
        })
        
        this.authors = authors.map(author => ({
          ...author,
          poem_count: poemCounts[author.id] || 0
        }))
      } catch (error) {
        console.error('加载诗人数据失败:', error)
      } finally {
        this.loading = false
      }
    },
    
    getAvatarEmoji(name) {
      // 简单的emoji映射
      const emojiMap = {
        '李白': '🍷',
        '杜甫': '📖',
        '苏轼': '🖋️',
        '白居易': '✍️',
        '王维': '🎨',
        '李清照': '🌸',
        '辛弃疾': '⚔️',
        '陆游': '❤️'
      }
      return emojiMap[name] || '👤'
    },
    
    truncateDescription(desc) {
      if (!desc) return '暂无介绍'
      return desc.length > 60 ? desc.substring(0, 60) + '...' : desc
    },
    
    viewAuthorDetail(author) {
      this.$emit('view-author-detail', author)
    }
  },
  
  async mounted() {
    await this.loadAuthors()
  }
}
</script>

<style scoped>
.authors-page {
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

.authors-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}

.author-card {
  background: white;
  border-radius: 10px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  text-align: center;
}

.author-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0,0,0,0.2);
}

.author-avatar {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.author-name {
  font-size: 1.3rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.author-dynasty {
  color: #e74c3c;
  font-weight: 600;
  margin-bottom: 1rem;
}

.author-description {
  color: #7f8c8d;
  line-height: 1.5;
  margin-bottom: 1rem;
}

.author-stats {
  font-size: 0.9rem;
  color: #95a5a6;
}

.loading {
  text-align: center;
  padding: 3rem;
  color: #7f8c8d;
}

@media (max-width: 768px) {
  .authors-grid {
    grid-template-columns: 1fr;
  }
}
</style>