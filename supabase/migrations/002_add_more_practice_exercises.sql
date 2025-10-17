-- 添加更多实战练习题目的数据

-- 1. 添加更多意象识别练习
INSERT INTO practice_exercises (title, description, type, difficulty, content, options, correct_answer, explanation) VALUES
(
    '意象识别练习 - 柳树意象',
    '识别诗词中的柳树意象及其象征意义',
    'choice',
    'easy',
    '王之涣《登鹳雀楼》中"羌笛何须怨杨柳"一句，柳树意象象征什么？',
    '["离别之情", "春天到来", "高洁品格", "思乡之情"]',
    '离别之情',
    '柳树在古诗词中常象征离别，因为"柳"与"留"谐音，表达挽留之意。'
),
(
    '意象识别练习 - 梅花意象',
    '识别诗词中的梅花意象及其象征意义',
    'choice',
    'easy',
    '王安石《梅花》中"墙角数枝梅，凌寒独自开"主要赞美梅花的什么品质？',
    '["高洁坚贞", "美丽动人", "香气袭人", "生命力强"]',
    '高洁坚贞',
    '梅花在严寒中开放，象征高洁坚贞的品格和不畏艰难的意志。'
),
(
    '意象识别练习 - 月亮意象',
    '识别诗词中的月亮意象及其象征意义',
    'choice',
    'medium',
    '苏轼《水调歌头》中"明月几时有？把酒问青天"表达了什么情感？',
    '["思乡怀人", "人生感慨", "政治失意", "及时行乐"]',
    '人生感慨',
    '这里的月亮意象不仅表达思乡，更体现了对人生、宇宙的深刻思考。'
);

-- 2. 添加更多韵律分析练习
INSERT INTO practice_exercises (title, description, type, difficulty, content, options, correct_answer, explanation) VALUES
(
    '韵律分析练习 - 平仄识别',
    '分析诗词的平仄规律',
    'choice',
    'medium',
    '杜甫《春望》首句"国破山河在"的平仄规律是什么？',
    '["仄仄平平仄", "平平仄仄平", "仄平平仄仄", "平仄仄平平"]',
    '仄仄平平仄',
    '五言律诗的首句平仄规律为"仄仄平平仄"，体现了格律诗的严谨性。'
),
(
    '韵律分析练习 - 押韵规律',
    '分析诗词的押韵特点',
    'fill',
    'medium',
    '李白《静夜思》的韵脚是：床前明月光，疑是地上___。举头望明月，低头思故___。',
    NULL,
    '霜,乡',
    '这首诗押"ang"韵，"光"、"霜"、"乡"押韵，体现了诗歌的音乐美。'
),
(
    '韵律分析练习 - 对仗识别',
    '识别诗词中的对仗手法',
    'choice',
    'hard',
    '杜甫《登高》中"无边落木萧萧下，不尽长江滚滚来"运用了什么修辞手法？',
    '["对仗", "比喻", "夸张", "拟人"]',
    '对仗',
    '这两句诗在字数、结构、意义上都形成完美对仗，体现了律诗的艺术特色。'
);

-- 3. 添加更多修辞手法练习
INSERT INTO practice_exercises (title, description, type, difficulty, content, options, correct_answer, explanation) VALUES
(
    '修辞手法练习 - 拟人识别',
    '识别诗词中的拟人手法',
    'choice',
    'easy',
    '杜牧《秋夕》中"银烛秋光冷画屏"运用了什么修辞手法？',
    '["拟人", "比喻", "夸张", "对偶"]',
    '拟人',
    '"冷"字将人的感受赋予画屏，是典型的拟人手法。'
),
(
    '修辞手法练习 - 夸张识别',
    '识别诗词中的夸张手法',
    'choice',
    'medium',
    '李白《秋浦歌》中"白发三千丈，缘愁似个长"运用了什么修辞手法？',
    '["夸张", "比喻", "拟人", "对偶"]',
    '夸张',
    '"三千丈"极度夸张白发的长度，突出愁绪的深重。'
),
(
    '修辞手法练习 - 比喻识别',
    '识别诗词中的比喻手法',
    'choice',
    'medium',
    '李煜《虞美人》中"问君能有几多愁？恰似一江春水向东流"运用了什么修辞手法？',
    '["比喻", "拟人", "夸张", "设问"]',
    '比喻',
    '将愁绪比作东流的春水，形象生动地表达了愁绪的绵长无尽。'
);

