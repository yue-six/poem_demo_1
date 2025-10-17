-- 创建实战练习相关的数据库表

-- 1. 创建练习题目表
CREATE TABLE IF NOT EXISTS practice_exercises (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL CHECK (type IN ('choice', 'fill', 'essay')),
    difficulty VARCHAR(20) NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
    content TEXT NOT NULL,
    options JSONB, -- 选择题选项
    correct_answer TEXT,
    explanation TEXT,
    poem_id BIGINT, -- 关联的诗词ID
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 创建练习尝试记录表
CREATE TABLE IF NOT EXISTS exercise_attempts (
    id BIGSERIAL PRIMARY KEY,
    exercise_id BIGINT NOT NULL REFERENCES practice_exercises(id),
    user_id UUID REFERENCES auth.users(id),
    user_answer TEXT NOT NULL,
    is_correct BOOLEAN,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 创建赏析技巧表
CREATE TABLE IF NOT EXISTS appreciation_techniques (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100) NOT NULL,
    difficulty_level INTEGER DEFAULT 1,
    content TEXT,
    examples JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 插入示例练习题目
INSERT INTO practice_exercises (title, description, type, difficulty, content, options, correct_answer, explanation) VALUES
(
    '意象识别练习 - 月光意象',
    '识别诗词中的月光意象及其象征意义',
    'choice',
    'easy',
    '李白的《静夜思》中，"床前明月光"一句主要运用了哪种意象？',
    '["月光意象", "山水意象", "花鸟意象", "人物意象"]',
    '月光意象',
    '月光意象在诗中营造了宁静、思乡的氛围，象征着游子对故乡的思念之情。'
),
(
    '韵律分析练习 - 韵脚识别',
    '分析诗词的韵律结构和节奏特点',
    'fill',
    'medium',
    '请填写杜甫《春望》的韵脚：国破山河在，城春草木___。',
    NULL,
    '深',
    '这首诗采用平水韵，"深"字与后文的押韵相呼应，体现了诗歌的音乐美。'
),
(
    '修辞手法练习 - 比喻识别',
    '识别并分析诗词中的修辞手法',
    'choice',
    'medium',
    '李商隐《无题》中"春蚕到死丝方尽，蜡炬成灰泪始干"运用了哪种修辞手法？',
    '["比喻", "拟人", "夸张", "对偶"]',
    '比喻',
    '这里用春蚕吐丝比喻爱情的执着，用蜡烛燃烧比喻奉献精神。'
),
(
    '意境赏析练习 - 情景交融',
    '深入理解诗词的意境和情感表达',
    'essay',
    'hard',
    '请分析王维《山居秋暝》中"明月松间照，清泉石上流"所营造的意境。',
    NULL,
    '这两句诗通过明月、松林、清泉、石头的意象组合，营造出宁静幽美的山水意境，体现了诗人超脱尘世、向往自然的情怀。',
    '诗人运用视觉和听觉的描写，创造出动静结合、情景交融的艺术境界。'
);

-- 5. 插入赏析技巧数据
INSERT INTO appreciation_techniques (title, description, category, difficulty_level, content, examples) VALUES
(
    '意象分析',
    '分析诗词中的意象运用，理解作者的创作意图和情感表达',
    '基础技巧',
    1,
    '意象是诗词中通过具体物象表达抽象情感的艺术手法。常见的意象包括自然景物、动物植物、器物建筑等。',
    '["月光意象象征思乡", "柳树意象象征离别", "梅花意象象征高洁"]'
),
(
    '韵律节奏',
    '把握诗词的韵律美和节奏感，体会音乐性的艺术效果',
    '进阶技巧',
    2,
    '韵律包括平仄、押韵、对仗等要素，节奏体现在诗句的长短、停顿和重音上。',
    '["五言绝句的节奏特点", "七言律诗的押韵规律", "词牌的音乐性"]'
),
(
    '修辞手法',
    '识别比喻、拟人、夸张等修辞手法，理解艺术表现力',
    '基础技巧',
    1,
    '修辞手法是增强诗词表现力的重要手段，包括比喻、拟人、夸张、对偶、排比等。',
    '["比喻使抽象变具体", "拟人赋予物象生命", "夸张强化情感表达"]'
),
(
    '意境营造',
    '感受诗词营造的意境氛围，体会情景交融的艺术境界',
    '高级技巧',
    3,
    '意境是诗词通过意象组合所创造的整体艺术氛围，体现情景交融、虚实相生的美学特征。',
    '["山水诗的清幽意境", "边塞诗的雄浑意境", "婉约词的细腻意境"]'
);

-- 6. 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_practice_exercises_difficulty ON practice_exercises(difficulty);
CREATE INDEX IF NOT EXISTS idx_practice_exercises_type ON practice_exercises(type);
CREATE INDEX IF NOT EXISTS idx_exercise_attempts_user_id ON exercise_attempts(user_id);
CREATE INDEX IF NOT EXISTS idx_exercise_attempts_exercise_id ON exercise_attempts(exercise_id);
CREATE INDEX IF NOT EXISTS idx_appreciation_techniques_category ON appreciation_techniques(category);

-- 7. 启用行级安全策略（RLS）
ALTER TABLE practice_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercise_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE appreciation_techniques ENABLE ROW LEVEL SECURITY;

-- 8. 创建RLS策略
-- 练习题目对所有用户可见
CREATE POLICY "练习题目对所有用户可见" ON practice_exercises FOR SELECT USING (true);

-- 用户只能查看自己的练习记录
CREATE POLICY "用户只能查看自己的练习记录" ON exercise_attempts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "用户可以插入自己的练习记录" ON exercise_attempts FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 赏析技巧对所有用户可见
CREATE POLICY "赏析技巧对所有用户可见" ON appreciation_techniques FOR SELECT USING (true);

-- 9. 添加更新时间触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_practice_exercises_updated_at 
    BEFORE UPDATE ON practice_exercises 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();