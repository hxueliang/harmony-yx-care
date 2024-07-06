import Config from '../constants/Config'
import HeartData from './HeartData'
import ChartLineData from './ChartLineData'
import CheckEmptyUtils from '../constants/CheckEmptyUtils'
import {ChartData} from './ChartData'
import { findMaxMin, splitRange } from '../utils/number'

export default class DrawModel {
  private dataSource?: ChartData
  //数据源
  private moveLineCurX: number = -100
  //当前移动线条的位置
  public  screenWidth: number = 350;
  // 屏幕宽度
  private canvasContext: CanvasRenderingContext2D;
  private onSelectListener?: (index: number) => void
  //选中后回调给业务方
  private curSelected: number = -1
  // 当前选中的下标
  private lineSpaceValue: number = 0
  // 横向的间隔
  private lineMinValue: number = 0

  private highlightIndex: number =0
  // 最小值
  // private img: ImageBitmap = new ImageBitmap("slider.png")

  //底部波浪线图片

  constructor(canvasContext: CanvasRenderingContext2D) {
    this.canvasContext = canvasContext
  }

  onSelected(listener: (index: number) => void) {
    // 业务层选中节点的回调函数
    this.onSelectListener = listener
  }

  initMoveLineCurX(){
    this.moveLineCurX=-100
  }

  // 绘制方法
  draw(canvasContext: CanvasRenderingContext2D, screenWidth: number, screenHeight: number) {
    if (CheckEmptyUtils.isEmptyObj(canvasContext)) return

    this.canvasContext = canvasContext;
    this.screenWidth = screenWidth;
    this.canvasContext.clearRect(0, 0, this.canvasContext.width, this.canvasContext.height)

    this.canvasContext.save();
    this.canvasContext.translate(0, this.canvasContext.height);
    this.canvasContext.rotate(Math.PI);
    this.canvasContext.scale(-1, 1);

    this.drawBgLine()
    this.drawHeartLine()
    this.drawHeartLineShadow()
    this.drawMoveLine()
    this.drawHeartText()
    this.drawSelectStatus()
    this.drawWave()
    this.judgeSelect()

    this.canvasContext.restore();
  }

  // 获取x轴数据
  getXAis(): string[] {
    if (this.dataSource != null) {
      return this.dataSource.xAxis
    }
    return []
  }

  // 获取y轴数据
  getYAis(): ChartLineData[] {
    if (this.dataSource != null) {
      return this.dataSource.yAxis
    }
    return []
  }

  /**
   * 绘制横向血压线及文字
   * */
  drawBgLine() {
    // 绘制横线的x坐标开始和结束为止
    let hLineStartP = Config.MARGIN_LEFT
    let hLineEndP = this.screenWidth - Config.MARGIN_LEFT
    //   找出多条数据中的最大值和最小值
    //   绘制刻度值
    const YScaleValue = this.calculateYScaleValue()
    YScaleValue.forEach((item, index) => {
      //   绘制横线
      this.canvasContext.lineWidth = 0.5
      this.canvasContext.lineWidth = 0.5
      this.canvasContext.strokeStyle = Config.BG_LINE_COLOR
      this.canvasContext.beginPath()
      this.canvasContext.moveTo(hLineStartP, index * Config.BG_LINE_SPACE + Config.BG_LINE_OFFSET_Y + Config.RENDER_OFFSET)
      this.canvasContext.lineTo(hLineEndP, index * Config.BG_LINE_SPACE + Config.BG_LINE_OFFSET_Y + Config.RENDER_OFFSET)
      this.canvasContext.stroke()

      //   绘制刻度值
      this.canvasContext.font = Config.FONT_SIZE_NORMAL
      let textWidth = this.canvasContext.measureText(item.toString())
        .width
      let textHeight = this.canvasContext.measureText(item.toString())
        .height
      let textX = (this.screenWidth - Config.MARGIN_LEFT) - textWidth
      let textY = index * Config.BG_LINE_SPACE + Config.BG_LINE_OFFSET_Y + Config.RENDER_OFFSET + textHeight / 2
      this.canvasContext.fillStyle = Config.FONT_COLOR_NORMAL
      this.rotateText(this.canvasContext, item.toString(), textX, textY)

    })
  }

