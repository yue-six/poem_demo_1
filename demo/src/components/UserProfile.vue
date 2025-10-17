<template>
  <div class="user-profile-page">
    <div class="profile-header">
      <div class="user-avatar">
        <img v-if="userProfile.avatar_url" :src="userProfile.avatar_url" :alt="userProfile.username">
        <div v-else class="avatar-placeholder">
          {{ getInitials(userProfile.username) }}
        </div>
      </div>
      <div class="user-info">
        <h2>{{ userProfile.username }}</h2>
        <p class="user-bio">{{ userProfile.bio || '这位用户还没有填写个人简介' }}</p>
        <p class="join-date">加入时间：{{ formatDate(userProfile.created_at) }}</p>
      </div>
    </div>

    <!-- 用户统计 -->
    <div class="user-stats">
      <div class="stat-item">
        <div class="stat-value">{{ userStats.total_favorites || 0 }}</div>
        <div class="stat-label">收藏诗词</div>
      </div>
      <div class="stat-item">
        <div class="stat-value">{{ userStats.total_reads || 0 }}</div>
        <div class="stat-label">阅读记录</div>
      </div>
      <div class="stat-item">
        <div class="stat-value">{{ userStats.total_comments || 0 }}</div>
        <div class="stat-label">发表评论</div>
      </div>

    </div>

    <!-- 收藏的诗词 -->
    <div class="section">
      <h3>❤️ 我的收藏</h3>
      <div v-if="favorites.length > 0" class="favorites-list">
        <div 
          v-for="favorite in favorites" 
          :key="favorite.id" 
          class="favorite-item"
          @click="viewPoem(favorite.poem)"
        >
          <h4>{{ favorite.poem.title }}</h4>
          <p class="author">{{ favorite.poem.author }}</p>
          <p class="preview">{{ getPoemPreview(favorite.poem.content) }}</p>
        </div>
      </div>
      <div v-else class="empty-state">
        <p>还没有收藏任何诗词</p>
        <button @click="$router.push('/poems')" class="browse-button">
          去浏览诗词
        </button>
      </div>
    </div>

    <!-- 阅读历史 -->
    <div class="section">
      <h3>📖 阅读历史</h3>
      <div v-if="readingHistory.length > 0" class="history-list">
        <div 
          v-for="history in readingHistory" 
          :key="history.id" 
          class="history-item"
          @click="viewPoem(history.poem)"
        >
          <h4>{{ history.poem.title }}</h4>
          <p class="author">{{ history.poem.author }}</p>
          <p class="read-time">阅读时间：{{ formatTime(history.read_at) }}</p>
        </div>
      </div>
      <div v-else class="empty-state">
        <p>还没有阅读记录</p>
      </div>
    </div>
  </div>
</template>

<script>
import { auth, db } from '../supabase.js'

export default {
  name: 'UserProfile',
  data() {
    return {
      userProfile: {
        username: '',
        avatar_url: '',
        bio: '',
        created_at: ''
      },
      userStats: {},
      favorites: [],
      readingHistory: []
    }
  },
  methods: {
    async loadUserProfile() {
      try {
        const user = await auth.getCurrentUser()
        if (!user) {
          this.$router.push('/auth')
          return
        }

        // 加载用户资料
        await this.loadProfileData(user.id)
        
        // 加载用户统计
        await this.loadUserStats(user.id)
        
        // 加载收藏和阅读历史
        await this.loadUserData(user.id)
        
      } catch (error) {
        console.error('加载用户资料失败:', error)
      }
    },

    async loadProfileData(userId) {
      const { data, error } = await db.getUserProfile(userId)
      if (!error && data) {
        this.userProfile = data
      }
    },

    async loadUserStats(userId) {
      // 这里可以调用统计服务获取用户数据
      // 暂时使用模拟数据
      this.userStats = {
        total_favorites: 12,
        total_reads: 45,
        total_comments: 8
      }
    },

    async loadUserData(userId) {
      // 加载收藏
      const { data: favoritesData } = await db.getFavorites(userId)
      if (favoritesData) {
        this.favorites = favoritesData
      }

      // 加载阅读历史
      const { data: historyData } = await db.getReadingHistory(userId)
      if (historyData) {
        this.readingHistory = historyData
      }
    },

    getInitials(username) {
      return username ? username.charAt(0).toUpperCase() : 'U'
    },

    formatDate(date) {
      if (!date) return '未知'
      return new Date(date).toLocaleDateString('zh-CN')
    },

    formatTime(date) {
      if (!date) return '未知'
      return new Date(date).toLocaleString('zh-CN')
    },

    getPoemPreview(content) {
      if (!content) return '内容加载中...'
      const lines = content.split('\n').filter(line => line.trim())
      return lines.slice(0, 2).join('，') + (lines.length > 2 ? '...' : '')
    },

    viewPoem(poem) {
      this.$router.push({
        path: '/poem-detail',
        query: { id: poem.id }
      })
    }
  },

  async mounted() {
    await this.loadUserProfile()
  }
}
</script>

<style scoped>
.user-profile-page {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.profile-header {
  display: flex;
  align-items: center;
  background: white;
  border-radius: 10px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  margin-bottom: 2rem;
}

.user-avatar {
  margin-right: 2rem;
}

.user-avatar img {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  object-fit: cover;
}

.avatar-placeholder {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background: #667eea;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2rem;
  font-weight: bold;
}

.user-info h2 {
  font-size: 2rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.user-bio {
  color: #7f8c8d;
  font-size: 1.1rem;
  margin-bottom: 0.5rem;
}

.join-date {
  color: #bdc3c7;
  font-size: 0.9rem;
}

.user-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1rem;
  margin-bottom: 2rem;
}

.stat-item {
  background: white;
  border-radius: 10px;
  padding: 1.5rem;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.stat-value {
  font-size: 2rem;
  font-weight: bold;
  color: #667eea;
  margin-bottom: 0.5rem;
}

.stat-label {
  color: #7f8c8d;
  font-size: 0.9rem;
}

.section {
  background: white;
  border-radius: 10px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.section h3 {
  font-size: 1.5rem;
  color: #2c3e50;
  margin-bottom: 1rem;
  border-left: 4px solid #667eea;
  padding-left: 1rem;
}

.favorites-list,
.history-list {
  display: grid;
  gap: 1rem;
}

.favorite-item,
.history-item {
  border: 1px solid #e9ecef;
  border-radius: 5px;
  padding: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.favorite-item:hover,
.history-item:hover {
  border-color: #667eea;
  transform: translateY(-2px);
}

.favorite-item h4,
.history-item h4 {
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.author {
  color: #7f8c8d;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.preview {
  color: #5a6c7d;
  font-style: italic;
  line-height: 1.4;
}

.read-time {
  color: #bdc3c7;
  font-size: 0.8rem;
}

.empty-state {
  text-align: center;
  padding: 2rem;
  color: #7f8c8d;
}

.browse-button {
  background: #667eea;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 0.5rem 1rem;
  cursor: pointer;
  margin-top: 1rem;
}

.browse-button:hover {
  background: #5a6fd8;
}

@media (max-width: 768px) {
  .profile-header {
    flex-direction: column;
    text-align: center;
  }
  
  .user-avatar {
    margin-right: 0;
    margin-bottom: 1rem;
  }
  
  .user-stats {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>