import {ChartData} from '../model/ChartData';

@Component
export struct ValueView {
  @State timeDesc: string = ""
  @State labelDesc: string = ""
  @State valueDesc: string = ""
  @Link unitDesc: string
  @Link @Watch("refresh") dataSource: ChartData
  @Link @Watch("refresh") index: number
  @Consume curTimeStamp: number

  refresh() {
    this.timeDesc = this.dataSource.xAlias[this.index]
    this.labelDesc = this.dataSource.xLabel ? this.dataSource.xLabel[this.index] : ''
    const match = this.timeDesc.match(/(\d{4})年(\d{2})月(\d{2})日/);
    if (match) {
      // 将匹配到的年、月、日部分组合为目标格式
      const formattedDateStr = `${match[1]}-${match[2]}-${match[3]}`;
      this.curTimeStamp = new Date(formattedDateStr).getTime()
    } else {
      console.log("日期格式不正确");
    }

    let desc = ""
    this.dataSource.yAxis.forEach((data, _) => {
      const value = data.getDrawPoints()[this.index]
        .value
      if (value <= 0) {
        desc += "--/"
      } else {
        desc += data.getDrawPoints()[this.index]
          .value + "/"
      }
    })
    desc = desc.substring(0, desc.length - 1);
    this.valueDesc = desc
  }

  build() {
    Column() {
      Text(this.timeDesc)
        .fontSize(13)
        .fontColor('#999999')
      RelativeContainer() {
        Text(this.labelDesc)
          .id("text0")
          .fontSize(13)
          .fontColor('#191919')
          .fontWeight(FontWeight.Bold)
          .alignRules({
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
            right: { anchor: "text1", align: HorizontalAlign.Start }
          })
          .margin({ right: 9 })

        Text(this.valueDesc)
          .id("text1")
          .fontSize(26)
          .fontColor('#191919')
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            middle: { anchor: "__container__", align: HorizontalAlign.Center }
          })
        Text(this.unitDesc)
          .id("text2")
          .fontSize(13)
          .fontColor('#191919')
          .fontWeight(FontWeight.Bold)
          .alignRules({
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
            left: { anchor: "text1", align: HorizontalAlign.End }
          })
          .margin({ left: 4 })
      }
      .width('100%')
      .height(36)

      // Text("偏高")
      //   .fontSize(12)
      //   .fontColor('#FFAB2D')
      //   .margin({ top: 7.5 })
      //   .backgroundColor("#FFF0D9")
      //   .width(37)
      //   .height(20)
      //   .textAlign(TextAlign.Center)
      //   .borderRadius(10)
    }
    .margin({ top: 5 })
  }
}

