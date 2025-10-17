<template>
  <div class="dynasties-page">
    <div class="page-header">
      <h2>🏛️ 朝代诗词</h2>
      <p>按朝代浏览诗词，感受不同时代的文化特色</p>
    </div>
    
    <!-- 朝代列表 -->
    <div class="dynasties-grid">
      <div 
        v-for="dynasty in dynasties" 
        :key="dynasty.name" 
        class="dynasty-card"
        @click="viewDynastyPoems(dynasty)"
      >
        <div class="dynasty-icon">{{ getDynastyEmoji(dynasty.name) }}</div>
        <h3 class="dynasty-name">{{ dynasty.name }}</h3>
        <p class="dynasty-period">{{ dynasty.period }}</p>
        <div class="dynasty-stats">
          <span class="stat-item">📚 {{ dynasty.poem_count }} 首诗词</span>
          <span class="stat-item">👨‍🎓 {{ dynasty.poet_count }} 位诗人</span>
        </div>
        <p class="dynasty-description">{{ dynasty.description }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import { StatisticsService } from '../services/statisticsService.js'

export default {
  name: 'Dynasties',
  data() {
    return {
      dynasties: []
    }
  },
  methods: {
    async loadDynasties() {
      try {
        const stats = await StatisticsService.getDynastyStats()
        
        if (stats && stats.length > 0) {
          // 使用数据库中的实际朝代数据
          this.dynasties = stats.map(stat => ({
            name: stat.dynasty,
            period: this.getDynastyPeriod(stat.dynasty),
            description: this.getDynastyDescription(stat.dynasty),
            poem_count: stat.poem_count,
            poet_count: stat.poet_count
          }))
        } else {
          // 如果数据库没有数据，使用默认数据
          this.loadDefaultDynasties()
        }
      } catch (error) {
        console.error('加载朝代数据失败:', error)
        // 使用默认数据
        this.loadDefaultDynasties()
      }
    },
    
    loadDefaultDynasties() {
      this.dynasties = [
        {
          name: '唐代',
          period: '618-907年',
          description: '唐诗是中国古典诗歌的巅峰，以李白、杜甫为代表',
          poem_count: 560,
          poet_count: 45
        },
        {
          name: '宋代',
          period: '960-1279年',
          description: '宋词婉约豪放并重，苏轼、李清照为杰出代表',
          poem_count: 480,
          poet_count: 38
        },
        {
          name: '元代',
          period: '1271-1368年',
          description: '元曲通俗易懂，关汉卿、马致远为重要作家',
          poem_count: 120,
          poet_count: 12
        },
        {
          name: '明代',
          period: '1368-1644年',
          description: '明诗继承传统，小说创作繁荣',
          poem_count: 200,
          poet_count: 18
        },
        {
          name: '清代',
          period: '1644-1912年',
          description: '清诗题材广泛，纳兰性德、龚自珍为代表',
          poem_count: 180,
          poet_count: 15
        }
      ]
    },
    
    getDynastyPeriod(dynastyName) {
      const periods = {
        '唐代': '618-907年',
        '宋代': '960-1279年',
        '元代': '1271-1368年',
        '明代': '1368-1644年',
        '清代': '1644-1912年',
        '战国': '公元前475-221年',
        '汉代': '公元前202-220年',
        '魏晋': '220-420年',
        '南北朝': '420-589年',
        '隋代': '581-618年',
        '近代': '1840-1949年'
      }
      return periods[dynastyName] || '未知时期'
    },
    
    getDynastyDescription(dynastyName) {
      const descriptions = {
        '唐代': '唐诗是中国古典诗歌的巅峰，以李白、杜甫为代表',
        '宋代': '宋词婉约豪放并重，苏轼、李清照为杰出代表',
        '元代': '元曲通俗易懂，关汉卿、马致远为重要作家',
        '明代': '明诗继承传统，小说创作繁荣',
        '清代': '清诗题材广泛，纳兰性德、龚自珍为代表',
        '战国': '楚辞兴起，屈原《离骚》为杰出代表',
        '汉代': '汉赋盛行，乐府诗反映民间生活',
        '魏晋': '建安文学繁荣，陶渊明开创田园诗派',
        '南北朝': '山水诗兴起，民歌创作丰富',
        '隋代': '承前启后，为唐诗繁荣奠定基础',
        '近代': '新诗运动兴起，融合中西文化'
      }
      return descriptions[dynastyName] || `${dynastyName}时期的诗词文化丰富多彩`
    },
    
    getDefaultPoemCount(dynastyName) {
      const counts = {
        '唐代': 560,
        '宋代': 480,
        '元代': 120,
        '明代': 200,
        '清代': 180
      }
      return counts[dynastyName] || 0
    },
    
    getDefaultPoetCount(dynastyName) {
      const counts = {
        '唐代': 45,
        '宋代': 38,
        '元代': 12,
        '明代': 18,
        '清代': 15
      }
      return counts[dynastyName] || 0
    },
    
    getDynastyEmoji(name) {
      const emojiMap = {
        '唐代': '🏯',
        '宋代': '🎨',
        '元代': '🎭',
        '明代': '🏮',
        '清代': '👑'
      }
      return emojiMap[name] || '📜'
    },
    
    viewDynastyPoems(dynasty) {
      // 跳转到朝代详情页面
      this.$router.push({
        path: '/dynasty-detail',
        query: { dynasty: dynasty.name }
      })
    }
  },
  
  async mounted() {
    await this.loadDynasties()
  }
}
</script>

<style scoped>
.dynasties-page {
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

.dynasties-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.dynasty-card {
  background: white;
  border-radius: 10px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  text-align: center;
}

.dynasty-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0,0,0,0.2);
}

.dynasty-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.dynasty-name {
  font-size: 1.5rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.dynasty-period {
  color: #e74c3c;
  font-weight: 600;
  margin-bottom: 1rem;
}

.dynasty-stats {
  display: flex;
  justify-content: space-around;
  margin-bottom: 1rem;
  font-size: 0.9rem;
  color: #7f8c8d;
}

.dynasty-description {
  color: #7f8c8d;
  line-height: 1.5;
  font-size: 0.9rem;
}

@media (max-width: 768px) {
  .dynasties-grid {
    grid-template-columns: 1fr;
  }
}
</style>