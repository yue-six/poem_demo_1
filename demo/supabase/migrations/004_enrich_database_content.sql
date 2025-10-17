-- 丰富数据库内容，为每个板块添加更多数据
-- 1. 添加更多诗人数据
INSERT INTO poets (name, dynasty, description) VALUES
('李白', '唐代', '诗仙，唐代伟大的浪漫主义诗人，代表作有《静夜思》、《将进酒》等'),
('杜甫', '唐代', '诗圣，唐代伟大的现实主义诗人，代表作有《春望》、《登高》等'),
('苏轼', '宋代', '东坡居士，宋代文学家、书画家，代表作有《水调歌头》、《念奴娇·赤壁怀古》等'),
('李清照', '宋代', '易安居士，宋代著名女词人，婉约派代表，代表作有《声声慢》、《如梦令》等'),
('白居易', '唐代', '乐天，唐代现实主义诗人，代表作有《琵琶行》、《长恨歌》等'),
('王维', '唐代', '摩诘，唐代山水田园诗人，诗中有画，画中有诗'),
('辛弃疾', '宋代', '稼轩，宋代豪放派词人，代表作有《青玉案·元夕》、《破阵子》等'),
('陆游', '宋代', '放翁，宋代爱国诗人，代表作有《钗头凤》、《示儿》等'),
('孟浩然', '唐代', '唐代山水田园诗人，与王维并称"王孟"'),
('杜牧', '唐代', '牧之，唐代诗人，与李商隐并称"小李杜"')
ON CONFLICT (name) DO NOTHING;

-- 2. 添加更多诗词数据
INSERT INTO poems (title, content, poet_id, appreciation, tags) VALUES
('静夜思', '床前明月光，疑是地上霜。举头望明月，低头思故乡。', 
 (SELECT id FROM poets WHERE name = '李白'),
 '这首诗通过简洁的语言描绘了月夜思乡的场景，表达了诗人对故乡的深切思念。',
 ARRAY['思乡', '月亮', '夜晚']),
('春望', '国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。烽火连三月，家书抵万金。白头搔更短，浑欲不胜簪。', 
 (SELECT id FROM poets WHERE name = '杜甫'),
 '这首诗描写了安史之乱后长安城的荒凉景象，表达了诗人忧国忧民的情怀。',
 ARRAY['爱国', '春天', '忧国']),
('水调歌头', '明月几时有？把酒问青天。不知天上宫阙，今夕是何年。我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间。', 
 (SELECT id FROM poets WHERE name = '苏轼'),
 '这首词表达了诗人对人生的思考和对亲人的思念，意境深远，语言优美。',
 ARRAY['思念', '月亮', '人生']),
('声声慢', '寻寻觅觅，冷冷清清，凄凄惨惨戚戚。乍暖还寒时候，最难将息。三杯两盏淡酒，怎敌他、晚来风急？雁过也，正伤心，却是旧时相识。', 
 (SELECT id FROM poets WHERE name = '李清照'),
 '这首词通过细腻的描写表达了女词人深沉的哀愁和孤独感。',
 ARRAY['哀愁', '孤独', '秋天']),
('将进酒', '君不见黄河之水天上来，奔流到海不复回。君不见高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。', 
 (SELECT id FROM poets WHERE name = '李白'),
 '这首诗表现了诗人豪放不羁的性格和对人生的深刻感悟。',
 ARRAY['豪放', '人生', '饮酒']),
('登高', '风急天高猿啸哀，渚清沙白鸟飞回。无边落木萧萧下，不尽长江滚滚来。万里悲秋常作客，百年多病独登台。艰难苦恨繁霜鬓，潦倒新停浊酒杯。', 
 (SELECT id FROM poets WHERE name = '杜甫'),
 '这首诗描绘了秋日登高的壮阔景象，抒发了诗人漂泊异乡的感慨。',
 ARRAY['秋天', '登高', '思乡']),
