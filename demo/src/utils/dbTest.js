import { supabase } from '../supabase.js'

export async function testDatabaseConnection() {
  try {
    console.log('测试Supabase数据库连接...')
    
    // 测试基本连接
    const { data, error } = await supabase.from('poems').select('count').limit(1)
    
    if (error) {
      console.log('数据库连接失败:', error.message)
      return { success: false, error: error.message }
    } else {
      console.log('数据库连接成功')
      return { success: true, data }
    }
  } catch (error) {
    console.log('数据库连接异常:', error.message)
    return { success: false, error: error.message }
  }
}

export async function checkPracticeTables() {
  try {
    console.log('检查实战练习相关表...')
    
    // 检查练习题目表
    const { data: exercises, error: exercisesError } = await supabase
      .from('practice_exercises')
      .select('count')
      .limit(1)
    
    if (exercisesError) {
      console.log('练习题目表不存在或无法访问:', exercisesError.message)
      return { tablesExist: false }
    }
    
    // 检查练习尝试记录表
    const { data: attempts, error: attemptsError } = await supabase
      .from('exercise_attempts')
      .select('count')
      .limit(1)
    
    if (attemptsError) {
      console.log('练习尝试记录表不存在或无法访问:', attemptsError.message)
      return { tablesExist: false }
    }
    
    console.log('实战练习相关表存在')
    return { tablesExist: true }
  } catch (error) {
    console.log('检查表过程中出现异常:', error.message)
    return { tablesExist: false }
  }
}

