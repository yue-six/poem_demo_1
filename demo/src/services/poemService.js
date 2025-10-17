import { supabase } from '../supabase.js'

export class PoemService {
  // 获取所有诗人
  static async getPoets() {
    const { data, error } = await supabase
      .from('poets')
      .select('*')
      .order('name')
    
    if (error) throw error
    return data
  }

  // 获取所有诗词
  static async getPoems() {
    const { data, error } = await supabase
      .from('poems')
      .select(`
        *,
        poets (*)
      `)
      .order('title')
    
    if (error) throw error
    return data
  }

  // 根据诗人ID获取诗词
  static async getPoemsByPoet(poetId) {
    const { data, error } = await supabase
      .from('poems')
      .select(`
        *,
        poets (*)
      `)
      .eq('poet_id', poetId)
      .order('title')
    
    if (error) throw error
    return data
  }

  // 添加收藏
  static async addFavorite(poemId) {
    const user = supabase.auth.user()
    if (!user) throw new Error('用户未登录')
    
    const { data, error } = await supabase
      .from('user_favorites')
      .insert({
        user_id: user.id,
        poem_id: poemId
      })
    
    if (error) throw error
    return data
  }

  // 移除收藏
  static async removeFavorite(poemId) {
    const user = supabase.auth.user()
    if (!user) throw new Error('用户未登录')
    
    const { data, error } = await supabase
      .from('user_favorites')
      .delete()
      .eq('user_id', user.id)
      .eq('poem_id', poemId)
    
    if (error) throw error
    return data
  }

  // 获取用户收藏
  static async getUserFavorites() {
    const user = supabase.auth.user()
    if (!user) throw new Error('用户未登录')
    
    const { data, error } = await supabase
      .from('user_favorites')
      .select(`
        poem_id,
        poems (*)
      `)
      .eq('user_id', user.id)
    
    if (error) throw error
    return data.map(item => item.poems)
  }

  // 搜索诗词
  static async searchPoems(query) {
    const { data, error } = await supabase
      .from('poems')
      .select(`
        *,
        poets (*)
      `)
      .or(`title.ilike.%${query}%,content.ilike.%${query}%,tags.cs.{${query}}`)
    
    if (error) throw error
    return data
  }
}