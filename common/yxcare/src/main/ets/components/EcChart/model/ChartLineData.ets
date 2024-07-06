import HeartData from './HeartData'

export default class ChartLineData {
  private name: string; // 描述
  private color: string; // 数值
  private points: number[] = [] //y轴的数据集合
  private drawPoints: HeartData[] = [] // 绘制的数据集合

  constructor(name: string, color: string, points: number[]) {
    this.name = name
    this.color = color
    this.points = points
    this.convert(points)
  }

  // 根据传递的数据，转换为绘制的数据
  convert(points: number[]) {
    this.drawPoints = []
    points.forEach((data, index) => {
      const item = new HeartData(data)
      this.drawPoints.push(item)
    })
  }

  // 获取绘制数据集合
  getDrawPoints() {
    return this.drawPoints
  }

  // 获取配置颜色
  getColor() {
    return this.color
  }

  // 获取配置名称
  getName() {
    return this.name
  }
}
