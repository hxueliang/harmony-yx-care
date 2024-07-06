/**
 * 处理服务端传来的数据
 */
import { TimeMode } from '../constants/TimeMode';
import {ChartData} from '../model/ChartData';
import ChartLineData from '../model/ChartLineData';
import { HealthDetailChartData } from '../types/api';

const typeOrder: string[] = ['lowPressure', 'highPressure'];

export function handleChartData(data: HealthDetailChartData, timeMode: number) {
  // 先把数据按照typeOrder 重新排序处理下
  // ---> 主要是为了 顶部的数据展示："收缩压数值/舒张压数值" 或者是 "收缩压数值/舒张压数值"
  data.verticalDataList = data.verticalDataList.sort((a, b) => {
    const a_line = typeof a.lineName === 'string' ? a.lineName : '';
    const b_line = typeof b.lineName === 'string' ? b.lineName : '';

    const aIndex = typeOrder.indexOf(a_line);
    const bIndex = typeOrder.indexOf(b_line);
    return aIndex - bIndex;
  });
  const dataSource = new ChartData()
  const xAis = data.horizontalDataList
  const xAlias = data.horizontalAliasList
  const xLabel = data.horizontalLabelList
  const yAis: ChartLineData[] = []
  data.verticalDataList.map((item, index) => {
    yAis.push(new ChartLineData(item.lineName || '', index == 0 ? "#F9365B" : '#02C4B3', item.values || []))
  })
  dataSource.setXAis(xAis)
  dataSource.setXAlias(xAlias)
  dataSource.setXLabel(xLabel)
  dataSource.setYAis(yAis)
  dataSource.setTimeStep(timeMode == 0 ? 6 : 1)

  return dataSource
}

/**
 * 根据选择的日或者周， 判断对应的折线图下标
 */
export function getSelectIndexBySelectData(timeMode: TimeMode, selectedDate: Date) {
  if (timeMode == 0) {
    const minutes = selectedDate.getHours() * 60 + selectedDate.getMinutes();
    return minutes
  } else {
    return selectedDate.getDay() == 0 ? 6 : selectedDate.getDay() - 1
  }
}