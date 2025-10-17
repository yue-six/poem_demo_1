-- 更新诗词表结构以匹配前端应用需求
-- 添加新的字段和修改现有结构

-- 首先删除现有的示例数据（如果存在）
DELETE FROM poems;
DELETE FROM poets;

-- 修改poems表结构
ALTER TABLE poems 
ADD COLUMN IF NOT EXISTS author TEXT,
ADD COLUMN IF NOT EXISTS dynasty TEXT,
ADD COLUMN IF NOT EXISTS type TEXT,
ADD COLUMN IF NOT EXISTS analysis TEXT,
ADD COLUMN IF NOT EXISTS features TEXT[],
ADD COLUMN IF NOT EXISTS key_points TEXT[],
ADD COLUMN IF NOT EXISTS likes INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS reads INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS comments INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS featured BOOLEAN DEFAULT false;

-- 更新poems表的RLS策略
DROP POLICY IF EXISTS "任何人都可以查看诗词" ON poems;
CREATE POLICY "任何人都可以查看诗词" ON poems
  FOR SELECT USING (true);

CREATE POLICY "任何人都可以更新阅读次数" ON poems
  FOR UPDATE USING (true);

-- 创建likes表来记录用户点赞
CREATE TABLE IF NOT EXISTS poem_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  UNIQUE(poem_id, user_id)
);

ALTER TABLE poem_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "用户可以管理自己的点赞" ON poem_likes
  FOR ALL USING (auth.uid() = user_id);

-- 创建reads表来记录阅读次数
CREATE TABLE IF NOT EXISTS poem_reads (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

ALTER TABLE poem_reads ENABLE ROW LEVEL SECURITY;

CREATE POLICY "任何人都可以记录阅读" ON poem_reads
  FOR INSERT USING (true);