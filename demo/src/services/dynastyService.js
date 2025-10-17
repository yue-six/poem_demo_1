import { supabase } from '../supabase.js'

export const DynastyService = {
  // 获取所有朝代信息
  async getDynasties() {
    try {
      const { data, error } = await supabase
        .from('dynasties')
        .select('*')
        .order('id')
      
      if (error) throw error
      return data || []
    } catch (error) {
      console.error('获取朝代数据失败:', error)
      return []
    }
  },
  
  // 获取指定朝代的诗词
  async getPoemsByDynasty(dynastyName) {
    try {
      const { data, error } = await supabase
        .from('poems')
        .select(`
          *,
          poets (
            name,
            dynasty,
            description
          )
        `)
        .eq('dynasty', dynastyName)
        .order('title')
      
      if (error) throw error
      return data || []
    } catch (error) {
      console.error(`获取${dynastyName}朝诗词失败:`, error)
      return []
    }
  },
  
  // 获取朝代统计信息
  async getDynastyStats() {
    try {
      const { data, error } = await supabase
        .from('dynasties')
        .select(`
          name,
          period,
          poems:poems(count),
          poets:poets(count)
        `)
      
      if (error) throw error
      return data || []
    } catch (error) {
      console.error('获取朝代统计失败:', error)
      return []
    }
  }
}