import { router } from '@kit.ArkUI'

@Component
export struct EcDeviceTip {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 提示类型
  type: 'success' | 'fail' = 'success'
  // 提示文案
  message: string = ''
  // 关闭跳转地址
  closeUrl: string = 'pages/Index'
  // 正常跳转地址和按钮文字
  url: string = ''
  btnText: string = '继续安装'

  build() {
    Column() {
      // 关闭页面
      Row() {
        Image($r('app.media.btn_clean'))
          .width(24)
          .aspectRatio(1)
      }
      .width('100%')
      .padding({ left: 24 })
      .height(56)
      .onClick(() => {
        router.pushUrl({ url: this.closeUrl }, () => {
          router.clear()
        })
      })

      // 提示
      Column() {
        Image(this.type === 'success' ? $r("app.media.img_success") : $r("app.media.img_fail"))
          .width(152)
          .aspectRatio(1)
          .margin({ top: 20, bottom: 15 })
        Text(this.message)
          .fontColor($r('app.color.yk_mid_19'))
          .fontSize(18)
          .fontWeight(600)
        Button(this.btnText)
          .margin({ top: 50 })
          .width(230)
          .height(40)
          .backgroundColor($r('app.color.yk_main_color'))
          .onClick(() => {
            if (this.url) {
              router.pushUrl({ url: this.url }, () => {
                router.clear()
              })

            } else {
              router.back()
            }
          })
      }
      .width('100%')
      // .layoutWeight(1)
      .backgroundColor('#fff')
    }
    .width('100%')
    .padding({ top: this.topHeight })
    // .height('100%')
    .backgroundColor($r('app.color.yk_mid_bg'))
  }
}