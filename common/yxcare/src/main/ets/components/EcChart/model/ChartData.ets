import Config from '../constants/Config'
import ChartLineData from './ChartLineData'

export class ChartData {
  //x轴描述数组
  xAxis: string[] = []
  xAlias: string[] = []
  xLabel?: string[] = []
  //y周数据数组
  yAxis: ChartLineData[] = []
  //x周描述步长
  timeStep: number = 2

  constructor() {
  }

  // 设置x轴数据
  setXAis(xAxis: string[]) {
    this.xAxis = xAxis
  }

  // 设置x轴别名数据
  setXAlias(xAlias: string[]) {
    this.xAlias = xAlias
  }

  // 设置横轴数据标签名，用于血糖数据
  setXLabel(xLabel?: string[]) {
    this.xLabel = xLabel
  }

  // 设置y轴数据
  setYAis(yAxis: ChartLineData[]) {
    this.yAxis = yAxis
  }

  // 设置步长
  setTimeStep(timeStep: number) {
    this.timeStep = timeStep
    // Config.TIME_STEP = this.timeStep
  }
}
