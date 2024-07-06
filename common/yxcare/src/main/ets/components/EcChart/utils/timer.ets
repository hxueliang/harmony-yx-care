/**
 * 根据当前日期， 获取周区间日期集合
 * */
export const getWeekDateRange = (curTimeStamp: number): string[] => {

  let date = new Date(curTimeStamp)
  const offset: number = (date.getDay() + 6) % 7;
  // 计算本周开始的日期
  const startDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - offset);
  // 计算本周结束的日期
  const endDate = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + 6);
  // 格式化日期字符串
  const startYear: number = startDate.getFullYear();
  const startMonth: number = startDate.getMonth() + 1;
  const startDay: number = startDate.getDate();

  const endYear: number = endDate.getFullYear();
  const endMonth: number = endDate.getMonth() + 1;
  const endDay: number = endDate.getDate();

  // 拼接开始时间和结束时间字符串
  const startTime: string = `${startYear}-${startMonth}-${startDay}`;
  const endTime: string = `${endYear}-${endMonth}-${endDay}`;

  return getDateRange(startTime, endTime)
}

// 获取一周7天内的日期集合
export const getDateRange = (startTime: string, endTime: string) => {
  // 存储日期的数组
  const dates: Date[] = [];

  // 循环添加七天日期
  for (let i = 0; i < 7; i++) {
    const currentDate = new Date(startTime);
    currentDate.setDate(currentDate.getDate() + i);
    dates.push(currentDate);
  }

  // 输出日期
  const datesStrArr = dates.map((date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${month}-${day}`
  });

  return datesStrArr
}