('念奴娇·赤壁怀古', '大江东去，浪淘尽，千古风流人物。故垒西边，人道是，三国周郎赤壁。乱石穿空，惊涛拍岸，卷起千堆雪。江山如画，一时多少豪杰。', 
 (SELECT id FROM poets WHERE name = '苏轼'),
 '这首词通过对赤壁古战场的描写，抒发了对历史英雄的追忆和感慨。',
 ARRAY['怀古', '赤壁', '英雄']),
('如梦令', '常记溪亭日暮，沉醉不知归路。兴尽晚回舟，误入藕花深处。争渡，争渡，惊起一滩鸥鹭。', 
 (SELECT id FROM poets WHERE name = '李清照'),
 '这首小令描写了夏日游玩的愉快情景，语言清新自然。',
 ARRAY['游玩', '夏日', '愉快']),
('琵琶行', '浔阳江头夜送客，枫叶荻花秋瑟瑟。主人下马客在船，举酒欲饮无管弦。醉不成欢惨将别，别时茫茫江浸月。', 
 (SELECT id FROM poets WHERE name = '白居易'),
 '这首叙事诗通过琵琶女的遭遇反映了社会现实，语言优美动人。',
 ARRAY['叙事', '琵琶', '社会']),
('青玉案·元夕', '东风夜放花千树，更吹落、星如雨。宝马雕车香满路。凤箫声动，玉壶光转，一夜鱼龙舞。', 
 (SELECT id FROM poets WHERE name = '辛弃疾'),
 '这首词描写了元宵佳节的热闹景象，表达了诗人对美好生活的向往。',
 ARRAY['元宵', '热闹', '节日'])
ON CONFLICT (title) DO NOTHING;

