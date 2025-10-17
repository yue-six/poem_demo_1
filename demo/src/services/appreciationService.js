import { supabase } from '../supabase.js'

export const AppreciationService = {
  // 获取所有赏析技巧
  async getTechniques() {
    try {
      const { data, error } = await supabase
        .from('appreciation_techniques')
        .select('*')
        .order('id')
      
      if (error) throw error
      return data || []
    } catch (error) {
      console.error('获取赏析技巧失败:', error)
      return []
    }
  },
  
  // 获取指定分类的赏析技巧
  async getTechniquesByCategory(category) {
    try {
      const { data, error } = await supabase
        .from('appreciation_techniques')
        .select('*')
        .eq('category', category)
        .order('difficulty_level')
      
      if (error) throw error
      return data || []
    } catch (error) {
      console.error(`获取${category}分类赏析技巧失败:`, error)
      return []
    }
  },
  
  // 获取练习题目
  async getPracticeExercises() {
    try {
      const { data, error } = await supabase
        .from('practice_exercises')
        .select(`
          *,
          poems (
            title,
            content,
            poets (
              name
            )
          )
        `)
        .order('difficulty')
      
      if (error) throw error
      return data || []
    } catch (error) {
      console.error('获取练习题目失败:', error)
      return []
    }
  },
  
  // 获取指定难度的练习题目
  async getExercisesByDifficulty(difficulty) {
    try {
      const { data, error } = await supabase
        .from('practice_exercises')
        .select(`
          *,
          poems (
            title,
            content,
            poets (
              name
            )
          )
        `)
        .eq('difficulty', difficulty)
        .order('id')
      
      if (error) throw error
      return data || []
    } catch (error) {
      console.error(`获取${difficulty}难度练习题目失败:`, error)
      return []
    }
  },
  
  // 提交练习答案
  async submitExerciseAnswer(exerciseId, userAnswer, userId = null) {
    try {
      const { data, error } = await supabase
        .from('exercise_attempts')
        .insert({
          exercise_id: exerciseId,
          user_id: userId,
          user_answer: userAnswer,
          submitted_at: new Date().toISOString()
        })
        .select()
        .single()
      
      if (error) throw error
      return data
    } catch (error) {
      console.error('提交练习答案失败:', error)
      return null
    }
  },
  
  // 获取热门赏析诗词
  async getPopularPoems(limit = 10) {
    try {
      const { data, error } = await supabase
        .from('poems')
        .select(`
          *,
          poets (
            name,
            dynasty
          )
        `)
        .limit(limit)
      
      if (error) throw error
      return data || []
    } catch (error) {
      console.error('获取热门诗词失败:', error)
      return []
    }
  }
}