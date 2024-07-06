export interface dataType {
  value: number
  type: number
}

export class TableDateType {
  date: string = ''
  value: dataType[] = []
}

@Component
export struct EcHealthRecord {
  @Link data: TableDateType[] // 血糖数据
  @Prop TableDate: string // 日期入参
  @State wt: number = 100 / 9 // 36.7 统一定义到宽度 - 多地方同步提出来方便修改

  build() {
    Column() {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Start,
      }) {
        // 定义表格的头
        TableHead({ wt: this.wt })
        Divider()
          .vertical(false)
          .color('#DCDDDC')
        // 定义表格的主体
        TableRow({ wt: this.wt, TableDate: this.TableDate, data: $data })
      }
      .width('100%')
      .height('100%')
      .border({
        width: 1,
        color: '#ccc'
      })
    }
    .width('100%')
    .padding({ top: 0, left: 10, right: 10, bottom: 10 })
  }
}

// 表头数据类型
interface headDataType {
  title: string
  child?: string[]
}

// 表格的头部
@Component
struct TableHead {
  @Prop wt: number
  // 表头数据
  private headData: headDataType[] = [
    { title: '日期' },
    { title: '凌晨' },
    { title: '早餐', child: ['空腹', '后'] },
    { title: '午餐', child: ['前', '后'] },
    { title: '晚餐', child: ['前', '后'] },
    { title: '睡前' },
  ]

  /*
   * 主要实现逻辑 变量表头的书 如果有child就 展示两行布局如果没有就直接单行布局
   * */
  build() {
    Column() {
      Flex({ direction: FlexDirection.Row }) {
        ForEach(this.headData, (item: headDataType, index) => {
          if (item.child) {
            Column() {
              Row() {
                Text(item.title)
                  .textAlign(TextAlign.Center)
                  .fontSize(12)
                  .width('100%')
                  .height(34)
                  .fontWeight(500)
              }

              Divider()
                .vertical(false)
                .color('#DCDDDC')
              Row() {
                ForEach(item.child, (it: string, ind) => {
                  Text(it)
                    .width('50%')
                    .textAlign(TextAlign.Center)
                    .fontSize(12)
                    .height(35)
                    .fontWeight(500)
                  if (ind == 0) {
                    Divider()
                      .vertical(true)
                      .height(35)
                      .color('#DCDDDC')
                  }
                })
              }
            }
            .width(this.wt * 2 + '%')
          } else {
            Column() {
              Text(item.title)
                .textAlign(TextAlign.Center)
                .fontSize(12)
                .width(12)
                .height(70)
            }
            .width(this.wt + '%')
          }
          if (index != 5) {
            Divider()
              .vertical(true)
              .color('#DCDDDC')
              .height(70)
          }
        })
      }
      .width('100%')
      .backgroundColor('#F4F6F7')
    }
    .width('100%')
  }
}

/*
 * 日期计算转换 - 主要功能是将
 * 入参:
 * currentDate:string 当前的月份
 * data:[{  当前月份的血糖数据
 *  date: '2024-01-04',
 *   value: [
 *     { value: 0, type :1  },
 *     { value: 0, type :1  },
 *     { value: 0, type :1  },
 *     { value: 5.4, type :2  },
 *     { value: 0, type :1  },
 *     { value: 0, type :1  },
 *     { value: 0, type :1  },
 *     { value: 0, type :1  }
 *   ]}]
 * */
// 表头数据
interface dataValueType {
  value: number
  type: number
}

// 处理数据的类型定义
interface tabListDataType {
  day: string
  week: string
  data: dataValueType[]
}

// 数据处理函数 - 将日期数据和后台的血糖值数据合并
function initTableDate(currentDate: string, data: TableDateType[]) {
  const date = new Date()
  const currentMonth = currentDate || date.getMonth() + 1
  const daysOfWeek = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  const dayNumber: number = new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
  const tabListData: tabListDataType[] = []
  // 按照传入的月份currentDate 将做侧的所需要的日期数据和当月的血糖数据data进行整合 最后输出一个完整数组
  for (let i = 1; i <= dayNumber; i++) {
    let dataValue: dataValueType[] = [
      { value: 0, type: 1 },
      { value: 0, type: 1 },
      { value: 0, type: 1 },
      { value: 0, type: 1 },
      { value: 0, type: 1 },
      { value: 0, type: 1 },
      { value: 0, type: 1 },
      { value: 0, type: 1 }
    ]
    let catchData: tabListDataType = {
      day: `${currentMonth}/${i}`,
      week: daysOfWeek[new Date(`${date.getFullYear()}-${currentMonth}-${i}}`).getDay()],
      data: dataValue
    }
    data.forEach(it => {
      const data = `${date.getFullYear()}-${currentMonth < 10 ? `0${currentMonth}` : currentMonth}-${i < 10 ? `0${i}` : i}`
      if (it.date == data) {
        catchData.data = it.value
      }
    })
    tabListData.push(catchData)
  }
  return tabListData
}

