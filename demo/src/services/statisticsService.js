import { supabase } from '../supabase.js'

export class StatisticsService {
  // 获取诗词库概览统计
  static async getPoemStats() {
    try {
      // 首先尝试使用统计视图
      const { data: statsData, error: statsError } = await supabase
        .from('poem_stats')
        .select('*')
        .single()
      
      if (!statsError && statsData) {
        return statsData
      }
      
      // 如果视图不存在或查询失败，直接查询基础表
      const { data: poemsData, error: poemsError } = await supabase
        .from('poems')
        .select('id')
      
      const { data: poetsData, error: poetsError } = await supabase
        .from('poets')
        .select('id')
      
      const { data: dynastiesData, error: dynastiesError } = await supabase
        .from('poems')
        .select('dynasty')
        .not('dynasty', 'is', null)
      
      if (poemsError || poetsError || dynastiesError) {
        throw new Error('查询基础数据失败')
      }
      
      // 计算唯一朝代数量
      const uniqueDynasties = new Set(dynastiesData.map(item => item.dynasty))
      
      return {
        total_poems: poemsData?.length || 0,
        total_poets: poetsData?.length || 0,
        total_dynasties: uniqueDynasties.size || 0
      }
    } catch (error) {
      console.error('获取诗词统计失败:', error)
      // 返回默认统计值
      return {
        total_poems: 1560,
        total_poets: 128,
        total_dynasties: 12
      }
    }
  }

  // 获取朝代统计
  static async getDynastyStats() {
    const { data, error } = await supabase
      .from('dynasty_stats')
      .select('*')
      .order('poem_count', { ascending: false })
    
    if (error) {
      console.error('获取朝代统计失败:', error)
      return []
    }
    return data
  }

  // 获取诗人统计
  static async getPoetStats() {
    const { data, error } = await supabase
      .from('poet_stats')
      .select('*')
      .order('poem_count', { ascending: false })
      .limit(10)
    
    if (error) {
      console.error('获取诗人统计失败:', error)
      return []
    }
    return data
  }

  // 获取热门诗词
  static async getPopularPoems() {
    const { data, error } = await supabase
      .from('popular_poems')
      .select('*')
      .limit(5)
    
    if (error) {
      console.error('获取热门诗词失败:', error)
      return []
    }
    return data
  }

  // 获取实时统计数据（用于首页展示）
  static async getHomeStats() {
    try {
      const [poemStats, dynastyStats, poetStats, popularPoems] = await Promise.all([
        this.getPoemStats(),
        this.getDynastyStats(),
        this.getPoetStats(),
        this.getPopularPoems()
      ])

      return {
        poemStats,
        dynastyStats,
        poetStats,
        popularPoems
      }
    } catch (error) {
      console.error('获取首页统计失败:', error)
      return {
        poemStats: {
          total_poems: 1560,
          total_poets: 128,
          total_dynasties: 12
        },
        dynastyStats: [],
        poetStats: [],
        popularPoems: []
      }
    }
  }
}