<template>
  <div class="poem-detail-overlay" @click.self="closeDetail">
    <div class="poem-detail-modal">
      <div class="modal-header">
        <h2>{{ currentPoem.title }}</h2>
        <button @click="closeDetail" class="close-btn">×</button>
      </div>
      
      <div class="poem-info">
        <div class="info-item">
          <span class="label">作者：</span>
          <span class="value">{{ currentPoem.author }}</span>
        </div>
        <div class="info-item">
          <span class="label">朝代：</span>
          <span class="value">{{ currentPoem.dynasty }}</span>
        </div>
        <div class="info-item">
          <span class="label">类型：</span>
          <span class="value">{{ currentPoem.type }}</span>
        </div>
      </div>
      
      <div class="poem-content">
        <div class="content-section">
          <h3>📖 诗词全文</h3>
          <div class="poem-text">
            <p v-for="(line, index) in currentPoem.content" :key="index" class="poem-line">
              {{ line }}
            </p>
          </div>
        </div>
        
        <div v-if="currentPoem.translation" class="content-section">
          <h3>🔤 现代译文</h3>
          <div class="translation-text">
            <p>{{ currentPoem.translation }}</p>
          </div>
        </div>
        
        <div v-if="currentPoem.notes" class="content-section">
          <h3>📝 注释赏析</h3>
          <div class="notes-text">
            <p>{{ currentPoem.notes }}</p>
          </div>
        </div>
      </div>
      
      <div class="modal-actions">
        <button @click="closeDetail" class="action-btn">关闭</button>
        <button @click="copyToClipboard" class="action-btn secondary">复制全文</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PoemDetail',
  props: {
    poem: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      currentPoem: {}
    }
  },
  watch: {
    poem: {
      immediate: true,
      handler(newPoem) {
        if (newPoem) {
          this.currentPoem = { ...newPoem }
          // 为诗词添加更多详细信息
          this.enrichPoemData()
        }
      }
    }
  },
  methods: {
    enrichPoemData() {
      // 为诗词添加翻译和注释信息
      const poemEnrichments = {
        '静夜思': {
          translation: '明亮的月光洒在床前，好像地上泛起了一层霜。我禁不住抬起头来，看那天窗外空中的一轮明月，不由得低头沉思，想起远方的家乡。',
          notes: '这首诗写的是在寂静的月夜思念家乡的感受。诗的前两句，是写诗人在作客他乡的特定环境中一刹那间所产生的错觉。'
        },
        '春望': {
          translation: '长安沦陷，国家破碎，只有山河依旧；春天来了，人烟稀少的长安城里草木茂密。感伤国事，不禁涕泪四溅，鸟鸣惊心，徒增离愁别恨。',
          notes: '这首诗全篇情景交融，感情深沉，而又含蓄凝练，言简意赅，充分体现了“沉郁顿挫”的艺术风格。'
        },
        '水调歌头': {
          translation: '明月从什么时候才开始出现的？我端起酒杯遥问苍天。不知道在天上的宫殿，何年何月。我想要乘御清风回到天上，又恐怕在美玉砌成的楼宇，受不住高耸九天的寒冷。',
          notes: '此词是中秋望月怀人之作，表达了对胞弟苏辙的无限怀念。词人运用形象描绘手法，勾勒出一种皓月当空、亲人千里、孤高旷远的境界氛围。'
        },
        '声声慢': {
          translation: '苦苦地寻寻觅觅，却只见冷冷清清，怎不让人凄惨悲戚。秋天总是忽然变暖，又转寒冷，最难保养休息。',
          notes: '作品通过描写残秋所见、所闻、所感，抒发自己因国破家亡、天涯沦落而产生的孤寂落寞、悲凉愁苦的心绪。'
        },
        '将进酒': {
          translation: '你难道看不见那黄河之水从天上奔腾而来，波涛翻滚直奔东海，从不再往回流。你难道看不见那年迈的父母，对着明镜悲叹自己的白发，早晨还是满头的黑发，怎么才到傍晚就变成了雪白一片。',
          notes: '这首诗非常形象地表现了李白桀骜不驯的性格：一方面对自己充满自信，孤高自傲；一方面在政治前途出现波折后，又流露出纵情享乐之情。'
        },
        '登高': {
          translation: '风急天高猿猴啼叫显得十分悲哀，水清沙白的河洲上有鸟儿在盘旋。无边无际的树木萧萧地飘下落叶，望不到头的长江水滚滚奔腾而来。',
          notes: '全诗通过登高所见秋江景色，倾诉了诗人长年漂泊、老病孤愁的复杂感情，慷慨激越、动人心弦。'
        },
        '念奴娇·赤壁怀古': {
          translation: '大江浩浩荡荡向东流去，滔滔巨浪淘尽千古英雄人物。那旧营垒的西边，人们说那就是三国周瑜鏖战的赤壁。',
          notes: '此词通过对月夜江上壮美景色的描绘，借对古代战场的凭吊和对风流人物才略、气度、功业的追念，曲折地表达了作者怀才不遇、功业未就、老大未成的忧愤之情。'
        },
        '如梦令': {
          translation: '时常记起溪边亭中游玩至日色已暮，沉迷在优美的景色中忘记了回家的路。尽了酒宴兴致才乘舟返回，不小心进入藕花深处。',
          notes: '这首小令用词简练，只选取了几个片断，把移动着的风景和作者怡然的心情融合在一起，写出了作者青春年少时的好心情。'
        },
        '琵琶行': {
          translation: '夜晚在浔阳江头送别友人，枫叶荻花在秋风中瑟瑟作响。主人和客人下马在船上饯别设宴，举起酒杯要饮却无助兴的音乐。',
          notes: '这首诗通过写琵琶女生活的不幸，结合诗人自己在宦途所受到的打击，唱出了“同是天涯沦落人，相逢何必曾相识”的心声。'
        },
        '青玉案·元夕': {
          translation: '像东风吹散千树繁花一样，又吹得烟火纷纷、乱落如雨。豪华的马车满路芳香。悠扬的凤箫声四处回荡，玉壶般的明月渐渐西斜，一夜鱼龙灯飞舞笑语喧哗。',
          notes: '此词从极力渲染元宵节绚丽多彩的热闹场面入手，反衬出一个孤高淡泊、超群拔俗、不同于金翠脂粉的女性形象。'
        }
      }
      
      if (poemEnrichments[this.currentPoem.title]) {
        Object.assign(this.currentPoem, poemEnrichments[this.currentPoem.title])
      }
    },
    
    closeDetail() {
      this.$emit('close')
    },
    
    async copyToClipboard() {
      const fullText = `${this.currentPoem.title}\n${this.currentPoem.author}（${this.currentPoem.dynasty}）\n\n${this.currentPoem.content.join('\n')}`
      
      try {
        await navigator.clipboard.writeText(fullText)
        alert('诗词已复制到剪贴板！')
      } catch (err) {
        console.error('复制失败:', err)
        // 降级方案
        const textArea = document.createElement('textarea')
        textArea.value = fullText
        document.body.appendChild(textArea)
        textArea.select()
        document.execCommand('copy')
        document.body.removeChild(textArea)
        alert('诗词已复制到剪贴板！')
      }
    }
  }
}
</script>