-- 4. 添加更多意境赏析练习
INSERT INTO practice_exercises (title, description, type, difficulty, content, options, correct_answer, explanation) VALUES
(
    '意境赏析练习 - 山水意境',
    '分析山水诗的意境特点',
    'essay',
    'hard',
    '请分析王维《山居秋暝》中"空山新雨后，天气晚来秋"所营造的意境。',
    NULL,
    '这两句诗通过"空山"、"新雨"、"晚秋"等意象，营造出清新、宁静的山水意境，体现了诗人超脱尘世、向往自然的情怀，展现了中国山水诗"诗中有画"的艺术特色。',
    '诗人运用简练的语言，创造出动静结合、虚实相生的艺术境界，让读者感受到大自然的宁静美和生命的和谐。'
),
(
    '意境赏析练习 - 边塞意境',
    '分析边塞诗的意境特点',
    'essay',
    'hard',
    '请分析王昌龄《出塞》中"秦时明月汉时关，万里长征人未还"所表达的意境和情感。',
    NULL,
    '这两句诗通过"明月"、"关隘"、"长征"等意象，营造出苍凉、雄浑的边塞意境，表达了戍边将士的思乡之情和保家卫国的豪情壮志，体现了边塞诗的历史厚重感和英雄气概。',
    '诗人巧妙地将历史与现实结合，通过时空的跨越展现边塞的永恒和征人的艰辛，具有强烈的艺术感染力。'
),
(
    '意境赏析练习 - 田园意境',
    '分析田园诗的意境特点',
    'essay',
    'medium',
    '请分析陶渊明《饮酒》中"采菊东篱下，悠然见南山"所营造的意境。',
    NULL,
    '这两句诗通过"采菊"、"东篱"、"南山"等意象，营造出闲适、淡泊的田园意境，体现了诗人超脱世俗、回归自然的生活态度，展现了中国田园诗"天人合一"的哲学思想。',
    '诗人用朴素的语言描绘出人与自然和谐相处的美好画面，表达了对自由、宁静生活的向往和追求。'
);

-- 5. 添加综合练习题目
INSERT INTO practice_exercises (title, description, type, difficulty, content, options, correct_answer, explanation) VALUES
(
    '综合练习 - 诗词鉴赏',
    '综合运用多种赏析技巧',
    'choice',
    'hard',
    '李清照《声声慢》中"寻寻觅觅，冷冷清清，凄凄惨惨戚戚"主要运用了什么艺术手法？',
    '["叠字手法", "比喻手法", "夸张手法", "对偶手法"]',
    '叠字手法',
    '这里连续使用七组叠字，增强了语言的音乐性和情感的表达力，是李清照词作的经典手法。'
),
(
    '综合练习 - 艺术特色分析',
    '分析诗词的整体艺术特色',
    'essay',
    'hard',
    '请综合分析李白《将进酒》的艺术特色和思想内涵。',
    NULL,
    '《将进酒》通过豪放的笔触、丰富的想象和强烈的情感表达，展现了李白浪漫主义的诗歌风格。诗中运用夸张、比喻等手法，将饮酒的豪情与对人生的感慨相结合，表达了"人生得意须尽欢"的豁达情怀和"天生我材必有用"的自信精神，具有强烈的艺术感染力和深刻的思想内涵。',
    '这首诗在艺术上体现了李白诗歌的典型特色：语言豪放、想象奇特、情感真挚，在思想内容上表达了对人生的深刻思考和对自由的不懈追求。'
);

-- 6. 添加填空题练习
INSERT INTO practice_exercises (title, description, type, difficulty, content, options, correct_answer, explanation) VALUES
(
    '填空题练习 - 名句补全',
    '补全经典诗词名句',
    'fill',
    'easy',
    '补全名句：人生若只如初见，________________。',
    NULL,
    '何事秋风悲画扇',
    '这是纳兰性德《木兰花·拟古决绝词柬友》中的名句，表达了对美好初见的怀念和对现实变迁的感慨。'
),
(
    '填空题练习 - 诗句接龙',
    '根据上下文补全诗句',
    'fill',
    'medium',
    '接龙诗句：春风又绿江南岸，________________。',
    NULL,
    '明月何时照我还',
    '这是王安石《泊船瓜洲》中的名句，表达了诗人对故乡的思念之情。'
),
(
    '填空题练习 - 词牌填空',
    '补全词牌名句',
    'fill',
    'hard',
    '补全苏轼《水调歌头》名句：但愿人长久，________________。',
    NULL,
    '千里共婵娟',
    '这是中秋词中的经典名句，表达了对亲人的美好祝愿和超越时空的情感联系。'
);

-- 7. 更新现有题目的难度分类
UPDATE practice_exercises 
SET difficulty = 'hard' 
WHERE title LIKE '%意境赏析%' OR title LIKE '%综合练习%';

UPDATE practice_exercises 
SET difficulty = 'medium' 
WHERE title LIKE '%韵律分析%' AND type = 'choice';

-- 8. 为部分题目添加诗词关联（如果诗词表存在）
-- 注意：这里需要根据实际的诗词表结构进行调整
-- UPDATE practice_exercises SET poem_id = (SELECT id FROM poems WHERE title = '静夜思' LIMIT 1) WHERE content LIKE '%静夜思%';
-- UPDATE practice_exercises SET poem_id = (SELECT id FROM poems WHERE title = '春望' LIMIT 1) WHERE content LIKE '%春望%';

-- 9. 创建索引优化查询性能（如果不存在）
CREATE INDEX IF NOT EXISTS idx_practice_exercises_title ON practice_exercises(title);
CREATE INDEX IF NOT EXISTS idx_practice_exercises_difficulty_type ON practice_exercises(difficulty, type);

-- 10. 统计新增题目数量
SELECT 
    COUNT(*) as total_exercises,
    COUNT(CASE WHEN difficulty = 'easy' THEN 1 END) as easy_count,
    COUNT(CASE WHEN difficulty = 'medium' THEN 1 END) as medium_count,
    COUNT(CASE WHEN difficulty = 'hard' THEN 1 END) as hard_count,
    COUNT(CASE WHEN type = 'choice' THEN 1 END) as choice_count,
    COUNT(CASE WHEN type = 'fill' THEN 1 END) as fill_count,
    COUNT(CASE WHEN type = 'essay' THEN 1 END) as essay_count
FROM practice_exercises;