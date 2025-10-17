-- 创建诗词相关表结构
CREATE TABLE IF NOT EXISTS poets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  dynasty TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

CREATE TABLE IF NOT EXISTS poems (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  poet_id UUID REFERENCES poets(id) ON DELETE CASCADE,
  translation TEXT,
  appreciation TEXT,
  tags TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

CREATE TABLE IF NOT EXISTS user_favorites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  UNIQUE(user_id, poem_id)
);

-- 启用 RLS（行级安全策略）
ALTER TABLE poets ENABLE ROW LEVEL SECURITY;
ALTER TABLE poems ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;

-- 创建策略：所有人都可以读取诗人和诗词
CREATE POLICY "任何人都可以查看诗人" ON poets
  FOR SELECT USING (true);

CREATE POLICY "任何人都可以查看诗词" ON poems
  FOR SELECT USING (true);

-- 只有认证用户可以管理收藏
CREATE POLICY "用户可以管理自己的收藏" ON user_favorites
  FOR ALL USING (auth.uid() = user_id);

-- 插入示例数据
INSERT INTO poets (name, dynasty, description) VALUES
  ('李白', '唐代', '诗仙，浪漫主义诗人代表'),
  ('杜甫', '唐代', '诗圣，现实主义诗人代表'),
  ('苏轼', '宋代', '文学家、书法家、画家');

INSERT INTO poems (title, content, poet_id, translation, appreciation, tags) VALUES
  ('静夜思', '床前明月光，疑是地上霜。举头望明月，低头思故乡。', 
   (SELECT id FROM poets WHERE name = '李白'),
   'Bright moonlight before my bed, Seems frost on the ground. Lifting my head, I gaze at the moon; Lowering it, I think of home.',
   '这首诗表达了游子思乡之情，语言简练，意境深远。',
   ARRAY['思乡', '月亮', '夜晚']),
  
  ('春望', '国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。', 
   (SELECT id FROM poets WHERE name = '杜甫'),
   'The state is destroyed, but mountains and rivers remain; In spring the city has lush grass and trees. Moved by the times, flowers bring tears; Hating separation, birds startle the heart.',
   '杜甫在安史之乱期间所作，表达了对国家命运的忧虑。',
   ARRAY['爱国', '春天', '忧国']);