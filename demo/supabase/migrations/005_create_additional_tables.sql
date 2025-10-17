-- 创建赏析技巧表
CREATE TABLE IF NOT EXISTS appreciation_techniques (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50) NOT NULL,
    difficulty_level VARCHAR(20) DEFAULT '初级',
    example_poem_id INTEGER REFERENCES poems(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- 创建练习题目表
CREATE TABLE IF NOT EXISTS practice_exercises (
    id SERIAL PRIMARY KEY,
    poem_id INTEGER REFERENCES poems(id),
    question TEXT NOT NULL,
    options JSONB,
    correct_answer TEXT NOT NULL,
    explanation TEXT,
    difficulty VARCHAR(20) DEFAULT '初级',
    created_at TIMESTAMP DEFAULT NOW()
);

-- 创建练习尝试记录表
CREATE TABLE IF NOT EXISTS exercise_attempts (
    id SERIAL PRIMARY KEY,
    exercise_id INTEGER REFERENCES practice_exercises(id),
    user_id UUID REFERENCES auth.users(id),
    user_answer TEXT,
    is_correct BOOLEAN,
    submitted_at TIMESTAMP DEFAULT NOW()
);

-- 创建朝代信息表
CREATE TABLE IF NOT EXISTS dynasties (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    period VARCHAR(100),
    capital VARCHAR(100),
    notable_poets TEXT,
    characteristics TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 插入朝代数据
INSERT INTO dynasties (name, period, capital, notable_poets, characteristics) VALUES
('唐代', '618年-907年', '长安（今西安）', '李白、杜甫、白居易、王维、孟浩然', '唐诗达到鼎盛，分为初唐、盛唐、中唐、晚唐四个时期，风格多样，题材广泛'),
('宋代', '960年-1279年', '汴京（今开封）、临安（今杭州）', '苏轼、李清照、辛弃疾、陆游、王安石', '宋词繁荣，分为北宋和南宋，婉约派与豪放派并立'),
('元代', '1271年-1368年', '大都（今北京）', '关汉卿、马致远、白朴、郑光祖', '元曲兴起，杂剧盛行，诗词相对衰落'),
('明代', '1368年-1644年', '南京、北京', '唐寅、文征明、徐渭、汤显祖', '小说繁荣，诗词创作相对保守，注重格律'),
('清代', '1644年-1912年', '北京', '纳兰性德、曹雪芹、郑板桥、袁枚', '诗词创作复兴，出现性灵派，小说达到高峰')
ON CONFLICT (name) DO NOTHING;

-- 插入赏析技巧数据
INSERT INTO appreciation_techniques (name, description, category, difficulty_level, example_poem_id) VALUES
('意象分析', '分析诗词中的意象元素，理解其象征意义和情感表达', '分析方法', '初级', 
 (SELECT id FROM poems WHERE title = '静夜思')),
('韵律节奏', '分析诗词的平仄、押韵和节奏变化，体会音乐美感', '形式分析', '初级', 
 (SELECT id FROM poems WHERE title = '春望')),
('情感把握', '理解诗词表达的情感基调和发展变化', '情感分析', '中级', 
 (SELECT id FROM poems WHERE title = '声声慢')),
('典故解读', '分析诗词中使用的典故及其文化内涵', '文化分析', '高级', 
 (SELECT id FROM poems WHERE title = '念奴娇·赤壁怀古')),
('结构分析', '分析诗词的篇章结构和逻辑关系', '形式分析', '中级', 
 (SELECT id FROM poems WHERE title = '琵琶行')),
('语言特色', '分析诗词的语言风格和修辞手法', '语言分析', '初级', 
 (SELECT id FROM poems WHERE title = '如梦令'))
ON CONFLICT (name) DO NOTHING;

-- 插入练习题目数据
INSERT INTO practice_exercises (poem_id, question, options, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM poems WHERE title = '静夜思'), 
 '《静夜思》中"床前明月光"的"床"指的是什么？',
 '["睡觉的床", "井边的围栏", "窗户", "桌子"]'::jsonb,
 '井边的围栏',
 '在古代，"床"有时指井边的围栏，这首诗描写的是庭院中的景象。',
 '初级'),

((SELECT id FROM poems WHERE title = '春望'), 
 '《春望》表达了诗人怎样的情感？',
 '["喜悦之情", "忧国忧民", "思乡之情", "闲适自在"]'::jsonb,
 '忧国忧民',
 '这首诗写于安史之乱期间，表达了诗人对国家命运的担忧和对人民疾苦的同情。',
 '中级'),

((SELECT id FROM poems WHERE title = '声声慢'), 
 '李清照《声声慢》开头的叠字有什么作用？',
 '["增强节奏感", "表达强烈情感", "营造凄凉氛围", "展示语言技巧"]'::jsonb,
 '营造凄凉氛围',
 '七组叠字层层递进，生动地表现了词人孤独寂寞、凄苦无依的心境。',
 '高级')
ON CONFLICT (poem_id, question) DO NOTHING;