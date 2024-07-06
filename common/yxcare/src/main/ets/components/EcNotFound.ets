import { ResManager } from '../utils'

@Component
export struct EcNotFound {
  tip: string = '暂无相关内容哦～'

  build() {
    Column() {
      Image(ResManager.IC_ZWNR)
        .width(160)
        .height(144)
      Text(this.tip)
        .fontSize(ResManager.EC_NORMAL_FS)
        .fontColor(ResManager.EC_MID_59)
        .margin({ top: 20 })
    }
  }
}