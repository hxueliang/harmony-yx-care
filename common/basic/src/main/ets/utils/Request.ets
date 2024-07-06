import { Log } from '@abner/log';
import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';

// 创建实例
const instance = axios.create({
  baseURL: 'https://zhyl-harmony.itheima.net',
  timeout: 5000,
});

// 请求拦截器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  Log.info(`${config.method!}-${config.url}：${JSON.stringify(config.params || config.data)}`)
  return config;
}, (error: AxiosError) => {
  AlertDialog.show({ message: error.message })
  Log.error(error.message)
  return Promise.reject(error);
});

// 响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  if (response.data?.code === 200) {
    Log.warn(response.data)
    return response.data?.data
  }
  AlertDialog.show({ message: response.data?.msg })
  Log.error(response.data?.msg)
  return Promise.reject(response.data)
}, (error: AxiosError) => {
  AlertDialog.show({ message: error.message })
  Log.error(error.message)
  return Promise.reject(error);
});

export {
  instance
}