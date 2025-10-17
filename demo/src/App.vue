<template>
  <div id="app">
    <header class="app-header poetic-border">
      <div class="header-content">
        <div class="header-top">
          <h1 class="fade-in-up">{{ appTitle }}</h1>
        </div>
        <p class="subtitle">传承千年文化，品味诗词之美</p>
        <nav class="nav-menu">
          <router-link 
            v-for="tab in tabs" 
            :key="tab.id"
            :to="tab.path"
            :class="{ active: $route.path === tab.path }"
            class="nav-btn float"
          >
            <span class="nav-icon">{{ tab.icon }}</span>
            {{ tab.name }}
          </router-link>
        </nav>
      </div>
    </header>

    <main class="app-main">
      <router-view></router-view>
    </main>

    <footer class="app-footer">
      <div class="footer-content">
        <p>&copy; 2025 诗词赏析 · 构建时间: {{ buildTime }}</p>
        <div class="footer-links">
          <router-link 
            v-for="tab in tabs" 
            :key="tab.id"
            :to="tab.path"
            class="footer-link"
          >
            {{ tab.name }}
          </router-link>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
import Home from './components/Home.vue'
import Poems from './components/Poems.vue'
import Authors from './components/Authors.vue'
import Appreciation from './components/Appreciation.vue'

export default {
  name: 'App',
  components: {
    Home,
    Poems,
    Authors,
    Appreciation
  },
  data() {
    return {
      appTitle: '诗词赏析',
      activeTab: 'home',
      buildTime: new Date().toLocaleString('zh-CN'),
      tabs: [
        { id: 'home', name: '首页', path: '/', component: 'Home', icon: '🏠' },
        { id: 'poems', name: '诗词库', path: '/poems', component: 'Poems', icon: '📖' },
        { id: 'dynasties', name: '朝代诗词', path: '/dynasties', component: 'Dynasties', icon: '🏛️' },
        { id: 'appreciation', name: '赏析技巧', path: '/appreciation', component: 'Appreciation', icon: '🔍' }
      ]
    }
  },
  methods: {
    switchTab(tabId) {
      const tab = this.tabs.find(t => t.id === tabId)
      if (tab) {
        this.$router.push(tab.path)
      }
      // 平滑滚动到顶部
      window.scrollTo({ top: 0, behavior: 'smooth' })
    },
    handleSearchPoem(poemTitle) {
      this.activeTab = 'poems'
      // 这里可以添加搜索功能，在实际应用中会传递搜索参数
      setTimeout(() => {
        // 模拟搜索效果
        const searchInput = document.querySelector('.search-box input')
        if (searchInput) {
          searchInput.value = poemTitle
          searchInput.focus()
        }
      }, 100)
    }
  }
}
</script>

<style scoped>
#app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.app-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 2rem 0;
  box-shadow: 0 4px 20px rgba(0,0,0,0.1);
  position: relative;
  overflow: hidden;
}

.app-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text x="50%" y="50%" font-family="serif" font-size="12" fill="rgba(255,255,255,0.05)" text-anchor="middle" dominant-baseline="middle">诗</text></svg>');
  opacity: 0.3;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.header-top {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 1rem;
}

.app-header h1 {
  margin: 0 0 0.5rem 0;
  font-size: 3rem;
  font-weight: 700;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}

.subtitle {
  font-size: 1.2rem;
  opacity: 0.9;
  margin-bottom: 2rem;
  font-style: italic;
  text-align: center;
}

.nav-menu {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.nav-btn {
  background: rgba(255,255,255,0.15);
  border: 2px solid rgba(255,255,255,0.3);
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 50px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1rem;
  backdrop-filter: blur(10px);
}

.nav-btn:hover {
  background: rgba(255,255,255,0.25);
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0,0,0,0.2);
}

.nav-btn.active {
  background: white;
  color: #667eea;
  border-color: white;
}

.nav-icon {
  font-size: 1.2rem;
}

.app-main {
  flex: 1;
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

/* 页面切换动画 */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.5s ease, transform 0.5s ease;
}

.fade-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.app-footer {
  background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
  color: #ecf0f1;
  padding: 2rem 0;
  border-top: 1px solid rgba(255,255,255,0.1);
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  text-align: center;
}

.footer-links {
  margin-top: 1rem;
  display: flex;
  justify-content: center;
  gap: 2rem;
  flex-wrap: wrap;
}

.footer-link {
  cursor: pointer;
  transition: color 0.3s ease;
  opacity: 0.8;
}

.footer-link:hover {
  color: #667eea;
  opacity: 1;
}

@media (max-width: 768px) {
  .app-header h1 {
    font-size: 2rem;
  }
  
  .nav-menu {
    gap: 0.5rem;
  }
  
  .nav-btn {
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
  }
}
</style>