// 表格主题行列
@Component
struct TableRow {
  @Prop wt: number
  @Link @Watch('dateChange') data: TableDateType[] // 血糖数据 父组件传入的
  @Prop @Watch('dateChange') TableDate: string // 监听父组件传入的时间 对整个表格进行调整
  @State dateStr: string = '' // 当前时间的月份
  @State tabListData: tabListDataType[] = [] // 完整的表格数据 需要通过 initTableDate 进行处理后返回

  // 按照父组件传入数据进行整合
  dateChange() {
    const dataArr = this.TableDate.split('-')
    const nm = new Number(dataArr[1]) // 兼容 日期喂 2024-01 这种格式 默认格式2024-1
    if (dataArr && dataArr.length >= 2) {
      this.dateStr = nm.toString()
    }
    this.tabListData = initTableDate(this.dateStr, this.data)
  }

  // 生命周期  - 如果有默认参数 及直接执行 否会在日期选择数据传入的时候通过watch监听执行
  aboutToAppear(): void {
    if (this.TableDate) {
      this.dateChange()
    }
  }

  scroller: Scroller = new Scroller() // 滚动条
  private colNum: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9] // 列数据 - 主要用于循环出对应的表格

  /*
   * 这部分是表格的主体
   * 按日期循环行并填入对应的标题
   * 按照定义的列循环出每行的列 并填入对应的血糖数据
   * */
  build() {
    Scroll(this.scroller) {
      Column() {
        ForEach(this.tabListData, (item: tabListDataType) => {
          Flex({ direction: FlexDirection.Row }) {
            ForEach(this.colNum, (it: number, ind) => {
              if (ind === 0) {
                if (it % 2 == 0) {
                  Column() {
                    Text(item.week)
                      .fontSize(10)
                    Text(item.day)
                      .fontSize(12)
                      .fontColor('#999')
                  }
                  .width(this.wt + '%')
                  .height(35)
                } else {
                  Column() {
                    Text(item.week)
                      .fontSize(10)
                      .fontWeight(500)
                    Text(item.day)
                      .fontSize(10)
                      .fontColor('#999')
                  }
                  .backgroundColor('#F4F6F7')
                  .padding({ top: 7 })
                  .height(35)
                  .width(this.wt + '%')
                }
              } else {
                if (it % 2 == 0) {
                  Column() {
                    if (item.data[ind-1].type == 2) {
                      Text(!item.data[ind-1].value ? '' : String(item.data[ind-1].value))
                        .fontSize(14)
                        .fontColor('#0398FF')
                    } else {
                      Text(!item.data[ind-1].value ? '' : String(item.data[ind-1].value))
                        .fontSize(14)
                        .fontColor('#FFAB2D')
                    }
                  }
                  .width(this.wt + '%')
                  .height(35)
                  .justifyContent(FlexAlign.Center)

                  // .padding({ top: 3 })

                } else {
                  Column() {
                    if (item.data[ind-1].type == 2) {
                      Text(!item.data[ind-1].value ? '' : String(item.data[ind-1].value))
                        .fontSize(14)
                        .fontColor('#0398FF')
                      // .lineHeight(26)
                    } else {
                      Text(!item.data[ind-1].value ? '' : String(item.data[ind-1].value))
                        .fontSize(14)
                        .fontColor('#FFAB2D')
                      // .lineHeight(26)
                    }
                  }
                  .backgroundColor('#F4F6F7')
                  .height(35)
                  .justifyContent(FlexAlign.Center)
                  // .padding({ top: 3 })
                  .width(this.wt + '%')
                }
              }
              if (ind != 8) {
                Divider()
                  .vertical(true)
                  .color('#DCDDDC')
              }
            })
          }
          .width('100%')
          .height(35)

          Divider()
            .color('#DCDDDC')
        })
      }
      .width('100%')
    }
    .width('100%')
    .height('90%')
    .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
  }
}