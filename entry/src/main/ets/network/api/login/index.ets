import { Login } from '../../interface/index'
import http from "../../axios/http"
import { _API } from "../../axios/servicePort"

// 账（手机号）密登录
export const passwordLoginApi = (params: Login.ReqPasswordLoginParams) => {
  return http.post<Login.ResLogin>(_API + "/auth/passwordLogin", params)
}

//发送验证码
export const sendCodeApi = (phone: string) => {
  return http.post<void>(_API + `/common/sendSms?phone=${phone}`)
}

// 手机号验证码登录
export const codeLoginApi = (params: Login.ReqCodeLoginParams) => {
  return http.post<Login.ResLogin>(_API + "/auth/codeLogin", params)
}

// 退出登录
export const logoutApi = () => {
  return http.post<void>(_API + "/auth/logout")
}

// 刷新token
export const refreshTokenApi = () => {
  return http.post<Login.ResLogin>(_API + "/auth/refresh")
}