// * 请求响应参数(不包含data)
export interface Result {
  code: string;
  msg: string;
}

// * 请求响应参数(包含data)
export interface ResultData<T> extends Result {
  data: T;
}

// * 分页请求参数
export interface ReqPage {
  page: number;
  limit: number;
}

// * 文件上传模块
export namespace Upload {
  export interface ResFileUrl {
    pkId: number;
    fileUrl: string;
    type: number;
  }
}

export namespace Login {
  export interface ReqCodeLoginParams {
    phone: string;
    code: string;
  }

  export interface ReqPasswordLoginParams {
    phone: string;
    password: string;
  }

  export interface ResLogin {
    pkId: number;
    phone: string;
    nickname: string;
    slogan: string;
    avatar: string;
    createTime: string;
    tips: string;
    accessToken: string;
    lastLoginTime: string;
    bgImg: string
  }
}