  // 计算右侧y轴的刻度值
  calculateYScaleValue(): number[] {
    let tempArr: number[] = []
    this.getYAis()
      .forEach((data) => {
        data.getDrawPoints()
          .forEach((item) => {
            tempArr.push(item.value)
          })
      })
    // 找出最大值和最小值， 整个折线图的上下要留空白， 所以进行暂定 50% 的浮动，可以进行实际情况修改这个值
    const array: number[] = findMaxMin(tempArr)
    const MinValue = array[1] * (1 - 0.5)
    const MaxValue = array[0] * (1 + 0.5)
    // 通过最大值和最小值，获取到右侧刻度集合
    const result = splitRange(MaxValue, MinValue)

    this.lineMinValue = result[0]
    this.lineSpaceValue = result[1] - result[0]
    return result
  }

  /**
   * 绘制柱状图
   * */
  drawHeartBar() {
    this.getYAis()
      .forEach((data, index) => {
        let lineWidth = 4
        let lineSize = data.getDrawPoints()
          .length
        let wSpace = (this.screenWidth - 2 * Config.MARGIN_LEFT - 2 * Config.LINE_MARGIN) / (lineSize - 1)

        data.getDrawPoints()
          .forEach((data, index) => {
            // 绘制血压条
            let lineX = wSpace * index + Config.MARGIN_LEFT + Config.LINE_MARGIN
            let endY = (data.value - this.lineMinValue) / this.lineSpaceValue * Config.BG_LINE_SPACE + Config.BG_LINE_OFFSET_Y + Config.RENDER_OFFSET
            let startY = Config.RENDER_OFFSET + 15
            this.canvasContext.lineWidth = lineWidth
            this.canvasContext.beginPath()
            this.canvasContext.moveTo(lineX, startY)
            this.canvasContext.lineTo(lineX, endY)
            this.canvasContext.stroke()
            data.setLineX(lineX)
            data.setLineEndY(endY)
            data.setLineSpace(wSpace)

            // 绘制圆点
            if (data.value > 0) {
              let centerX = lineX
              let centerY = endY; // 圆心 Y 坐标
              let radius = 2; // 圆的半径
              this.canvasContext.fillStyle = '#E42D5F'; // 填充颜色为红色
              this.canvasContext.beginPath();
              this.canvasContext.arc(centerX, centerY, radius, 0, 2 * Math.PI); // 绘制圆路径
              this.canvasContext.fill(); // 填充路径
            }
          })
      })
  }

  /**
   * 绘制血压数折线图
   * */
  drawHeartLine() {

    this.getYAis()
      .forEach((item, index) => {
        let lineSize = item.getDrawPoints()
          .length
        let wSpace = (this.screenWidth - 2 * Config.MARGIN_LEFT - 2 * Config.LINE_MARGIN) / (lineSize - 1)

        let cursor = 0
        item.getDrawPoints()
          .forEach((data, index) => {
            // 绘制血压条
            let lineX = wSpace * index + Config.MARGIN_LEFT + Config.LINE_MARGIN
            let endY = (data.value - this.lineMinValue) / this.lineSpaceValue * Config.BG_LINE_SPACE + Config.BG_LINE_OFFSET_Y + Config.RENDER_OFFSET
            data.setLineX(lineX)
            data.setLineEndY(endY)
            data.setLineSpace(wSpace)
            // 如果当前刻度有值，才会进行绘制， 如果值为空， 则跳过绘制
            if (data.value > 0) {
              // if (this.moveLineCurX < 0) {
              //   this.moveLineCurX = lineX
              // }
              if (this.moveLineCurX < 0 && this.highlightIndex == index) {
                // this.moveLineCurX = lineX
                this.setMoveLineCur(lineX, 'move')
              }
              if (cursor == 0) {
                this.canvasContext.beginPath()
                this.canvasContext.moveTo(lineX, endY)
              } else {
                this.canvasContext.lineTo(lineX, endY)
              }
              cursor += 1
            }
          })
        this.canvasContext.strokeStyle = item.getColor()
        this.canvasContext.lineWidth = 1
        this.canvasContext.stroke()
      })
  }

