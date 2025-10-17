-- 创建诗词库概览统计视图
-- 诗词总数统计
CREATE OR REPLACE VIEW poem_stats AS
SELECT 
  COUNT(*) as total_poems,
  COUNT(DISTINCT poet_id) as total_poets,
  COUNT(DISTINCT dynasty) as total_dynasties,
  COALESCE(SUM(likes), 0) as total_likes
FROM poems;

-- 各朝代诗词数量统计
CREATE OR REPLACE VIEW dynasty_stats AS
SELECT 
  dynasty,
  COUNT(*) as poem_count,
  COUNT(DISTINCT poet_id) as poet_count
FROM poems 
WHERE dynasty IS NOT NULL
GROUP BY dynasty
ORDER BY poem_count DESC;

-- 诗人作品数量统计
CREATE OR REPLACE VIEW poet_stats AS
SELECT 
  p.name as poet_name,
  p.dynasty,
  COUNT(po.id) as poem_count
FROM poets p
LEFT JOIN poems po ON p.id = po.poet_id
GROUP BY p.id, p.name, p.dynasty
ORDER BY poem_count DESC;

-- 热门诗词统计（按点赞数）
CREATE OR REPLACE VIEW popular_poems AS
SELECT 
  po.id,
  po.title,
  p.name as author,
  po.dynasty,
  po.likes,
  po.reads,
  po.comments
FROM poems po
LEFT JOIN poets p ON po.poet_id = p.id
WHERE po.likes > 0
ORDER BY po.likes DESC
LIMIT 10;

-- 插入更多示例数据以丰富统计
INSERT INTO poets (name, dynasty, description) VALUES
  ('白居易', '唐代', '现实主义诗人，作品通俗易懂'),
  ('王维', '唐代', '诗佛，山水田园诗代表'),
  ('李清照', '宋代', '婉约派词人代表'),
  ('辛弃疾', '宋代', '豪放派词人代表'),
  ('陆游', '宋代', '爱国诗人，作品丰富'),
  ('孟浩然', '唐代', '山水田园诗派代表'),
  ('杜牧', '唐代', '晚唐著名诗人'),
  ('李商隐', '唐代', '晚唐著名诗人，诗风婉约');

INSERT INTO poems (title, content, poet_id, dynasty, type, appreciation, likes, reads, comments) VALUES
  ('赋得古原草送别', '离离原上草，一岁一枯荣。野火烧不尽，春风吹又生。', 
   (SELECT id FROM poets WHERE name = '白居易'), '唐代', '诗',
   '这首诗通过对野草的描写，表达了生命力的顽强和离别的伤感。', 1560, 2890, 234),
  
  ('相思', '红豆生南国，春来发几枝。愿君多采撷，此物最相思。', 
   (SELECT id FROM poets WHERE name = '王维'), '唐代', '诗',
   '以红豆寄托相思之情，语言简练，情感真挚。', 1289, 1987, 156),
  
  ('声声慢', '寻寻觅觅，冷冷清清，凄凄惨惨戚戚。乍暖还寒时候，最难将息。', 
   (SELECT id FROM poets WHERE name = '李清照'), '宋代', '词',
   '李清照晚年作品，表达了对亡夫的深切思念和国破家亡的悲痛。', 2890, 4567, 389),
  
  ('青玉案·元夕', '东风夜放花千树，更吹落、星如雨。宝马雕车香满路。', 
   (SELECT id FROM poets WHERE name = '辛弃疾'), '宋代', '词',
   '描写元宵佳节的热闹场景，寄托了对理想境界的追求。', 1987, 3245, 267),
  
  ('游山西村', '莫笑农家腊酒浑，丰年留客足鸡豚。山重水复疑无路，柳暗花明又一村。', 
   (SELECT id FROM poets WHERE name = '陆游'), '宋代', '诗',
   '描写农村风光，蕴含深刻的人生哲理。', 1678, 2789, 189),
  
  ('春晓', '春眠不觉晓，处处闻啼鸟。夜来风雨声，花落知多少。', 
   (SELECT id FROM poets WHERE name = '孟浩然'), '唐代', '诗',
   '描写春天早晨的景色，语言清新自然。', 2345, 3678, 278),
  
  ('清明', '清明时节雨纷纷，路上行人欲断魂。借问酒家何处有，牧童遥指杏花村。', 
   (SELECT id FROM poets WHERE name = '杜牧'), '唐代', '诗',
   '描写清明时节的景象，情感真挚动人。', 1890, 2987, 156),
  
  ('夜雨寄北', '君问归期未有期，巴山夜雨涨秋池。何当共剪西窗烛，却话巴山夜雨时。', 
   (SELECT id FROM poets WHERE name = '李商隐'), '唐代', '诗',
   '表达了对远方亲友的思念之情，意境深远。', 1567, 2456, 189);

-- 更新诗词库概览统计的RLS策略
CREATE POLICY "任何人都可以查看统计信息" ON poem_stats
  FOR SELECT USING (true);

CREATE POLICY "任何人都可以查看朝代统计" ON dynasty_stats
  FOR SELECT USING (true);

CREATE POLICY "任何人都可以查看诗人统计" ON poet_stats
  FOR SELECT USING (true);

CREATE POLICY "任何人都可以查看热门诗词" ON popular_poems
  FOR SELECT USING (true);