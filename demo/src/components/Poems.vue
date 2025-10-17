<template>
  <div class="poems-page">
    <div class="page-header">
      <h2>📚 诗词库</h2>
      <p>收录历代经典诗词，涵盖唐诗宋词元曲等</p>
    </div>
    
    <!-- 搜索和筛选 -->
    <div class="filters-section">
      <div class="search-box">
        <input 
          v-model="searchQuery" 
          type="text" 
          placeholder="搜索诗词标题、内容或作者..."
          class="search-input"
        />
        <button @click="searchPoems" class="search-btn">🔍 搜索</button>
      </div>
      
      <div class="filter-options">
        <select v-model="selectedDynasty" @change="filterPoems" class="filter-select">
          <option value="">全部朝代</option>
          <option v-for="dynasty in dynasties" :key="dynasty" :value="dynasty">
            {{ dynasty }}
          </option>
        </select>
        
        <select v-model="selectedType" @change="filterPoems" class="filter-select">
          <option value="">全部类型</option>
          <option value="诗">诗</option>
          <option value="词">词</option>
          <option value="曲">曲</option>
        </select>
      </div>
    </div>
    
    <!-- 诗词列表 -->
    <div class="poems-grid">
      <div 
        v-for="poem in filteredPoems" 
        :key="poem.id" 
        class="poem-card"
        @click="viewPoemDetail(poem)"
      >
        <div class="poem-header">
          <span class="dynasty-badge">{{ poem.dynasty }}</span>
          <span class="type-badge">{{ poem.type }}</span>
        </div>
        <h3 class="poem-title">{{ poem.title }}</h3>
        <p class="poem-author">作者：{{ poem.author }}</p>
        <div class="poem-preview">
          <p v-for="(line, index) in poem.content.slice(0, 2)" :key="index" class="preview-line">
            {{ line }}
          </p>
          <p v-if="poem.content.length > 2" class="more-indicator">...</p>
        </div>

      </div>
    </div>
    
    <!-- 加载状态 -->
    <div v-if="loading" class="loading">
      <p>正在加载诗词...</p>
    </div>
    
    <!-- 空状态 -->
    <div v-if="!loading && filteredPoems.length === 0" class="empty-state">
      <p>暂无诗词数据</p>
    </div>
    
    <!-- 分页 -->
    <div v-if="totalPages > 1" class="pagination">
      <button 
        @click="prevPage" 
        :disabled="currentPage === 1" 
        class="page-btn"
      >
        ← 上一页
      </button>
      <span class="page-info">第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
      <button 
        @click="nextPage" 
        :disabled="currentPage === totalPages" 
        class="page-btn"
      >
        下一页 →
      </button>
    </div>
    
    <!-- 诗词详情弹窗 -->
    <PoemDetail 
      v-if="showPoemDetail && selectedPoem"
      :poem="selectedPoem"
      @close="closePoemDetail"
    />
  </div>
</template>

<script>
import { PoemService } from '../services/poemService.js'
import PoemDetail from './PoemDetail.vue'