  /**
   * 绘制血压数折线图阴影
   * */
  drawHeartLineShadow() {
    const lineSize = this.getYAis()
      .length
    this.getYAis()
      .forEach((item, index) => {
        const path2Db: Path2D = new Path2D()
        let cursor = 0
        let startIndex = 0
        let lastIndex = 0

        //计算折线图最高最低位置
        let minValue = 0
        let maxValue = 0
        item.getDrawPoints()
          .forEach((data, index) => {
            // 绘制血压条绘制血压条
            if (data.value > 0) {
              if (cursor == 0) {
                this.canvasContext.beginPath()
                path2Db.moveTo(data.lineX, data.lineEndY)
                startIndex = index
                minValue = data.lineEndY
                maxValue = data.lineEndY
              } else {
                path2Db.lineTo(data.lineX, data.lineEndY)
              }
              lastIndex = index
              cursor += 1

              if (data.lineEndY < minValue) {
                minValue = data.lineEndY
              }
              if (data.lineEndY > maxValue) {
                maxValue = data.lineEndY
              }
            }
          })

        const firstLineY = Config.BG_LINE_OFFSET_Y + Config.RENDER_OFFSET
        let offset = 0
        if (lineSize > 1) {
          offset = minValue - 20
          if (offset < firstLineY) {
            offset = firstLineY
          }
        } else {
          offset = firstLineY
        }
        path2Db.lineTo(item.getDrawPoints()[lastIndex]
          .lineX, offset)
        path2Db.lineTo(item.getDrawPoints()[startIndex]
          .lineX, offset)
        path2Db.closePath()

        // note: 华为渐变着色问题，等待修复
        // const gradient = this.canvasContext.createLinearGradient(this.screenWidth / 2, offset, this.screenWidth / 2, maxValue);
        // const startColor = '#50ffffff'; // 渐变线的起始颜色
        // const endColor = "#" + "20" + item.getColor().replace("#", "");
        // gradient.addColorStop(0, startColor);
        // gradient.addColorStop(1, endColor);
        this.canvasContext.fillStyle = item.getColor()

        // this.canvasContext.fill(path2Db)
      })
  }

  /**
   * 绘制移动线条
   * */
  drawMoveLine() {
    const startColor = '#ffffff';
    const endColor = '#A27F90';

    let startY = 25 + Config.RENDER_OFFSET
    let endY = 210 + Config.RENDER_OFFSET
    const gradient = this.canvasContext.createLinearGradient(this.moveLineCurX, startY, this.moveLineCurX, endY);
    gradient.addColorStop(0, startColor);
    gradient.addColorStop(0.5, endColor);
    gradient.addColorStop(1, startColor);

    this.canvasContext.lineWidth = 1
    // this.canvasContext.strokeStyle = gradient
    this.canvasContext.strokeStyle = '#dcdcdc'
    this.canvasContext.beginPath()
    this.canvasContext.moveTo(this.moveLineCurX, startY)
    this.canvasContext.lineTo(this.moveLineCurX, endY)
    this.canvasContext.stroke()
  }

