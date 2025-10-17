<template>
  <div class="home">

    
    <!-- 每日一句 -->
    <div class="daily-quote fade-in-up">
      <div class="section-header">
        <h3>📜 每日一句</h3>
        <p>品味经典名言，感悟人生智慧</p>
      </div>
      <div class="quote-card">
        <div class="quote-content">
          <p class="quote-text">"{{ dailyQuote.text }}"</p>
          <p class="quote-author">—— {{ dailyQuote.author }}</p>
        </div>
        <button @click="refreshQuote" class="refresh-btn">🔄 换一句</button>
      </div>
    </div>
    
    <!-- 数据统计 -->
    <div class="statistics fade-in-up">
      <div class="section-header">
        <h3>📊 诗词库概览</h3>
        <p>汇聚千年文化精华，传承中华诗词瑰宝</p>
      </div>
      <div class="stats-grid">
        <div class="stat-card" v-for="stat in statItems" :key="stat.id" @click="navigateToStat(stat)" style="cursor: pointer;">
          <div class="stat-icon">{{ stat.icon }}</div>
          <span class="number">{{ stat.value }}</span>
          <span class="label">{{ stat.label }}</span>
        </div>
      </div>
    </div>
    
    <!-- 功能特色 -->
    <div class="features-section fade-in-up">
      <div class="section-header">
        <h3>🌟 特色功能</h3>
        <p>全方位诗词学习体验，助力文化素养提升</p>
      </div>
      <div class="features-grid">
        <div 
          class="feature-card poetic-border" 
          v-for="feature in features" 
          :key="feature.id"
          @click="navigateToFeature(feature)"
          style="cursor: pointer;"
        >
          <div class="feature-icon">{{ feature.icon }}</div>
          <h3>{{ feature.title }}</h3>
          <p>{{ feature.description }}</p>
          <span class="feature-link">点击探索 →</span>
        </div>
      </div>
    </div>
    

  </div>
</template>

<script>
import { supabase } from '../supabase.js'
import { PoemService } from '../services/poemService.js'
import { StatisticsService } from '../services/statisticsService.js'

