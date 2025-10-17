import { createRouter, createWebHistory } from 'vue-router'
import Home from './components/Home.vue'
import Poems from './components/Poems.vue'
import Authors from './components/Authors.vue'
import Dynasties from './components/Dynasties.vue'
import Appreciation from './components/Appreciation.vue'
import DynastyDetail from './components/DynastyDetail.vue'
import Auth from './components/Auth.vue'
import UserProfile from './components/UserProfile.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/poems',
    name: 'Poems',
    component: Poems
  },
  {
    path: '/authors',
    name: 'Authors',
    component: Authors
  },
  {
    path: '/dynasties',
    name: 'Dynasties',
    component: Dynasties
  },
  {
    path: '/appreciation',
    name: 'Appreciation',
    component: Appreciation
  },
  {
    path: '/dynasty-detail',
    name: 'DynastyDetail',
    component: DynastyDetail
  },
  {
    path: '/auth',
    name: 'Auth',
    component: Auth
  },
  {
    path: '/profile',
    name: 'UserProfile',
    component: UserProfile,
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  // 检查路由是否需要认证
  if (to.meta.requiresAuth) {
    const user = JSON.parse(localStorage.getItem('supabase.auth.token'))
    if (!user) {
      // 未登录，跳转到登录页面
      next('/auth')
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router