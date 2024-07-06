import {ChartData} from './ChartData'
import { TimeMode } from '../constants/TimeMode'
import ChartLineData from './ChartLineData';
import Config from '../constants/Config'
import { getWeekDateRange } from '../utils/timer'

export class DataModel {
  // 这里requestData 在于模拟 dataSource数据， 这里可以根据后端实际返回的数据即可， dataSource 的数据结构详见README.md
  requestData(timeMode: TimeMode, curTime: number): ChartData {
    const dataSource = new ChartData()
    switch (timeMode) {
    // 模拟日的数据，一天有24个小时
      case TimeMode.Day:
        const tempList: number[] = [];
        const xAis: string[] = [];
        for (let index = 0; index <= 24; index++) {
          tempList.push(Math.floor(this.generateRandomNumber(150, 200)))
          xAis.push(index < 10 ? `0${index}:00` : `${index}:00`)
        }
        const tempList2: number[] = [];
        for (let index = 0; index <= 24; index++) {
          tempList2.push(Math.floor(this.generateRandomNumber(120, 140)))
        }

        const tempList3: number[] = [];
        for (let index = 0; index <= 24; index++) {
          tempList3.push(Math.floor(this.generateRandomNumber(80, 100)))
        }

        const yAis: ChartLineData[] = []
        yAis.push(new ChartLineData("name1", "#F9365B", tempList))
        yAis.push(new ChartLineData("name1", "#02C4B3", tempList2))
        dataSource.setYAis(yAis)
        dataSource.setXAis(xAis)
        dataSource.setTimeStep(6)

        break;
      case TimeMode.Week: {
        // 模拟周的数据，一周有7天
        const tempList: number[] = [];
        const xAis: string[] = [];
        for (let index = 0; index < 7; index++) {
          tempList.push(this.randomValue())
          const weekStr = Config.WEEK_DESC_ARRAY

          xAis.push(weekStr[index].toString())
        }
        const tempList2: number[] = [];
        for (let index = 0; index < 7; index++) {
          tempList2.push(this.randomValue())
        }
        const yAis: ChartLineData[] = []
        yAis.push(new ChartLineData("name1", "#02C4B3", tempList))
        // yAis.push(new ChartLineData("name1", "#ff0000", tempList2))
        dataSource.setYAis(yAis)
        dataSource.setXAis(getWeekDateRange(curTime))
        dataSource.setTimeStep(1)
        break;
      }
    }
    return dataSource
  }

  // 随机返回正常数据和兼顾0的情况
  randomValue(): number {
    const percent = Math.random() * 10
    if (percent > 6) {
      return 0
    } else {
      return Math.floor(this.generateRandomNumber(40, 200))
    }
  }

  // 生成随机数据
  generateRandomNumber(min: number, max: number): number {
    const range = max - min + 1;
    return Math.floor(Math.random() * range) + min;
  }
}