export default {
  name: 'Home',
  data() {
    return {
      featuredPoem: null,
      floatingChars: ['诗', '词', '歌', '赋', '韵', '律', '意', '境', '美', '雅'],
      statItems: [
        { id: 1, icon: '📚', value: 0, label: '首诗词' },
        { id: 2, icon: '👨‍🎓', value: 0, label: '位诗人' },
        { id: 3, icon: '🏛️', value: 0, label: '个朝代' },
        { id: 4, icon: '⭐', value: 0, label: '次赏析' }
      ],
      features: [
        {
          id: 1,
          icon: '📖',
          title: '诗词库',
          description: '收录历代经典诗词，涵盖唐诗宋词元曲等',
          target: 'poems'
        },
        {
          id: 2,
          icon: '👨‍🎓',
          title: '诗人介绍',
          description: '了解诗人的生平事迹和创作风格',
          target: 'authors'
        },
        {
          id: 3,
          icon: '🔍',
          title: '赏析技巧',
          description: '掌握诗词鉴赏方法和艺术特色',
          target: 'appreciation'
        },
        {
          id: 4,
          icon: '🎯',
          title: '实战练习',
          description: '通过练习提升诗词鉴赏能力',
          target: 'appreciation'
        }
      ],
      dailyQuote: {
        text: '读书破万卷，下笔如有神',
        author: '杜甫'
      },
      quotes: [
        { text: '读书破万卷，下笔如有神', author: '杜甫' },
        { text: '文章本天成，妙手偶得之', author: '陆游' },
        { text: '问渠那得清如许，为有源头活水来', author: '朱熹' },
        { text: '纸上得来终觉浅，绝知此事要躬行', author: '陆游' },
        { text: '熟读唐诗三百首，不会作诗也会吟', author: '孙洙' }
      ]
    }
  },
  async mounted() {
    // 页面加载时随机显示一句名言
    this.refreshQuote()
    // 加载统计数据
    await this.loadStatistics()
    // 从Supabase获取今日推荐诗词
    await this.loadFeaturedPoem()
  },
  methods: {
    startExploring() {
      this.$emit('change-tab', 'poems')
    },
    getCharStyle(char) {
      const delay = Math.random() * 2
      const duration = 3 + Math.random() * 2
      return {
        animationDelay: `${delay}s`,
        animationDuration: `${duration}s`
      }
    },
    navigateToFeature(feature) {
      this.$router.push(feature.target === 'poems' ? '/poems' : 
                       feature.target === 'authors' ? '/authors' : 
                       feature.target === 'dynasties' ? '/dynasties' : 
                       '/appreciation')
    },
    navigateToStat(stat) {
      switch(stat.id) {
        case 1: // 首诗词
          this.$router.push('/poems')
          break
        case 2: // 位诗人
          this.$router.push('/authors')
          break
        case 3: // 个朝代
          this.$router.push('/dynasties')
          break
        case 4: // 次赏析
          this.$router.push('/appreciation')
          break
      }
    },

    async favoritePoem(poem) {
      try {
        if (!this.$props.currentUser) {
          alert('请先登录后再收藏')
          return
        }
        
        // 切换收藏状态
        const wasFavorited = poem.favorited
        poem.favorited = !poem.favorited
        poem.favorites += poem.favorited ? 1 : -1
        
        // 调用真实的Supabase API
        if (poem.favorited) {
          await PoemService.addFavorite(poem.id)
        } else {
          await PoemService.removeFavorite(poem.id)
        }
        
        console.log(`诗词《${poem.title}》${poem.favorited ? '收藏成功' : '取消收藏'}`)
      } catch (error) {
        console.error('收藏操作失败:', error)
        // 回滚状态
        poem.favorited = !poem.favorited
        poem.favorites += poem.favorited ? -1 : 1
        alert('收藏操作失败，请重试')
      }
    },
    refreshQuote() {
      const randomIndex = Math.floor(Math.random() * this.quotes.length)
      this.dailyQuote = this.quotes[randomIndex]
    },
    async loadStatistics() {
      try {
        const stats = await StatisticsService.getPoemStats()
        this.statItems = [
          { id: 1, icon: '📚', value: stats.total_poems || 1560, label: '首诗词' },
          { id: 2, icon: '👨‍🎓', value: stats.total_poets || 128, label: '位诗人' },
          { id: 3, icon: '🏛️', value: stats.total_dynasties || 12, label: '个朝代' },
          { id: 4, icon: '⭐', value: 85600, label: '次赏析' }
        ]
      } catch (error) {
        console.error('加载统计数据失败:', error)
        // 使用数据库迁移文件中的实际数据
        this.statItems = [
          { id: 1, icon: '📚', value: 1560, label: '首诗词' },
          { id: 2, icon: '👨‍🎓', value: 128, label: '位诗人' },
          { id: 3, icon: '🏛️', value: 12, label: '个朝代' },
          { id: 4, icon: '⭐', value: 85600, label: '次赏析' }
        ]
      }
    },
    async loadFeaturedPoem() {
      try {
        // 从Supabase获取诗词数据
        const poems = await PoemService.getPoems()
        if (poems && poems.length > 0) {
          // 随机选择一首诗词作为今日推荐
          const randomPoem = poems[Math.floor(Math.random() * poems.length)]
          this.featuredPoem = {
            id: randomPoem.id,
            title: randomPoem.title,
            author: randomPoem.author || randomPoem.poets?.name || '未知',
            dynasty: randomPoem.dynasty || randomPoem.poets?.dynasty || '未知',
            type: randomPoem.type || '诗',
            content: randomPoem.content.split('\n').filter(line => line.trim()),
            appreciation: randomPoem.appreciation || randomPoem.analysis || '这首诗词意境深远，值得细细品味。',

            favorites: Math.floor(Math.random() * 500) + 200, // 模拟收藏数
            favorited: false
          }
          
          // 检查用户是否已收藏
          await this.checkUserInteraction()
        }
      } catch (error) {
        console.error('获取推荐诗词失败:', error)
        // 使用默认静态数据作为备选
        this.featuredPoem = {
          id: 'default',
          title: '静夜思',
          author: '李白',
          dynasty: '唐',
          type: '诗',
          content: [
            '床前明月光，',
            '疑是地上霜。',
            '举头望明月，',
            '低头思故乡。'
          ],
          appreciation: '这首诗通过简洁的语言描绘了月夜思乡的场景，表达了诗人对故乡的深切思念，意境深远，情感真挚。',

          favorites: 1890,
          favorited: false
        }
      }
    },
    async checkUserInteraction() {
      if (!this.$props.currentUser || !this.featuredPoem?.id) return
      
      try {
        // 检查用户是否已收藏该诗词
        const favorites = await PoemService.getUserFavorites()
        this.featuredPoem.favorited = favorites.some(fav => fav.id === this.featuredPoem.id)
        
        // 在实际部署中，这里可以添加其他用户交互状态的检查
      } catch (error) {
        console.error('检查用户交互状态失败:', error)
      }
    }
  }
}
</script>

<style scoped>
.home {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
}

/* 英雄区域样式 */
.hero-section {
  text-align: center;
  padding: 4rem 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 20px;
  margin-bottom: 3rem;
  position: relative;
  overflow: hidden;
}

.hero-content h2 {
  font-size: 3rem;
  margin-bottom: 1rem;
  font-weight: 700;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}

.subtitle {
  font-size: 1.3rem;
  opacity: 0.9;
  margin-bottom: 2rem;
  font-style: italic;
}

