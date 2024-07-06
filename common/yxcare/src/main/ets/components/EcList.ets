/**
 * 例子
 import { EcList } from '@ohos/common'

 class Params {
 page: number = 1
 pageSize: number = 10
 }

 @Component
 export struct StateListDemo {
 // 1. 列表
 @State
 list: number[] = []
 // 请求参数
 params: Params = { page: 1, pageSize: 10 }
 // 加载状态
 @State
 finished: boolean = false
 // 加载中loading
 @State
 loading: boolean = false
 // 刷新中
 @State
 isRefreshing: boolean = false
 // 触底加载数据
 load = () => {
 if (this.loading || this.finished) return
 this.loading = true
 // 请求数据
 setTimeout(() => {
 for (let index = 0; index < this.params.pageSize; index++) {
 this.list.push(this.list.length + 1)
 }
 this.loading = false
 // 判断是否还有更多
 if (this.list.length === 30) {
 this.finished = true
 } else {
 this.params.page++
 }

 }, 1000)
 }
 // 刷新列表
 refresh = () => {
 setTimeout(() => {
 //  重置列表和状态
 this.loading = false
 this.finished = false
 this.list = []
 // 重置请求参数
 this.params.page = 1
 this.list = Array.from(new Array(10))
 .map((item: null, i: number) => i + 1)
 // 关闭刷新状态
 this.isRefreshing = false
 }, 2000)
 }

 build() {
 Column() {
 EcList({
 loading: this.loading,
 finished: this.finished,
 isRefreshing: $isRefreshing,
 load: this.load,
 refresh: this.refresh
 }) {
 ForEach(this.list, (item: number) => {
 ListItem() {
 Column({ space: 14 }) {
 Row() {
 Text('李玉虎')
 .fontColor($r('app.color.yk_mid_black'))
 .fontSize($r('app.float.yk_page_title_font_size'))
 .fontWeight(500)
 .margin({ bottom: 5 })

 Button('护理计划内')
 .height(20)
 .borderRadius(10)// 计划外 bg：#FFF0D9
 .backgroundColor('#DBF0FF')
 .fontColor($r('app.color.yk_sub_blue'))
 .fontSize($r('app.float.yk_small_font_size'))
 }
 .width('100%')
 .justifyContent(FlexAlign.SpaceBetween)

 Row() {
 Text('期望服务时间：2023年8月2日14:00')
 .fontColor($r('app.color.yk_mid_59'))
 .fontSize(13)
 }
 .width('100%')

 // 备注
 Row() {
 Text('喂饭的时候用老人自己的餐具，喂饭的时候用老人自己的餐具，喂饭的时候用老人自己的餐具')
 .fontSize($r('app.float.yk_small_font_size'))
 .fontColor('#50A0D8')
 .lineHeight(20)
 }
 .width('100%')
 .backgroundColor('#E9F6FF')
 .borderRadius(5)
 .padding({ left: 10, right: 10, top: 5, bottom: 8 })


 Row() {
 Button('取消')
 .height(28)
 .fontSize($r('app.float.yk_small_font_size'))
 .fontColor($r('app.color.yk_main_color'))
 .backgroundColor('#fff')
 Button('改期')
 .height(28)
 .fontSize($r('app.float.yk_small_font_size'))
 .fontColor($r('app.color.yk_main_color'))
 .backgroundColor('#fff')
 Button('执行')
 .height(28)
 .fontSize($r('app.float.yk_small_font_size'))
 .fontColor('#fff')
 .backgroundColor($r('app.color.yk_main_color'))
 }
 .width('100%')
 .justifyContent(FlexAlign.End)
 }
 .width('100%')
 .borderRadius($r('app.float.yk_normal_radius'))
 .backgroundColor($r('app.color.yk_mid_white'))
 .padding({ left: 14, right: 14, top: 10, bottom: 10 })
 }
 })
 }
 }
 .layoutWeight(1)
 .padding({ left: 15, right: 15 })

 }
 */
import promptAction from '@ohos.promptAction'
import { ResManager } from '../utils'

@Component
export struct EcList {
  sticky: StickyStyle = StickyStyle.None
  // 是否自动加载
  @Prop
  autoLoad: boolean = true
  @State
  refreshStatus: RefreshStatus = RefreshStatus.Inactive
  // 文字提示
  loadingText: string = '加载中...'
  finishedText: string = '没有更多了~'
  gutter: number = 10
  // 加载中loading
  @Prop
  loading: boolean = false
  // 是否加载完成
  @Prop
  finished: boolean = false
  // 刷新中
  // 双向绑定
  @Link
  isRefreshing: boolean
  // 列表数据
  @BuilderParam
  listContent: () => void = this.DefaultListContent

  // 默认Builder
  @Builder
  DefaultListContent() {
    ListItem() {
      Text('列表...')
    }
  }

  // 触底加载数据
  load: () => void = () => {
  }
  // 刷新列表
  refresh: () => void = () => {
  }

  // 加载交互
  @Builder
  LoadingBuilder() {
    if (this.finished) {
      Row() {
        Text(this.finishedText)
          .fontColor(ResManager.EC_MID_99)
          .fontSize(ResManager.EC_NORMAL_FS)
      }
      .width('100%')
      .height(50)
      .justifyContent(FlexAlign.Center)
    } else {
      if (this.loading) {
        Row() {
          LoadingProgress()
            .width(24)
            .margin({ right: 5 })
          Text(this.loadingText)
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_NORMAL_FS)
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
      }
    }
  }

  refreshStatusTxt() {
    switch (this.refreshStatus) {
      case RefreshStatus.Drag:
        return '下拉刷新'
      case RefreshStatus.OverDrag:
        return '释放刷新'
      case RefreshStatus.Refresh:
        return '刷新中...'
      default:
        return ''
    }
  }

  @Builder
  RefreshBuilder() {
    Row() {
      Progress({ value: 0, total: 100, type: ProgressType.Ring })
        .width(20)
        .color(ResManager.EC_MAIN_COLOR)
        .style({
          strokeWidth: 20,
          status: this.refreshStatus === RefreshStatus.Refresh ? ProgressStatus.LOADING : ProgressStatus.PROGRESSING
        })
        .margin({ right: 10 })
      Text(this.refreshStatusTxt())
        .fontColor(ResManager.EC_MID_59)
        .fontSize(ResManager.EC_NORMAL_FS)
    }
    .margin(30)
  }

  // aboutToAppear() {
  //   this.autoLoad && this.load()
  // }

  build() {
    // 下拉刷新，上拉加载
    Column() {
      // list
      // Refresh({ refreshing: $$this.isRefreshing }) {
      Refresh({ refreshing: $$this.isRefreshing, builder: this.RefreshBuilder() }) {
        List({ space: this.gutter }) {
          // 列表
          this.listContent()
          // 加载状态
          if (this.refreshStatus !== RefreshStatus.Refresh) {
            ListItem() {
              this.LoadingBuilder()
            }
          }
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .sticky(this.sticky)
        // .padding({ left: 15, right: 15 })
        .onReachEnd(() => {
          this.autoLoad && this.load()
        })
      }
      // 下拉刷新状态
      .onStateChange((refreshStatus: RefreshStatus) => {
        this.refreshStatus = refreshStatus
        console.info('Refresh onStatueChange state is ' + refreshStatus)
        if (refreshStatus === RefreshStatus.Done) {
          promptAction.showToast({
            message: '刷新成功'
          })
        }
      })
      .onRefreshing(() => {
        this.refresh()
      })
      .width('100%')
      .height('100%')
    }
    .width('100%')
    // .height('100%')
    .layoutWeight(1)
  }
}