  /**
   * 绘制血压数值文本
   * */
  drawHeartText() {
    if (!this.getXAis()[0]) return
    let textWidth = this.canvasContext.measureText(this.getXAis()[0])
      .width

    // 最大能容纳多少个刻度文本值
    let maxTextCount = (this.screenWidth - 2 * Config.MARGIN_LEFT - 2 * Config.LINE_MARGIN) / textWidth
    // 根据能容纳最多个刻度文本值，  算出算出最大步长
    let timeStep = Math.floor(this.getXAis()
      .length / maxTextCount) * 2
    // 取最大步长
    timeStep = timeStep < this.dataSource!.timeStep ? this.dataSource!.timeStep : timeStep

    this.getXAis()
      .forEach((data, index) => {
        this.canvasContext.font = Config.FONT_SIZE_NORMAL
        // 获取x轴长度
        const lineSize = this.getXAis()
          .length
        // 获取每个横向间距
        let wSpace = (this.screenWidth - 2 * Config.MARGIN_LEFT - 2 * Config.LINE_MARGIN) / (lineSize - 1)
        let lineX = wSpace * index + Config.MARGIN_LEFT + Config.LINE_MARGIN
        //判断是否匹配步长，显示刻度
        let textWidth = this.canvasContext.measureText(data)
          .width

        if (this.dataSource != null && index % timeStep == 0) {
          let textX = lineX
          let textY = Config.RENDER_OFFSET + 8
          let offsetY = 0
          let distance = Math.abs(textX - this.moveLineCurX)
          if (distance < Config.TEXT_Y_OFFSET) {
            offsetY = (1 - (distance / Config.TEXT_Y_OFFSET)) * 18
          }
          if (distance < Config.TEXT_Y_OFFSET) {
            this.canvasContext.fillStyle = "#4B4B4B"
          } else {
            this.canvasContext.fillStyle = Config.FONT_COLOR_NORMAL
          }

          textY += offsetY
          this.rotateText(this.canvasContext, data, textX - textWidth / 2, textY)
        }
      })
  }

  /**
   * 选中血压条后红色球变大效果
   * */
  drawSelectStatus() {
    this.getYAis()
      .forEach((item, index) => {
        let selectedData: HeartData
        item.getDrawPoints()
          .forEach((data, index) => {
            let centerX = data.lineX
            let centerY = data.lineEndY
            if (centerX == this.moveLineCurX) {
              selectedData = data
              //外层白色圆环
              let radius1 = 4; // 圆的半径
              this.canvasContext.fillStyle = item.getColor(); // 填充颜色为红色
              this.canvasContext.beginPath();
              this.canvasContext.arc(centerX, centerY, radius1, 0, 2 * Math.PI); // 绘制圆路径
              this.canvasContext.fill(); // 绘制线条
            }
          })
      })
  }

  /**
   * 绘制波浪线
   */
  drawWaveByBgImg() {
    this.canvasContext.save();
    this.canvasContext.translate(0, 60)
    this.canvasContext.rotate(Math.PI)
    this.canvasContext.scale(-1, 1)
    this.canvasContext.fillRect(0, 50, 50, 50)
    // this.canvasContext.drawImage(this.img, this.moveLineCurX - 35, Config.RENDER_OFFSET, 70, 25)
    this.canvasContext.restore();

    // 绘制底部灰色背景
    this.canvasContext.fillStyle = Config.ARC_BG_COLOR
    this.canvasContext.fillRect(0, 0, this.screenWidth, Config.RENDER_OFFSET)

    // 绘制手势跟随小球
    let radius = 10
    const centerX = this.moveLineCurX
    const centerY = Config.RENDER_OFFSET
    this.canvasContext.fillStyle = '#FFFFFF';
    this.canvasContext.beginPath();
    this.canvasContext.arc(centerX, centerY, radius, 0, 2 * Math.PI); // 绘制圆路径
    this.canvasContext.fill(); // 绘制线条
  }


