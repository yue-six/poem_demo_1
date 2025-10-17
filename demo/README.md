# 诗词赏析 Vue 项目

这是一个基于 Vue 3 的诗词赏析应用，集成了 Supabase 后端服务。

## 功能特性

- 📚 诗词浏览和搜索
- 👨‍🎓 诗人信息展示  
- 🔐 Supabase 用户认证
- ⭐ 诗词收藏功能
- 📱 响应式设计

## 技术栈

- **前端**: Vue 3 + Vite
- **后端**: Supabase (认证 + 数据库)
- **部署**: Vercel
- **样式**: CSS3 + 渐变效果

## 快速开始

### 环境要求

- Node.js 16+
- npm 或 yarn

### 安装依赖

```bash
cd demo
npm install
```

### 配置 Supabase

1. 复制 `.env.example` 为 `.env`
2. 在 Supabase 创建项目并获取配置
3. 在 `.env` 中填入你的 Supabase URL 和 anon key

```env
VITE_SUPABASE_URL=你的_supabase_project_url
VITE_SUPABASE_ANON_KEY=你的_supabase_anon_key
```

### 开发模式

```bash
npm run dev
```

### 构建生产版本

```bash
npm run build
```

### 预览构建结果

```bash
npm run preview
```

## 项目结构

```
src/
├── components/          # Vue 组件
│   ├── Auth.vue        # 认证组件
│   ├── Home.vue        # 首页
│   ├── Poems.vue       # 诗词库
│   ├── Authors.vue     # 诗人介绍
│   └── Appreciation.vue # 赏析技巧
├── supabase.js         # Supabase 客户端配置
├── App.vue            # 根组件
├── main.js            # 应用入口
└── style.css          # 全局样式
```

## Supabase 配置

详细配置说明请参考 [SUPABASE_SETUP.md](./SUPABASE_SETUP.md)

### 数据库表

- `authors` - 诗人信息
- `poems` - 诗词内容  
- `favorites` - 用户收藏

### 认证功能

- 用户注册/登录
- 会话管理
- 密码重置

## 部署

### Vercel 部署

1. 将代码推送到 GitHub
2. 在 Vercel 中导入项目
3. 配置环境变量
4. 部署完成

### 环境变量

在 Vercel 中设置以下环境变量：

- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

## 开发说明

### 代码规范

- 使用 Vue 3 Composition API
- 组件采用单文件组件格式
- CSS 使用 scoped 样式
- 遵循语义化命名规范

### 功能模块

1. **认证系统**: 基于 Supabase Auth
2. **数据管理**: 使用 Supabase 实时数据库
3. **UI/UX**: 现代化渐变设计和动画效果
4. **响应式**: 支持移动端和桌面端

## 许可证

MIT License