-- 3. 添加朝代信息表
CREATE TABLE IF NOT EXISTS dynasties (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  period VARCHAR(100) NOT NULL,
  capital VARCHAR(100),
  notable_emperors TEXT,
  cultural_features TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 4. 填充朝代数据
INSERT INTO dynasties (name, period, capital, notable_emperors, cultural_features) VALUES
('唐代', '618-907年', '长安（今西安）', '唐太宗、唐玄宗、武则天', '诗歌创作达到顶峰，唐诗成为中国古典诗歌的代表'),
('宋代', '960-1279年', '汴京（今开封）、临安（今杭州）', '宋太祖、宋仁宗、宋徽宗', '词创作繁荣，宋词与唐诗并称"唐诗宋词"'),
('元代', '1271-1368年', '大都（今北京）', '元世祖忽必烈', '元曲兴起，戏曲文学发展'),
('明代', '1368-1644年', '南京、北京', '明太祖朱元璋、明成祖朱棣', '小说创作繁荣，四大名著中的三部成书于明代'),
('清代', '1644-1912年', '北京', '康熙帝、乾隆帝', '诗词创作继承传统，小说创作继续发展');

-- 5. 创建赏析技巧表
CREATE TABLE IF NOT EXISTS appreciation_techniques (
  id SERIAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  examples TEXT,
  difficulty_level VARCHAR(20) DEFAULT 'medium',
  category VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);

-- 6. 填充赏析技巧数据
INSERT INTO appreciation_techniques (title, description, examples, difficulty_level, category) VALUES
('意象分析', '分析诗词中的意象运用，理解作者的创作意图和情感表达。意象是诗词中具体可感的形象，通过分析意象可以深入理解诗词内涵。', '李白的"明月"象征思乡，杜甫的"秋风"象征萧瑟', 'easy', '基础技巧'),
('韵律节奏', '把握诗词的韵律美和节奏感，体会音乐性的艺术效果。诗词的平仄、押韵、对仗等手法构成独特的韵律美。', '《静夜思》的平仄交替，《水调歌头》的押韵规律', 'medium', '音乐性分析'),
('修辞手法', '识别比喻、拟人、夸张等修辞手法，理解艺术表现力。修辞手法能够增强诗词的表现力和感染力。', '李白的"白发三千丈"运用夸张手法', 'medium', '语言艺术'),
('意境营造', '感受诗词营造的意境氛围，体会情景交融的艺术境界。意境是诗词的灵魂，通过意象的组合营造出独特的艺术空间。', '王维的山水诗营造出"诗中有画"的意境', 'hard', '高级鉴赏'),
('典故运用', '理解诗词中引用的历史典故，把握文化内涵。典故能够增加诗词的文化厚度和深度。', '辛弃疾词中大量运用历史典故', 'hard', '文化背景');

-- 7. 创建练习题目表
CREATE TABLE IF NOT EXISTS practice_exercises (
  id SERIAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  poem_id INTEGER REFERENCES poems(id),
  question TEXT NOT NULL,
  options JSONB,
  correct_answer TEXT NOT NULL,
  explanation TEXT,
  difficulty VARCHAR(20) DEFAULT 'medium',
  created_at TIMESTAMP DEFAULT NOW()
);

-- 8. 填充练习题目数据
INSERT INTO practice_exercises (title, description, poem_id, question, options, correct_answer, explanation, difficulty) VALUES
('意象识别练习', '识别《静夜思》中的关键意象', 1, '《静夜思》中主要运用了哪些意象来表达思乡之情？', '["明月", "霜", "故乡", "所有选项"]', '所有选项', '明月象征团圆，霜象征寒冷，故乡是思念的对象', 'easy'),
('修辞手法分析', '分析《将进酒》中的修辞手法', 5, '《将进酒》中"君不见黄河之水天上来"运用了什么修辞手法？', '["比喻", "夸张", "拟人", "对偶"]', '夸张', '通过夸张手法表现黄河的雄伟气势', 'medium'),
('意境赏析', '理解《春望》的意境特点', 2, '《春望》营造了怎样的意境氛围？', '["豪迈壮阔", "凄凉悲壮", "清新自然", "浪漫神秘"]', '凄凉悲壮', '通过国破家亡的描写营造凄凉氛围', 'hard');

-- 9. 更新统计视图
CREATE OR REPLACE VIEW poem_statistics AS
SELECT 
  COUNT(*) as total_poems,
  COUNT(DISTINCT poet_id) as total_poets,
  COUNT(DISTINCT dynasty) as total_dynasties,
  COALESCE(SUM(likes), 0) as total_likes
FROM poems;

-- 10. 创建朝代诗词统计视图
CREATE OR REPLACE VIEW dynasty_stats AS
SELECT 
  d.name as dynasty,
  COUNT(p.id) as poem_count,
  COUNT(DISTINCT p.poet_id) as poet_count
FROM dynasties d
LEFT JOIN poems p ON p.dynasty = d.name
GROUP BY d.id, d.name
ORDER BY d.id;

-- 为所有表启用行级安全策略
ALTER TABLE poets ENABLE ROW LEVEL SECURITY;
ALTER TABLE poems ENABLE ROW LEVEL SECURITY;
ALTER TABLE dynasties ENABLE ROW LEVEL SECURITY;
ALTER TABLE appreciation_techniques ENABLE ROW LEVEL SECURITY;
ALTER TABLE practice_exercises ENABLE ROW LEVEL SECURITY;

-- 创建允许匿名读取的策略
CREATE POLICY "允许匿名读取诗人数据" ON poets FOR SELECT USING (true);
CREATE POLICY "允许匿名读取诗词数据" ON poems FOR SELECT USING (true);
CREATE POLICY "允许匿名读取朝代数据" ON dynasties FOR SELECT USING (true);
CREATE POLICY "允许匿名读取赏析技巧" ON appreciation_techniques FOR SELECT USING (true);
CREATE POLICY "允许匿名读取练习题目" ON practice_exercises FOR SELECT USING (true);