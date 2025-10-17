import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig(({ mode }) => {
  // 加载环境变量
  const env = loadEnv(mode, process.cwd(), '')
  
  return {
    plugins: [vue()],
    server: {
      port: 3000,
      open: true
    },
    base: './',
    build: {
      outDir: 'dist',
      assetsDir: 'assets'
    },
    define: {
      // 确保环境变量在构建时可用
      'process.env': env
    }
  }
})