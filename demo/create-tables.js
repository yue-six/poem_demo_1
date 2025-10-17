// 创建数据库表的脚本
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

dotenv.config()

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
)

const createTablesSQL = `
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

ALTER TABLE poets ENABLE ROW LEVEL SECURITY;
ALTER TABLE poems ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "任何人都可以查看诗人" ON poets
  FOR SELECT USING (true);

CREATE POLICY "任何人都可以查看诗词" ON poems
  FOR SELECT USING (true);

CREATE POLICY "用户可以管理自己的收藏" ON user_favorites
  FOR ALL USING (auth.uid() = user_id);
`

async function createTables() {
  console.log('开始创建数据库表...')
  
  try {
    // 使用SQL执行功能创建表
    const { error } = await supabase.rpc('exec_sql', { sql: createTablesSQL })
    
    if (error) {
      console.error('创建表失败:', error)
    } else {
      console.log('数据库表创建成功')
    }
  } catch (error) {
    console.error('执行SQL失败:', error)
  }
}

createTables()