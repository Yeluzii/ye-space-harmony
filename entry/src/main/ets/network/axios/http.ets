import { ResultData } from "../interface"
import { axiosInstance } from "./axiosInstance";

interface ApiService {
  get<T>(url: string, params?: object): Promise<ResultData<T>>

  post<T>(url: string, data?: object): Promise<ResultData<T>>

  put<T>(url: string, data?: object): Promise<ResultData<T>>

  delete<T>(url: string, data?: object): Promise<ResultData<T>>
}

class ApiServiceImpl implements ApiService {
  get<T>(url: string, params?: object): Promise<ResultData<T>> {
    return axiosInstance.get(url, { params })
  }

  post<T>(url: string, data?: object): Promise<ResultData<T>> {
    return axiosInstance.post(url, data)
  }

  put<T>(url: string, data?: object): Promise<ResultData<T>> {
    return axiosInstance.put(url, data)
  }

  delete<T>(url: string, data?: object): Promise<ResultData<T>> {
    return axiosInstance.delete(url, { data })
  }
}

export default new ApiServiceImpl()