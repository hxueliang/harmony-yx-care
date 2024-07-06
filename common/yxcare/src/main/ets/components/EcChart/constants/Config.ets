/**
 * 配置常量
 * 包括颜色，坐标，位置等信息
 * */
export default class Config {
  // MarginLeft
  static readonly MARGIN_LEFT = 30

  //吸附效果偏移量
  static readonly ATTACH_OFFSET = 5;

  //血压文本Y值偏移量
  static readonly TEXT_Y_OFFSET = 30;

  //背景线条底部偏移量
  static readonly BG_LINE_OFFSET_Y = 50;

  //背景线条底部偏移量
  static readonly BG_LINE_SPACE = 40;

  //背景线条颜色
  static readonly BG_LINE_COLOR = "#E7E7E7"

  //背景线条的数量
  static readonly BG_LINE_NUM = 5

  //血压刻度值
  static readonly HEART_RANGE_ARRAY = ["40", "85", "130", "175", "220"]

  //血压最小值
  static readonly HEART_VALUE_MIN = 40

  //每行血压的跨度
  static readonly HEART_VALUE_RANGE = 45

  //默认字体大小
  static readonly FONT_SIZE_NORMAL = '25px'
  static readonly FONT_SIZE_BIG = '110px'
  static readonly FONT_SIZE_MID = '40px'

  //btns字体大小
  static readonly FONT_SIZE_BTN_TITLE = '35px'
  static readonly FONT_SIZE_BTN_DESC = '45px'

  //默认字体颜色
  static readonly FONT_COLOR_NORMAL = '#B4B4B4'

  //弧度颜色
  static readonly ARC_BG_COLOR = "#f7f7f9"

  //底部绘制起点
  static readonly RENDER_OFFSET = 20

  //波纹宽度
  static readonly WAVE_LENGTH = 66
  static readonly WAVE_AMPLITUDE = 13
  static readonly LINE_MARGIN = 20

  //底部日期的间隔步长
  static TIME_STEP = 3

  //时间导航栏高度
  static readonly TIME_NAV_BAR_HEIGHT = 50
  //画布高度
  static readonly CANVAS_HEIGHT = 270
  //chartView高度
  static readonly HEART_CHART_VIEW_HEIGHT = Config.TIME_NAV_BAR_HEIGHT + Config.CANVAS_HEIGHT
  static readonly DAY_DESC_ARRAY = ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "24:00"]
  static readonly WEEK_DESC_ARRAY = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]


  // 字重
  static readonly FONT_WEIGHT: number = 500;

  // 比例百分百
  static readonly FULL_PERCENT: string = '100%';

  // 整个tab的高度
  static readonly TAB_HEIGHT: number = 550

  // 底部btns 每个的宽度和高度
  static readonly BTNS_WIDTH: number = 200
  static readonly BTNS_HEIGHT: number = 100
}