-- 创建用户认证相关的数据库表结构

-- 创建用户资料表（扩展Supabase Auth的用户信息）
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  username VARCHAR(50) UNIQUE NOT NULL,
  avatar_url TEXT,
  bio TEXT,
  favorite_poems_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (id)
);

-- 创建收藏表
CREATE TABLE IF NOT EXISTS favorites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, poem_id)
);

-- 创建阅读历史表
CREATE TABLE IF NOT EXISTS reading_history (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  read_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  read_count INTEGER DEFAULT 1
);

-- 创建评论表
CREATE TABLE IF NOT EXISTS comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  likes INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建点赞表
CREATE TABLE IF NOT EXISTS poem_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, poem_id)
);

-- 创建评论点赞表
CREATE TABLE IF NOT EXISTS comment_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, comment_id)
);

-- 启用RLS（行级安全策略）
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE reading_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE poem_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE comment_likes ENABLE ROW LEVEL SECURITY;

-- 用户资料表RLS策略
CREATE POLICY "用户可以查看所有用户资料" ON user_profiles
  FOR SELECT USING (true);

CREATE POLICY "用户可以更新自己的资料" ON user_profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "用户可以插入自己的资料" ON user_profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- 收藏表RLS策略
CREATE POLICY "用户可以查看自己的收藏" ON favorites
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "用户可以管理自己的收藏" ON favorites
  FOR ALL USING (auth.uid() = user_id);

-- 阅读历史表RLS策略
CREATE POLICY "用户可以查看自己的阅读历史" ON reading_history
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "用户可以管理自己的阅读历史" ON reading_history
  FOR ALL USING (auth.uid() = user_id);

-- 评论表RLS策略
CREATE POLICY "任何人都可以查看评论" ON comments
  FOR SELECT USING (true);

CREATE POLICY "认证用户可以发表评论" ON comments
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "用户可以更新自己的评论" ON comments
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "用户可以删除自己的评论" ON comments
  FOR DELETE USING (auth.uid() = user_id);

-- 诗词点赞表RLS策略
CREATE POLICY "任何人都可以查看点赞" ON poem_likes
  FOR SELECT USING (true);

CREATE POLICY "认证用户可以点赞" ON poem_likes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "用户可以取消自己的点赞" ON poem_likes
  FOR DELETE USING (auth.uid() = user_id);

-- 评论点赞表RLS策略
CREATE POLICY "任何人都可以查看评论点赞" ON comment_likes
  FOR SELECT USING (true);

CREATE POLICY "认证用户可以点赞评论" ON comment_likes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "用户可以取消自己的评论点赞" ON comment_likes
  FOR DELETE USING (auth.uid() = user_id);

-- 创建触发器自动更新updated_at字段
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_profiles_updated_at 
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at 
  BEFORE UPDATE ON comments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 创建触发器自动创建用户资料
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, username, avatar_url, bio)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1)),
    NEW.raw_user_meta_data->>'avatar_url',
    NEW.raw_user_meta_data->>'bio'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 创建视图用于用户统计
CREATE OR REPLACE VIEW user_stats AS
SELECT 
  up.id,
  up.username,
  up.avatar_url,
  COUNT(DISTINCT f.id) as total_favorites,
  COUNT(DISTINCT rh.id) as total_reads,
  COUNT(DISTINCT c.id) as total_comments,
  COUNT(DISTINCT pl.id) as total_likes_given
FROM user_profiles up
LEFT JOIN favorites f ON up.id = f.user_id
LEFT JOIN reading_history rh ON up.id = rh.user_id
LEFT JOIN comments c ON up.id = c.user_id
LEFT JOIN poem_likes pl ON up.id = pl.user_id
GROUP BY up.id, up.username, up.avatar_url;

-- 为RLS策略创建索引以提高性能
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_poem_id ON favorites(poem_id);
CREATE INDEX IF NOT EXISTS idx_reading_history_user_id ON reading_history(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON comments(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_poem_id ON comments(poem_id);
CREATE INDEX IF NOT EXISTS idx_poem_likes_user_id ON poem_likes(user_id);
CREATE INDEX IF NOT EXISTS idx_poem_likes_poem_id ON poem_likes(poem_id);
CREATE INDEX IF NOT EXISTS idx_comment_likes_user_id ON comment_likes(user_id);
CREATE INDEX IF NOT EXISTS idx_comment_likes_comment_id ON comment_likes(comment_id);

-- 插入一些示例用户数据（用于测试）
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at) VALUES
  (
    '11111111-1111-1111-1111-111111111111',
    'test@example.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW()
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'user@example.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW()
  );

INSERT INTO user_profiles (id, username, avatar_url, bio) VALUES
  (
    '11111111-1111-1111-1111-111111111111',
    '诗词爱好者',
    'https://example.com/avatar1.jpg',
    '热爱古典诗词，尤其喜欢唐诗宋词'
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    '文学研究者',
    'https://example.com/avatar2.jpg',
    '专注于中国古代文学研究'
  );