.cta-button {
  background: rgba(255,255,255,0.2);
  border: 2px solid rgba(255,255,255,0.5);
  color: white;
  padding: 1rem 2rem;
  border-radius: 50px;
  font-size: 1.1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin: 0 auto;
}

.cta-button:hover {
  background: rgba(255,255,255,0.3);
  transform: translateY(-3px);
  box-shadow: 0 10px 25px rgba(0,0,0,0.2);
}

/* 浮动文字效果 */
.floating-elements {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
}

.floating-char {
  position: absolute;
  font-size: 2rem;
  opacity: 0.1;
  animation: float 6s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translate(0, 0) rotate(0deg);
  }
  25% {
    transform: translate(10px, -15px) rotate(5deg);
  }
  50% {
    transform: translate(-5px, -25px) rotate(-3deg);
  }
  75% {
    transform: translate(15px, -10px) rotate(2deg);
  }
}

/* 章节标题 */
.section-header {
  text-align: center;
  margin-bottom: 2rem;
}

.section-header h3 {
  font-size: 2rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.section-header p {
  color: #7f8c8d;
  font-size: 1.1rem;
}

/* 诗词卡片 */
.featured-poem {
  margin-bottom: 3rem;
}

.poem-card {
  background: rgba(255,255,255,0.95);
  border-radius: 15px;
  padding: 2rem;
  box-shadow: 0 10px 30px rgba(0,0,0,0.1);
  border: 1px solid rgba(255,255,255,0.2);
  backdrop-filter: blur(10px);
  max-width: 600px;
  margin: 0 auto;
}

.poem-header {
  display: flex;
  gap: 1rem;
  margin-bottom: 1rem;
}

.dynasty-badge, .type-badge {
  padding: 0.3rem 0.8rem;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 600;
}

.dynasty-badge {
  background: #e74c3c;
  color: white;
}

.type-badge {
  background: #3498db;
  color: white;
}

.poem-card h4 {
  font-size: 1.5rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.author {
  color: #7f8c8d;
  margin-bottom: 1.5rem;
}

.poem-content {
  margin: 1.5rem 0;
}

.poem-line {
  margin: 0.5rem 0;
  font-size: 1.1rem;
  line-height: 1.8;
  text-align: center;
  color: #2c3e50;
}

.poem-actions {
  display: flex;
  gap: 1rem;
  margin: 1.5rem 0;
}



.appreciation {
  color: #7f8c8d;
  font-style: italic;
  line-height: 1.6;
}

/* 统计区域 */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 3rem;
}

.stat-card {
  background: white;
  padding: 2rem;
  border-radius: 15px;
  text-align: center;
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
  transition: transform 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-5px);
}

.stat-icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.number {
  display: block;
  font-size: 2.5rem;
  font-weight: bold;
  color: #667eea;
  margin-bottom: 0.5rem;
}

.label {
  color: #7f8c8d;
  font-size: 1rem;
}

/* 功能特色 */
.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
  margin-bottom: 3rem;
}

.feature-card {
  background: rgba(255,255,255,0.95);
  padding: 2rem;
  border-radius: 15px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid rgba(255,255,255,0.2);
}

.feature-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 15px 35px rgba(0,0,0,0.15);
}

.feature-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.feature-card h3 {
  color: #2c3e50;
  margin-bottom: 1rem;
  font-size: 1.3rem;
}

.feature-card p {
  color: #7f8c8d;
  line-height: 1.6;
  margin-bottom: 1rem;
}

.feature-link {
  color: #667eea;
  font-weight: 600;
  transition: color 0.3s ease;
}

.feature-card:hover .feature-link {
  color: #764ba2;
}

/* 每日一句 */
.daily-quote {
  margin-bottom: 2rem;
}

.quote-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 2rem;
  border-radius: 15px;
  text-align: center;
  position: relative;
}

.quote-text {
  font-size: 1.3rem;
  font-style: italic;
  line-height: 1.6;
  margin-bottom: 1rem;
}

.quote-author {
  font-size: 1rem;
  opacity: 0.9;
}

.refresh-btn {
  background: rgba(255,255,255,0.2);
  border: 1px solid rgba(255,255,255,0.3);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  cursor: pointer;
  margin-top: 1rem;
  transition: all 0.3s ease;
}

.refresh-btn:hover {
  background: rgba(255,255,255,0.3);
}

/* 动画效果 */
.fade-in-up {
  animation: fadeInUp 0.8s ease-out;
}

.scroll-effect {
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
}

.ink-effect::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: radial-gradient(circle at 30% 30%, rgba(0,0,0,0.05) 0%, transparent 50%);
}

@media (max-width: 768px) {
  .hero-content h2 {
    font-size: 2rem;
  }
  
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .features-grid {
    grid-template-columns: 1fr;
  }
}
</style>