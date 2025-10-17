import { createClient } from '@supabase/supabase-js'

// Supabase 配置 - 直接使用环境变量值
const supabaseUrl = 'https://brryzwnhlueiojnoackt.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJycnl6d25obHVlaW9qbm9hY2t0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1MDk3OTMsImV4cCI6MjA3NjA4NTc5M30.-DA-Z5UvXpEss_K-nO-rN-TZQ_6p7iGkfBjqgxAg28w'

// 创建 Supabase 客户端（添加重试和超时配置）
console.log('Supabase配置检查:')
console.log('URL:', supabaseUrl)
console.log('Key:', supabaseAnonKey ? '已配置' : '未配置')

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
    flowType: 'pkce'
  },
  global: {
    headers: {
      'Content-Type': 'application/json',
      'apikey': supabaseAnonKey
    }
  },
  db: {
    schema: 'public'
  },
  realtime: {
    params: {
      eventsPerSecond: 10
    }
  }
})

// 认证相关函数
export const auth = {
  // 用户登录
  async signIn(email, password) {
    try {
      console.log('尝试登录:', email)
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      })
      
      if (error) {
        console.error('登录错误:', error)
      } else {
        console.log('登录成功:', data)
      }
      
      return { data, error }
    } catch (error) {
      console.error('登录异常:', error)
      return { data: null, error }
    }
  },

  // 用户注册
  async signUp(email, password, username, bio = '') {
    try {
      console.log('尝试注册:', email, username)
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            username: username,
            bio: bio
          },
          emailRedirectTo: window.location.origin
        }
      })
      
      if (error) {
        console.error('注册错误:', error)
      } else {
        console.log('注册成功:', data)
      }
      
      // 如果注册成功，尝试立即确认用户（绕过邮箱验证）
      if (data?.user && !error) {
        try {
          console.log('尝试自动登录激活账户')
          const { data: loginData, error: loginError } = await supabase.auth.signInWithPassword({
            email,
            password
          })
          
          if (loginError) {
            console.log('自动登录失败:', loginError)
          } else {
            console.log('自动登录成功:', loginData)
          }
        } catch (loginError) {
          console.log('自动激活账户失败，需要手动登录')
        }
      }
      
      return { data, error }
    } catch (error) {
      console.error('注册异常:', error)
      return { data: null, error }
    }
  },

  // 用户退出
  async signOut() {
    const { error } = await supabase.auth.signOut()
    return { error }
  },

  // 获取当前用户
  async getCurrentUser() {
    const { data: { user } } = await supabase.auth.getUser()
    return user
  },

  // 监听认证状态变化
  onAuthStateChange(callback) {
    return supabase.auth.onAuthStateChange((event, session) => {
      callback(event, session)
    })
  }
}

// 数据库操作函数
export const db = {
  // 获取诗人列表
  async getAuthors() {
    const { data, error } = await supabase
      .from('authors')
      .select('*')
      .order('name')
    return { data, error }
  },

  // 获取诗词列表
  async getPoems(authorId = null) {
    let query = supabase
      .from('poems')
      .select(`
        *,
        authors(name)
      `)
      .order('title')

    if (authorId) {
      query = query.eq('author_id', authorId)
    }

    const { data, error } = await query
    return { data, error }
  },

  // 添加收藏
  async addFavorite(poemId, userId) {
    const { data, error } = await supabase
      .from('favorites')
      .insert({
        poem_id: poemId,
        user_id: userId
      })
    return { data, error }
  },

  // 获取用户资料
  async getUserProfile(userId) {
    const { data, error } = await supabase
      .from('user_profiles')
      .select('*')
      .eq('id', userId)
      .single()
    return { data, error }
  },

  // 获取用户收藏
  async getFavorites(userId) {
    const { data, error } = await supabase
      .from('favorites')
      .select(`
        id,
        poems(*, poets(name))
      `)
      .eq('user_id', userId)
    return { data, error }
  },

  // 获取阅读历史
  async getReadingHistory(userId) {
    const { data, error } = await supabase
      .from('reading_history')
      .select(`
        id,
        read_at,
        poems(*, poets(name))
      `)
      .eq('user_id', userId)
      .order('read_at', { ascending: false })
      .limit(10)
    return { data, error }
  },

  // 添加收藏
  async addFavorite(userId, poemId) {
    const { data, error } = await supabase
      .from('favorites')
      .insert({
        user_id: userId,
        poem_id: poemId
      })
    return { data, error }
  },

  // 移除收藏
  async removeFavorite(userId, poemId) {
    const { data, error } = await supabase
      .from('favorites')
      .delete()
      .eq('user_id', userId)
      .eq('poem_id', poemId)
    return { data, error }
  },

  // 添加阅读记录
  async addReadingHistory(userId, poemId) {
    const { data, error } = await supabase
      .from('reading_history')
      .insert({
        user_id: userId,
        poem_id: poemId
      })
    return { data, error }
  }
}

export default supabase