  /**
   * 绘制波浪线
   */
  drawWave() {
    this.canvasContext.save();
    this.canvasContext.translate(0, 60)
    this.canvasContext.rotate(Math.PI)
    this.canvasContext.scale(-1, 1)

    let waveLength = Config.WAVE_LENGTH
    const arcStartX = this.moveLineCurX - waveLength / 2
    const arcStartY = Config.RENDER_OFFSET

    const arcEndX = this.moveLineCurX + waveLength / 2

    const width = arcEndX - arcStartX
    const height = 16
    const startX = 0; // 起始 x 坐标
    const startY = height; // y 轴起始位置
    const amplitude = height / 2; // 振幅
    this.canvasContext.translate(0, 25)

    this.canvasContext.beginPath();
    this.canvasContext.moveTo(startX, startY)
    for (let deg = 0; deg < 360; deg++) {
      const x = arcStartX + width / 360 * deg
      const y = Math.cos(deg / 360 * 2 * Math.PI) * amplitude + amplitude

      this.canvasContext.lineTo(x, y)
    }
    this.canvasContext.closePath();
    this.canvasContext.fillStyle = Config.ARC_BG_COLOR
    this.canvasContext.fill();
    this.canvasContext.restore()
    // this.canvasContext.fillRect(0, 0, this.screenWidth, Config.RENDER_OFFSET)

    // 绘制底部灰色背景
    this.canvasContext.fillStyle = Config.ARC_BG_COLOR
    this.canvasContext.fillRect(0, 0, this.screenWidth, Config.RENDER_OFFSET)

    // 绘制手势跟随小球
    let radius = 10
    const centerX = this.moveLineCurX
    const centerY = Config.RENDER_OFFSET
    this.canvasContext.fillStyle = Color.White;
    this.canvasContext.beginPath();
    this.canvasContext.arc(centerX, centerY, radius, 0, 2 * Math.PI); // 绘制圆路径
    this.canvasContext.fill(); // 绘制线条
  }

  /**
   * 判断选中区域
   * */
  judgeSelect() {
    this.getYAis()
      .forEach((item, _) => {
        item.getDrawPoints()
          .forEach((data, index) => {
            if (this.moveLineCurX >= data.lineX - data.lineSpace / 2 && this.moveLineCurX < data.lineX + data.lineSpace / 2) {
              //回调业务层
              if (this.curSelected != index && this.onSelectListener) {
                this.onSelectListener(index)
              }
              this.curSelected = index
            }
          })
      })
  }

  /**
   * 设置数据源
   */
  setDataSource(data: ChartData) {
    this.dataSource = data
  }

  /**
   * 设置默认高亮下标
   */
  setHighlightIndex(index: number) {
    this.highlightIndex =index
  }

  /**
   * 根据touch事件设置移动线条最新位置
   * */
  setMoveLineCur(targetX: number, type: string) {
    this.moveLineCurX = this.judgeRange(targetX, type)
  }

  judgeRange(targetX: number, type: string): number {
    //增加吸附效果
    this.getYAis()
      .forEach((item, index) => {
        let lineSize = item.getDrawPoints()
          .length
        let wSpace = (this.screenWidth - 2 * Config.MARGIN_LEFT - 2 * Config.LINE_MARGIN) / (lineSize - 1)

        // 计算最多容纳多少条，吸附效果是比较好的
        let maxCount = (this.screenWidth - 2 * Config.MARGIN_LEFT - 2 * Config.LINE_MARGIN) / Config.ATTACH_OFFSET
        // 手指移动和松手的吸附临界值
        let offset = type == 'move' ? Config.ATTACH_OFFSET : wSpace / 2
        if (item.getDrawPoints()
          .length > maxCount) {
          offset = wSpace / 2
        }
        item.getDrawPoints()
          .forEach((data, index) => {
            let lineX = data.lineX
            let value = data.value
            if (type == 'move') {
              if (targetX >= lineX - offset && targetX <= lineX + offset && value > 0) {
                targetX = lineX
              }
            } else {
              if (targetX >= lineX - offset && targetX <= lineX + offset) {
                targetX = lineX
              }
            }
          })
      })

    //判断边界
    let rangeMinX = Config.MARGIN_LEFT + Config.LINE_MARGIN
    let rangeMaxX = this.screenWidth - Config.MARGIN_LEFT - Config.LINE_MARGIN
    if (targetX <= rangeMinX) {
      targetX = rangeMinX
    }
    if (targetX >= rangeMaxX) {
      targetX = rangeMaxX
    }

    return targetX
  }

  rotateText(ctx: CanvasRenderingContext2D, text: string, x: number, y: number) {
    ctx.save();
    ctx.translate(x, y)
    ctx.rotate(Math.PI)
    ctx.scale(-1, 1)
    ctx.fillText(text, 0, 0);
    ctx.restore();
  }
}