export default {
  name: 'Poems',
  components: {
    PoemDetail
  },
  data() {
    return {
      poems: [],
      filteredPoems: [],
      loading: false,
      searchQuery: '',
      selectedDynasty: '',
      selectedType: '',
      dynasties: [],
      currentPage: 1,
      pageSize: 12,
      totalPages: 0,
      selectedPoem: null,
      showPoemDetail: false
    }
  },
  methods: {
    async loadPoems() {
      this.loading = true
      try {
        const poems = await PoemService.getPoems()
        this.poems = poems.map(poem => ({
          ...poem,
          content: poem.content.split('\n').filter(line => line.trim()),
          author: poem.author || poem.poets?.name || '未知',
          dynasty: poem.dynasty || poem.poets?.dynasty || '未知',
          type: poem.type || '诗'
        }))
        
        // 提取朝代列表
        this.dynasties = [...new Set(this.poems.map(p => p.dynasty).filter(Boolean))]
        
        this.filterPoems()
      } catch (error) {
        console.error('加载诗词失败:', error)
        // 使用数据库迁移文件中的实际数据
        this.poems = this.getFallbackPoems()
        this.dynasties = [...new Set(this.poems.map(p => p.dynasty).filter(Boolean))]
        this.filterPoems()
      } finally {
        this.loading = false
      }
    },
    
    getFallbackPoems() {
      return [
        {
          id: 1,
          title: '静夜思',
          content: ['床前明月光', '疑是地上霜', '举头望明月', '低头思故乡'],
          author: '李白',
          dynasty: '唐代',
          type: '诗',

        },
        {
          id: 2,
          title: '春望',
          content: ['国破山河在', '城春草木深', '感时花溅泪', '恨别鸟惊心', '烽火连三月', '家书抵万金', '白头搔更短', '浑欲不胜簪'],
          author: '杜甫',
          dynasty: '唐代',
          type: '诗',

        },
        {
          id: 3,
          title: '水调歌头',
          content: ['明月几时有？把酒问青天。', '不知天上宫阙，今夕是何年。', '我欲乘风归去，又恐琼楼玉宇，高处不胜寒。', '起舞弄清影，何似在人间。'],
          author: '苏轼',
          dynasty: '宋代',
          type: '词',

        },
        {
          id: 4,
          title: '声声慢',
          content: ['寻寻觅觅，冷冷清清，凄凄惨惨戚戚。', '乍暖还寒时候，最难将息。', '三杯两盏淡酒，怎敌他、晚来风急？', '雁过也，正伤心，却是旧时相识。'],
          author: '李清照',
          dynasty: '宋代',
          type: '词',

        },
        {
          id: 5,
          title: '将进酒',
          content: ['君不见黄河之水天上来，奔流到海不复回。', '君不见高堂明镜悲白发，朝如青丝暮成雪。', '人生得意须尽欢，莫使金樽空对月。'],
          author: '李白',
          dynasty: '唐代',
          type: '诗',

        },
        {
          id: 6,
          title: '登高',
          content: ['风急天高猿啸哀，渚清沙白鸟飞回。', '无边落木萧萧下，不尽长江滚滚来。', '万里悲秋常作客，百年多病独登台。', '艰难苦恨繁霜鬓，潦倒新停浊酒杯。'],
          author: '杜甫',
          dynasty: '唐代',
          type: '诗',

        },
        {
          id: 7,
          title: '念奴娇·赤壁怀古',
          content: ['大江东去，浪淘尽，千古风流人物。', '故垒西边，人道是，三国周郎赤壁。', '乱石穿空，惊涛拍岸，卷起千堆雪。', '江山如画，一时多少豪杰。'],
          author: '苏轼',
          dynasty: '宋代',
          type: '词',

        },
        {
          id: 8,
          title: '如梦令',
          content: ['常记溪亭日暮，沉醉不知归路。', '兴尽晚回舟，误入藕花深处。', '争渡，争渡，惊起一滩鸥鹭。'],
          author: '李清照',
          dynasty: '宋代',
          type: '词',

        },
        {
          id: 9,
          title: '琵琶行',
          content: ['浔阳江头夜送客，枫叶荻花秋瑟瑟。', '主人下马客在船，举酒欲饮无管弦。', '醉不成欢惨将别，别时茫茫江浸月。'],
          author: '白居易',
          dynasty: '唐代',
          type: '诗',

        },
        {
          id: 10,
          title: '青玉案·元夕',
          content: ['东风夜放花千树，更吹落、星如雨。', '宝马雕车香满路。凤箫声动，玉壶光转，一夜鱼龙舞。'],
          author: '辛弃疾',
          dynasty: '宋代',
          type: '词',

        }
      ]
    },
    
    filterPoems() {
      let filtered = this.poems
      
      // 搜索过滤
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase()
        filtered = filtered.filter(poem => 
          poem.title.toLowerCase().includes(query) ||
          poem.content.some(line => line.toLowerCase().includes(query)) ||
          poem.author.toLowerCase().includes(query)
        )
      }
      
      // 朝代过滤
      if (this.selectedDynasty) {
        filtered = filtered.filter(poem => poem.dynasty === this.selectedDynasty)
      }
      
      // 类型过滤
      if (this.selectedType) {
        filtered = filtered.filter(poem => poem.type === this.selectedType)
      }
      
      this.filteredPoems = filtered
      this.updatePagination()
    },
    
    searchPoems() {
      this.currentPage = 1
      this.filterPoems()
    },
    
    updatePagination() {
      this.totalPages = Math.ceil(this.filteredPoems.length / this.pageSize)
      const startIndex = (this.currentPage - 1) * this.pageSize
      const endIndex = startIndex + this.pageSize
      this.filteredPoems = this.filteredPoems.slice(startIndex, endIndex)
    },
    
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--
        this.updatePagination()
      }
    },
    
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
        this.updatePagination()
      }
    },
    
    viewPoemDetail(poem) {
      this.selectedPoem = poem
      this.showPoemDetail = true
    },
    
    closePoemDetail() {
      this.showPoemDetail = false
      this.selectedPoem = null
    }
  },
  
  async mounted() {
    await this.loadPoems()
  }
}
</script>

<style scoped>
.poems-page {
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

.filters-section {
  background: white;
  padding: 1.5rem;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  margin-bottom: 2rem;
}

.search-box {
  display: flex;
  gap: 1rem;
  margin-bottom: 1rem;
}

.search-input {
  flex: 1;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 1rem;
}

.search-btn {
  padding: 0.75rem 1.5rem;
  background: #667eea;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background 0.3s ease;
}

.search-btn:hover {
  background: #5a6fd8;
}

.filter-options {
  display: flex;
  gap: 1rem;
}

.filter-select {
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 5px;
  background: white;
}

.poems-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.poem-card {
  background: white;
  border-radius: 10px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.poem-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0,0,0,0.2);
}

.poem-header {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.dynasty-badge, .type-badge {
  padding: 0.2rem 0.5rem;
  border-radius: 15px;
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

.poem-title {
  font-size: 1.2rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.poem-author {
  color: #7f8c8d;
  margin-bottom: 1rem;
}

.poem-preview {
  margin-bottom: 1rem;
}

.preview-line {
  margin: 0.25rem 0;
  color: #555;
  font-size: 0.9rem;
}

.more-indicator {
  color: #999;
  font-style: italic;
}



.loading, .empty-state {
  text-align: center;
  padding: 3rem;
  color: #7f8c8d;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  margin-top: 2rem;
}

.page-btn {
  padding: 0.5rem 1rem;
  border: 1px solid #ddd;
  background: white;
  border-radius: 5px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.page-btn:hover:not(:disabled) {
  background: #667eea;
  color: white;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  color: #7f8c8d;
}

@media (max-width: 768px) {
  .poems-grid {
    grid-template-columns: 1fr;
  }
  
  .filters-section {
    padding: 1rem;
  }
  
  .search-box {
    flex-direction: column;
  }
  
  .filter-options {
    flex-direction: column;
  }
}
</style>