// 获取模拟数据作为备选
export function getMockPracticeExercises() {
  return [
    {
      id: 1,
      title: '意象识别练习',
      description: '识别诗词中的关键意象及其象征意义',
      difficulty: 'easy',
      icon: '🔍',
      questions: [
        {
          id: 1,
          type: 'choice',
          content: '李白的《静夜思》中，"床前明月光"一句主要运用了哪种意象？',
          options: ['月光意象', '山水意象', '花鸟意象', '人物意象'],
          correctAnswer: '月光意象',
          explanation: '月光意象在诗中营造了宁静、思乡的氛围，象征着游子对故乡的思念之情。'
        },
        {
          id: 5,
          type: 'choice',
          content: '王之涣《登鹳雀楼》中"羌笛何须怨杨柳"一句，柳树意象象征什么？',
          options: ['离别之情', '春天到来', '高洁品格', '思乡之情'],
          correctAnswer: '离别之情',
          explanation: '柳树在古诗词中常象征离别，因为"柳"与"留"谐音，表达挽留之意。'
        },
        {
          id: 6,
          type: 'choice',
          content: '王安石《梅花》中"墙角数枝梅，凌寒独自开"主要赞美梅花的什么品质？',
          options: ['高洁坚贞', '美丽动人', '香气袭人', '生命力强'],
          correctAnswer: '高洁坚贞',
          explanation: '梅花在严寒中开放，象征高洁坚贞的品格和不畏艰难的意志。'
        }
      ]
    },
    {
      id: 2,
      title: '韵律分析练习',
      description: '分析诗词的韵律结构和节奏特点',
      difficulty: 'medium',
      icon: '🎵',
      questions: [
        {
          id: 2,
          type: 'fill',
          content: '请填写杜甫《春望》的韵脚：国破山河在，城春草木___。',
          correctAnswer: '深',
          explanation: '这首诗采用平水韵，"深"字与后文的押韵相呼应，体现了诗歌的音乐美。'
        },
        {
          id: 7,
          type: 'choice',
          content: '杜甫《春望》首句"国破山河在"的平仄规律是什么？',
          options: ['仄仄平平仄', '平平仄仄平', '仄平平仄仄', '平仄仄平平'],
          correctAnswer: '仄仄平平仄',
          explanation: '五言律诗的首句平仄规律为"仄仄平平仄"，体现了格律诗的严谨性。'
        },
        {
          id: 8,
          type: 'fill',
          content: '李白《静夜思》的韵脚是：床前明月光，疑是地上___。举头望明月，低头思故___。',
          correctAnswer: '霜,乡',
          explanation: '这首诗押"ang"韵，"光"、"霜"、"乡"押韵，体现了诗歌的音乐美。'
        }
      ]
    },
    {
      id: 3,
      title: '修辞手法练习',
      description: '识别并分析诗词中的修辞手法',
      difficulty: 'medium',
      icon: '🖋️',
      questions: [
        {
          id: 3,
          type: 'choice',
          content: '李商隐《无题》中"春蚕到死丝方尽，蜡炬成灰泪始干"运用了哪种修辞手法？',
          options: ['比喻', '拟人', '夸张', '对偶'],
          correctAnswer: '比喻',
          explanation: '这里用春蚕吐丝比喻爱情的执着，用蜡烛燃烧比喻奉献精神。'
        },
        {
          id: 9,
          type: 'choice',
          content: '杜牧《秋夕》中"银烛秋光冷画屏"运用了什么修辞手法？',
          options: ['拟人', '比喻', '夸张', '对偶'],
          correctAnswer: '拟人',
          explanation: '"冷"字将人的感受赋予画屏，是典型的拟人手法。'
        },
        {
          id: 10,
          type: 'choice',
          content: '李白《秋浦歌》中"白发三千丈，缘愁似个长"运用了什么修辞手法？',
          options: ['夸张', '比喻', '拟人', '对偶'],
          correctAnswer: '夸张',
          explanation: '"三千丈"极度夸张白发的长度，突出愁绪的深重。'
        }
      ]
    },
    {
      id: 4,
      title: '意境赏析练习',
      description: '深入理解诗词的意境和情感表达',
      difficulty: 'hard',
      icon: '🎨',
      questions: [
        {
          id: 4,
          type: 'essay',
          content: '请分析王维《山居秋暝》中"明月松间照，清泉石上流"所营造的意境。',
          correctAnswer: '这两句诗通过明月、松林、清泉、石头的意象组合，营造出宁静幽美的山水意境，体现了诗人超脱尘世、向往自然的情怀。',
          explanation: '诗人运用视觉和听觉的描写，创造出动静结合、情景交融的艺术境界。'
        },
        {
          id: 11,
          type: 'essay',
          content: '请分析王昌龄《出塞》中"秦时明月汉时关，万里长征人未还"所表达的意境和情感。',
          correctAnswer: '这两句诗通过"明月"、"关隘"、"长征"等意象，营造出苍凉、雄浑的边塞意境，表达了戍边将士的思乡之情和保家卫国的豪情壮志。',
          explanation: '诗人巧妙地将历史与现实结合，通过时空的跨越展现边塞的永恒和征人的艰辛，具有强烈的艺术感染力。'
        },
        {
          id: 12,
          type: 'essay',
          content: '请分析陶渊明《饮酒》中"采菊东篱下，悠然见南山"所营造的意境。',
          correctAnswer: '这两句诗通过"采菊"、"东篱"、"南山"等意象，营造出闲适、淡泊的田园意境，体现了诗人超脱世俗、回归自然的生活态度。',
          explanation: '诗人用朴素的语言描绘出人与自然和谐相处的美好画面，表达了对自由、宁静生活的向往和追求。'
        }
      ]
    },
    {
      id: 5,
      title: '综合练习',
      description: '综合运用多种赏析技巧进行深度分析',
      difficulty: 'hard',
      icon: '📚',
      questions: [
        {
          id: 13,
          type: 'choice',
          content: '李清照《声声慢》中"寻寻觅觅，冷冷清清，凄凄惨惨戚戚"主要运用了什么艺术手法？',
          options: ['叠字手法', '比喻手法', '夸张手法', '对偶手法'],
          correctAnswer: '叠字手法',
          explanation: '这里连续使用七组叠字，增强了语言的音乐性和情感的表达力，是李清照词作的经典手法。'
        },
        {
          id: 14,
          type: 'fill',
          content: '补全名句：人生若只如初见，________________。',
          correctAnswer: '何事秋风悲画扇',
          explanation: '这是纳兰性德《木兰花·拟古决绝词柬友》中的名句，表达了对美好初见的怀念和对现实变迁的感慨。'
        },
        {
          id: 15,
          type: 'essay',
          content: '请综合分析李白《将进酒》的艺术特色和思想内涵。',
          correctAnswer: '《将进酒》通过豪放的笔触、丰富的想象和强烈的情感表达，展现了李白浪漫主义的诗歌风格。诗中运用夸张、比喻等手法，将饮酒的豪情与对人生的感慨相结合，表达了"人生得意须尽欢"的豁达情怀和"天生我材必有用"的自信精神。',
          explanation: '这首诗在艺术上体现了李白诗歌的典型特色：语言豪放、想象奇特、情感真挚，在思想内容上表达了对人生的深刻思考和对自由的不懈追求。'
        }
      ]
    },
    {
      id: 6,
      title: '填空题练习',
      description: '补全经典诗词名句，检验诗词积累',
      difficulty: 'medium',
      icon: '✍️',
      questions: [
        {
          id: 16,
          type: 'fill',
          content: '接龙诗句：春风又绿江南岸，________________。',
          correctAnswer: '明月何时照我还',
          explanation: '这是王安石《泊船瓜洲》中的名句，表达了诗人对故乡的思念之情。'
        },
        {
          id: 17,
          type: 'fill',
          content: '补全苏轼《水调歌头》名句：但愿人长久，________________。',
          correctAnswer: '千里共婵娟',
          explanation: '这是中秋词中的经典名句，表达了对亲人的美好祝愿和超越时空的情感联系。'
        },
        {
          id: 18,
          type: 'fill',
          content: '补全杜甫名句：两个黄鹂鸣翠柳，________________。',
          correctAnswer: '一行白鹭上青天',
          explanation: '这是杜甫《绝句》中的名句，描绘了春天生机勃勃的景象。'
        }
      ]
    }
  ]
}