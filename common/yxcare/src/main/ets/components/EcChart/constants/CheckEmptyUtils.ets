/**
 * 判空方法
 * 包括空对象，空字符串，空数组
 * */
class CheckEmptyUtils {
  isEmptyObj(obj: object | string) {
    return (typeof obj === 'undefined' || obj === null || obj === '');
  }

  isEmptyStr(str: string) {
    return str.trim().length === 0;
  }

  isEmptyArr(arr: Array<string>) {
    return arr.length === 0;
  }
}

export default new CheckEmptyUtils();