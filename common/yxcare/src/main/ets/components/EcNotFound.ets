@Component
export struct EcNotFound {
  tip: string = '暂无相关内容哦～'

  build() {
    Column() {
      Image($r('app.media.ic_zwnr'))
        .width(160)
        .height(144)
      Text(this.tip)
        .fontSize($r('app.float.yk_normal_font_size'))
        .fontColor($r('app.color.yk_mid_59'))
        .margin({ top: 20 })
    }
  }
}