<style scoped>
.poem-detail-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 1rem;
}

.poem-detail-modal {
  background: white;
  border-radius: 15px;
  max-width: 600px;
  width: 100%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #eee;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 15px 15px 0 0;
}

.modal-header h2 {
  margin: 0;
  font-size: 1.5rem;
}

.close-btn {
  background: none;
  border: none;
  color: white;
  font-size: 2rem;
  cursor: pointer;
  padding: 0;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
}

.poem-info {
  padding: 1.5rem;
  background: #f8f9fa;
  border-bottom: 1px solid #eee;
}

.info-item {
  display: flex;
  margin-bottom: 0.5rem;
}

.info-item:last-child {
  margin-bottom: 0;
}

.label {
  font-weight: 600;
  color: #555;
  min-width: 60px;
}

.value {
  color: #333;
}

.poem-content {
  padding: 1.5rem;
}

.content-section {
  margin-bottom: 2rem;
}

.content-section:last-child {
  margin-bottom: 0;
}

.content-section h3 {
  color: #667eea;
  margin-bottom: 1rem;
  font-size: 1.2rem;
  border-left: 4px solid #667eea;
  padding-left: 0.75rem;
}

.poem-text {
  line-height: 2;
  font-size: 1.1rem;
  color: #2c3e50;
}

.poem-line {
  margin: 0.5rem 0;
  text-align: center;
}

.translation-text, .notes-text {
  line-height: 1.6;
  color: #555;
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 5px;
  border-left: 3px solid #667eea;
}

.modal-actions {
  padding: 1.5rem;
  border-top: 1px solid #eee;
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
}

.action-btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.action-btn:first-child {
  background: #667eea;
  color: white;
}

.action-btn:first-child:hover {
  background: #5a6fd8;
}

.action-btn.secondary {
  background: #f8f9fa;
  color: #333;
  border: 1px solid #ddd;
}

.action-btn.secondary:hover {
  background: #e9ecef;
}

@media (max-width: 768px) {
  .poem-detail-modal {
    margin: 1rem;
    max-height: 85vh;
  }
  
  .modal-actions {
    flex-direction: column;
  }
  
  .action-btn {
    width: 100%;
  }
}
</style>