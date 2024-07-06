import { legendItem } from '../types/api'

@Component
export struct TipsView {
  @Prop tipsDesc: string
  @Prop legend: legendItem[]

  build() {
    Column() {
      Row() {
        Text(this.tipsDesc)
          .fontSize(10)
          .fontColor('#191919')
      }
      .margin({ bottom: 10 })

      Row() {
        ForEach(this.legend, (item: legendItem, index: number) => {
          Text("")
            .margin({ right: 6 })
            .textAlign(TextAlign.Center)
            .fontSize(10)
            .fontColor('#191919')
            .backgroundColor(item.color)
            .borderRadius(5)
            .width(5)
            .height(5)
          Text(item.name)
            .fontSize(10)
            .fontColor('#191919')
            .margin({ right: index == 0 ? 16 : 0 })
        }, (item: legendItem) => JSON.stringify(item))
      }
    }
    .width('100%')
    .padding({ bottom: 15 })
    .backgroundColor('#f7f7f9')
  }
}

