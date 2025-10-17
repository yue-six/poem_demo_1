<template>
  <div class="dynasty-detail-page">
    <div class="page-header">
      <button class="back-button" @click="$router.back()">← 返回</button>
      <h2>{{ dynastyInfo.name }} 诗词库</h2>
      <p>{{ dynastyInfo.period }} • {{ dynastyInfo.description }}</p>
    </div>

    <!-- 朝代统计信息 -->
    <div class="dynasty-stats-overview">
      <div class="stat-card">
        <div class="stat-icon">📚</div>
        <div class="stat-content">
          <div class="stat-value">{{ dynastyInfo.poem_count }}</div>
          <div class="stat-label">首诗词</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">👨‍🎓</div>
        <div class="stat-content">
          <div class="stat-value">{{ dynastyInfo.poet_count }}</div>
          <div class="stat-label">位诗人</div>
        </div>
      </div>
    </div>

    <!-- 诗人列表 -->
    <div class="section">
      <h3>👨‍🎓 诗人列表</h3>
      <div class="poets-grid">
        <div 
          v-for="poet in poets" 
          :key="poet.id" 
          class="poet-card"
          @click="viewPoetPoems(poet)"
        >
          <div class="poet-avatar">{{ getPoetInitial(poet.name) }}</div>
          <div class="poet-info">
            <h4 class="poet-name">{{ poet.name }}</h4>
            <p class="poet-stats">{{ poet.poem_count }} 首作品</p>
            <p class="poet-description">{{ poet.description || '著名诗人' }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 诗词列表 -->
    <div class="section">
      <h3>📚 诗词作品</h3>
      <div class="poems-list">
        <div 
          v-for="poem in poems" 
          :key="poem.id" 
          class="poem-card"
          @click="viewPoemDetail(poem)"
        >
          <div class="poem-header">
            <h4 class="poem-title">{{ poem.title }}</h4>
            <span class="poem-author">{{ poem.author }}</span>
          </div>
          <div class="poem-content">
            {{ getPoemPreview(poem.content) }}
          </div>
          <div class="poem-footer">
            <span class="poem-type">{{ poem.type }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { StatisticsService } from '../services/statisticsService.js'
import { supabase } from '../supabase.js'

export default {
  name: 'DynastyDetail',
  data() {
    return {
      dynastyInfo: {
        name: '',
        period: '',
        description: '',
        poem_count: 0,
        poet_count: 0
      },
      poets: [],
      poems: []
    }
  },
  methods: {
    async loadDynastyData() {
      const dynastyName = this.$route.query.dynasty
      if (!dynastyName) {
        this.$router.push('/dynasties')
        return
      }

      try {
        // 加载朝代基本信息
        this.dynastyInfo = await this.getDynastyInfo(dynastyName)
        
        // 加载诗人数据
        await this.loadPoets(dynastyName)
        
        // 加载诗词数据
        await this.loadPoems(dynastyName)
      } catch (error) {
        console.error('加载朝代数据失败:', error)
        this.loadFallbackData(dynastyName)
      }
    },

    async getDynastyInfo(dynastyName) {
      try {
        const stats = await StatisticsService.getDynastyStats()
        const dynastyStat = stats.find(s => s.dynasty === dynastyName)
        
        if (dynastyStat) {
          return {
            name: dynastyName,
            period: this.getDynastyPeriod(dynastyName),
            description: this.getDynastyDescription(dynastyName),
            poem_count: dynastyStat.poem_count,
            poet_count: dynastyStat.poet_count
          }
        }
      } catch (error) {
        console.error('获取朝代统计失败:', error)
      }

      // 返回默认信息
      return {
        name: dynastyName,
        period: this.getDynastyPeriod(dynastyName),
        description: this.getDynastyDescription(dynastyName),
        poem_count: this.getDefaultPoemCount(dynastyName),
        poet_count: this.getDefaultPoetCount(dynastyName)
      }
    },

    async loadPoets(dynastyName) {
      try {
        const { data, error } = await supabase
          .from('poets')
          .select('*')
          .eq('dynasty', dynastyName)
          .order('name')

        if (!error && data) {
          // 获取每个诗人的作品数量
          const poetsWithCounts = await Promise.all(
            data.map(async poet => {
              const { data: poems } = await supabase
                .from('poems')
                .select('id')
                .eq('poet_id', poet.id)
              
              return {
                ...poet,
                poem_count: poems ? poems.length : 0
              }
            })
          )
          
          this.poets = poetsWithCounts
        } else {
          this.loadFallbackPoets(dynastyName)
        }
      } catch (error) {
        console.error('加载诗人数据失败:', error)
        this.loadFallbackPoets(dynastyName)
      }
    },

    async loadPoems(dynastyName) {
      try {
        const { data, error } = await supabase
          .from('poems')
          .select(`
            *,
            poets(name)
          `)
          .eq('dynasty', dynastyName)
          .order('title')

        if (!error && data) {
          this.poems = data.map(poem => ({
            ...poem,
            author: poem.poets?.name || '未知'
          }))
        } else {
          this.loadFallbackPoems(dynastyName)
        }
      } catch (error) {
        console.error('加载诗词数据失败:', error)
        this.loadFallbackPoems(dynastyName)
      }
    },

    loadFallbackData(dynastyName) {
      this.dynastyInfo = {
        name: dynastyName,
        period: this.getDynastyPeriod(dynastyName),
        description: this.getDynastyDescription(dynastyName),
        poem_count: this.getDefaultPoemCount(dynastyName),
        poet_count: this.getDefaultPoetCount(dynastyName)
      }
      this.loadFallbackPoets(dynastyName)
      this.loadFallbackPoems(dynastyName)
    },

    loadFallbackPoets(dynastyName) {
      const poetsMap = {
        '唐代': [
          { id: 1, name: '李白', description: '诗仙，浪漫主义诗人代表', poem_count: 45 },
          { id: 2, name: '杜甫', description: '诗圣，现实主义诗人代表', poem_count: 38 },
          { id: 3, name: '白居易', description: '现实主义诗人，作品通俗易懂', poem_count: 32 }
        ],
        '宋代': [
          { id: 4, name: '苏轼', description: '豪放派词人代表', poem_count: 28 },
          { id: 5, name: '李清照', description: '婉约派词人代表', poem_count: 25 },
          { id: 6, name: '辛弃疾', description: '豪放派词人代表', poem_count: 22 }
        ]
      }
      
      this.poets = poetsMap[dynastyName] || [
        { id: 1, name: '著名诗人', description: '该朝代的杰出诗人', poem_count: 20 }
      ]
    },

    loadFallbackPoems(dynastyName) {
      const poemsMap = {
        '唐代': [
          { id: 1, title: '静夜思', author: '李白', content: '床前明月光，疑是地上霜。举头望明月，低头思故乡。', type: '诗' },
          { id: 2, title: '春望', author: '杜甫', content: '国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。', type: '诗' },
          { id: 3, title: '赋得古原草送别', author: '白居易', content: '离离原上草，一岁一枯荣。野火烧不尽，春风吹又生。', type: '诗' }
        ],
        '宋代': [
          { id: 4, title: '水调歌头', author: '苏轼', content: '明月几时有？把酒问青天。不知天上宫阙，今夕是何年。', type: '词' },
          { id: 5, title: '声声慢', author: '李清照', content: '寻寻觅觅，冷冷清清，凄凄惨惨戚戚。乍暖还寒时候，最难将息。', type: '词' },
          { id: 6, title: '青玉案·元夕', author: '辛弃疾', content: '东风夜放花千树，更吹落、星如雨。宝马雕车香满路。', type: '词' }
        ]
      }
      
      this.poems = poemsMap[dynastyName] || [
        { id: 1, title: '经典诗词', author: '著名诗人', content: '这是一首经典的诗词作品。', type: '诗' }
      ]
    },

    getDynastyPeriod(dynastyName) {
      const periods = {
        '唐代': '618-907年',
        '宋代': '960-1279年',
        '元代': '1271-1368年',
        '明代': '1368-1644年',
        '清代': '1644-1912年'
      }
      return periods[dynastyName] || '未知时期'
    },

    getDynastyDescription(dynastyName) {
      const descriptions = {
        '唐代': '唐诗是中国古典诗歌的巅峰，以李白、杜甫为代表',
        '宋代': '宋词婉约豪放并重，苏轼、李清照为杰出代表',
        '元代': '元曲通俗易懂，关汉卿、马致远为重要作家',
        '明代': '明诗继承传统，小说创作繁荣',
        '清代': '清诗题材广泛，纳兰性德、龚自珍为代表'
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
      return counts[dynastyName] || 100
    },

    getDefaultPoetCount(dynastyName) {
      const counts = {
        '唐代': 45,
        '宋代': 38,
        '元代': 12,
        '明代': 18,
        '清代': 15
      }
      return counts[dynastyName] || 10
    },

    getPoetInitial(name) {
      return name ? name.charAt(0) : '?'
    },

    getPoemPreview(content) {
      if (!content) return '内容加载中...'
      const lines = content.split('\n').filter(line => line.trim())
      return lines.slice(0, 2).join('，') + (lines.length > 2 ? '...' : '')
    },

    viewPoetPoems(poet) {
      this.$router.push({
        path: '/poet-detail',
        query: { poet: poet.name, dynasty: this.dynastyInfo.name }
      })
    },

    viewPoemDetail(poem) {
      this.$router.push({
        path: '/poem-detail',
        query: { id: poem.id, title: poem.title }
      })
    }
  },

  async mounted() {
    await this.loadDynastyData()
  },

  watch: {
    '$route.query.dynasty': {
      handler() {
        this.loadDynastyData()
      },
      immediate: true
    }
  }
}
</script>

<style scoped>
.dynasty-detail-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.back-button {
  background: #f8f9fa;
  border: 1px solid #e9ecef;
  border-radius: 5px;
  padding: 0.5rem 1rem;
  cursor: pointer;
  margin-bottom: 1rem;
}

.back-button:hover {
  background: #e9ecef;
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

.dynasty-stats-overview {
  display: flex;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 3rem;
}

.stat-card {
  display: flex;
  align-items: center;
  background: white;
  border-radius: 10px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  min-width: 150px;
}

.stat-icon {
  font-size: 2.5rem;
  margin-right: 1rem;
}

.stat-value {
  font-size: 2rem;
  font-weight: bold;
  color: #2c3e50;
}

.stat-label {
  color: #7f8c8d;
  font-size: 0.9rem;
}

.section {
  margin-bottom: 3rem;
}

.section h3 {
  font-size: 1.5rem;
  color: #2c3e50;
  margin-bottom: 1rem;
  border-left: 4px solid #3498db;
  padding-left: 1rem;
}

.poets-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.poet-card {
  display: flex;
  align-items: center;
  background: white;
  border-radius: 10px;
  padding: 1rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: transform 0.3s ease;
}

.poet-card:hover {
  transform: translateY(-2px);
}

.poet-avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: #3498db;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: bold;
  margin-right: 1rem;
}

.poet-info {
  flex: 1;
}

.poet-name {
  font-size: 1.2rem;
  color: #2c3e50;
  margin-bottom: 0.25rem;
}

.poet-stats {
  color: #e74c3c;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.poet-description {
  color: #7f8c8d;
  font-size: 0.9rem;
  line-height: 1.4;
}

.poems-list {
  display: grid;
  gap: 1rem;
}

.poem-card {
  background: white;
  border-radius: 10px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: transform 0.3s ease;
}

.poem-card:hover {
  transform: translateY(-2px);
}

.poem-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.poem-title {
  font-size: 1.2rem;
  color: #2c3e50;
  margin: 0;
}

.poem-author {
  color: #7f8c8d;
  font-size: 0.9rem;
}

.poem-content {
  color: #5a6c7d;
  line-height: 1.6;
  margin-bottom: 1rem;
  font-style: italic;
}

.poem-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.poem-type {
  background: #ecf0f1;
  color: #7f8c8d;
  padding: 0.25rem 0.5rem;
  border-radius: 3px;
  font-size: 0.8rem;
}



@media (max-width: 768px) {
  .dynasty-stats-overview {
    flex-direction: column;
    align-items: center;
  }
  
  .poets-grid {
    grid-template-columns: 1fr;
  }
}
</style>