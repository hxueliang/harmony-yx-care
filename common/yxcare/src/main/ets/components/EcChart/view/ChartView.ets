import DrawModel from '../model/DrawModel'
import {ChartData} from '../model/ChartData';
import { legendItem } from '../types/api'
import { TipsView } from './TipsView'

let context = getContext(this);

interface ContainerSize {
  width: string;
  height: string;
}


@Component
export struct ChartView {
  // 开启抗锯齿
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  // canvas 绘制对象
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  // 绘制Model
  private drawModel: DrawModel = new DrawModel(this.canvasContext);
  // 鼠标按下时的x坐标
  private lastDownX = 0;
  onSelected?: (index: number) => void
  // 监听数据源变化的时候，刷新数据
  @Link @Watch('refresh') dataSource: ChartData
  @State screenWidth: number = 350
  @State screenHeight: number = 0;
  @Prop tipsDesc: string
  @Prop legend: legendItem[]
  @Link @Watch('updateHighlightIndex') selectedIndex: number

  aboutToAppear() {
    this.drawModel.onSelected((index: number) => {
      if (this.onSelected) {
        this.onSelected(index)
      }
    })
  }

  updateHighlightIndex() {
    // 更新高亮的下标
    this.drawModel.setHighlightIndex(this.selectedIndex)
    // moveLineX 进入初始化状态
    this.drawModel.initMoveLineCurX()

    this.draw()
  }

  refresh() {
    // 存数据源
    this.drawModel.setDataSource(this.dataSource)
    // 进行绘制
    this.draw()
  }

  draw() {
    this.drawModel.draw(this.canvasContext, this.screenWidth, this.screenHeight);
  }

  build() {
    Column() {
      Row() {
        Column() {
          Canvas(this.canvasContext)
            .width(this.screenWidth)
            .height(250)
            .onReady(() => {
              setTimeout(() => {
                this.updateHighlightIndex()
              }, 0)
            })
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                //手指按下时设置移动线条应该所处的位置
                this.lastDownX = event.touches[0].x
                // 更新移动的x坐标
                this.drawModel.setMoveLineCur(this.lastDownX, 'move')
              }
              if (event.type === TouchType.Move) {
                let moveX = event.touches[0].x
                // 更新移动的x坐标
                this.drawModel.setMoveLineCur(moveX, 'move')
                this.drawModel.draw(this.canvasContext, this.screenWidth, this.screenHeight)
              }
              if (event.type === TouchType.Up) {
                let moveX = event.touches[0].x
                // 更新移动的x坐标
                this.drawModel.setMoveLineCur(moveX, 'up')
                this.drawModel.draw(this.canvasContext, this.screenWidth, this.screenHeight)
              }
            })
        }
        .width('100%')
      }
      .onAppear(() => {
        const containerSize = JSON.parse(getInspectorByKey('container'))
          .$attrs
          .size as ContainerSize;
        this.screenWidth = Number(containerSize.width.split('v')[0])
        this.screenHeight = Number(containerSize.height.split('v')[0])
      })
      .id('container')

      TipsView({ tipsDesc: this.tipsDesc, legend: this.legend })

    }

  }
}
