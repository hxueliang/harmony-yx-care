export interface HealthDetailChartData {
  /**
   * 横轴数据别名，用于周数据构建日期
   */
  horizontalAliasList: string[];
  /**
   * 横轴数据
   */
  horizontalDataList: string[];
  /**
   * 横轴标签
   */
  horizontalLabelList?: string[];
  /**
   * 单位
   */
  unit: string;
  /**
   * 竖轴数据
   */
  verticalDataList: VerticalDataList[];
}

export interface VerticalDataList {
  /**
   * 折线名称,lowPressure：低压，highPressure：高压，其他同入参functionName
   */
  lineName?: string;
  /**
   * 数据列表
   */
  // values?: Array<number | null>;
  values?: number[];
}

export interface legendItem {
  name: string;
  color: string
}