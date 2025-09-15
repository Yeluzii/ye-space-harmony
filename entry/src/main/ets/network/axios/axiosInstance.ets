import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from "@ohos/axios";
import { promptAction } from "@kit.ArkUI";
import { User } from "../../module/user";

export const axiosInstance = axios.create(
  {
    // baseURL: 'http://10.20.222.197:8082',
    baseURL: 'https://ychen.fun',
    timeout: 10000,
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    }
  }
)

// 请求拦截器
axiosInstance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  const userStorage: User | undefined = AppStorage.get('user')
  if (userStorage) {
    config.headers.Authorization = userStorage.accessToken
  }
  return config
}, (error: AxiosError) => {
  return Promise.reject(error)
})

// 响应拦截器
axiosInstance.interceptors.response.use((response: AxiosResponse) => {
  console.log("完整响应：",JSON.stringify(response))
  if (response.data.code == 0) {
    return response.data
  } else {
    promptAction.showToast({
      message: response.data.msg || "请求失败",
      duration: 2000,
      alignment: Alignment.Top
    });
    return Promise.reject(response.data)
  }
}, (error: AxiosError) => {
  const res = error.response?.data as object;
  promptAction.showToast({
    message: res["msg"] || '网络错误',
    duration: 2000,
    alignment: Alignment.Top
  })
  return Promise.reject(error)
})