export default class HeartData {
  value: number;
  // 数值
  lineX: number = 0;
  // 横轴X值
  lineEndY: number = 0;
  // 纵轴Y值
  lineSpace: number = 0;

  //线条间距

  constructor(value: number) {
    this.value = value
  }

  setLineX(value: number) {
    this.lineX = value
  }

  setLineEndY(value: number) {
    this.lineEndY = value
  }

  setLineSpace(value: number) {
    this.lineSpace = value
  }
}
