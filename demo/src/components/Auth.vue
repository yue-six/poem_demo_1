<template>
  <div class="auth-container">
    <div class="auth-card">
      <h2>{{ isLogin ? '登录' : '注册' }}</h2>
      
      <form @submit.prevent="handleSubmit" class="auth-form">
        <div class="form-group">
          <label for="email">邮箱</label>
          <input
            id="email"
            v-model="form.email"
            type="email"
            required
            placeholder="请输入邮箱地址"
          />
        </div>
        
        <div class="form-group">
          <label for="password">密码</label>
          <input
            id="password"
            v-model="form.password"
            type="password"
            required
            placeholder="请输入密码"
            minlength="6"
          />
        </div>
        
        <div v-if="!isLogin" class="form-group">
          <label for="username">用户名</label>
          <input
            id="username"
            v-model="form.username"
            type="text"
            required
            placeholder="请输入用户名"
          />
        </div>
        
        <button type="submit" class="auth-button" :disabled="loading">
          {{ loading ? '处理中...' : (isLogin ? '登录' : '注册') }}
        </button>
      </form>
      
      <div class="auth-switch">
        <p>
          {{ isLogin ? '还没有账号？' : '已有账号？' }}
          <a href="#" @click.prevent="toggleMode">
            {{ isLogin ? '立即注册' : '立即登录' }}
          </a>
        </p>
      </div>
      
      <div v-if="error" class="error-message">
        {{ error }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '../supabase.js'

const router = useRouter()
const isLogin = ref(true)
const loading = ref(false)
const error = ref('')

const form = reactive({
  email: '',
  password: '',
  username: ''
})

const toggleMode = () => {
  isLogin.value = !isLogin.value
  error.value = ''
  // 重置表单
  Object.keys(form).forEach(key => {
    form[key] = ''
  })
}

const handleSubmit = async () => {
  loading.value = true
  error.value = ''

  try {
    if (isLogin.value) {
      // 登录逻辑
      const { data, error: authError } = await supabase.auth.signInWithPassword({
        email: form.email,
        password: form.password
      })
      
      if (authError) throw authError
      
      // 登录成功，跳转到首页
      router.push('/')
    } else {
      // 注册逻辑
      const { data, error: authError } = await supabase.auth.signUp({
        email: form.email,
        password: form.password,
        options: {
          data: {
            username: form.username
          }
        }
      })
      
      if (authError) throw authError
      
      // 注册成功，提示用户检查邮箱
      alert('注册成功！请检查您的邮箱以验证账户。')
      toggleMode() // 切换到登录模式
    }
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.auth-card {
  background: white;
  padding: 40px;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

.auth-card h2 {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
  font-size: 24px;
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-group label {
  margin-bottom: 5px;
  font-weight: 500;
  color: #555;
}

.form-group input {
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 16px;
  transition: border-color 0.3s;
}

.form-group input:focus {
  outline: none;
  border-color: #667eea;
}

.auth-button {
  padding: 12px;
  background: #667eea;
  color: white;
  border: none;
  border-radius: 5px;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s;
}

.auth-button:hover:not(:disabled) {
  background: #5a6fd8;
}

.auth-button:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.auth-switch {
  text-align: center;
  margin-top: 20px;
}

.auth-switch a {
  color: #667eea;
  text-decoration: none;
}

.auth-switch a:hover {
  text-decoration: underline;
}

.error-message {
  margin-top: 15px;
  padding: 10px;
  background: #fee;
  border: 1px solid #fcc;
  border-radius: 5px;
  color: #c33;
  text-align: center;
}
</style>