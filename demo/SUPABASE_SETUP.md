# Supabase 配置说明

## 1. 创建 Supabase 项目

1. 访问 [Supabase](https://supabase.com) 并注册账号
2. 创建新项目
3. 获取项目 URL 和 anon key

## 2. 配置环境变量

复制 `.env.example` 为 `.env` 并填入你的 Supabase 配置：

```env
VITE_SUPABASE_URL=你的_supabase_project_url
VITE_SUPABASE_ANON_KEY=你的_supabase_anon_key
```

## 3. 数据库表结构

在 Supabase SQL 编辑器中执行以下 SQL 创建表：

### authors 表（诗人信息）
```sql
CREATE TABLE authors (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  dynasty TEXT NOT NULL,
  lifespan TEXT,
  title TEXT,
  description TEXT,
  style TEXT,
  achievements TEXT,
  tags TEXT[],
  poem_count INTEGER DEFAULT 0,
  popularity INTEGER DEFAULT 0,
  followers INTEGER DEFAULT 0,
  featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);
```

### poems 表（诗词信息）
```sql
CREATE TABLE poems (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  author_id UUID REFERENCES authors(id) ON DELETE CASCADE,
  dynasty TEXT,
  tags TEXT[],
  analysis TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);
```

### favorites 表（用户收藏）
```sql
CREATE TABLE favorites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
  UNIQUE(user_id, poem_id)
);
```

## 4. 启用 RLS（行级安全）

为每个表启用行级安全并设置策略：

### authors 表策略
```sql
ALTER TABLE authors ENABLE ROW LEVEL SECURITY;

-- 允许所有人读取诗人信息
CREATE POLICY "任何人都可以查看诗人信息" ON authors
  FOR SELECT USING (true);
```

### poems 表策略
```sql
ALTER TABLE poems ENABLE ROW LEVEL SECURITY;

-- 允许所有人读取诗词信息
CREATE POLICY "任何人都可以查看诗词" ON poems
  FOR SELECT USING (true);
```

### favorites 表策略
```sql
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- 用户只能查看自己的收藏
CREATE POLICY "用户只能查看自己的收藏" ON favorites
  FOR SELECT USING (auth.uid() = user_id);

-- 用户只能添加自己的收藏
CREATE POLICY "用户只能添加自己的收藏" ON favorites
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 用户只能删除自己的收藏
CREATE POLICY "用户只能删除自己的收藏" ON favorites
  FOR DELETE USING (auth.uid() = user_id);
```

## 5. 插入示例数据

插入一些示例诗人数据：

```sql
-- 插入诗人数据
INSERT INTO authors (name, dynasty, lifespan, title, description, style, tags, poem_count, popularity, followers, featured) VALUES
('李白', '唐代', '701年-762年', '诗仙', '唐代伟大的浪漫主义诗人', '豪放飘逸，想象丰富，意境奇妙', ARRAY['浪漫主义', '豪放派'], 1000, 95, 5000, true),
('杜甫', '唐代', '712年-770年', '诗圣', '唐代伟大的现实主义诗人', '沉郁顿挫，语言精炼，格律严谨', ARRAY['现实主义', '社会派'], 1400, 92, 4500, true),
('苏轼', '宋代', '1037年-1101年', '东坡居士', '北宋文学家、书画家', '豪放洒脱，题材广阔，清新豪健', ARRAY['豪放派', '文学家'], 2700, 88, 3000, true);

-- 插入诗词数据
INSERT INTO poems (title, content, author_id, dynasty, tags) VALUES
('静夜思', '床前明月光，疑是地上霜。举头望明月，低头思故乡。', (SELECT id FROM authors WHERE name = '李白'), '唐代', ARRAY['思乡', '月亮']),
('春望', '国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。', (SELECT id FROM authors WHERE name = '杜甫'), '唐代', ARRAY['爱国', '春天']);
```

## 6. 部署说明

1. 在 Vercel 环境变量中设置 Supabase 配置
2. 确保构建时能读取环境变量
3. 测试认证功能是否正常工作

## 7. 故障排除

- 检查环境变量是否正确设置
- 确认 Supabase 项目 URL 和密钥正确
- 验证数据库表结构和 RLS 策略
- 检查浏览器控制台是否有错误信息