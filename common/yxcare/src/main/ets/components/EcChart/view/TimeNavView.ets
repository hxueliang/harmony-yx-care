import Config from '../constants/Config'
import { TimeMode } from '../constants/TimeMode'
import window from '@ohos.window';
import { ResManager } from '../../../utils';

let context = getContext(this);

@Component
export struct TimeNavView {
  @Consume curTimeStamp: number //当前时间戳
  private timeMode = 0 //时间格式，日、周
  private selectedDate: Date = new Date() //选中的时间
  onTimeChange?: (time: number, startTime: string, endTime: string) => void //回调函数
  uiContext?: UIContext
  startTime: string = ''
  endTime: string = ''

  aboutToAppear() {
    window.getLastWindow(context)
      .then((windowClass: window.Window) => {
        this.uiContext = windowClass.getUIContext();
      })
      .catch((error: Error) => {
      })
  }

  build() {
    RelativeContainer() {
      RelativeContainer() {
        Image(ResManager.IC_ARROW_LEFT)
          .id("image_left")
          .width(7)
          .height(14)
          .onClick(() => {
            this.changeTime(-1)
          })
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            middle: { anchor: "__container__", align: HorizontalAlign.Center }
          })
      }
      .id("rel_1")
      .width(12)
      .height(24)
      .margin({ left: 15 })
      .alignRules({
        center: { anchor: "__container__", align: VerticalAlign.Center },
        left: { anchor: "__container__", align: HorizontalAlign.Start }
      })

      Text(this.getTimeStr())
        .fontSize(15)
        .fontColor("#999999")
        .onClick(() => {

          this.uiContext?.showDatePickerDialog({
            start: new Date("2000-1-1"),
            end: new Date("2100-12-31"),
            selected: new Date(this.curTimeStamp),
            onAccept: (value: DatePickerResult) => {
              this.curTimeStamp = new Date(Number(value.year), Number(value.month), Number(value.day)).getTime()
              this.getTimeStr()
              this.onTimeChange && this.onTimeChange(this.curTimeStamp, this.startTime, this.endTime)
              console.info("DatePickerDialog:onAccept()" + JSON.stringify(value))
            },
          })
        })
        .alignRules({
          center: { anchor: "__container__", align: VerticalAlign.Center },
          middle: { anchor: "__container__", align: HorizontalAlign.Center }
        })
        .id("text")

      Image(ResManager.IC_DOWN)
        .width(12)
        .aspectRatio(1.4)
        .id("image_arrow")
        .alignRules({
          center: { anchor: "__container__", align: VerticalAlign.Center },
          left: { anchor: "text", align: HorizontalAlign.End }
        })
        .onClick(() => {
          this.changeTime(-1)
        })
        .margin({ left: 9 })

      RelativeContainer() {
        Image(ResManager.IC_ARROW_RIGHT)
          .width(7)
          .height(14)
          .id("image_right")
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            middle: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .margin({ right: 16 })
          .onClick(() => {
            this.changeTime(1)
          })
      }
      .id("rel_2")
      .width(12)
      .height(24)
      .margin({ right: 15 })
      .alignRules({
        center: { anchor: "__container__", align: VerticalAlign.Center },
        right: { anchor: "__container__", align: HorizontalAlign.End }
      })
    }
    .width(Config.FULL_PERCENT)
    .height(24)
    .margin({ top: 12 })
    .onAppear(() => this.onTimeChange && this.onTimeChange(this.curTimeStamp, this.startTime, this.endTime))
  }

  /**
   * 日期"翻页"功能
   * 天：上一天下一天 +- 24 * 60 * 60 * 1000
   * 轴：上一周下一周 +- 7 * 24 * 60 * 60 * 1000
   * */
  changeTime(direction: number) {
    switch (this.timeMode) {
      case TimeMode.Day:
        this.getDayBounds(24 * 60 * 60 * 1000 * direction)
        break;
      case TimeMode.Week:
        this.getWeekBounds(7 * 24 * 60 * 60 * 1000 * direction)
        break;
      default:
        break;
    }

    if (this.onTimeChange) {
      this.onTimeChange(this.curTimeStamp, this.startTime, this.endTime)
    }
  }

  /**
   * 将当前时间戳转换为字符串
   * */
  getTimeStr(): string {
    switch (this.timeMode) {
      case TimeMode.Day:
        return this.getDayBounds(0)
      case TimeMode.Week:
        return this.getWeekBounds(0)
      default:
        return ""
    }
  }

  fillZero(time: number) {
    return time < 10 ? '0' + time : time
  }

  /**
   * 获取天时间
   * */
  getDayBounds(delX: number) {
    this.curTimeStamp = this.curTimeStamp + delX

    let date = new Date(this.curTimeStamp)
    const year: number = date.getFullYear();
    const month: number = date.getMonth() + 1;
    const day: number = date.getDate();
    const weekdays: string[] = ['日', '一', '二', '三', '四', '五', '六'];
    const weekday: string = weekdays[date.getDay()];
    this.startTime = `${year}-${this.fillZero(month)}-${this.fillZero(day)}`;
    this.endTime = `${year}-${this.fillZero(month)}-${this.fillZero(day)}`;
    return `${year}年${month}月${day}日`;
  }

  /**
   * 获取周时间
   * */
  getWeekBounds(delX: number) {
    this.curTimeStamp = this.curTimeStamp + delX

    let date = new Date(this.curTimeStamp)
    const offset: number = (date.getDay() + 6) % 7;
    // 计算本周开始的日期
    const startDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - offset);
    // 计算本周结束的日期
    const endDate = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + 6);
    // 格式化日期字符串
    const startYear: number = startDate.getFullYear();
    const startMonth: number = startDate.getMonth() + 1;
    const startDay: number = startDate.getDate();

    const endYear: number = endDate.getFullYear();
    const endMonth: number = endDate.getMonth() + 1;
    const endDay: number = endDate.getDate();

    // 拼接开始时间和结束时间字符串
    const startTime: string = `${startYear}年${startMonth}月${startDay}日`;
    const endTime: string = `${endYear}年${endMonth}月${endDay}日`;

    this.startTime = `${startYear}-${this.fillZero(startMonth)}-${this.fillZero(startDay)}`
    this.endTime = `${endYear}-${this.fillZero(endMonth)}-${this.fillZero(endDay)}`;

    return startTime + "-" + endTime;
  }
}


