// 比较所有值的大小
export function findMaxMin(arr: number[]): number[] {
  if (!arr || arr.length === 0) {
    return [0, 0];
  }

  let maxVal = arr[0];
  let minVal = arr[0];

  for (let i = 1; i < arr.length; i++) {
    if (arr[i] > maxVal) {
      maxVal = arr[i];
    }
    if (arr[i] < minVal) {
      minVal = arr[i];
    }
  }
  return [maxVal, minVal]
}

export function splitRange(maxVal: number, minVal: number): number[] {
  const step = (maxVal - minVal) / 4;

  const values: number[] = [];
  for (let i = 0; i < 4; i++) {
    values.push(Math.floor(minVal + i * step));
  }
  values.push(Math.floor(maxVal)); // 将最大值也加入结果
  return values;
}