// 数据库初始化脚本 - 用于填充示例诗词数据
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

// 加载环境变量
dotenv.config()

// 从环境变量获取Supabase配置
const supabaseUrl = process.env.VITE_SUPABASE_URL || 'https://brryzwnhlueiojnoackt.supabase.co'
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJycnl6d25obHVlaW9qbm9hY2t0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1MDk3OTMsImV4cCI6MjA3NjA4NTc5M30.-DA-Z5UvXpEss_K-nO-rN-TZQ_6p7iGkfBjqgxAg28w'

const supabase = createClient(supabaseUrl, supabaseKey)

// 示例诗词数据
const samplePoems = [
  {
    title: '静夜思',
    author: '李白',
    dynasty: '唐',
    type: '诗',
    content: '床前明月光，疑是地上霜。举头望明月，低头思故乡。',
    analysis: '这首诗通过描绘月夜思乡的场景，表达了诗人对故乡的深切思念。语言简练，意境深远。',
    features: ['语言简练', '意境深远', '情感真挚', '画面感强'],
    key_points: ['明月光', '地上霜', '望明月', '思故乡'],
    likes: 2345,
    reads: 15600,
    comments: 289,
    featured: true
  },
  {
    title: '水调歌头·明月几时有',
    author: '苏轼',
    dynasty: '宋',
    type: '词',
    content: '明月几时有？把酒问青天。不知天上宫阙，今夕是何年。我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间。转朱阁，低绮户，照无眠。不应有恨，何事长向别时圆？人有悲欢离合，月有阴晴圆缺，此事古难全。但愿人长久，千里共婵娟。',
    analysis: '这首词以月起兴，围绕中秋明月展开想象和思考，把人世间的悲欢离合之情纳入对宇宙人生的哲理性追寻之中。',
    features: ['想象丰富', '哲理深刻', '意境开阔', '语言优美'],
    key_points: ['明月几时有', '把酒问青天', '人有悲欢离合', '千里共婵娟'],
    likes: 1890,
    reads: 12800,
    comments: 345,
    featured: true
  },
  {
    title: '春晓',
    author: '孟浩然',
    dynasty: '唐',
    type: '诗',
    content: '春眠不觉晓，处处闻啼鸟。夜来风雨声，花落知多少。',
    analysis: '这首诗语言平易浅近，自然天成，一点也看不出人工雕琢的痕迹。言浅意浓，景真情切。',
    features: ['语言平易', '自然天成', '画面清新', '意境优美'],
    key_points: ['春眠不觉晓', '处处闻啼鸟', '夜来风雨声', '花落知多少'],
    likes: 1567,
    reads: 9800,
    comments: 167,
    featured: false
  },
  {
    title: '声声慢·寻寻觅觅',
    author: '李清照',
    dynasty: '宋',
    type: '词',
    content: '寻寻觅觅，冷冷清清，凄凄惨惨戚戚。乍暖还寒时候，最难将息。三杯两盏淡酒，怎敌他、晚来风急？雁过也，正伤心，却是旧时相识。满地黄花堆积。憔悴损，如今有谁堪摘？守着窗儿，独自怎生得黑？梧桐更兼细雨，到黄昏、点点滴滴。这次第，怎一个愁字了得！',
    analysis: '这首词通过描写残秋所见、所闻、所感，抒发自己因国破家亡、天涯沦落而产生的孤寂落寞、悲凉愁苦的心绪。',
    features: ['情感深沉', '语言精炼', '意境凄凉', '音韵和谐'],
    key_points: ['寻寻觅觅', '冷冷清清', '凄凄惨惨戚戚', '怎一个愁字了得'],
    likes: 1987,
    reads: 11200,
    comments: 234,
    featured: true
  },
  {
    title: '将进酒',
    author: '李白',
    dynasty: '唐',
    type: '诗',
    content: '君不见黄河之水天上来，奔流到海不复回。君不见高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来。烹羊宰牛且为乐，会须一饮三百杯。岑夫子，丹丘生，将进酒，杯莫停。与君歌一曲，请君为我倾耳听。钟鼓馔玉不足贵，但愿长醉不愿醒。',
    analysis: '这首诗借酒放歌，抒发了诗人怀才不遇的苦闷和自信豁达的人生态度，展现了李白豪放洒脱的性格。',
    features: ['豪放洒脱', '气势磅礴', '情感奔放', '语言夸张'],
    key_points: ['黄河之水天上来', '人生得意须尽欢', '天生我材必有用', '千金散尽还复来'],
    likes: 2678,
    reads: 18900,
    comments: 456,
    featured: true
  },
  {
    title: '登高',
    author: '杜甫',
    dynasty: '唐',
    type: '诗',
    content: '风急天高猿啸哀，渚清沙白鸟飞回。无边落木萧萧下，不尽长江滚滚来。万里悲秋常作客，百年多病独登台。艰难苦恨繁霜鬓，潦倒新停浊酒杯。',
    analysis: '这首诗通过登高所见秋景，抒发了诗人长年漂泊、老病孤愁的复杂情感，被誉为"古今七律第一"。',
    features: ['对仗工整', '意境开阔', '情感深沉', '语言精炼'],
    key_points: ['风急天高猿啸哀', '无边落木萧萧下', '不尽长江滚滚来', '万里悲秋常作客'],
    likes: 1789,
    reads: 10200,
    comments: 189,
    featured: false
  }
]

async function initDatabase() {
  console.log('开始初始化诗词数据库...')
  
  try {
    // 检查诗词表是否存在数据
    const { data: existingPoems, error: checkError } = await supabase
      .from('poems')
      .select('id')
      .limit(1)
    
    if (checkError) {
      console.error('检查诗词表失败:', checkError)
      return
    }
    
    if (existingPoems && existingPoems.length > 0) {
      console.log('诗词表已有数据，跳过初始化')
      return
    }
    
    // 插入示例诗词数据
    const { data, error } = await supabase
      .from('poems')
      .insert(samplePoems)
    
    if (error) {
      console.error('插入诗词数据失败:', error)
    } else {
      console.log(`成功插入 ${data.length} 首诗词数据`)
    }
    
  } catch (error) {
    console.error('初始化数据库失败:', error)
  }
}

// 运行初始化
initDatabase()