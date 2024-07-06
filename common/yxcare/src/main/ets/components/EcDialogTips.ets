/**
 * demo:
 *
 lookDialog: CustomDialogController = new CustomDialogController({
 builder: EcDialogTips({
 title: '取消原因',
 // 解决 this 指向问题
 // tipsContent: () => {
 //   this.tipsContent()
 // },
 confirmButton: {
 text: '确定',
 // color:$r('app.color.yk_main_color'),
 cb: () => {

 }
 },
 cancelButton: {
 text: '取消',
 // color:'red',
 // cb:()=>{
 //
 // }
 }
 }),
 alignment: DialogAlignment.Center
 })
 */
class ButtonConfig {
  text: string = '我知道了'
  // $r('app.color.yk_mid_59') ｜ $r('app.color.yk_main_color')
  color?: ResourceStr = ''
  cb?: () => void = () => {
  }
}

@CustomDialog
export struct EcDialogTips {
  // 提示标题
  title: string = '提示'
  titleAlign: 'start' | 'center' = 'start'
  // 列表数据
  @BuilderParam
  tipsContent: () => void = this.DefaultTipsContent
  // 按钮配置
  // 确定
  confirmButton: ButtonConfig | null = null
  // 取消
  cancelButton: ButtonConfig | null = null

  // 默认Builder
  @Builder
  DefaultTipsContent() {
    Text('默认提示！')
  }

  // 控制器
  controller: CustomDialogController

  build() {
    Column() {
      //  1. 标题
      Row() {
        Text(this.title)
          // .fontColor($r('app.color.yk_mid_19'))#191919
          .fontColor('#191919')
          .fontSize(18)
          .fontWeight(500)
      }
      .width('100%')
      .justifyContent(this.titleAlign === 'start' ? FlexAlign.Start : FlexAlign.Center)
      .padding({ left: 18, right: 18 })
      .height(56)

      // 2. 提示内容
      this.tipsContent()

      // 分割线
      Divider()
        // .color($r('app.color.yk_mid_line'))
        .color('#E8E8E8')
        .margin({ left: 15, right: 15 })
      // 按钮
      Row() {
        // 取消
        Button(this.cancelButton?.text)
          .onClick(() => {
            // this.controller.close()
            this.cancelButton?.cb && this.cancelButton?.cb()
          })
            // .fontSize($r('app.float.yk_module_title_font_size'))
            .fontSize('16fp')
          .backgroundColor('transparent')
          // .fontColor(this.cancelButton?.color || $r('app.color.yk_mid_59'))
          .fontColor(this.cancelButton?.color || '#595959')

        // 确定
        if (this.confirmButton?.text) {
          Divider()
            .vertical(true)
            .height(24)
          // .color($r('app.color.yk_mid_99'))
          .color('#999999')

          Button(this.confirmButton?.text)
            .onClick(() => {
              // this.controller.close()
              this.confirmButton?.cb && this.confirmButton?.cb()
            })
              // .fontSize($r('app.float.yk_module_title_font_size'))
              .fontSize('16fp')
            .backgroundColor('transparent')
            // .fontColor(this.confirmButton?.color || $r('app.color.yk_main_color'))
            .fontColor(this.confirmButton?.color || '#00C4B3')
        }
      }
      .width('100%')
      .margin({ top: 10, bottom: 10 })
      .justifyContent(FlexAlign.SpaceAround)
    }
    .backgroundColor(null)
    .linearGradient(null)
  }
}
